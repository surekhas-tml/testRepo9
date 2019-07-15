//
//  FinancierRequestViewController.m
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//
#define kLabelFont [UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]
#define maxWidth 100.0f

#import "FinancierRequestViewController.h"
#import "FinancierSearchCollectionViewCell.h"
#import "Home_LandingPageViewController.h"
#import "PersonalDetails.h"
#import "ContactDetails.h"
#import "AccountDetails.h"
#import "VehicleDetails.h"
#import "RetailFinancierDetails.h"
#import "MBProgressHUD.h"
#import "FinanciersDBHelpers.h"
#import "EventDBHelper.h"
#import "EGPagedArray.h"
#import "FinancierRequestViewController+CreateFinancier.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "HelperManualView.h"

@interface FinancierRequestViewController () <FinancierSectionViewDelegate, FinancierRequestViewControllerDelegate> {
    
    NSMutableArray *tabButtonsArray;
    NSMutableArray *tabViewArray;
    NSMutableArray *financierListArray;
    NSMutableArray *arrayWithoutDuplicates;
    NSMutableArray *financierBranchDetailsArray;
    NSMutableArray *financierTMFBDMDetailsArray;
    NSMutableDictionary *dictFinancier;
    UIAlertController *alertController;
    UILabel *lbl;
    
    BOOL multipleSelection;
    BOOL checkBoxSelected;
    BOOL refrehButtonClicked;
    
    UITextField *activeField;

    HelperManualView * helperView;
    FinancierSectionType financierTabsViewSelectedSection;
}

@property (nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) EGPagedArray  *fieldDetailsArray;

@end

@implementation FinancierRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refrehButtonClicked = false;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    financierListArray      = [[NSMutableArray alloc] init];
    arrayWithoutDuplicates  = [[NSMutableArray alloc] init];
    dictFinancier           = [[NSMutableDictionary alloc] init];
    
    _containerView.layer.borderWidth = 0;
    _containerView.layer.borderColor = [UIColor grayColor].CGColor;
    
    _contactView.delegate = self;
    
    NSLog(@"financierOpty is%@", _financierOpportunity);
    [self.lobTextField setText:_financierOpportunity.toFinancierOpty.lob];
    [self.pplTextField setText:_financierOpportunity.toFinancierOpty.ppl];
    [self.plTextField setText:_financierOpportunity.toFinancierOpty.pl];
    [self.vcTextField setText:_financierOpportunity.toFinancierOpty.vcNumber];
    
