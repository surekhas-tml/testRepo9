//
//  CreateOpportunityViewController.m
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ProductSelectionViewController.h"
#import "SearchResultCell.h"
#import "RelatedOpportunityCell.h"
#import "EGRKWebserviceRepository.h"
#import "NSString+NSStringCategory.h"
#import "EGVCNumber.h"
#import "EGLob.h"
#import "EGPpl.h"
#import "EGPl.h"
#import "EGVCList.h"
#import "EGPagedArray.h"
#import "EGPagedTableView.h"
#import "VCNumberDBHelper.h"
#import "DashboardHelper.h"
#import "AsyncLocationManager.h"

static NSString *cellIdentifier = @"searchResultCell";
@interface ProductSelectionViewController ()<UITableViewDataSource, UITableViewDelegate, DropDownViewControllerDelegate, UITextFieldDelegate, EGPagedTableViewDelegate> {
    
    NSString *selectedLOB;
    NSString *selectedPL;
    NSString *selectedPPL;
    
    EGLob *selectedLOBObj;
    EGPpl *selectedPPLObj;
    EGPl *selectedPLObj;
	
	BOOL createOpty;
    BOOL isVCReset;
    BOOL isFirstTimeOnlineCallForVC;
}

@property (nonatomic, strong) EGPagedArray *vcDetailsArray;

@end

@implementation ProductSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGestureToDropDownFields];
    // Set the seleted LOB, PPL and PL values
    
    if (self.entryPoint == InvokeForUpdateOpportunity) {
        createOpty = NO;
    }
    else {
        createOpty = YES;
        [self bindLOBPPLPLData];
        [[AsyncLocationManager sharedInstance] startAsyncLocationFetch];
    }
    
    if (self.entryPoint == InvokeForDraftEdit || self.entryPoint) {
        [self adjustUIForEditDraftOperation];
    }
    
    isFirstTimeOnlineCallForVC = true; // Flag used to prevent 1st time API call when view loaded
    [self.searchResultTableView setPagedTableViewCallback:self];
    [self.searchResultTableView setTableviewDataSource:self];
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"ProductSelectionViewController :- %@",self.opportunity.toVCNumber.vcNumber);
//    if (![appdelegate.userName isEqual:[NSNull null]] || self.entryPoint == InvokeForDraftEdit || self.entryPoint == InvokeForUpdateOpportunity) {
//        [self.vcSearchTextField setText: self.opportunity.toVCNumber.vcNumber];
//        [self loadVCDetailsFromOfflineDB:self.vcSearchTextField.text];
//    }
    if (self.opportunity && self.opportunity.toVCNumber && self.opportunity.toVCNumber.vcNumber) {
        [self.vcSearchTextField setText: self.opportunity.toVCNumber.vcNumber];
        [self loadVCDetailsFromOfflineDB:self.vcSearchTextField.text];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (EGPagedArray *)vcDetailsArray {
    if (!_vcDetailsArray) {
        _vcDetailsArray = [[EGPagedArray alloc] init];
    }
    return _vcDetailsArray;
}

- (DropDownTextField *)lobDropDownTextField {
    if (!_lobDropDownTextField.field) {
        _lobDropDownTextField.field = [[Field alloc] init];
    }
    return _lobDropDownTextField;
}

- (DropDownTextField *)pplDropDownTextField {
    if (!_pplDropDownTextField.field) {
        _pplDropDownTextField.field = [[Field alloc] init];
    }
    return _pplDropDownTextField;
}

- (DropDownTextField *)plDropDownTextField {
    if (!_plDropDownTextField.field) {
        _plDropDownTextField.field = [[Field alloc] init];
    }
    return _plDropDownTextField;
}

#pragma mark - Bind Values to UI

- (void)bindLOBPPLPLData {
    if (self.opportunity &&
        [self.opportunity.toVCNumber.lob hasValue] &&
        [self.opportunity.toVCNumber.ppl hasValue] &&
        [self.opportunity.toVCNumber.pl hasValue]) {
        
        [self.lobDropDownTextField setText:self.opportunity.toVCNumber.lob];
        [self.pplDropDownTextField setText:self.opportunity.toVCNumber.ppl];
        [self.plDropDownTextField setText:self.opportunity.toVCNumber.pl];
    }
}

#pragma mark - Private Methods

- (void)adjustUIForEditDraftOperation {
    selectedLOB = self.opportunity.toVCNumber.lob;
    selectedPPL = self.opportunity.toVCNumber.ppl;
    selectedPL = self.opportunity.toVCNumber.pl;
    
//    [self loadResultInTableView];
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.lobDropDownTextField superview] addGestureRecognizer:tapGesture];
    [[self.pplDropDownTextField superview] addGestureRecognizer:tapGesture];
    [[self.plDropDownTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.lobDropDownTextField) {
                    if ([self fieldInputValid:self.lobDropDownTextField]) {
                        [self fetchAllLOBs];
                    }
                }
                else if (textField == self.pplDropDownTextField) {
                    if ([self fieldInputValid:self.pplDropDownTextField]) {
                        [self fetchPPLForSelectedLOB:selectedLOBObj];
                    }
                }
                else if (textField == self.plDropDownTextField) {
                    if ([self fieldInputValid:self.plDropDownTextField]) {
                        [self fetchPLForSelectedPPL:selectedPPLObj];
                    }
                }
            }
        }
    }
}

