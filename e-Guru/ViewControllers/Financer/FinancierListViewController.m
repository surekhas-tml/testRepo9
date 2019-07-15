//
//  FinancierListViewController.m
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierListViewController.h"
#import "FinancierListTableViewCell.h"
#import "FinancierChildTableViewCell.h"

#import "UIColor+eGuruColorScheme.h"
#import "EGPagedTableView.h"
#import "CountdownTimer.h"

#import "FinancierListDetailModel.h"
#import "Home_LandingPageViewController.h"
#import "FinancierPreviewDetailsVC.h"
#import "FinancierRequestViewController.h"

#import "EGRKWebserviceRepository.h"
#import "DashboardHelper.h"
#import "EGErrorTableViewCell.h"
#import "AppRepo.h"
#import "NSDate+eGuruDate.h"
#import "HelperManualView.h"

static CGFloat cellYAxis = 73.0f;

@interface FinancierListViewController ()<UITableViewDelegate, UITableViewDataSource, EGPagedTableViewDelegate>
{
    CountdownTimer *timer;
    HelperManualView * helperView;

}
@property (weak, nonatomic) IBOutlet EGPagedTableView   *pplwiseDataTableView;
@property (strong, nonatomic) EGPagedArray              *parentCellArray;
@property (strong, nonatomic) NSMutableArray            *expandedIndexArray;
@property (strong, nonatomic) NSMutableDictionary       *requestDictionary;

@end

@implementation FinancierListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"opportunity data%@", self.opportunity);
    
    _previewButton.layer.cornerRadius = 5.0f;
    _submitToCRMButton.hidden = true;
    timer = [[CountdownTimer alloc] init];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        self.noteLabel.hidden=false;
        self.currentStockLabel.hidden=false;
    }else{
        self.noteLabel.hidden=true;
        self.currentStockLabel.hidden=true;
    }
    _plusButton.hidden = true;
    [self.pplwiseDataTableView setPagedTableViewCallback:self];
    [self.pplwiseDataTableView setTableviewDataSource:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: true];
    if(!helperView) {
        helperView = [[HelperManualView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    helperView.hidden = true;
    [self.view addSubview:helperView];
    
}

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:KEY_OFFSET];
    
    if (_opportunity) {
        [self fetchFinancierAPI:self.opportunity.optyID];
    } else{
       
         dispatch_async(dispatch_get_main_queue(), ^(void){
            [self searchManageOpportunity:self.strFinancierOptyID];
         });        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self fetchFinancierAPI:self.strFinancierOptyID];
        });

    }
}

//manageOptySearchApiWithOptyID for list details screen dSM is coming at this line
-(void)searchManageOpportunity:(NSString *)optyString{
    NSInteger val = _search_status;
    
    NSDictionary* queryParams = [[NSMutableDictionary alloc] init];
    [queryParams setValue:optyString forKey:@"opty_id"];
    [queryParams setValue:[NSNumber numberWithInteger:val] forKey:@"search_status"];
    [queryParams setValue:@"0" forKey:@"offset"];
    [queryParams setValue:@"1" forKey:@"limit"];
    
    [[EGRKWebserviceRepository sharedRepository]searchOpportunity:queryParams andSucessAction:^(EGPagination *oportunity) {
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self opportunitySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [self opportunitySearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)opportunitySearchFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods hideProgressHUD];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"FinancierList Manage Opportunity";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
    } andReportIssueAction:^{
        
    }];
}