//    self.draftButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDraftValueChanged:) name:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil];
    
    /* to fetch from Draft and show data */
    if ([_entryPoint isEqualToString:DRAFT]) {
        [self setLobPPLValue];
        
        if (![_insertQuoteModel.financier_name isEqualToString:@""]) {
            [dictFinancier setObject:_insertQuoteModel.financier_name forKey:@"financier_name"];
            [dictFinancier setObject:_insertQuoteModel.financier_id forKey:@"financier_id"];
            [arrayWithoutDuplicates addObject:dictFinancier];
            [financierListArray addObject:dictFinancier];
            
            if ([[[financierListArray valueForKey:@"financier_id"] objectAtIndex:0] isEqual: @"1-6RJIVJB"]) {
                _financierTMFView.hidden = false;
                _financierBDMView.hidden = false;
                
                _searchTMFBranchDropDown.text = _insertQuoteModel.branch_name != nil ?_insertQuoteModel.branch_name : @"";
                _searchTMFBDMDropDown.text    = _insertQuoteModel.bdm_name != nil ?_insertQuoteModel.bdm_name :@"" ;

                financierTMFBDMDetailsArray   = [[NSMutableArray alloc] initWithArray:self.insertQuoteModel.financierTMFBDMDetailsArray];
                
                if (_insertQuoteModel.branch_name != nil) {
                    [dictFinancier setObject:_insertQuoteModel.branch_name forKey:@"branch_name"];
                } else{
                    [dictFinancier setObject:_insertQuoteModel.branch_name forKey:@"branch_name"];
                }
                
                if (_insertQuoteModel.branch_id != nil) {
                    [dictFinancier setObject:_insertQuoteModel.branch_id forKey:@"branch_id"];
                } else{
                    [dictFinancier setObject:_insertQuoteModel.branch_id forKey:@"branch_id"];
                }
                
                if (_insertQuoteModel.bdm_id != nil) {
                    [dictFinancier setObject:_insertQuoteModel.bdm_id forKey:@"bdm_id"];
                } else{
                    [dictFinancier setObject:@"" forKey:@"bdm_id"];
                }
  
                if (_insertQuoteModel.bdm_name != nil) {
                    [dictFinancier setObject:_insertQuoteModel.bdm_name forKey:@"bdm_name"];
                } else{
                    [dictFinancier setObject:@"" forKey:@"bdm_name"];
                }
              
                if (_insertQuoteModel.bdm_mobile_no != nil) {
                    [dictFinancier setObject:_insertQuoteModel.bdm_mobile_no forKey:@"bdm_mobile_no"];
                } else{
                    [dictFinancier setObject:@"" forKey:@"bdm_mobile_no"];
                }
                
            }
            
            [_financierSearchCollectionView reloadData];
        }

//        if ([_insertQuoteModel.toggleMode isEqualToString:@"true"]) {
//            NSDictionary *userInfo = @{@"financier_id":@"1-4G25N97"};
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:userInfo];
//        }
        
        [self.draftButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
        [self initUI];
        
    } else if([_entryPoint isEqualToString:@"listView"]){
        multipleSelection = YES;
        [self fetchFinancierQuoteAPI];
        
    }else{
        if (!_financierOpportunity.isQuoteSubmittedToFinancier) {
            multipleSelection = NO;
            _insertQuoteModel = [[FinancierInsertQuoteModel alloc] initWithObject:(AAAFinancierOpportunityMO * _Nullable)_financierOpportunity];
            [self initUI];
            
        } else{
            multipleSelection = YES;
            [self fetchFinancierQuoteAPI];
        }
        
    }

    _otpBlurrView.hidden    = true;
    
    [self setUpOTPTextfields];

    [_agrementButton setBackgroundImage:[UIImage imageNamed:@"check-box-empty.png"]
                        forState:UIControlStateNormal];
    [_agrementButton setBackgroundImage:[UIImage imageNamed:@"ic_check_box.png"]
                        forState:UIControlStateSelected];
    [_agrementButton setBackgroundImage:[UIImage imageNamed:@"ic_check_box.png"]
                        forState:UIControlStateHighlighted];
    _agrementButton.adjustsImageWhenHighlighted=YES;
    
    [self setupsearchTMFBDMDropDownTextField];
    //[self bindTapToView:self.view];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    
    helperView = [[HelperManualView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    helperView.hidden = true;
    helperView.selectedViewType = helperManualSectionType_personalDetails;
    [self.view addSubview:helperView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Initialization

// This method initialized the required
// UI components for this screen
- (void)initUI {
    
        [self loadTabButtons];
        [self loadTabViews];
        [self markMandatoryFields];    
}

-(void)setLobPPLValue{
    [self.lobTextField setText:_insertQuoteModel.lob];
    [self.pplTextField setText:_insertQuoteModel.ppl];
    [self.plTextField setText:_insertQuoteModel.pl];
    [self.vcTextField setText:_insertQuoteModel.vc_number];
}

-(void)setUpOTPTextfields{
    [self SetTextFieldBorder:_txt1];
    [self SetTextFieldBorder:_txt2];
    [self SetTextFieldBorder:_txt3];
    [self SetTextFieldBorder:_txt4];
    [self SetTextFieldBorder:_txt5];
    [self SetTextFieldBorder:_txt6];
    _txt1.delegate = self;
    _txt2.delegate = self;
    _txt3.delegate = self;
    _txt4.delegate = self;
    _txt5.delegate = self;
    _txt6.delegate = self;
    
    [_txt1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt5 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt6 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.searchFinancierDropDownField];
    [UtilityMethods setRedBoxBorder:self.searchTMFBranchDropDown];
    [UtilityMethods setRedBoxBorder:self.searchTMFBDMDropDown];
}

-(void)SetTextFieldBorder :(UITextField *)textField{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self configureView];
}

- (void)configureView {
    self.navigationController.title = FINANCER_Field_DETAIL;
    [UtilityMethods navigationBarSetupForController:self];
}

// This method loads the bottom tab buttons in
// tabButtonsArray and bind actions to each of these buttons
- (void)loadTabButtons {
  
    // Select the first tab
    [self.personalDetailsTab setTabSelected:true];
    
    if (!tabButtonsArray) {
        tabButtonsArray = [[NSMutableArray alloc] initWithObjects:
                           self.personalDetailsTab,
                           self.contactDetailsTab,
                           self.accountDetailsTab,
                           self.vehicleDetailsTab,
                           self.retailFinancierTab,
                           nil];
    }
    
    // Bind Section Type to each tab
    self.personalDetailsTab.sectionType = FinancierPersonalDetailsVw;
    self.contactDetailsTab.sectionType = FinancierContactsDetailsVw;
    self.accountDetailsTab.sectionType = FinancierAccountDetailsVw;
    self.vehicleDetailsTab.sectionType = FinancierVehicleDetailsVw;
    self.retailFinancierTab.sectionType = RetailFinancierDetailsVw;
    
    // Bind Action to tab buttons
    [self.personalDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contactDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.accountDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.vehicleDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.retailFinancierTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set following fields completed
    [self.personalDetailsTab setStatusOfMandatoryFields:true];
    [self.contactDetailsTab setStatusOfMandatoryFields:true];
    [self.accountDetailsTab setStatusOfMandatoryFields:true];
    [self.vehicleDetailsTab setStatusOfMandatoryFields:true];
    [self.retailFinancierTab setStatusOfMandatoryFields:true];
}

// This method load the views for given Financier Request Type
// and renders the first view in tabViewArray
- (void)loadTabViews {
    
    if ([_entryPoint isEqualToString:DRAFT]) {
        tabViewArray = [self getFinancierSectionsWithData:self.insertQuoteModel forMode:FinancierModeCreate];
        if ([_insertQuoteModel.toggleMode isEqualToString:@"true"]) {
            NSDictionary *userInfo = @{@"draftEntry":@"true"};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:userInfo];
        }

    } else{
        
        if (refrehButtonClicked) {
            //to make it readable/writable for differrent entry points refresh button
            if ([_entryPoint isEqualToString:PROCESSED]) {
                tabViewArray = [self getFinancierSectionsWithData:self.insertQuoteModel forMode:FinancierModeDisplay];
            } else {
                tabViewArray = [self getFinancierSectionsWithData:self.insertQuoteModel forMode:FinancierModeCreate];
            }
            
        } else {
            if (!multipleSelection) {
                tabViewArray = [self getFinancierSectionsWithData:self.insertQuoteModel forMode:FinancierModeCreate];
            } else {
                tabViewArray = [self getFinancierSectionsWithData:self.insertQuoteModel forMode:FinancierModeDisplay];
            }
        }

    }
   
    if (tabViewArray && [tabViewArray count] > 0) {
        [self toggleTabButton:((FinancierTabsView *)[tabButtonsArray objectAtIndex:0]).button];
    }
}

-(NSMutableArray *)getFinancierSectionsWithData:(id)financierFieldModel  forMode:(FinancierMode)financierMode {
    
    NSMutableArray *sectionList = [[NSMutableArray alloc] init];
    
    //to update only vehicle detail view when refresh clicked
//         if (refrehButtonClicked) {
////            PersonalDetails         *personalDetailsVw  = [[PersonalDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
////            ContactDetails          *contactsVw         = [[ContactDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
////            AccountDetails          *accountsVw         = [[AccountDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
//            VehicleDetails          *vehicleVw          = [[VehicleDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
////            RetailFinancierDetails  *retailFinancierVw  = [[RetailFinancierDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
//            
////            [sectionList addObject:personalDetailsVw];
////            [sectionList addObject:contactsVw];
////            [sectionList addObject:accountsVw];
//            [sectionList addObject:vehicleVw];
////            [sectionList addObject:retailFinancierVw];
//         }
//         else{

            if ([_entryPoint isEqualToString:DRAFT]) {
                PersonalDetails         *personalDetailsVw  = [[PersonalDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:DRAFT];
                ContactDetails          *contactsVw         = [[ContactDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:DRAFT];
                AccountDetails          *accountsVw         = [[AccountDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:DRAFT];
                VehicleDetails          *vehicleVw          = [[VehicleDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:DRAFT];
                RetailFinancierDetails  *retailFinancierVw  = [[RetailFinancierDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:DRAFT];
                
                [sectionList addObject:personalDetailsVw];
                [sectionList addObject:contactsVw];
                [sectionList addObject:accountsVw];
                [sectionList addObject:vehicleVw];
                [sectionList addObject:retailFinancierVw];
            }
            else {
                PersonalDetails         *personalDetailsVw  = [[PersonalDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
                ContactDetails          *contactsVw         = [[ContactDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
                AccountDetails          *accountsVw         = [[AccountDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
                VehicleDetails          *vehicleVw          = [[VehicleDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
                RetailFinancierDetails  *retailFinancierVw  = [[RetailFinancierDetails alloc] initWithMode:financierMode andModel:financierFieldModel ? : nil andEntryPoint:PROCESSED];
                
                [sectionList addObject:personalDetailsVw];
                [sectionList addObject:contactsVw];
                [sectionList addObject:accountsVw];
                [sectionList addObject:vehicleVw];
                [sectionList addObject:retailFinancierVw];
            }
             
//         }
    return sectionList;
}

#pragma mark - Private Methods

// This method selected the clicked buttons
// and deselects all other buttons in tabButtonsArray
- (void)toggleTabButton:(UIButton *)clickedButton {
    
    FinancierTabsView *selectedTab = nil;
    
    for (FinancierTabsView *tabView in tabButtonsArray) {
        if (tabView.button == clickedButton) {
            [tabView setTabSelected:true];
            selectedTab = tabView;
        }
        else {
            [tabView setTabSelected:false];
        }
    }
    
    if (selectedTab) {
        [self showViewForSelectedTab:selectedTab];
    }
}

// This method shows the view for selected tab
// and hides the view for remaining tabs
- (void)showViewForSelectedTab:(FinancierTabsView *)tab {
   
    financierTabsViewSelectedSection = tab.sectionType;
    
    switch (tab.sectionType) {
        case FinancierPersonalDetailsVw:
        {
            helperView.selectedViewType = helperManualSectionType_personalDetails;

        }
            break;
        case FinancierContactsDetailsVw:
        {
            helperView.selectedViewType = helperManualSectionType_ContactDetails;

        }
            break;
        case FinancierAccountDetailsVw:
        {
            helperView.selectedViewType = helperManualSectionType_AccountDetails;
   
        }
            break;
        case FinancierVehicleDetailsVw:
        {
            helperView.selectedViewType = helperManualSectionType_vehOptyDetails;

        }
            break;
        case RetailFinancierDetailsVw:
        {
            helperView.selectedViewType = helperManualSectionType_RetailFinanceDetails;
        }
            break;
        default:
            break;
    }
    
    if (tabViewArray && [tabViewArray count] > 0) {
        
        for (FinancierSectionView *tabView in tabViewArray) {
            if (tab.sectionType == tabView.sectionType) {
                [self showTab:tabView];
            }
            else {
                [self hideTab:tabView];
            }
            tabView.delegate = self;
            [tabView checkIfMandatoryFieldsAreFilled];
        }
    }
}


// This method decided how to show a given view
- (void)showTab:(id)sectionView {
    
    if ([sectionView isDescendantOfView:self.containerView]) {
        [sectionView setHidden:false];
    }
    else {
        [sectionView setFrame:self.containerView.bounds];
        self.contactView.delegate = self;
        
        if(refrehButtonClicked) {
            refrehButtonClicked = false;
            for (id view in self.containerView.subviews) {
                [view removeFromSuperview];
            }
        }
        
        [self.containerView addSubview:sectionView];
//        [sectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    }
    [self.containerView bringSubviewToFront:sectionView];
    
//    //to enable submit button
//    [self areMandatoryFieldsFilled]; //new
//    if ([self areMandatoryFieldsFilled]) {
//        self.submitButton.enabled = true;
//    }
}

- (void)hideTab:(FinancierSectionView *)sectionView {
    if ([sectionView isDescendantOfView:self.containerView]) {
        [sectionView setHidden:true];
        [self.containerView sendSubviewToBack:sectionView];
    }
}


- (void)onDraftValueChanged:(NSNotification *)notification {
    
//    self.draftButton.enabled = YES;   
}

#pragma mark - FinancierSectionBaseViewDelegate Method

- (void)mandatoryFieldsFilled:(BOOL)fieldsFilled inView:(id)sectionView {
    
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDraftValueChanged:) name:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil];
    
    NSArray *filteredArray = nil;
    
    if ([sectionView isKindOfClass:[PersonalDetails class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", FinancierPersonalDetailsVw]];
    }
    else if([sectionView isKindOfClass:[ContactDetails class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", FinancierContactsDetailsVw]];
    }
    else if([sectionView isKindOfClass:[AccountDetails class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", FinancierAccountDetailsVw]];
    }
    else if([sectionView isKindOfClass:[VehicleDetails class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", FinancierVehicleDetailsVw]];
    }
    else if([sectionView isKindOfClass:[RetailFinancierDetails class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", RetailFinancierDetailsVw]];
    }
       
    if (filteredArray && [filteredArray count] > 0) {
        FinancierTabsView *tabButton = [filteredArray objectAtIndex:0];
        [tabButton setStatusOfMandatoryFields:fieldsFilled];
//        [self areMandatoryFieldsFilled]; //new
    }
    
}

- (BOOL)areMandatoryFieldsFilled {
    
    BOOL hasIncompleteMandatoryFields = false;
    NSString *mandatoryFieldsCompletionError = @"Please fill mandatory details in";
    
    if(![self.searchTMFBDMDropDown.text isEqualToString:@""] && [self isTMFBDMObjectForTMFBDMNamePresent:self.searchTMFBDMDropDown.text]) {
        [UtilityMethods alert_ShowMessage:[self formatMandatoryFieldsCompletionError:[mandatoryFieldsCompletionError stringByAppendingString:@" \"TMF BDM.\""]] withTitle:APP_NAME andOKAction:^{
        }];
        self.searchTMFBDMDropDown.text = @"";
        return false;
    }
    
    if (!financierListArray || !financierListArray.count || financierListArray.count == 0) {
        hasIncompleteMandatoryFields = true;
        mandatoryFieldsCompletionError = [mandatoryFieldsCompletionError stringByAppendingString:[NSString stringWithFormat:@" \"Financier list before proceed.\","]];
    }
//    else if (![self branchSelected]) {
//        hasIncompleteMandatoryFields = true;
//    }
    
    NSInteger currentIndex = 1;
    for (FinancierTabsView *tabButton in tabButtonsArray) {
        if (![tabButton getMandatoryFieldsFilledStatus]) {
            hasIncompleteMandatoryFields = true;
            mandatoryFieldsCompletionError = [mandatoryFieldsCompletionError stringByAppendingString:[NSString stringWithFormat:@" \"%@\",", tabButton.titleLabel.text]];
        }
        currentIndex ++;
    }
    
    if (!checkBoxSelected) {
        hasIncompleteMandatoryFields = true;
        mandatoryFieldsCompletionError = [mandatoryFieldsCompletionError stringByAppendingString:[NSString stringWithFormat:@" \"Please check the box before proceed.\","]];
    }
    
    if (hasIncompleteMandatoryFields) {
        [UtilityMethods alert_ShowMessage:[self formatMandatoryFieldsCompletionError:mandatoryFieldsCompletionError] withTitle:APP_NAME andOKAction:^{
        }];
    }
    
    return !hasIncompleteMandatoryFields;
}

- (NSString *)formatMandatoryFieldsCompletionError:(NSString *) errorMessage {
    errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSRange lastComma = [errorMessage rangeOfString:@"," options:NSBackwardsSearch];
    
    // First replace the last comma with full stop
    if(lastComma.location != NSNotFound) {
        errorMessage = [errorMessage stringByReplacingCharactersInRange:lastComma
                                                             withString: @"."];
    }
    
    // Now replace the last comma with and
    lastComma = [errorMessage rangeOfString:@"," options:NSBackwardsSearch];
    if(lastComma.location != NSNotFound) {
        errorMessage = [errorMessage stringByReplacingCharactersInRange:lastComma
                                                             withString: @" and"];
    }
    return errorMessage;
}

- (DropDownTextField *)searchFinancierDropDownField {
    if(!_searchFinancierDropDownField.field){
        _searchFinancierDropDownField.field = [[Field alloc] init];
    }
    return _searchFinancierDropDownField;
}

- (DropDownTextField *)searchTMFBranchDropDown {
    if(!_searchTMFBranchDropDown.field){
        _searchTMFBranchDropDown.field = [[Field alloc] init];
    }
    return _searchTMFBranchDropDown;
}

//- (DropDownTextField *)searchTMFBDMDropDown {
//    if(!_searchTMFBDMDropDown.field){
//        _searchTMFBDMDropDown.field = [[Field alloc] init];
//    }
//    return _searchTMFBDMDropDown;
//}

- (BOOL)dataExistsForField:(DropDownTextField *)textField {
    
    if (textField.field.mDataList &&
        [textField.field.mDataList count] > 0 &&
        textField.field.mValues &&
        [textField.field.mValues count] > 0) {
        return true;
    }
    return false;
}

- (void)showDropDownForView:(DropDownTextField *)textField {
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    
    if (textField.field.mValues == nil || textField.field.mValues.count == 0) {
        [UtilityMethods alert_ShowMessage:@"No Data Found" withTitle:APP_NAME andOKAction:^{
        }];
    }
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}


#pragma mark - IBAction

- (IBAction)checkboxButtonClicked:(UIButton *)sender {
    
    checkBoxSelected = !checkBoxSelected;/* Toggle */
    [_agrementButton setSelected:checkBoxSelected];
//    [self areMandatoryFieldsFilled]; // new
}

- (void)tabButtonClicked:(UIButton *)sender {
    [self toggleTabButton:sender];
}

- (IBAction)resetButtonClicked:(id)sender {
//    [self resetActiveSectionFields];
}

- (IBAction)submitButtonClicked:(id)sender {
    [activeField resignFirstResponder];
    
//    [self sendOtpAPI];    //only for testing purpose
//    [self submitFinancierAPI]; //only for testing purpose
    
    if ([self areMandatoryFieldsFilled]) {
        if ([self branchSelected]) {
            [self sendOtpAPI];
        }
    }
}

- (IBAction)draftButtonClicked:(id)sender {
    NSError *error;
    NSMutableArray *financierinfoarray;
    NSFetchRequest *requestFinancier = [AAADraftFinancierMO fetchRequest];// new financier draft
    financierinfoarray = [NSMutableArray arrayWithArray:[appdelegate.managedObjectContext executeFetchRequest:requestFinancier error:&error]];  //for financier
    
    
    if(![self.searchTMFBDMDropDown.text isEqualToString:@""] && [self isTMFBDMObjectForTMFBDMNamePresent:self.searchTMFBDMDropDown.text]) {
        self.searchTMFBDMDropDown.text = @"";
        self.insertQuoteModel.bdm_name = self.searchTMFBDMDropDown.text;
        self.insertQuoteModel.bdm_id = @"";
    }
    
    int index = 0;
    BOOL flag = false;
    for (int i=0; i< [financierinfoarray count]; i++) {
        AAADraftFinancierMO *financierDraft = [financierinfoarray objectAtIndex:i];  
        if ([_insertQuoteModel.opty_id isEqualToString:[financierDraft valueForKeyPath:@"toInsertQuote.opty_id"]]) {
            index = i;
            flag = true;
        }
    }
    
    if (flag == true) {
        AAADraftFinancierMO *financierDraft = [financierinfoarray objectAtIndex:index];
        if ([_insertQuoteModel.opty_id isEqualToString:[financierDraft valueForKeyPath:@"toInsertQuote.opty_id"]]) {
            [self updateFinancier:EGDraftStatusSavedAsDraft];
        }
    }
     else {
        if ([self.draftButton.titleLabel.text isEqualToString:@"  Update Draft"]){
            [self updateFinancier:EGDraftStatusSavedAsDraft];
        }
        else{
            [self saveFinancier:EGDraftStatusSavedAsDraft];
        }
    }
    
}

- (BOOL)branchSelected {
    
    BOOL hasIncompleteSelectedBranch = false;
    
    if ([[[financierListArray valueForKey:@"financier_id"] objectAtIndex:0] isEqualToString:@"1-6RJIVJB"]) {
        
        if (![[[financierListArray valueForKey:@"branch_id"] objectAtIndex:0] isEqualToString:@""]) {
            
            if (![[[financierListArray valueForKey:@"bdm_name"] objectAtIndex:0] isEqualToString:@""]) {
                
            } else {
                hasIncompleteSelectedBranch = true;
                [UtilityMethods alert_ShowMessage:[self formatMandatoryFieldsCompletionError:@"Please select TMF BDM name"] withTitle:APP_NAME andOKAction:^{
                }];
            }
        } else{
            hasIncompleteSelectedBranch = true;
            [UtilityMethods alert_ShowMessage:[self formatMandatoryFieldsCompletionError:@"Please select TMF Branch name"] withTitle:APP_NAME andOKAction:^{
            }];
        }
    }
    return !hasIncompleteSelectedBranch;
}

- (IBAction)btnResendClicked:(id)sender {
    [self cleartextfield];
    [activeField resignFirstResponder];
    
    [self sendOtpAPI];
}

- (IBAction)btnValidateClicked:(id)sender {
    [activeField resignFirstResponder];
//    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_ValidateOTP withEventCategory:GA_CL_Financier withEventResponseDetails:nil];
    if ([self otpTextFieldValid]) {
        [self verifyOtpAPI];
    }
}

- (IBAction)btnCancelClicked:(id)sender {
    [activeField resignFirstResponder];
    [self hidePopupView];
}

- (IBAction)financierDropDownClicked:(id)sender {
    
    if ([self dataExistsForField:self.searchFinancierDropDownField]) {
        [self showDropDownForView:self.searchFinancierDropDownField];
        return;
    }
    [self searchFinancierAPI];
}
- (IBAction)financierTMFBranchDropDownClicked:(id)sender
{
    if ([self dataExistsForField:self.searchTMFBranchDropDown]) {
        [self showDropDownForView:self.searchTMFBranchDropDown];
        return;
    }
    [self searchTMFBranchAPI];
}
- (IBAction)financierTMFBDMDropDownClicked:(id)sender {

    if ([[financierTMFBDMDetailsArray objectAtIndex:0] count] == 0 || [financierTMFBDMDetailsArray objectAtIndex:0] == nil) {
        [UtilityMethods alert_ShowMessage:@"No Data Found" withTitle:APP_NAME andOKAction:^{
        }];
    } else {
        [self showTMFBDMDropDown:[financierTMFBDMDetailsArray objectAtIndex:0]];
    }
    
}

- (IBAction)refreshButtonClicked:(id)sender {
    refrehButtonClicked = true;
    
    [UtilityMethods showProgressHUD:YES];
    
    if ([_entryPoint isEqualToString:@"listView"]) {
        [self fetchFinancierQuoteAPI];
    }
    else if ([_entryPoint isEqualToString:NON_PROCESSED] || [_entryPoint isEqualToString:DRAFT]) {
        [self searchFinancierOptyWithParam];
    }
    
}

- (IBAction)helperButtonClicked:(id)sender {
    
    [helperView setViewAccordingToSelectedHelperView];
   
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    [helperView.layer addAnimation:animation forKey:nil];
    
    [UIView transitionWithView:helperView
                      duration:0.8
                       options:UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        [helperView setHidden:!helperView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@" manual shown!!!");
                    }];
    
}

#pragma mark -  APICalls
//v2 api call
-(void)searchFinancierOptyWithParam{
    NSString *strOptyID;
   
    if ([_entryPoint isEqualToString:DRAFT]) {
        strOptyID = _insertQuoteModel.opty_id;
    } else{
        strOptyID = _financierOpportunity.optyID;
    }
    
    
    NSDictionary *dict = @{@"opty_id": strOptyID,
                            @"is_quote_submitted_to_financier" : @false,
//                            @"search_status"                   : @1,
                            @"sales_stage_name"                : @[@"C1 (Quote Tendered)"]
                            };
    
    
    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:dict andSucessAction:^(EGPagination* oportunity) {
        NSString  *offset = [dict objectForKey:@"offset"];

        if ([offset integerValue] == 0) {
            [self.fieldDetailsArray clearAllItems];
        }

        [self opportunitySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self opportunitySearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)opportunitySearchFailedWithErrorMessage:(NSString *)errorMessage{
//    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
//    appDelegate.screenNameForReportIssue = @"Manage Opportunity";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
    } andReportIssueAction:^{
    }];
}

-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
    [UtilityMethods hideProgressHUD];
    
    _fieldDetailsArray  = [EGPagedArray mergeWithCopy:self.fieldDetailsArray withPagination:paginationObj];

    if ([_fieldDetailsArray count] == 0) {
        
    }else{
        if(nil != _fieldDetailsArray) {
            _financierOpportunity = [_fieldDetailsArray objectAtIndex:0];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                _insertQuoteModel = [[FinancierInsertQuoteModel alloc] initWithObject:(AAAFinancierOpportunityMO * _Nullable)_financierOpportunity];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initUI];
            });
            
        }
    }
}


- (void)fetchFinancierQuoteAPI {
    
    NSDictionary* dict;
    if ([_entryPoint isEqualToString:DRAFT]) {
        dict = @{@"opty_id": _insertQuoteModel.opty_id ? : @""};
    } else {
        dict = @{@"opty_id": self.financierOpportunity.optyID ? : @""};
        
    }

    
    [[EGRKWebserviceRepository sharedRepository] fetchFinancier:dict
                                               andSuccessAction:^(EGPagination *financierFieldObj) {
                                                   [UtilityMethods hideProgressHUD];

                                                   [self loadResultInArray:financierFieldObj];
                                                   
                                               } andFailuerAction:^(NSError *error) {
                                                   [UtilityMethods hideProgressHUD];
                                                    [self initUI];
                                               }];
}

- (void)loadResultInArray:(EGPagination *)paginationObj {
    
    _fieldDetailsArray  = [EGPagedArray mergeWithCopy:self.fieldDetailsArray withPagination:paginationObj];
    if ([_fieldDetailsArray count] == 0) {
        
    }else{
        self.financierListModel = [_fieldDetailsArray objectAtIndex:0];
    }
    
    //calling TAB UI
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnMainThread:^{
        [UtilityMethods hideProgressHUD];
        
        _insertQuoteModel = [[FinancierInsertQuoteModel alloc] initWithFetchQuoteObject:(FinancierListDetailModel *)_financierListModel];
        
        if ([_entryPoint isEqualToString:@"listView"]) {
            [self setLobPPLValue];
        }
        [self initUI];
        
    }];
}

-(void)searchFinancierAPI{
    NSDictionary* dict;
    
    if ([_entryPoint isEqualToString:DRAFT]) {
        dict = @{@"opty_id": _insertQuoteModel.opty_id};
    } else {
        dict = @{@"opty_id": _financierOpportunity.optyID};
    }
    
    
    [[EGRKWebserviceRepository sharedRepository]searchFinancier:dict
                                                andSucessAction:^(id financier) {
                                                    NSMutableArray* arrValue = [[NSMutableArray alloc] init];
                                                    
                                                    for (int i = 0; i< [[financier valueForKey:@"result"] count] ; i ++) {
                                                        NSArray* financierArray = [[financier valueForKey:@"result"] objectAtIndex:i];
                                                        
                                                        [arrValue addObject:financierArray];
                                                    }
                                                
                                                    if (arrValue.count == 0 || arrValue == nil) {
                                                        [UtilityMethods hideProgressHUD];
                                                        [UtilityMethods alert_ShowMessage:@"No result found!" withTitle:APP_NAME andOKAction:^{
                                                        }];
                                                    } else{
                                                        [UtilityMethods hideProgressHUD];
                                                        [self showFinancierDropDown:arrValue];
                                                    }
                                                    
                                                } andFailureAction:^(NSError *error) {
                                                    if (error.localizedRecoverySuggestion) {
                                                        [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    else {
                                                        [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                        }];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    [UtilityMethods hideProgressHUD];

                                                }];
    
}

-(void)searchTMFBranchAPI{
    NSDictionary* dict;
    
    if ([_entryPoint isEqualToString:DRAFT]) {
        dict = @{@"lob": _insertQuoteModel.lob,
                               @"div_id": _insertQuoteModel.division_id};
    
    } else if([_entryPoint isEqualToString:LISTVIEW]) {
        dict = @{@"lob": _insertQuoteModel.lob,
                 @"div_id": _insertQuoteModel.division_id};
    }
    else {
        dict = @{@"lob": _financierOpportunity.toFinancierOpty.lob,
                 @"div_id": _financierOpportunity.toFinancierOpty.divID};
    }

    [[EGRKWebserviceRepository sharedRepository]searchFinancierTMFBranch:dict
                                                andSucessAction:^(id tmfBranchArray) {
                                                    
                                                financierBranchDetailsArray = [NSMutableArray new];
                                                for (int i = 0; i< [tmfBranchArray count] ; i ++)
                                                {
                                                    NSArray *arrBDM = [tmfBranchArray objectAtIndex:i];
                                                    [financierBranchDetailsArray addObject:arrBDM];
                                                }
                                                if(financierBranchDetailsArray.count == 0 || financierBranchDetailsArray ==nil)
                                                {
                                                    [UtilityMethods hideProgressHUD];
                                                } else{
                                                    [UtilityMethods hideProgressHUD];
                                                    [self showTMFBranchDropDown:financierBranchDetailsArray];
                                                    /*insert array in model */
                                                }
                                                
                                                    
                                                } andFailureAction:^(NSError *error) {
                                                    if (error.localizedRecoverySuggestion) {
                                                        [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    else {
                                                        [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                        }];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    [UtilityMethods hideProgressHUD];
                                                }];
}

-(void)sendOtpAPI{
    [activeField resignFirstResponder];
    NSDictionary* dict;
    
    if ([_entryPoint isEqualToString:DRAFT]) {
        dict = @{@"app_name": @"com.tatamotors.egurucrm", @"phone_number": _insertQuoteModel.mobile_no};
    } else {
//        dict = @{@"app_name": @"com.tatamotors.egurucrm", @"phone_number": _financierOpportunity.toFinancierContact.mobileno };  // old method
        dict = @{@"app_name": @"com.tatamotors.egurucrm", @"phone_number": _insertQuoteModel.mobile_no};
        //    NSDictionary* dict = @{@"app_name": @"com.tatamotors.egurucrm", @"phone_number": @"8208065061"};
    }
    
    [[EGRKWebserviceRepository sharedRepository]sendOTP:dict
                                        andSucessAction:^(id otp) {
                                            [UtilityMethods hideProgressHUD];
                                            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                                            self.hud.label.text = [otp valueForKey:@"msg"];
                                            [self.hud hideAnimated:YES afterDelay:2];
                                            
                                            _otpBlurrView.hidden = false;
                                            [self cleartextfield];
                                            [UIView transitionWithView:_otpBlurrView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                            } completion:NULL];
                                            
                                        } andFailureAction:^(NSError *error) {
                                            if (error.localizedRecoverySuggestion) {
                                                [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                                                [UtilityMethods hideProgressHUD];
                                            }
                                            else {
                                                [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                }];
                                                [UtilityMethods hideProgressHUD];
                                            }
                                            [UtilityMethods hideProgressHUD];
                                        }];
}

-(void)verifyOtpAPI{
    NSDictionary* dict;
    NSString *otpString =  [NSString stringWithFormat:@"%@%@%@%@%@%@", _txt1.text,_txt2.text,_txt3.text,_txt4.text,_txt5.text,_txt6.text];
    
    if ([_entryPoint isEqualToString:DRAFT]) {
         dict = @{@"otp_number":otpString,@"phone_number": _insertQuoteModel.mobile_no ,@"status":@"Registration OTP"};
    }
    else if ([_entryPoint isEqualToString:LISTVIEW]){
        dict = @{@"otp_number":otpString,@"phone_number": _insertQuoteModel.mobile_no ,@"status":@"Registration OTP"};
    }
    else {
         dict = @{@"otp_number":otpString,@"phone_number": _financierOpportunity.toFinancierContact.mobileno ,@"status":@"Registration OTP"};
        //    NSDictionary* dict = @{@"otp_number":otpString,@"phone_number": @"8208065061" ,@"status":@"Registration OTP"};
    }

    [[EGRKWebserviceRepository sharedRepository]verifyOTP:dict
                                          andSucessAction:^(id verifiedMsg) {
                                              [UtilityMethods hideProgressHUD];
                                              [self hidePopupView];
                                              [self verifiedOtpAlert:[verifiedMsg valueForKey:@"msg"]];
                                              
                                          } andFailureAction:^(NSError *error) {
                                              
                                              [self cleartextfield];
                                              if (error.localizedRecoverySuggestion) {
                                                  [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                                                  [UtilityMethods hideProgressHUD];
                                              }
                                              else {
                                                  [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                  }];
                                                  [UtilityMethods hideProgressHUD];
                                              }
                                              [UtilityMethods hideProgressHUD];                                             
                                              
                                          }];
}

-(void)submitFinancierAPI{
    
    [[EGRKWebserviceRepository sharedRepository] createFinancier:[self bindValuesToInsertOptyModel]
                                                andSucessAction:^(id response) {
                                                    
                                                    //-------------//
                                                    //delete draft intry if submitted
                                                    if([self.entryPoint  isEqual: DRAFT]){
                                                        NSFetchRequest *fetchRequest = [AAADraftFinancierMO fetchRequest];
                                                        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftID == %@ && SELF.userIDLink == %@",  self.draftFinancier.draftID ,[[AppRepo sharedRepo] getLoggedInUser].userName]];
                                                        
                                                        AAADraftFinancierMO * draftFinancierInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
                                                        
                                                        [appdelegate.managedObjectContext deleteObject:draftFinancierInfo];
                                                        
                                                        [appdelegate saveContext];
                                                    }
                                                    //-------------//
                                                    
                                                    [UtilityMethods alert_ShowMessage:[response valueForKey:@"msg"] withTitle:APP_NAME andOKAction:^(void){
                                                        
                                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
                                                        Home_LandingPageViewController *vc = (Home_LandingPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Home_LandingPage_View"];
                                                        [self.navigationController pushViewController:vc animated:YES];
                                                        
                                                         [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_InsertQuote_Submit_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_InsertQuote_Successful];
                                                    }];
                                                    
                                                } andFailureAction:^(NSError *error) {
                                                    
                                                    if (error.localizedRecoverySuggestion) {
                                                        [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    else {
                                                        [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                        }];
                                                        [UtilityMethods hideProgressHUD];
                                                    }
                                                    [self.hud hideAnimated:YES afterDelay:2];
                                                    [UtilityMethods hideProgressHUD];
                                                    
                                                    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_InsertQuote_Submit_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_InsertQuote_Failed];
                                                }];
    
}

- (NSDictionary *)bindValuesToInsertOptyModel {
    
    NSDictionary   *inputDictionary =
    @{
      @"financier_branch_details":financierListArray,
      @"opty_details": @{
              @"organization": _insertQuoteModel.organization ? : @"-",
              @"title": _insertQuoteModel.title ? :@"-",
              @"father_mother_spouse_name": _insertQuoteModel.father_mother_spouse_name ? :@"-",
              @"relationship_type": _insertQuoteModel.relation_type ? : @"-",
              @"gender": _insertQuoteModel.gender ? :@"-",
              @"first_name": _insertQuoteModel.first_name ? :@"-",
              @"last_name": _insertQuoteModel.last_name ? :@"-",
              @"mobile_no": _insertQuoteModel.mobile_no ? :@"-",
              @"religion": _insertQuoteModel.religion ? :@"-",
              @"address_type": _insertQuoteModel.address_type ? :@"-",
              @"address1": _insertQuoteModel.address1 ? :@"-",
              @"address2": _insertQuoteModel.address2 ? :@"-",
              @"area": _insertQuoteModel.area ? :@"-",
              @"city_town_village": _insertQuoteModel.city_town_village ? :@"-",
              @"state": _insertQuoteModel.state ? :@"-",
              @"district": _insertQuoteModel.district ? :@"-",
              @"taluka": _insertQuoteModel.taluka ? :@"-",
              @"pincode": _insertQuoteModel.pincode ? :@"-",
              @"date_of_birth": _insertQuoteModel.date_of_birth ? :@"-",
              @"customer_subcategory": _insertQuoteModel.customer_category_subcategory ? :@"-",
              @"customer_category": _insertQuoteModel.customer_category ? :@"-",
              @"partydetails_maritalstatus": _insertQuoteModel.partydetails_maritalstatus ? :@"-",
              @"intended_application": _insertQuoteModel.intended_application ? :@"-",
              @"account_type": _insertQuoteModel.account_type ? :@"-",
              @"account_name": _insertQuoteModel.account_name ? :@"-",
              @"account_site": _insertQuoteModel.account_site ? :@"-",
              @"account_number": _insertQuoteModel.account_number ? :@"-",
              @"account_address1": _insertQuoteModel.account_address2 ? :@"-",
              @"account_address2": _insertQuoteModel.account_address2 ? :@"-",
              @"account_city_town_village": _insertQuoteModel.account_city_town_village ? :@"-",
              @"account_state": _insertQuoteModel.account_state ? :@"-",
              @"account_district": _insertQuoteModel.account_district ? :@"-",
              @"account_pincode": _insertQuoteModel.account_pincode ? :@"-",
              @"opty_id": _insertQuoteModel.opty_id ? :@"-",
              @"opty_created_date@": _insertQuoteModel.opty_created_date,
              @"ex_showroom_price": _insertQuoteModel.ex_showroom_price,
              @"on_road_price_total_amt": _insertQuoteModel.on_road_price_total_amt != nil ? _insertQuoteModel.on_road_price_total_amt : @"",     //new,
              @"cust_loan_type": _insertQuoteModel.cust_loan_type ,     //new
              @"pan_no_company": _insertQuoteModel.account_pan_no_company,
              @"pan_no_indiviual": _insertQuoteModel.pan_no_indiviual,
              @"id_type": _insertQuoteModel.id_type,
              @"id_description": _insertQuoteModel.id_description,
              @"id_issue_date": _insertQuoteModel.id_issue_date,
              @"id_expiry_date": _insertQuoteModel.id_expiry_date,
              @"lob": _insertQuoteModel.lob,
              @"ppl": _insertQuoteModel.ppl ,
              @"pl": _insertQuoteModel.pl ? :@"-",
              @"usage": _insertQuoteModel.usage ? :@"-",
              @"vehicle_class": _insertQuoteModel.vehicle_class ? :@"-",
              @"vehicle_color": _insertQuoteModel.vehicle_color ? :@"-",
              @"emission_norms": _insertQuoteModel.emission_norms ? :@"-",
              @"loandetails_repayable_in_months": _insertQuoteModel.loandetails_repayable_in_months ? :@"-",
              @"repayment_mode": _insertQuoteModel.repayment_mode ? :@"-",
              @"vc_number": _insertQuoteModel.vc_number ? :@"-",
              @"product_id": _insertQuoteModel.product_id ? :@"-",
              @"event_id": _insertQuoteModel.event_id ? :@"-",
              @"event_name": _insertQuoteModel.event_name ? :@"-",
              @"bu_id": _insertQuoteModel.bu_id ? :@"-",
              @"channel_type": _insertQuoteModel.channel_type ? :@"-",
              @"ref_type": _insertQuoteModel.ref_type ? :@"-",
              @"mmgeo": _insertQuoteModel.mmgeo ? :@"-",
              @"camp_id": _insertQuoteModel.camp_id ? :@"-",
              @"camp_name": _insertQuoteModel.camp_name ? :@"-",
              @"body_type": _insertQuoteModel.body_type ? :@"-",
              @"loan_tenor": _insertQuoteModel.loan_tenor ? :@"-",
              @"division_id": _insertQuoteModel.division_id ? :@"-",
              @"organization_code": _insertQuoteModel.organization_code ? :@"-",
              @"quantity": _insertQuoteModel.quantity ? :@"-",
              @"fin_occupation_in_years": _insertQuoteModel.fin_occupation_in_years ? :@"-",
              @"fin_occupation": _insertQuoteModel.fin_occupation ? :@"-",
              @"partydetails_annualincome": _insertQuoteModel.partydetails_annualincome ? :@"-",
              @"indicative_loan_amt": _insertQuoteModel.indicative_loan_amt ? :@"-",
              @"ltv": _insertQuoteModel.ltv ? :@"-",
              @"account_tahsil_taluka": _insertQuoteModel.account_tahsil_taluka ? :@"-",
              @"type_of_property": _insertQuoteModel.type_of_property ? :@"-",
              @"customer_type": _insertQuoteModel.customer_type ? :@"-",
              
              @"coapplicant_first_name": _insertQuoteModel.coapplicant_first_name ? :@"-",
              @"coapplicant_last_name": _insertQuoteModel.coapplicant_last_name ? :@"-",
              @"coapplicant_mobile_no": _insertQuoteModel.coapplicant_mobile_no ? :@"-",
              @"coapplicant_pan_no_indiviual": _insertQuoteModel.coapplicant_pan_no_indiviual ? :@"-",
              @"coapplicant_city_town_village": _insertQuoteModel.coapplicant_city_town_village ? :@"-",
              @"coapplicant_address1": _insertQuoteModel.coapplicant_address1 ? :@"-",
              @"coapplicant_address2": _insertQuoteModel.coapplicant_address2 ? :@"-",
              @"coapplicant_pincode": _insertQuoteModel.coapplicant_pincode ? :@"-",
              @"coapplicant_date_of_birth": _insertQuoteModel.coapplicant_date_of_birth ? :@"-",

              }
      };
     [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_Selected withEventCategory:GA_CL_Financier withEventResponseDetails:[[financierListArray valueForKey:@"financier_name"] objectAtIndex:0]];
    
    return inputDictionary;
}
#pragma mark - UIControls
- (void)verifiedOtpAlert:(NSString *)msg{
    
    UIAlertController *alertMsg = [UIAlertController
                                   alertControllerWithTitle:nil
                                   message:[NSString stringWithFormat:@"%@, Do you want to submit the selected financier?", msg]
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *YesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    [self submitFinancierAPI];
                                }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"No action")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertMsg addAction:YesAction];
    [alertMsg addAction:noAction];
    [self presentViewController:alertMsg animated:YES completion:nil];
    
}

-(void)hidePopupView {
    [self cleartextfield];
    _otpBlurrView.hidden = true;
    [UIView transitionWithView:_otpBlurrView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    } completion:NULL];
}

-(void)cleartextfield{
    _txt1.text =@"";
    _txt2.text =@"";
    _txt3.text =@"";
    _txt4.text =@"";
    _txt5.text =@"";
    _txt6.text =@"";
}

- (BOOL)otpTextFieldValid{
    
    BOOL hasValidInput = true;
    
    if (![_txt1.text hasValue] || ![_txt2.text hasValue] || ![_txt3.text hasValue] || ![_txt4.text hasValue] || ![_txt5.text hasValue] || ![_txt6.text hasValue])
    {
        hasValidInput = false;
        [UtilityMethods alert_ShowMessage:@"Please enter OTP" withTitle:APP_NAME andOKAction:^{
        }];
    }
    return hasValidInput;
}

- (void)bindTapToView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAutoCompleteTableView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setDelegate:self];
    [view addGestureRecognizer:tapGesture];
}


- (void)removeAutoCompleteTableView:(UITapGestureRecognizer *)gesture {
    [self removeSearchTMFBDMDropDownListTableView];
}

- (void)removeSearchTMFBDMDropDownListTableView {
    if (self.searchTMFBDMDropDown && [self.searchTMFBDMDropDown.resultTableView isDescendantOfView:self.view]) {
        
        [self.searchTMFBDMDropDown.resultTableView removeFromSuperview];
        [self.searchTMFBDMDropDown resignFirstResponder];
    }
}

#pragma mark - gesture methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    if ([[touch.view superview] isKindOfClass:[FinancierSearchCollectionViewCell class]]) {
        return NO;
    }
    
    if ([touch.view isDescendantOfView:self.searchTMFBDMDropDown.resultTableView]) {
        return NO;
    }

    return YES;
}

#pragma mark - UICollectionViewDataSource Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string;
    if ([_entryPoint isEqualToString:DRAFT]) {
       string = [[arrayWithoutDuplicates objectAtIndex:indexPath.row] valueForKey:@"financier_name"];
    } else {
       string = [[financierListArray objectAtIndex:indexPath.row] valueForKey:@"financier_name"];
    }
    
//    return [(NSString *)[[financierListArray objectAtIndex:indexPath.row] valueForKey:@"financier_name"] sizeWithAttributes:NULL]; //automatically calculates
    
    if ([string isEqualToString:@"TATA MOTORS FINANCE LIMITED"]) {
        return CGSizeMake(220, 22);
    } else{
        return CGSizeMake(390, 22);
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrayWithoutDuplicates count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FinancierSearchCollectionViewCell *cell = (FinancierSearchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"financierSearchCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    cell.financierNameLabel.text = [[arrayWithoutDuplicates objectAtIndex:indexPath.row] valueForKey:@"financier_name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexpath %@", indexPath);
    [arrayWithoutDuplicates removeObjectAtIndex:indexPath.row];
    //Broadcast the status
    NSDictionary *userInfo = @{@"FinancierRemoved": @"YES"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:userInfo];
    
    NSString *strFinancierID = [[financierListArray valueForKey:@"financier_id"] objectAtIndex:0];
    if ([strFinancierID isEqualToString:@"1-6RJIVJB"]) {
        _financierTMFView.hidden = true;
        _financierBDMView.hidden = true;
        self.searchTMFBDMDropDown.text = @"";
    }
    [financierListArray removeObjectAtIndex:indexPath.row];
    [_financierSearchCollectionView reloadData];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView
{
    
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;

        NSDictionary *userInfo = @{@"Value_Changed": @"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
        
        if (textField != self.searchFinancierDropDownField) {
            textField.text = selectedValue;
            textField.field.mSelectedValue = selectedValue;
        }
        else if (textField == self.searchFinancierDropDownField) {
           
             [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_Selected withEventCategory:GA_CL_Financier withEventResponseDetails:[selectedObject objectForKey:@"financier_name"]];
            
            if ([[selectedObject objectForKey:@"financier_id"]  isEqual: @"1-6RJIVJB"]) {
                _financierTMFView.hidden = false;
                _searchTMFBranchDropDown.text = nil;
                
                [dictFinancier setObject:@"" forKey:@"branch_id"];
                [dictFinancier setObject:@"" forKey:@"branch_name"];
                [dictFinancier setObject:@"" forKey:@"bdm_id"];
                [dictFinancier setObject:@"" forKey:@"bdm_name"];
                [dictFinancier setObject:@"" forKey:@"bdm_mobile_no"];
                
                _financierBDMView.hidden = true;
            } else{
                [dictFinancier setObject:@"" forKey:@"branch_id"];
                [dictFinancier setObject:@"" forKey:@"branch_name"];
                [dictFinancier setObject:@"" forKey:@"bdm_id"];
                [dictFinancier setObject:@"" forKey:@"bdm_name"];
                [dictFinancier setObject:@"" forKey:@"bdm_mobile_no"];

                _searchTMFBranchDropDown.text = nil;
                self.searchTMFBDMDropDown.text = @"";
                _searchTMFBDMDropDown.text = nil;
                _financierTMFView.hidden = true;
                _financierBDMView.hidden = true;
            }
            
            if (multipleSelection) {
                //Broadcast the status
                //for chola mandalam issue when coming from listview
//                NSDictionary *processedStatus = @{@"listView":@"true"};
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:processedStatus];
                
                NSDictionary *userInfo = @{@"financier_id":[selectedObject objectForKey:@"financier_id"]};
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:userInfo];
                
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_id"] forKey:@"financier_id"];
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_name"] forKey:@"financier_name"];
                //adding dictionary to array
                [financierListArray addObject:dictFinancier];
                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:financierListArray];
                arrayWithoutDuplicates = [orderedSet mutableCopy];
                
                /* New method to store financeir name for draft in model */
                self.insertQuoteModel.financier_name = [[financierListArray valueForKey:@"financier_name"] objectAtIndex:0];
                self.insertQuoteModel.financier_id = [[financierListArray valueForKey:@"financier_id"] objectAtIndex:0];
                
                [_financierSearchCollectionView reloadData];
            } else {
                //Broadcast the status
                NSDictionary *userInfo = @{@"financier_id":[selectedObject objectForKey:@"financier_id"]};
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil userInfo:userInfo];
                
                //by removing array it only stores single object
                [financierListArray removeAllObjects];
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_id"] forKey:@"financier_id"];
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_name"] forKey:@"financier_name"];
                
                [financierListArray addObject:dictFinancier];
                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:financierListArray];
                arrayWithoutDuplicates = [orderedSet mutableCopy];
                
                /* New method to store financeir name for draft in model */
                self.insertQuoteModel.financier_name = [[financierListArray valueForKey:@"financier_name"] objectAtIndex:0];
                self.insertQuoteModel.financier_id = [[financierListArray valueForKey:@"financier_id"] objectAtIndex:0];
                
                [_financierSearchCollectionView reloadData];
            }
        }
        if (textField == self.searchTMFBranchDropDown) {
            financierTMFBDMDetailsArray = [[NSMutableArray alloc] init];
            self.insertQuoteModel.financierTMFBDMDetailsArray = [[NSMutableArray alloc] init]; //new bdm array initialization
            
            [financierListArray removeAllObjects];
            
            [dictFinancier setObject:[selectedObject objectForKey:@"branch_id"] forKey:@"branch_id"];
            [dictFinancier setObject:[selectedObject objectForKey:@"branch_name"] forKey:@"branch_name"];
            [financierListArray addObject:dictFinancier];
            //inserting into model
            self.insertQuoteModel.branch_name = [selectedObject objectForKey:@"branch_name"];
            self.insertQuoteModel.branch_id = [selectedObject objectForKey:@"branch_name"];
            
            [financierTMFBDMDetailsArray addObject:[selectedObject objectForKey:@"bdm_details"]];
            
            /*insert array into model */
            [self.insertQuoteModel.financierTMFBDMDetailsArray addObject:[selectedObject objectForKey:@"bdm_details"]];
            
            _financierBDMView.hidden = false;
            self.searchTMFBDMDropDown.text = @"";
            _searchTMFBDMDropDown.text = nil;
        }
        
        AutoCompleteUITextField *text_Field = (AutoCompleteUITextField *)dropDownForView;

        if (text_Field == self.searchTMFBDMDropDown) {
            [financierListArray removeAllObjects];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_id"] forKey:@"bdm_id"];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_name"] forKey:@"bdm_name"];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_mobile_no"] != nil ? [selectedObject objectForKey:@"bdm_mobile_no"] : @"" forKey:@"bdm_mobile_no"];
            
            self.insertQuoteModel.bdm_name = [selectedObject objectForKey:@"bdm_name"];
            self.insertQuoteModel.bdm_id = [selectedObject objectForKey:@"bdm_id"];
            self.insertQuoteModel.bdm_mobile_no = [selectedObject objectForKey:@"bdm_mobile_no"];
            
            [self.insertQuoteModel.financierTMFBDMDetailsArray addObject:dictFinancier];
            
            [financierListArray addObject:dictFinancier];
        }
    }
    FinancierSectionView *sectionView;
    [sectionView checkIfMandatoryFieldsAreFilled];
}

- (void)showFinancierDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"financier_name"];
    self.searchFinancierDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.searchFinancierDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.searchFinancierDropDownField];
}

- (void)showTMFBranchDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"branch_name"];
    self.searchTMFBranchDropDown.field.mValues = [nameResponseArray mutableCopy];
    self.searchTMFBranchDropDown.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.searchTMFBranchDropDown];
}

- (void)showTMFBDMDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"bdm_name"];
    self.searchTMFBDMDropDown.field.mValues = [nameResponseArray mutableCopy];
    self.searchTMFBDMDropDown.field.mDataList = [arr mutableCopy];
    //[self showDropDownForView:self.searchTMFBDMDropDown];
}

#pragma mark - AutoCompleteUITextField methods
- (void)setupsearchTMFBDMDropDownTextField {
    
    self.searchTMFBDMDropDown.autocompleteTableRowSelectedDelegate = self;
    self.searchTMFBDMDropDown.field = [[Field alloc] init];
    self.searchTMFBDMDropDown.layer.cornerRadius = 0;
    self.searchTMFBDMDropDown.clipsToBounds = true;
}

- (void)setTMFBDMValuesInTMFBDMDropDownField {
    
    NSMutableArray * TMFBDMMArray = [NSMutableArray new];
    
//    if([_entryPoint isEqualToString:DRAFT]) {
//        TMFBDMMArray = [financierTMFBDMDetailsArray objectAtIndex:0];
//    }

    for(NSDictionary * item in [financierTMFBDMDetailsArray objectAtIndex:0]) {
       
        if([_entryPoint isEqualToString:DRAFT]) {
            [TMFBDMMArray addObject:[item objectForKey:@"bdm_name"]];
        } else {
            [TMFBDMMArray addObject:[item objectForKey:@"bdm_name"]];
        }
    }
    
    [UtilityMethods RunOnBackgroundThread:^{
        [UtilityMethods RunOnOfflineDBThread:^{
            //FinanciersDBHelpers *financierDBHelper = [FinanciersDBHelpers new];
            self.searchTMFBDMDropDown.field.mDataList = [[financierTMFBDMDetailsArray objectAtIndex:0] mutableCopy];
            self.searchTMFBDMDropDown.field.mValues = [[TMFBDMMArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
            
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAutoCompleteTableForSearchTMFBDMDropDownField];
            }];
        }];
    }];

}

- (void)getTMFBDMObjectForTMFBDMName:(NSString *)financierName {
    if (self.searchTMFBDMDropDown.field.mDataList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bdm_name == %@", financierName];
        NSArray *filteredArray = [self.searchTMFBDMDropDown.field.mDataList filteredArrayUsingPredicate:predicate];
        
        if (filteredArray && [filteredArray count] > 0) {
            
            [financierListArray removeAllObjects];
            NSMutableDictionary * selectedObject = [[NSMutableDictionary alloc] initWithDictionary:[filteredArray objectAtIndex:0]];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_id"] forKey:@"bdm_id"];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_name"] forKey:@"bdm_name"];
            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_mobile_no"] != nil ? [selectedObject objectForKey:@"bdm_mobile_no"] : @"" forKey:@"bdm_mobile_no"];
            
            self.insertQuoteModel.bdm_name = [selectedObject objectForKey:@"bdm_name"];
            self.insertQuoteModel.bdm_id = [selectedObject objectForKey:@"bdm_id"];
            self.insertQuoteModel.bdm_mobile_no = [selectedObject objectForKey:@"bdm_mobile_no"];
            
            [financierListArray addObject:dictFinancier];
            
            FinancierSectionView *sectionView;
            [sectionView checkIfMandatoryFieldsAreFilled];
        }
    }
}

