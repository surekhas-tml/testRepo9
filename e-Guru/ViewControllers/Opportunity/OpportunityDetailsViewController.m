//
//  OpportunityDetailsViewController.m
//  e-Guru
//
//  Created by Juili on 04/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "OpportunityDetailsViewController.h"
#import "EGVCNumber.h"
#import "UILabel+EGCategory.h"
#import "QuotationPreviewViewController.h"

#import "FinancierRequestViewController.h"
#import "FinancierListViewController.h"
#import "FinancierPreviewDetailsVC.h"
#import "MBProgressHUD.h"

#define KEY_STATUS  @"status"

@interface OpportunityDetailsViewController ()<OpportunityOperationsHelperDelegate> {
    NSArray *actionList;
    EGQuotation *quotationDetailsObj;
    AppDelegate *app_Delegate;
    EGPagedArray * opportunityPagedArray; //for financierApi
}

@property (strong, nonatomic) EGPagedArray                   *parentCellArray;
@property (strong, nonatomic) FinancierRequestViewController * financierRequestVc;
@property (strong,nonatomic)OpportunityOperationsHelper *optyOprations;
@property (strong,nonatomic)NSMutableDictionary *requestDictionary;
@end

@implementation OpportunityDetailsViewController 
@synthesize opportunity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app_Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.optyOprations = [OpportunityOperationsHelper new];
    self.optyOprations.delegate = self;
    [self.opportunityActionSelector setEnabled:true];
    [self.opportunityActionSelector setUserInteractionEnabled:true];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateScreen)
                                                 name:@"UpdateScreen"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateSaleStageToPapersSubmitted)
//                                                 name:PapersSubmittedDone
//                                               object:nil];
    [self bindExchngeDetailsData];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Opportunity_Details];

}
-(void)UpdateScreen{
    [self populateDetailFields];
}

- (EGPagedArray *)parentCellArray {
    if (!_parentCellArray) {
        _parentCellArray = [[EGPagedArray alloc] init];
    }
    return _parentCellArray;
}