- (BOOL)fieldInputValid:(UITextField *)currentTextField {
    BOOL hasValidInput = true;
    NSString *errorMessage;
    
    if (currentTextField == self.pplDropDownTextField && ![self.lobDropDownTextField.text hasValue]) {
        errorMessage = @"Please select LOB";
        hasValidInput = false;
    }
    else if (currentTextField == self.plDropDownTextField) {
        if (![self.lobDropDownTextField.text hasValue]) {
            errorMessage = @"Please select LOB";
            hasValidInput = false;
        }
        else if (![self.pplDropDownTextField.text hasValue]) {
            errorMessage = @"Please select PPL";
            hasValidInput = false;
        }
    }
    
    if (!hasValidInput && errorMessage) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    
    return hasValidInput;
}

- (void)showDropDownForView:(DropDownTextField *)textField {
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    [self.searchResultView setHidden:false];
    
    self.vcDetailsArray = [EGPagedArray mergeWithCopy:self.vcDetailsArray withPagination:paginationObj];
    
    if (self.vcDetailsArray) {
        [self.searchResultTableView refreshData:self.vcDetailsArray];
        [self.searchResultTableView reloadData];
    }
}

- (void)setDataOpportunityModel:(EGVCNumber *)newModel {
    NSString *draftId = self.opportunity.draftID;
    EGContact * contactObj = self.opportunity.toContact;
    EGAccount* accountObj = self.opportunity.toAccount;
    self.opportunity = [[EGOpportunity alloc] init];
    if (contactObj) {
        [self.opportunity setToContact:contactObj];
    }
    if (accountObj) {
        [self.opportunity setToAccount:accountObj];
    }
    [self.opportunity setDraftID:draftId];
    [self.opportunity setLob:newModel.lob];
    [self.opportunity setPpl:newModel.ppl];
    [self.opportunity setPl:newModel.pl];
    [self.opportunity setToVCNumber:newModel];
    if ([self.delegate respondsToSelector:@selector(opportunityModelChanged:)]) {
        [self.delegate opportunityModelChanged:self.opportunity];
    }
}

- (BOOL)dataExistsForField:(DropDownTextField *)textField {
    
    if (textField.field.mDataList &&
        [textField.field.mDataList count] > 0 &&
        textField.field.mValues &&
        [textField.field.mValues count] > 0) {
        return true;
    }
    return false;
}

- (NSDictionary *)prepareVCListRequestDictionaryWithOffset:(NSInteger)offset {
    
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)offset];
    
    if ([self.productSelectionRadioButton isSelected]) {
        if (![self.vcSearchTextField.text hasValue]) {
            return nil;
        }
    
        NSDictionary *requestDictionary;
        if ([appdelegate.userName hasValue] || self.entryPoint == InvokeForDraftEdit || self.entryPoint == InvokeForUpdateOpportunity) {
            
            if (!isVCReset) {
                requestDictionary = @{@"pl" : @"",
                                      @"description" : @"",
                                      @"vc_number" : self.vcSearchTextField.text,
                                      @"offset": offsetString,
                                      @"limit":@"20"};
            }
            else{
                requestDictionary = @{@"pl" : self.vcSearchTextField.text,
                                      @"description" : self.vcSearchTextField.text,
                                      @"vc_number" : self.vcSearchTextField.text,
                                      @"offset": offsetString,
                                      @"limit":@"20"};
            }
            
        }
        
        else{
            requestDictionary = @{@"pl" : @"",
                                  @"description" : self.vcSearchTextField.text,
                                  @"offset": offsetString,
                                  @"limit":@"20"};
        }
        
        return requestDictionary;
    }
    else {
        if (!selectedLOBObj) {
            return nil;
        }
        NSDictionary *requestDictionary = @{@"pl" : selectedPLObj?selectedPLObj.plName:@"",
                                            @"description" : selectedPLObj?selectedPLObj.plName:@"",
                                            @"offset": offsetString,
                                            @"limit":@"20"};
        return requestDictionary;
    }
}