-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
    [UtilityMethods hideProgressHUD];
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    
    if ([opportunityPagedArray count] == 0) {
        [UtilityMethods hideProgressHUD];
    }else{
        if(nil != opportunityPagedArray) {
            self.opportunity = [opportunityPagedArray objectAtIndex:0];
            [self fetchFinancierAPI:self.opportunity.optyID];
        } else {
            
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    helperView.hidden = true;
    [self configureView];
}
- (void)configureView {
    self.navigationController.title = UPDATE_RETAIL_FINANCIER;
    [UtilityMethods navigationBarSetupForController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (EGPagedArray *)parentCellArray {
    if (!_parentCellArray) {
        _parentCellArray = [[EGPagedArray alloc] init];
    }
    return _parentCellArray;
}

- (NSMutableArray *)expandedIndexArray {
    if (!_expandedIndexArray) {
        _expandedIndexArray = [[NSMutableArray alloc] init];
    }
    return _expandedIndexArray;
}

- (CGFloat)calculateHeightForCellAtIndex:(NSIndexPath *)indexPath {
    
    if ([self shouldExpandCell:indexPath]) {
        if ([self.parentCellArray count] >0) {
            return (([self.parentCellArray count] + 1.5) * cellYAxis);
        }
    }
    return cellYAxis;
}

- (BOOL)shouldExpandCell:(NSIndexPath *)indexPath {
    if ([self.expandedIndexArray containsObject:[self getStringIndexFrom:indexPath]]) {
        return true;
    }
    return false;
}

- (NSString *)getStringIndexFrom:(NSIndexPath *)indexPath {
    NSLog(@"%@",[NSString stringWithFormat:@"%ld", (long)indexPath.row]);
    return [NSString stringWithFormat:@"%ld", (long)indexPath.row];
}

- (void)addChildViewsInCell:(FinancierListTableViewCell *)financierListTableViewCell atIndexPath:(NSIndexPath *)indexPath
{
    FinancierListDetailModel *financierListDataModel = [self.parentCellArray objectAtIndex:indexPath.row];
    
    NSInteger childIndex = 1;
    static CGFloat childCellYAxis = 60.0f;
    static CGFloat childCellDefaultHeight = 220.0f;
    
    FinancierChildTableViewCell *childView = [[FinancierChildTableViewCell alloc] initWithFrame:CGRectMake(0, childIndex * childCellYAxis, self.pplwiseDataTableView.frame.size.width, childCellDefaultHeight)];
    
    [childView.eligibilityAmtLabel setText:[NSString stringWithFormat:@"%@",financierListDataModel.eligibilityAmt]];
    [childView.irrPercentLabel setText:[UtilityMethods getDisplayStringForValue:financierListDataModel.irrPercent]];
    [childView.emiAmtLabel setText:financierListDataModel.emiAmt];
    [childView.financierSchemeLabel setText:financierListDataModel.schemeType];
    [childView.financierContactNameLabel setText:financierListDataModel.contactName];
    [childView.financierContactNoLabel setText:financierListDataModel.contactNo];
    [childView.commentLabel setText:[NSString stringWithFormat:@"    %@", financierListDataModel.comment]];
    
    [financierListTableViewCell.contentView addSubview:childView];
    childIndex ++;
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.parentCellArray = [EGPagedArray mergeWithCopy:self.parentCellArray withPagination:paginationObj];
    if(self.parentCellArray) {
        [self.pplwiseDataTableView refreshData:self.parentCellArray];
        [self.pplwiseDataTableView reloadData];
    }
}

- (void)bindFinancierValToOpptyModel {
    self.opportunity.toFinancier.financierName = financierName;
    self.opportunity.toFinancier.financierID = financierID;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parentCellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FinancierListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"financierListCell"];
    
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewData Source & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeightForCellAtIndex:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Don't do anything if error cell is clicked
    if ([[DashboardHelper sharedHelper] errorCellInTableView:tableView atIndexPath:indexPath])
    {
        return;
    }
    
    NSString *strIndex = [self getStringIndexFrom:indexPath];
    
    if ([self.expandedIndexArray containsObject:strIndex]) {
        [self.expandedIndexArray removeObject:strIndex];
    }
    else {
        
        [self.expandedIndexArray addObject:strIndex];
    }
    [self.pplwiseDataTableView reloadData];
}

- (void)setupCell:(FinancierListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    FinancierListDetailModel *financierListDataModel = [self.parentCellArray objectAtIndex:indexPath.row];
    
    // Set border color for parent cell
    [cell setBorder];
    
    [cell.financierNameLabel setText:financierListDataModel.financierName];
    [cell.optyIDLabel setText:[UtilityMethods getDisplayStringForValue:financierListDataModel.optyID]];
    [cell.caseIDLabel setText:[UtilityMethods getDisplayStringForValue:financierListDataModel.financierQuoteId]];
    [cell.caseStatusLabel setText:[UtilityMethods getDisplayStringForValue:financierListDataModel.caseStatus]];
//    [cell.integrationStatusLabel setText:[UtilityMethods getDisplayStringForValue:financierListDataModel.integrationStatus]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:dateFormatyyyyMMddThhmmssssssssZ];
   
    NSDate *date = [dateFormatter dateFromString:financierListDataModel.lastUpdatedStatus];
    [cell.lastUpdatedLabel setText:[UtilityMethods getDisplayStringForValue:[date ToISTStringInFormat:dateFormatyyyyMMddhyp]]];
    
    if ([cell.caseStatusLabel.text isEqualToString:@"Pending"]) {
        [timer startCountdownTimerFordemo:financierListDataModel.lastUpdatedStatus andEndDate:financierListDataModel.quoteSubmissionTime withUpdatingLable:cell.timerLabel];
    } else {
        [cell.timerLabel setText:@"-"];
    }
    //For preview button
    cell.previewButton.userData = financierListDataModel;
    [cell.previewButton addTarget:self action:@selector(selectCellPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([cell.caseStatusLabel.text isEqualToString:@"APPROVED"] && [financierListDataModel.sales_stage_name isEqualToString:@"C1 (Quote Tendered)"]) {
        _plusButton.hidden = true;
        cell.radioRetailButton.hidden = false;
        cell.radioRetailButton.userData = financierListDataModel;
        [cell.radioRetailButton addTarget:self action:@selector(selectRadioButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([cell.caseStatusLabel.text isEqualToString:@"APPROVED"]) {
        _plusButton.hidden = true;
    }
    else {
        cell.radioRetailButton.hidden = true;
        _plusButton.hidden = false;
    }
    
    if ([self shouldExpandCell:indexPath]) {
        cell.plusIconImage.image = [UIImage imageNamed:@"minus_button.png"];
        [self addChildViewsInCell:cell atIndexPath:indexPath];
    } else {
        cell.plusIconImage.image = [UIImage imageNamed:@"plus_button.png"];
    }
}

#pragma mark - API Calls

- (void)fetchFinancierAPI:(NSString *)optyString {
    NSDictionary *dict = @{@"opty_id": optyString ? optyString: @""};

    [[EGRKWebserviceRepository sharedRepository] fetchFinancier:dict andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        
        NSString  *offset = [dict objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [self.parentCellArray clearAllItems];
        }
        [self loadResultInTableView:paginationObj];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.pplwiseDataTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.pplwiseDataTableView reloadData];
    }];
}

#pragma mark - IBActions

- (IBAction)helperButtonClicked:(id)sender {
    
    helperView.selectedViewType = helperManualSectionType_CRM;
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

- (IBAction)financierFormButtonclicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle: [NSBundle mainBundle]];
    FinancierRequestViewController *vc = (FinancierRequestViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//    vc.financierOpportunity.optyID = self.strFinancierOptyID;
    EGFinancierOpportunity * opportunity  = [EGFinancierOpportunity new];
    opportunity.optyID = self.opportunity.optyID != nil ? self.opportunity.optyID : self.strFinancierOptyID;
   
    vc.financierOpportunity = opportunity;
    vc.entryPoint = @"listView";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)refreshButtonClicked:(id)sender {
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SubmitToCRM_Refresh withEventCategory:GA_CL_Financier withEventResponseDetails:nil];
    
    [UtilityMethods showProgressHUD:YES];
    _expandedIndexArray = [[NSMutableArray alloc] init];
    
    [self fetchFinancierAPI:self.opportunity.optyID != nil ? self.opportunity.optyID : _strFinancierOptyID];
}

- (IBAction)previewButtonClicked:(id)sender {
    //no use
}

-(void)selectCellPreviewButton:(CustomButton *)sender{
    
    FinancierListDetailModel * contactObject = [[FinancierListDetailModel alloc] init];
    contactObject = sender.userData;
        
    FinancierPreviewDetailsVC *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierPreviewDetails"];
    vc.financierListModel = contactObject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectRadioButton:(CustomButton *)sender{
    
    FinancierListDetailModel * contactObject = [[FinancierListDetailModel alloc] init];
    contactObject = sender.userData;
    
    if(radioButtonSelected) {
        radioButtonSelected = NO;
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"radio_btn_off.png"] forState:UIControlStateNormal];
        _submitToCRMButton.hidden = true;
    } else {
        radioButtonSelected = YES;
        [((UIButton *)sender) setImage:[UIImage imageNamed:@"radio_btn_on.png"] forState:UIControlStateNormal];
        //saving financier name inside global strings
        financierID  = contactObject.financierID;
        financierName  = contactObject.financierName;
        _submitToCRMButton.hidden = false;
    }
    
}

//Submit To CRM
- (IBAction)callUpdateOptyAPI:(id)sender {
    
    if (radioButtonSelected) {
        [self bindFinancierValToOpptyModel];
    }
    
    [[EGRKWebserviceRepository sharedRepository] crmSubmitCall:[self getRequestDictionaryFromOpportunityModel] andSuccessAction:^(NSArray* resArray){
        
        [UtilityMethods alert_ShowMessage:@"Papers Submitted Activity Updated Successfully." withTitle:APP_NAME andOKAction:^(void){
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
            Home_LandingPageViewController *vc = (Home_LandingPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Home_LandingPage_View"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_SubmitToCRM_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_SubmitToCRM_Successful];
        
    }andFailuerAction:^(NSError *error) {
        if (error.localizedRecoverySuggestion) {
            [UtilityMethods showErroMessageFromAPICall:error defaultMessage:UPDATE_OPPORTUNITY_FAILED_MESSAGE];
        }
        else {
            [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
            }];
        }
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_SubmitToCRM_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_SubmitToCRM_Failed];
        
    }];

}

- (NSDictionary *)getRequestDictionaryFromOpportunityModel {
//    NSLog(@"%@",self.opportunity.optyID);
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] opportunityMapping] inverseMapping]
                                                                                   objectClass:[EGOpportunity class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:self.opportunity requestDescriptor:requestDescriptor error:nil];
    return parametersDictionary;
}


@end