- (void)updateSaleStageToPapersSubmitted {
//    self.opportunity.salesStageName = C1APapersSubmitted;
    [self populateDetailFields];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:@"Open" forKey:KEY_STATUS];
        [_requestDictionary setObject:@"0" forKey:@"offset"];
        [_requestDictionary setObject:@"1" forKey:@"size"];
        if ([[AppRepo sharedRepo] isDSMUser]) {
            
            if ([self.showOpty isEqualToString:@"My_Opportunity"]) {
                self.isdsmdseactivity1=MYACTIVITY;
            [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity1] forKey:@"search_status"];
        }else{
            self.isdsmdseactivity1=TEAMACTIVITY;
            [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity1] forKey:@"search_status"];
        }}else
        {
            self.isdsmdseactivity1=MYACTIVITY;
            [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity1] forKey:@"search_status"];
        }

        [_requestDictionary setObject:self.opportunity.optyID forKey:@"opty_id"];
    }
    return _requestDictionary;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue oppor");
    if ([[segue identifier]isEqualToString:@"opportunityDetails_Segue"]) {
        OpportunityDetailsViewController *oDVC = (OpportunityDetailsViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunity;
    }else if ([[segue identifier]isEqualToString:@"CreateActivity_Segue"]) {
        NewActivityViewController *oDVC = (NewActivityViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunity;
        oDVC.contact = opportunity.toContact;
        
    }
    else if ([[segue identifier]isEqualToString:@"PendingActivity_Segue"]) {
            PendingActivitiesListViewController *oDVC = (PendingActivitiesListViewController *)[segue destinationViewController];
            oDVC.opportunity = opportunity;
        oDVC.contact = opportunity.toContact;
        if ([[AppRepo sharedRepo] isDSMUser]) {
            
            if ([self.showOpty isEqualToString:@"My_Opportunity"]) {
            oDVC.currentpendingActivityUser = @"My_Actitivity";
        }else{
            oDVC.currentpendingActivityUser = @"Team_Activity";
        }}
        else{
            oDVC.currentpendingActivityUser = @"Team_Activity";
        }

        }
    else if ([[segue identifier]isEqualToString:@"LostOpportunity_Segue"]) {
        LostOpportunityViewController *oDVC = (LostOpportunityViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunity;
        oDVC.currentoptyUsers = self.showOpty;
        oDVC.contact = oDVC.opportunity.toContact;
    }
    else if ([[segue identifier] isEqualToString:@"QuotationPreview_Segue"]) {
        QuotationPreviewViewController *quotationPreviewViewController = (QuotationPreviewViewController *)[segue destinationViewController];
        quotationPreviewViewController.opportunityObj = opportunity;
        quotationPreviewViewController.quotationObj = quotationDetailsObj;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [UtilityMethods navigationBarSetupForController:self];

    self.contatainerView.layer.borderWidth = 1.0f;
    self.contatainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self populateDetailFields];
    
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        if ([self.showOpty isEqualToString:@"My_Opportunity"] || [self.opportunity.leadAssignedPositionID isEqualToString:[[AppRepo sharedRepo] getLoggedInUser].positionID]) {
            self.dsenamelbl.hidden=YES;
            self.dsenamevalue.hidden=YES;
            actionList = [self.optyOprations setActionsArrayForOpportunity:opportunity withTab:@"My_Opportunity"];
        }else{
            self.dsenamelbl.hidden=NO;
            self.dsenamevalue.hidden=NO;
            self.dsenamevalue.text=[[self.opportunity.leadAssignedName stringByAppendingString:@" "] stringByAppendingString:opportunity.leadAssignedLastName];
            actionList = [self.optyOprations setActionsArrayForOpportunity:opportunity withTab:@"Team_Opportunity"];
        }
        

    }
    else{
 
        self.dsenamelbl.hidden=YES;
        self.dsenamevalue.hidden=YES;
        actionList = [self.optyOprations setActionsArrayForOpportunity:opportunity withTab:@"DSE"];
    }
}

-(void)populateDetailFields{
    [self.opportunityID setTextWithPlaceholder:[self.opportunity optyID]];
    
    NSString *firstName = (nil != self.opportunity.toContact.firstName) ? self.opportunity.toContact.firstName : @"";
    NSString *lastName = (nil != self.opportunity.toContact.lastName) ? self.opportunity.toContact.lastName : @"";
    self.opportunityName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    NSString *salesStageDate = [NSDate formatDate:self.opportunity.saletageDate FromFormat:dateFormatyyyyMMddTHHmmssZ toFormat:dateFormatddMMyyyy];
    [self.salesStageDate setTextWithPlaceholder:salesStageDate];
    
    [self.salesStageLabel setText:[NSString stringWithFormat:@"Opportunities with sales stage: %@", [self.opportunity salesStageName]]]; //to show current sales stage name
    
    [self.salesStage setTextWithPlaceholder:[self.opportunity salesStageName]];
    [self.productName setTextWithPlaceholder:[[self.opportunity toVCNumber] productName1]];
    [self.financerName setTextWithPlaceholder: [(EGFinancier *)[self.opportunity toFinancier] financierName]];
    
    EGContact *contact = [self.opportunity toContact];
    [self.contactNAme setTextWithPlaceholder: [[contact.firstName stringByAppendingString:@" "] stringByAppendingString:contact.lastName]];
    
    [self.contactPhoneNumber setTextWithPlaceholder:contact.contactNumber];
    [self.mobileNumber setTextWithPlaceholder: contact.contactNumber];
    [self.contactAddress setTextWithPlaceholder:[(EGAddress *)contact.toAddress addressLine1]];
    
    EGAccount *account = [self.opportunity toAccount];
    [self.accountName setTextWithPlaceholder:account.accountName];
    [self.accountContactNumeber setTextWithPlaceholder: account.contactNumber];
    
    // Get Done Activity Data
    [self getLatestDoneActivity];
}

- (void)bindPendingActivityData:(EGActivity *)pendingActivity {
    
    [self.activityDate setText:[UtilityMethods getDisplayStringForValue:[pendingActivity planedDateSystemTimeInFormat:dateFormatddMMyyyy]]];
    [self.activityType setText:[UtilityMethods getDisplayStringForValue:pendingActivity.activityType]];
    [self.activityComments setText:[UtilityMethods getDisplayStringForValue:pendingActivity.activityDescription]];
}

- (void)bindDoneActivityData:(EGActivity *)doneActivity {
    
    [self.doneActivityDate setText:[UtilityMethods getDisplayStringForValue:[doneActivity planedDateSystemTimeInFormat:dateFormatddMMyyyy]]];
    [self.doneActivityType setText:[UtilityMethods getDisplayStringForValue:doneActivity.activityType]];
    [self.doneActivityComments setText:[UtilityMethods getDisplayStringForValue:doneActivity.activityDescription]];
}
//Exchange Details value showing
- (void)bindExchngeDetailsData {
    
    [self.brandLabel setText: opportunity.ppl_for_exchange];
    [self.plLabel setText: opportunity.pl_for_exchange];
    [self.registrationLabel setText:opportunity.registration_no];
    [self.mileageLabel setText: opportunity.milage];
    [self.ageLabel setText: opportunity.age_of_vehicle];
//    [self.tml_src_chassisnumber setText: opportunity.tml_src_chassisnumber];
//    [self.tml_ref_pl_id setText: opportunity.tml_ref_pl_id];
//    [self.tml_src_assset_id setText: opportunity.tml_src_assset_id];
//    [self.interested_in_exchange setText: opportunity.interested_in_exchange];
}


#pragma mark - TextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([actionList count] == 0) {
        [self.opportunityActionSelector resignFirstResponder];
        [UtilityMethods alert_ShowMessage:[NSString stringWithFormat:@"Can Not Perform any action on Opportunity in %@ state",opportunity.salesStageName] withTitle:APP_NAME andOKAction:nil];
    }else{
        [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:actionList] andModelData:[NSMutableArray arrayWithArray:actionList]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [textField resignFirstResponder];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

# pragma mark - Opportunity Operations methods

-(void)DropDownViewClickedWithTag:(long)actionTag withOpty:(EGOpportunity *)opty{
    if ([[actionList objectAtIndex:actionTag] isEqualToString:UPDATE]) {
        [self.optyOprations openUpdateOpportunityViewFor:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Update_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
    }else if ([[actionList objectAtIndex:actionTag] isEqualToString:CREATE_NFA]) {
        [self.optyOprations openCreateNFARequestFor:opportunity fromVC:self];
    }else if([[actionList objectAtIndex:actionTag] isEqualToString:PENDINGACT]){
        [self.optyOprations showPendingActivitiesListFor:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Pending_Activity_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:LINKCAMPAIGN]){
        [self.optyOprations showAvailbleCampaignListFor:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Link_Campaign_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:MARKLOST]){
        [self.optyOprations markOpportunityAsLostFor:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Mark_as_Lost_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:CREATEC1]){
        [self.optyOprations createQuoteForOpportunityFor:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Create_C1_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:NEWACT]){
        [self.optyOprations showCreateNewActivityViewOnOpportunity:opportunity fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_New_Activity_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:ASSIGN]){
        [self.optyOprations getDSElist:opportunity fromVC:self showLoader:NO];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Opportunity_Details_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:EMAIL_QUOTATION]){
        [self getQuotationDetailForOpty:opportunity];
        //TODO: Add Google Analytics Event
        
    }
    else if ([[actionList objectAtIndex:actionTag] isEqualToString:RETAIL_FINANCIER]){
        [self getFinancierDetail:opportunity];
    }
    else if ([[actionList objectAtIndex:actionTag] isEqualToString:PREVIEW]){
        
//        [self performSelector:@selector(fetchFinancierAPI:) withObject:opty.optyID afterDelay:0.1];
        [self fetchFinancierAPI:opportunity];
//        opportunity = opty;
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    // Dealy added to allow dropdown view some time to dismiss
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.opportunityActionSelector.text = selectedValue;
        [self DropDownViewClickedWithTag:[actionList indexOfObject:selectedValue] withOpty:selectedObject];
    });
}