- (void)loadVCDetailsFromOfflineDB:(NSString *)searchString {
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnBackgroundThread:^{
        VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
        EGPagination *egPagination = [EGPagination new];
        
        [UtilityMethods RunOnOfflineDBThread:^{
            egPagination.items = [[vcNumberDBHelper fetchAllVCNumberWithSearchQuery:searchString] mutableCopy];
            egPagination.totalResults = egPagination.items.count;
            egPagination.totalResultsString = [NSString stringWithFormat:@"%lu",(unsigned long)egPagination.items.count];
            [UtilityMethods RunOnMainThread:^{
                [self loadResultInTableView:egPagination];
                [UtilityMethods hideProgressHUD];
            }];
        }];
    }];
}

- (void)populateVCListFromLobPPLAndPL {
    [UtilityMethods showProgressHUD:YES];
				[UtilityMethods RunOnBackgroundThread:^{
                    VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
                    EGPagination *egPagination = [EGPagination new];
                    [UtilityMethods RunOnOfflineDBThread:^{
                        egPagination.items = [[vcNumberDBHelper fetchAllVCNumberWithPL:[selectedPLObj plName] withPPL:[selectedPPLObj pplName] withLOB:[selectedLOBObj lobName]] mutableCopy];
                        egPagination.totalResults = egPagination.items.count;
                        egPagination.totalResultsString = [NSString stringWithFormat:@"%lu",(unsigned long)egPagination.items.count];
                        [UtilityMethods RunOnMainThread:^{
                            [UtilityMethods hideProgressHUD];
                            [self.searchResultTableView clearAllData];
                            [self loadResultInTableView:egPagination];
                        }];

                    }];
                    
                }];
}

- (void)populateDataForLOBTab {
    
    if (selectedLOBObj && selectedPPLObj && selectedPLObj) {
        [self populateVCListFromLobPPLAndPL];
    }
    else if (self.opportunity && self.opportunity.toVCNumber && [self.opportunity.toVCNumber.vcNumber hasValue]) {
        
        [UtilityMethods RunOnBackgroundThread:^{
            VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
            [UtilityMethods RunOnOfflineDBThread:^{

            NSArray *resultsArray = [vcNumberDBHelper fetchAllVCNumberWithSearchQuery:self.opportunity.toVCNumber.vcNumber];
            EGVCNumber *vcDetails;
            if (resultsArray && [resultsArray count] > 0) {
                vcDetails = [resultsArray objectAtIndex:0];
            }
            [UtilityMethods RunOnMainThread:^{
                if (vcDetails) {
                    // Set LOB
                    selectedLOBObj = [[EGLob alloc] init];
                    selectedLOBObj.lobName = vcDetails.lob;
                    [self.lobDropDownTextField setText:vcDetails.lob];
                    
                    // Set PPL
                    selectedPPLObj = [[EGPpl alloc] init];
                    selectedPPLObj.pplName = vcDetails.ppl;
                    [self.pplDropDownTextField setText:vcDetails.ppl];
                    
                    // Set PL
                    selectedPLObj = [[EGPl alloc] init];
                    selectedPLObj.plName = vcDetails.pl;
                    [self.plDropDownTextField setText:vcDetails.pl];
                    
                    [self populateVCListFromLobPPLAndPL];
                }
            }];
            
            }];
            
        }];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Reload Data :- %lu",(unsigned long)[self.vcDetailsArray currentSize]);
    return [self.vcDetailsArray currentSize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self setupCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= [self.vcDetailsArray currentSize]) {
        return 50;
    }
    
    static SearchResultCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [self.searchResultTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    });
    
    [self setupCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[DashboardHelper sharedHelper] errorCellInTableView:tableView atIndexPath:indexPath]) {
        return;
    }
    
    EGVCNumber *vcModel = [self.vcDetailsArray objectAtIndex:indexPath.row];
    if ([appdelegate.userName hasValue]) {
        isVCReset = YES;
        if ([self.delegate respondsToSelector:@selector(opportunityModelChanged:)]) {
            [self.opportunity setToVCNumber:vcModel];
            [self.delegate opportunityModelChanged:self.opportunity];
        }
    }
    else if (self.entryPoint == InvokeForDraftEdit || self.entryPoint == InvokeForUpdateOpportunity) {
        isVCReset = YES;
        [self setDataOpportunityModel:vcModel];
    }
    else{
        if (!self.opportunity.toVCNumber || ![self.opportunity.toVCNumber.vcNumber isCaseInsesitiveEqualTo:vcModel.vcNumber]) {
            [self setDataOpportunityModel:vcModel];
        } 
    }
    
    [self nextButtonClicked:nil];
}