- (BOOL)isTMFBDMObjectForTMFBDMNamePresent:(NSString *)financierName {
    BOOL isBDM = false;
    if (self.searchTMFBDMDropDown.field.mDataList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bdm_name == %@", financierName];
        NSArray *filteredArray = [self.searchTMFBDMDropDown.field.mDataList filteredArrayUsingPredicate:predicate];
        
        if (filteredArray && [filteredArray count] > 0) {
            isBDM = false;
        }else {
            isBDM = true;
        }
    }
    return isBDM;
}

- (void)showAutoCompleteTableForSearchTMFBDMDropDownField {
    
    [self showTMFBDMDropDown:[financierTMFBDMDetailsArray objectAtIndex:0]];
    if (self.searchTMFBDMDropDown.field.mValues && [self.searchTMFBDMDropDown.field.mValues count] > 0) {
        //financierTMFBDMDetailsArray
        CGRect frame = self.financierBDMView.frame;
        frame.origin.y += 10;
        [self.searchTMFBDMDropDown loadTableViewForTextFiled:frame
                                                    onView:self.view
                                                 withArray:self.searchTMFBDMDropDown.field.mValues
                                                     atTop:false];
        
        [self.searchTMFBDMDropDown.resultTableView reloadData];
        [self.searchTMFBDMDropDown showDropDownFromView];

    } else {
        [self setTMFBDMValuesInTMFBDMDropDownField];
    }
}