#pragma mark - OpportunityOperationsHelperDelegate Methods

- (void)optyAssignmentCompleted {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - API Calls

- (void)getLatestDoneActivity {
    [self.doneActivityLoaderView setHidden:false];
    [self.pendingActivityLoaderView setHidden:false];
    [self.requestDictionary setValue:@"Done" forKey:KEY_STATUS];
    [[EGRKWebserviceRepository sharedRepository]searchActivity:self.requestDictionary andSucessAction:^(EGPagination *paginationObj) {
        [self.doneActivityLoaderView setHidden:true];
        if (paginationObj.items && [paginationObj.items count] > 0) {
            [self bindDoneActivityData:[paginationObj.items objectAtIndex:0]];
        }
        [self getLatestPendingActivity];
    } andFailuerAction:^(NSError *error) {
        [self.doneActivityLoaderView setHidden:true];
        [self getLatestPendingActivity];
    }];
}

- (void)getLatestPendingActivity {
    [self.requestDictionary setValue:@"Open" forKey:KEY_STATUS];
    [self.pendingActivityLoaderView setHidden:false];
    [[EGRKWebserviceRepository sharedRepository]searchActivity:self.requestDictionary andSucessAction:^(EGPagination *paginationObj) {
        [self.pendingActivityLoaderView setHidden:true];
        if (paginationObj.items && [paginationObj.items count] > 0) {
            [self bindPendingActivityData:[paginationObj.items objectAtIndex:0]];
        }
    } andFailuerAction:^(NSError *error) {
        [self.pendingActivityLoaderView setHidden:true];
    }];
}

#pragma mark - Email Quotation

- (void)getQuotationDetailForOpty:(EGOpportunity *)optyObj {
    
    [[EGRKWebserviceRepository sharedRepository] getQuotationDetails:@{@"opty_id" : optyObj.optyID}
                                                    andSuccessAction:^(EGQuotation *quotation) {
                                                        quotationDetailsObj = quotation;
                                                        [self.optyOprations openQuotationPreviewFor:quotation opportunity:optyObj fromVC:self];
                                                    }
                                                    andFailuerAction:^(NSError *error) {
                                                        
                                                        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                            
                                                        } andReportIssueAction:^{
                                                            
                                                        }];
                                                    }];
}