#pragma mark - UITableView Private Methods

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)setupCell:(SearchResultCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (!self.vcDetailsArray || [self.vcDetailsArray currentSize] <= 0) {
        return;
    }
    EGVCNumber *vcObject = [self.vcDetailsArray objectAtIndex:indexPath.row];
    [cell.lobLabel setText:vcObject.lob];
    [cell.pplLabel setText:vcObject.ppl];
    [cell.plLabel setText:vcObject.pl];
    [cell.vcNumberLabel setText:vcObject.vcNumber];
    [cell.vcDescriptionLabel setText:vcObject.productDescription];
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor tableViewAlternateCellColor]];
    }
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        if (![textField.text isEqualToString:selectedValue]) {
            [self.vcDetailsArray clearAllItems];
        }
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        
        if (textField == self.lobDropDownTextField) {
            selectedLOBObj = (EGLob *)selectedObject;
            [UtilityMethods resetDynamicField:self.pplDropDownTextField];
            [UtilityMethods resetDynamicField:self.plDropDownTextField];
            [self.searchResultView setHidden:true];
        }
        else if (textField == self.pplDropDownTextField) {
            selectedPPLObj = (EGPpl *)selectedObject;
            [UtilityMethods resetDynamicField:self.plDropDownTextField];
            [self.searchResultView setHidden:true];
        }
        else if (textField == self.plDropDownTextField) {
            selectedPLObj = (EGPl *)selectedObject;
			
			if (createOpty) {
                [self populateVCListFromLobPPLAndPL];
			} else {
				// Delay added to show loader on below API call
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_FOR_API * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.searchResultView setHidden:false];
                    [self.searchResultTableView clearAllData];
                    [self.searchResultTableView reloadData];
//					[self fetchVCListforOffset:0];
				});
			}
        }
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.vcSearchTextField) {
        [self textFieldSearchReturnKeyTapped:textField];
    }
    [textField resignFirstResponder];
    return true;
}

#pragma mark - EGPagedTableViewDelegate Method

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    
    // Make API Call
    if (!createOpty && !isFirstTimeOnlineCallForVC) {
        [self fetchVCListforOffset:[pagedTableViewDataSource.data count]];
    }
    isFirstTimeOnlineCallForVC = false; // This should be always false
}

#pragma mark - IBActions

- (IBAction)textFieldSearchButtonClicked:(id)sender {
    if ([self.vcSearchTextField.text hasValue]) {
        [self.view endEditing:true];
        [self textFieldSearchReturnKeyTapped:self.vcSearchTextField];
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(productSelectionScreenNextButtonClicked)]) {
        [self.delegate productSelectionScreenNextButtonClicked];
    }
}

- (IBAction)radioButtonClicked:(id)sender {
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    if ([appdelegate.userName hasValue]) { // coming from product app
        // Clear already loaded results since new data will be loaded
        // as we are switching tabs
        [self.searchResultTableView clearAllData];
    }
    else {
        [self.searchResultView setHidden:true];
        [self.vcSearchTextField setText:@""];
    }
    
    if (sender == self.productSelectionRadioButton) {
        if (![self.productSelectionRadioButton isSelected]) {
            [self.productSelectionRadioButton setSelected:true];
            [self.lobSelectionRadioButton setSelected:false];
            [self.productSearchView setHidden:false];
            [self.lobPPLPLSelectionView setHidden:true];
            
            if ([appdelegate.userName hasValue]) { // coming from product app
                [self loadVCDetailsFromOfflineDB:self.vcSearchTextField.text];
            }
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Search_by_PL_VC_Description withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

        }
    }
    else if (sender == self.lobSelectionRadioButton) {
        if (![self.lobSelectionRadioButton isSelected]) {
            [self.vcSearchTextField resignFirstResponder];
            [self.lobSelectionRadioButton setSelected:true];
            [self.productSelectionRadioButton setSelected:false];
            
            [self.lobPPLPLSelectionView setHidden:false];
            [self.productSearchView setHidden:true];
            
            if ([appdelegate.userName hasValue]) { // coming from product app
                [self populateDataForLOBTab];
            }
            
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_SearchBy_LOB_PPL_PL withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

        }
    }
}