#pragma mark - AutoCompleteUITextFieldDelegate Methods

- (void)selectedActionSender:(id)sender {
    [self.view endEditing:true];
    [self getTMFBDMObjectForTMFBDMName:self.searchTMFBDMDropDown.text];
}


#pragma mark - TextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;

    if (textField == self.searchTMFBDMDropDown) {
        textField.text = @"";
        [self showAutoCompleteTableForSearchTMFBDMDropDownField];
    }
    else{
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = textField;
    if (textField == _txt6) {
        [textField resignFirstResponder];
    }
    if (textField == self.searchTMFBDMDropDown) {
        [self removeSearchTMFBDMDropDownListTableView];
        
        if([textField.text isEqualToString:@""]) {
            self.insertQuoteModel.bdm_name = @"";
            self.insertQuoteModel.bdm_id = @"";
            
            [dictFinancier setObject:self.insertQuoteModel.bdm_name forKey:@"bdm_name"];
            
//            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_id"] forKey:@"bdm_id"];
//            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_name"] forKey:@"bdm_name"];
//            [dictFinancier setObject:[selectedObject objectForKey:@"bdm_mobile_no"]
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField{
    activeField = textField;
    
    NSString *text = textField.text;
    
    if (text.length >= 1) {
        
        switch (textField.tag) {
            case 1:
                [self.txt2 becomeFirstResponder];
                break;
            case 2:
                [self.txt3 becomeFirstResponder];
                break;
            case 3:
                [self.txt4 becomeFirstResponder];
                break;
            case 4:
                [self.txt5 becomeFirstResponder];
                break;
            case 5:
                [self.txt6 becomeFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
    const char * _char = [textField.text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        
        switch (textField.tag) {
            case 6:
                [self.txt5 becomeFirstResponder];
                break;
            case 5:
                [self.txt4 becomeFirstResponder];
                break;
            case 4:
                [self.txt3 becomeFirstResponder];
                break;
            case 3:
                [self.txt2 becomeFirstResponder];
                break;
            case 2:
                [self.txt1 becomeFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.txt1 || textField == self.txt2 || textField == self.txt3 || textField == self.txt4 || textField == self.txt5 || textField == self.txt6) {
        if (length > 1)
//            return NO;
            switch (textField.tag) {
                case 1:
                    [self.txt2 becomeFirstResponder];
                    break;
                case 2:
                    [self.txt3 becomeFirstResponder];
                    break;
                case 3:
                    [self.txt4 becomeFirstResponder];
                    break;
                case 4:
                    [self.txt5 becomeFirstResponder];
                    break;
                case 5:
                    [self.txt6 becomeFirstResponder];
                    break;
                case 6:
                    [self.txt6 resignFirstResponder];
                    break;
                    
                default:
                    break;
            }

        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    if (textField == self.searchTMFBDMDropDown) {
        [self.searchTMFBDMDropDown reloadDropdownList_ForString:currentString];
    }
    
    return YES;
}


@end