#pragma mark - Preview API

- (void)fetchFinancierAPI:(EGOpportunity *)optyObj {
    [UtilityMethods showProgressHUD:TRUE];
    NSDictionary *dict = @{@"opty_id": optyObj.optyID,
                           @"sales_stage_name" : @[@"C1A (Papers submitted)"],
                           @"financier_case_status" : @"Approved"
                           };
    
    [[EGRKWebserviceRepository sharedRepository] fetchFinancier:dict andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        
        NSString  *offset = [dict objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [self.parentCellArray clearAllItems];
        }
        
        [self loadResultInTableView:paginationObj];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
    }];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.parentCellArray = [EGPagedArray mergeWithCopy:self.parentCellArray withPagination:paginationObj];
    if(self.parentCellArray) {
        
        FinancierListDetailModel *financierListDataModel = [self.parentCellArray objectAtIndex:0];
        
        FinancierPreviewDetailsVC *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierPreviewDetails"];
        vc.financierListModel = financierListDataModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Financier DetailApi

-(void)getFinancierDetail:(EGOpportunity*)optyObj{
    [UtilityMethods showProgressHUD:YES];
    [MBProgressHUD showHUDAddedTo:app_Delegate.window animated:true];
    int search_status = 1;
    if ([[AppRepo sharedRepo] isDSMUser]) {
        search_status = [self.showOpty isEqualToString:@"My_Opportunity"] ? 1 : 2;
    } else {
        search_status = 1;
    }
    
    NSDictionary *queryParams = @{@"sales_stage_name" : @[@"C1 (Quote Tendered)"],
                                  @"is_quote_submitted_to_financier" : @(optyObj.is_quote_submitted_to_financier),
                                  @"opty_id": optyObj.optyID,
                                  @"search_status": [NSNumber numberWithInt:search_status]
                                  };
    [self searchFinancierOptyWithParam:queryParams];
}

-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination *oportunity){
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self financierOptySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [MBProgressHUD hideHUDForView:app_Delegate.window animated:true];
        [self financierOpptySearcheFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)financierOpptySearcheFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods hideProgressHUD];
    [MBProgressHUD hideHUDForView:app_Delegate.window animated:true];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"OPtional page financier button clicked";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}
-(void)financierOptySearchedSuccessfully:(EGPagination *)paginationObj{
//    [UtilityMethods hideProg ressHUD];
    [UtilityMethods hideProgressHUD];
    [MBProgressHUD hideHUDForView:app_Delegate.window animated:true];
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    
    if ([opportunityPagedArray count] == 0) {
        //        NSLog(@"opty of Financier search is:%@", opportunityPagedArray);
//        [UtilityMethods alert_ShowMessage:[NSString stringWithFormat:@"Data Not Found"] withTitle:APP_NAME andOKAction:nil];
        
    }else{
        if(nil != opportunityPagedArray) {
            self.financierOpportunity = [opportunityPagedArray objectAtIndex:0];
    
            if (!_financierOpportunity.isQuoteSubmittedToFinancier) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                [self.navigationController pushViewController:_financierRequestVc animated:YES];
                
            } else {
                    if (!_financierOpportunity.is_eligible_for_insert_quote) {
                        FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                        vc.opportunity = self.opportunity;
                        [self.navigationController pushViewController:vc animated:YES] ;
                    
                    } else {
                       if (_financierOpportunity.isAnyCaseApproved) {
                            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                            vc.opportunity = self.opportunity;
                            [self.navigationController pushViewController:vc animated:YES] ;
                       } else {
                           if (_financierOpportunity.is_first_case_rejected) {
//                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
//                               self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                               self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                               FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                               vc.opportunity = self.opportunity;
                               [self.navigationController pushViewController:vc animated:YES];
                           } else {
                               if (_financierOpportunity.isTimeBefore48Hours) {
                                   FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                                   vc.opportunity = self.opportunity;
                                   [self.navigationController pushViewController:vc animated:YES] ;
                                   
                               } else {
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                                   self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                                   self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                                   [self.navigationController pushViewController:_financierRequestVc animated:YES];
                               }
                           }
                           
                    }
                
                }
            }
        }
    }
}

@end