- (void)textFieldSearchReturnKeyTapped:(UITextField *)searchTextField {
    if ([appdelegate.userName hasValue] || self.entryPoint == InvokeForDraftEdit ||self.entryPoint == InvokeForUpdateOpportunity) {
        isVCReset = YES;
    }
    [self.vcDetailsArray clearAllItems];
	if(createOpty) {
        [self loadVCDetailsFromOfflineDB:searchTextField.text];
	} else {
        [self.searchResultView setHidden:false];
        [self.searchResultTableView clearAllData];
        [self.searchResultTableView reloadData];
//		[self fetchVCListforOffset:0];
	}
}

#pragma mark - API Calls

- (void)fetchAllLOBs {

    if ([self dataExistsForField:self.lobDropDownTextField]) {
        [self showDropDownForView:self.lobDropDownTextField];
        return;
    }
	
	if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
		VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
        NSMutableArray *LOB = [[vcNumberDBHelper fetchAllLOB] mutableCopy];
            if (LOB != nil) {
              [UtilityMethods RunOnMainThread:^{
                  [self showLOBDropDown:LOB];
              }];
            }
        }];
	} else {
		[[EGRKWebserviceRepository sharedRepository] getListOfLOBsandSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				[self showLOBDropDown:[responseArray mutableCopy]];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)showLOBDropDown:(NSMutableArray *)arrLOB {
	NSArray *nameResponseArray = [arrLOB valueForKey:@"lobName"];
	self.lobDropDownTextField.field.mValues = [nameResponseArray mutableCopy];
	self.lobDropDownTextField.field.mDataList = [arrLOB mutableCopy];
	[self showDropDownForView:self.lobDropDownTextField];
}

- (void)fetchPPLForSelectedLOB:(EGLob *)selectedLOBLoc {
    
    if ([self dataExistsForField:self.pplDropDownTextField]) {
        [self showDropDownForView:self.pplDropDownTextField];
        return;
    }
	
	if(createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
            NSMutableArray *pplArray = [[vcNumberDBHelper fetchAllPPLFromLob:[selectedLOBLoc lobName]] mutableCopy];
            if (pplArray != nil) {
                [UtilityMethods RunOnMainThread:^{
                [self showPPLDropDown:pplArray];
                }];
            }
        }];
        

	} else {
		NSDictionary *requestDict = @{@"lob_name": [selectedLOBLoc lobName]};
		[[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				[self showPPLDropDown:[responseArray mutableCopy]];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)showPPLDropDown:(NSMutableArray *)pplArray {
	NSArray *nameResponseArray = [pplArray valueForKey:@"pplName"];
	self.pplDropDownTextField.field.mValues = [nameResponseArray mutableCopy];
	self.pplDropDownTextField.field.mDataList = [pplArray mutableCopy];
	[self showDropDownForView:self.pplDropDownTextField];
}

- (void)fetchPLForSelectedPPL:(EGPpl *)selectedPPLLoc {
    
    if ([self dataExistsForField:self.plDropDownTextField]) {
        [self showDropDownForView:self.plDropDownTextField];
        return;
    }
	
	if (createOpty) {
		VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
        [UtilityMethods RunOnOfflineDBThread:^{
		NSMutableArray *plArray = [[vcNumberDBHelper fetchAllPLFromLob:[selectedLOBObj lobName] withPPL:[selectedPPLLoc pplName]] mutableCopy];
            if (plArray != nil) {
                [UtilityMethods RunOnMainThread:^{
                    [self showPLDropDown:[plArray mutableCopy]];
                }];
            }
        }];
	} else {
		NSDictionary *requestDict = @{@"ppl": [selectedPPLLoc pplId]};
		[[EGRKWebserviceRepository sharedRepository] getListOfPL:requestDict andSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				[self showPLDropDown:[responseArray mutableCopy]];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)showPLDropDown:(NSMutableArray *)plArray {
	NSArray *nameResponseArray = [plArray valueForKey:@"plName"];
	self.plDropDownTextField.field.mValues = [nameResponseArray mutableCopy];
	self.plDropDownTextField.field.mDataList = [plArray mutableCopy];
	[self showDropDownForView:self.plDropDownTextField];
}


- (void)fetchVCListforOffset:(NSInteger)currentOffset {
    
    NSDictionary *requestDictionary = [self prepareVCListRequestDictionaryWithOffset:currentOffset];
    if (!requestDictionary) {
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] getVCList:requestDictionary
                                          andSuccessAction:^(EGPagination *paginationObj) {
                                              
                                              [self loadResultInTableView:paginationObj];
                                              
                                          } andFailuerAction:^(NSError *error) {
                                              [self.searchResultTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
                                              [self.searchResultTableView reloadData];
                                          }];
}

@end
