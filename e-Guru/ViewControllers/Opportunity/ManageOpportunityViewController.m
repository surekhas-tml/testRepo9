//
//  ManageOpportunityViewController.m
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ManageOpportunityViewController.h"
#import "ManageOpportunityViewController+SearchOpportunity.m"
#import "EGFinancier.h"
#import "EGMMGeography.h"
#import "EGReferralCustomer.h"
#import "EGVCNumber.h"
#import "EGSearchOptyFilter.h"
#import "DetailViewController.h"
#import "NSString+NSStringCategory.h"
#import "QuotationPreviewViewController.h"

#import "FinancierListViewController.h"
#import "FinancierRequestViewController.h"
#import "FinancierPreviewDetailsVC.h"
#import "MBProgressHUD.h"

@interface ManageOpportunityViewController () {
    EGQuotation     *quotationDetailsObj;
    AppDelegate *app_Delegate;
//    BOOL financierQuoteStatus;
}

@property (strong, nonatomic) EGPagedArray                   *parentCellArray;
@property (strong, nonatomic) EGPagedArray                   *financierOpportunityArray;
@property (strong,nonatomic)  OpportunityOperationsHelper    *optyOprations;
@property (strong, nonatomic) FinancierRequestViewController * financierRequestVc;

@end

@implementation ManageOpportunityViewController
@synthesize optyOprations, financierOpportunity;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureView];
    self.optyOprations = [[OpportunityOperationsHelper alloc]init];
    
    app_Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //** tableView datasource and delegate **//
    
    if ([self.parentVC isEqualToString:MYPAGE] )
    {
        self.optySwitchDSM_DSE.hidden = YES;
        [self.searchDrawerButton setHidden:YES];
        [self.optywithsalessatgelbl setHidden:YES];
        [self.filterInformation setText:[NSString stringWithFormat:@"Opportunities with Sales Stage : %@",SEARCH_FILTER_SALES_STAGE_C0]];
    } else if([self.parentVC isEqualToString:FINANCER]){
        self.optySwitchDSM_DSE.hidden = YES;
        [self.searchDrawerButton setHidden:YES];
        [self.optywithsalessatgelbl setHidden:YES];
        [self.filterInformation setText:[NSString stringWithFormat:@"Opportunities with Sales Stage Financer Details: %@",SEARCH_FILTER_SALES_STAGE_C0]];
    }
    else {
        NSLog(@"%@",[[AppRepo sharedRepo] getLoggedInUser].positionType);
        if (![[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
            _optySwitchDSM_DSE.hidden = YES;
        
        } else{
            [searchOpportunityView setCurrentUserOpportunity:@"My_Opportunity"];
        
        }
         [self.filterInformation setHidden:YES];
         [self.optywithsalessatgelbl setHidden:NO];
         [self.optywithsalessatgelbl setText:[NSString stringWithFormat:@"Opportunities with Sales Stage : %@",SEARCH_FILTER_SALES_STAGE_C0]];
         [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Manage_Opportunity];

    }
    
    [self.collectionView setPagedCollectionViewCallback:self];
    [self.collectionView setCollectionViewDataSource:self];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //for updating title of screen
    self.navigationController.title = MANAGEOPTY;
    
    [UtilityMethods navigationBarSetupForController:self];
    for (ManageOpportunityCollectionViewCell *cell in [self.collectionView visibleCells]) {
        if([cell isKindOfClass:[ManageOpportunityCollectionViewCell class]]){
        cell.nextActivityDropdown.text = @"";
        }
    }
     self.noresultfoundlbl.hidden=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self updateCollectionView];
    [self searchViewConfiguration];
    if (self.optySwitchDSM_DSE.selectedSegmentIndex == 0) {
        [searchOpportunityView setCurrentUserOpportunity:@"My_Opportunity"];
    }
    else{
        [searchOpportunityView setCurrentUserOpportunity:@"Team_Opportunity"];
    }
}

- (EGPagedArray *)financierOpportunityArray {
    if (!_financierOpportunityArray) {
        _financierOpportunityArray = [[EGPagedArray alloc] init];
    }
    return _financierOpportunityArray;
}

- (EGPagedArray *)parentCellArray {
    if (!_parentCellArray) {
        _parentCellArray = [[EGPagedArray alloc] init];
    }
    return _parentCellArray;
}

-(void)updateCollectionView{
    if (opportunityPagedArray.count > 0) {
        [opportunityPagedArray clearAllItems];
        [self.collectionView reloadData];
    }
}

- (void)configureView {
    
    // Update the user interface for the detail item.
    self.navigationController.title = MANAGEOPTY;
    [self addGestureRecogniserToView];
    searchOptyFilter = [self lastWeekC0OptyQuery];
    
   }

-(EGSearchOptyFilter *)lastWeekC0OptyQuery{
    
    NSDate *now = [[NSDate getEOD:[[NSDate date]toLocalTime]]toGlobalTime];
    NSDate *sevenDaysAgo = [[NSDate getSOD:[[NSDate getNoOfDays:7 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ]toLocalTime]]toGlobalTime];
    
    EGSearchOptyFilter *searchFilter = [[EGSearchOptyFilter alloc] init];

    if (self.invokedFrom == Home && self.searchByValue.stringToSearch.length > 0) {
        searchFilter.customer_cellular_number = self.searchByValue.stringToSearch;
    }else{
        searchFilter.from_date = [NSDate getDate:sevenDaysAgo InFormat:dateFormatyyyyMMddTHHmmssZ];
        
        searchFilter.to_date = [NSDate getDate:now InFormat:dateFormatyyyyMMddTHHmmssZ];
        
        searchFilter.sales_stage_name = SEARCH_FILTER_SALES_STAGE_C0;
        searchFilter.primary_employee_id = [[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID;
    }
    
    if (![[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        
        searchFilter.search_status=MYOPTY;
    }
    else{
        [searchOpportunityView setCurrentUserOpportunity:@"My_Opportunity"];
       searchFilter.search_status=MYOPTY;
    }
    return searchFilter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //when i click on retail thn if nil comes than next time after clicking on details opprtunityBeing Acted upon getinng nil value.
    if ([[segue identifier]isEqualToString:@"opportunityDetails_Segue"]) {
        OpportunityDetailsViewController *oDVC = (OpportunityDetailsViewController *)[segue destinationViewController];
        
        opportunityBeingActedUpon = [opportunityPagedArray objectAtIndex:[(UIView *)sender tag]];
        
        oDVC.opportunity = opportunityBeingActedUpon;
        if (_optySwitchDSM_DSE.selectedSegmentIndex == 0) {
            
            oDVC.showOpty = @"My_Opportunity";
        }else{
            oDVC.showOpty = @"Team_Opportunity";
        }
        
    }else if ([[segue identifier]isEqualToString:@"CreateActivity_Segue"]) {
        NewActivityViewController *oDVC = (NewActivityViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunityBeingActedUpon;
        oDVC.contact = oDVC.opportunity.toContact;

    }
    else if ([[segue identifier]isEqualToString:@"PendingActivity_Segue"]) {
        PendingActivitiesListViewController *oDVC = (PendingActivitiesListViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunityBeingActedUpon;
        oDVC.contact = oDVC.opportunity.toContact;
        if (_optySwitchDSM_DSE.selectedSegmentIndex == 0) {
            
            oDVC.currentpendingActivityUser = @"My_Actitivity";
        }else{
            oDVC.currentpendingActivityUser = @"Team_Activity";
        }


    }
    else if ([[segue identifier]isEqualToString:@"LostOpportunity_Segue"]) {
        LostOpportunityViewController *oDVC = (LostOpportunityViewController *)[segue destinationViewController];
        oDVC.opportunity = opportunityBeingActedUpon;
        oDVC.contact = oDVC.opportunity.toContact;
        if (_optySwitchDSM_DSE.selectedSegmentIndex == 0) {
            
            oDVC.currentoptyUsers = @"My_Opportunity";
        }else{
            oDVC.currentoptyUsers = @"Team_Opportunity";
        }
    }
    else if ([[segue identifier] isEqualToString:@"QuotationPreview_Segue"]) {
        QuotationPreviewViewController *quotationPreviewViewController = (QuotationPreviewViewController *)[segue destinationViewController];
        quotationPreviewViewController.opportunityObj = opportunityBeingActedUpon;
        quotationPreviewViewController.quotationObj = quotationDetailsObj;
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


#pragma mark - Collection View


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ManageOpportunityCollectionViewCell *optyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"opportunityCell" forIndexPath:indexPath];
    
    if (optyCell == nil) {
        optyCell = [[ManageOpportunityCollectionViewCell alloc]init];
    }
    
    if ([self.parentVC isEqualToString:MYPAGE] )
    {
        [self.searchDrawerButton setHidden:YES];
        [self.vcTitle setHidden:NO];
        [self.filterInformation setHidden:NO];
        
        [self.filterInformation setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.filterInformation
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0
                                                                               constant:-20];
        
        [self.view removeConstraint:appliedFilterLeadinConstraint];
        [self.view addConstraints:@[trailingConstraint]];
        optyCell.selectnextactionlbl.hidden = YES;
        optyCell.nextActivityDropdown.hidden = YES;

    }
    //change
    else{
        optyCell.selectnextactionlbl.hidden = NO;
        optyCell.nextActivityDropdown.hidden = NO;
    }
    
    optyCell.delegate = self;
    optyCell.nextActivityDropdown.delegate = self;
    optyCell.tag = indexPath.row;
    optyCell.nextActivityDropdown.tag = optyCell.tag;
    
    EGOpportunity *opportunity = [opportunityPagedArray objectAtIndex:indexPath.row];
    //EGDse *dse = [opportunityPagedArray objectAtIndex:indexPath.row];
        [optyCell.quantityView setTitle:opportunity.quantity.length > 0 ? opportunity.quantity : @"0" forState:UIControlStateNormal];
        optyCell.name.text = [NSString stringWithFormat:@"%@ %@",opportunity.toContact.firstName? : @"" , opportunity.toContact.lastName ? : @""];
        optyCell.productName.text = opportunity.toVCNumber.productName;
    
    optyCell.optyId.text = opportunity.optyID;
    optyCell.dseName.text = opportunity.leadAssignedName;
    optyCell.mobileNumber.text = opportunity.toContact.contactNumber;
    
    
    if ([opportunity.salesStageName containsString:@"C0"]) {

        optyCell.nfaStatus.hidden = YES;
        optyCell.nfaStatusTitle.hidden = YES;
        
        if ([[AppRepo sharedRepo]isDSMUser]) {
            
            if (_optySwitchDSM_DSE.selectedSegmentIndex == 0) {
                [optyCell.manageOptySubViewHeightConstraint setConstant:115.0f];
                [optyCell.dseName setHidden:true];
                [optyCell.dseNameTitle setHidden:true];
                
            }else{
                [optyCell.manageOptySubViewHeightConstraint setConstant:135.0f];
                [optyCell.DSELabelTopSpacingConstraints setConstant:-21];
                [optyCell.dseName setHidden:false];
                [optyCell.dseNameTitle setHidden:false];
            }
        }
        else {
            
            [optyCell.manageOptySubViewHeightConstraint setConstant:110.0f];
            [optyCell.dseName setHidden:true];
            [optyCell.dseNameTitle setHidden:true];
        }
    }else{
    
        optyCell.nfaStatus.hidden = false;
        optyCell.nfaStatusTitle.hidden = false;
        
        if ([opportunity.nfaNumber hasValue]) {
            optyCell.nfaStatus.text = @"YES";
        }else{

            optyCell.nfaStatus.text = @"NO";
        }
        if ([[AppRepo sharedRepo] isDSMUser]) {

            if (self.optySwitchDSM_DSE.selectedSegmentIndex == 0) {
                [optyCell.dseName setHidden:true];
                [optyCell.dseNameTitle setHidden:true];
                [optyCell.manageOptySubViewHeightConstraint setConstant:140.0f];
            }else{
                //[optyCell.OptyIdTopSpacingConstraints setConstant:0.0f];
                [optyCell.DSELabelTopSpacingConstraints setConstant:1.0];
                [optyCell.dseName setHidden:false];
                [optyCell.dseNameTitle setHidden:false];
                [optyCell.manageOptySubViewHeightConstraint setConstant:155.0f];
            }
        }
        else {

            [optyCell.manageOptySubViewHeightConstraint setConstant:135.0f];
            [optyCell.dseName setHidden:true];
            [optyCell.dseNameTitle setHidden:true];
        }
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];
    NSDate *date = [dateFormatter dateFromString:opportunity.opportunityCreatedDate];
    
        optyCell.optyCreationDate.text = [date ToISTStringInFormat:dateFormatddMMyyyy];
        optyCell.salesStage.text = opportunity.salesStageName;
        optyCell.lastPendingActivity.text = @"";
    
    if (!self.parentVC || ![self.parentVC isEqualToString:MYPAGE]) {

        if ((indexPath.row + 2) % 3 == 0) {
            [optyCell.colorStripeView setBackgroundColor:[UIColor colorWithR:235 G:198 B:72 A:1]];
        }
        else {
            [optyCell.colorStripeView setBackgroundColor:[UIColor colorWithR:0 G:161 B:25 A:1]];
        }
    }
    
    return optyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.parentVC isEqual:MYPAGE])
    {
        return CGSizeMake(305, 188);
    }
    else{
        if (indexPath.row >= [opportunityPagedArray count]) {
            return CGSizeMake(305, 240);
        }else{
            EGOpportunity *opportunity = [opportunityPagedArray objectAtIndex:indexPath.row];
            if ([opportunity.salesStageName containsString:@"C0"]) {
                
                if ([[AppRepo sharedRepo] isDSMUser]) {
                    if (self.optySwitchDSM_DSE.selectedSegmentIndex == 0) {
                        return CGSizeMake(305, 220);
                    }
                    else{
                        return CGSizeMake(305, 240);
                    }
                }else{
                    return CGSizeMake(305, 210);
                }
            }else{
                
                if ([[AppRepo sharedRepo] isDSMUser]) {
                    if (self.optySwitchDSM_DSE.selectedSegmentIndex == 0) {
                        return CGSizeMake(305, 240);
                    }else{
                        return CGSizeMake(305, 260);
                    }
                }else{
                    return CGSizeMake(305, 240);
                }
            }
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)loadMore:(EGPagedCollectionViewDataSource *)dataSource{
    NSLog(@"in load more %lu",(unsigned long)[dataSource.data count] );
    [self searchOpportunityForFilter:searchOptyFilter withOffset:[dataSource.data count] withSize:10];
}

#pragma mark - search Drawer Open Close Action Methods

- (IBAction)openSearchDrawer:(id)sender {
//    [self gestureHandlerMethodToDissmissSearchView:sender];
   
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    searchOpportunityView.searchFilter = searchOptyFilter;
    [searchOpportunityView.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:searchOpportunityView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [searchOpportunityView setHidden:!searchOpportunityView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@"Search Open");
                    }];
}

# pragma mark - Text field
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField.text  = @"";
    activeField = textField;
    if ([activeField isDescendantOfView:self.collectionView])
    {
        activeField.text  = @"";
        activeField = textField;
       
        //To stop crashing when OpportunityPagedAray has no data comng from server
        if (opportunityPagedArray.count > textField.tag) {
          opportunityBeingActedUpon = [opportunityPagedArray objectAtIndex:textField.tag];
        } 
        
        if ([[AppRepo sharedRepo] isDSMUser]) {
            
            if (self.optySwitchDSM_DSE.selectedSegmentIndex == 0) {
                actionList = [self.optyOprations setActionsArrayForOpportunity:opportunityBeingActedUpon withTab:@"My_Opportunity"];
            }else{
                actionList = [self.optyOprations setActionsArrayForOpportunity:opportunityBeingActedUpon withTab:@"Team_Opportunity"];
            }
            
        }else{
            actionList = [self.optyOprations setActionsArrayForOpportunity:opportunityBeingActedUpon withTab:@"DSE"];
        }
        
        if ([actionList count] == 0) {
            [self gestureHandlerMethodToDissmissSearchView:nil];
            [UtilityMethods alert_ShowMessage:[NSString stringWithFormat:@"Can Not Perform any action on Opportunity in %@ state, please tap on card to view opportunity details",opportunityBeingActedUpon.salesStageName] withTitle:APP_NAME andOKAction:nil];
        }else{
            [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:actionList] andModelData:[NSMutableArray arrayWithArray:actionList]];
        }
        
        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField{
    [textField resignFirstResponder];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder;
    
    // Try to find next responder
    if (nextResponder) {
        // Found next responder, so set it.
        nextTag++;
        [nextResponder becomeFirstResponder];
        
    } else {
        // Not found, so remove keyboard.
        
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

# pragma mark - Opportunity Operations methods

-(void)DropDownViewClickedWithTag:(long)actionTag withOpty:(EGOpportunity *)opty{
    if ([[actionList objectAtIndex:actionTag] isEqualToString:UPDATE]) {
        [self.optyOprations openUpdateOpportunityViewFor:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Update_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if ([[actionList objectAtIndex:actionTag] isEqualToString:CREATE_NFA]) {
        [self.optyOprations openCreateNFARequestFor:opty fromVC:self];
    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:PENDINGACT]){
        [self.optyOprations showPendingActivitiesListFor:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Pending_Activity_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:LINKCAMPAIGN]){
        [self.optyOprations showAvailbleCampaignListFor:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Link_Campaign_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:MARKLOST]){
        
        [self.optyOprations markOpportunityAsLostFor:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_MarkAs_Lost_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:CREATEC1]){
        [self.optyOprations createQuoteForOpportunityFor:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Create_C1_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:NEWACT]){
        [self.optyOprations showCreateNewActivityViewOnOpportunity:opty fromVC:self];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_New_Activity_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:ASSIGN]){
        [self.optyOprations getDSElist:opty fromVC:self showLoader:NO];
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
    }
    else if([[actionList objectAtIndex:actionTag] isEqualToString:EMAIL_QUOTATION]){
        
        [self performSelector:@selector(getQuotationDetailForOpty:) withObject:opty afterDelay:0.2];
        //TODO: Add Google Analytics Event
    }
    else if ([[actionList objectAtIndex:actionTag] isEqualToString:RETAIL_FINANCIER]){
        [UtilityMethods showProgressHUD:YES];
        [MBProgressHUD showHUDAddedTo:app_Delegate.window animated:true];
       
        [self performSelector:@selector(getFinancierDetail:) withObject:opty afterDelay:0.1];
        
        /*Use it for retailFinancier click page navigation */
        _opportunity = opty;
    }
    else if ([[actionList objectAtIndex:actionTag] isEqualToString:PREVIEW]){

        [self performSelector:@selector(fetchFinancierAPI:) withObject:opty.optyID afterDelay:0.1];
        _opportunity = opty;
    }
    
    activeField.text = @"";
}

#pragma mark - Preview API
- (void)fetchFinancierAPI:(NSString *)optyString {
    
    NSDictionary *dict = @{@"opty_id": optyString,
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
        [UtilityMethods hideProgressHUD];
        
        FinancierListDetailModel *financierListDataModel = [self.parentCellArray objectAtIndex:0];
        FinancierPreviewDetailsVC *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierPreviewDetails"];
        vc.financierListModel = financierListDataModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)getFinancierDetail:(EGOpportunity*)optyObj{
    //logic to send search status based on dse/dsm
    NSDictionary *queryParams_old = @{@"sales_stage_name" : @[@"C1 (Quote Tendered)"],
                                  @"search_status"    : @"1",
                                  @"is_quote_submitted_to_financier" : @(optyObj.is_quote_submitted_to_financier),
                                  @"opty_id": optyObj.optyID
                                };
    NSMutableDictionary * queryParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @[@"C1 (Quote Tendered)"],@"sales_stage_name",
                                        @"1",@"search_status",
                                        @(optyObj.is_quote_submitted_to_financier),@"is_quote_submitted_to_financier",
                                        optyObj.optyID,@"opty_id",
                                         nil];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        [queryParams setObject:[NSNumber numberWithInt:searchOptyFilter.search_status] forKey:@"search_status"];
    }else{
        [queryParams setObject:@"1" forKey:@"search_status"];
    }
    [self searchFinancierOptyWithParam:queryParams];
}

-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
   
    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination *oportunity){
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [_financierOpportunityArray clearAllItems];
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
    [UtilityMethods hideProgressHUD];
    _financierOpportunityArray = [EGPagedArray mergeWithCopy:_financierOpportunityArray withPagination:paginationObj];
    [MBProgressHUD hideHUDForView:app_Delegate.window animated:true];
    
    if ([_financierOpportunityArray count] == 0) {
        NSLog(@"opty of Financier has no data found:%@", _financierOpportunityArray);
    }
    else{
        if(nil != _financierOpportunityArray) {
            
            self.financierOpportunity = [_financierOpportunityArray objectAtIndex:0];
            if (!_opportunity.is_quote_submitted_to_financier) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                [self.navigationController pushViewController:_financierRequestVc animated:YES];
          
            } else {
              
                if (!_opportunity.is_eligible_for_insert_quote) {
                    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                    vc.opportunity = self.opportunity;
//                    vc.strFinancierOptyID = self.financierOpportunity.toFinancierOpty.optyID;
                    [self.navigationController pushViewController:vc animated:YES] ;
                
                } else {
                    if (_opportunity.is_Any_Case_Approved) {
                        FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                        vc.opportunity = self.opportunity;
                        [self.navigationController pushViewController:vc animated:YES] ;
                    
                    } else {
                        if (_opportunity.is_first_case_rejected) {
                             //old logic now changed on 28January2019 as per android
//                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
//                            self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                            self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                            vc.opportunity = self.opportunity;
                            [self.navigationController pushViewController:vc animated:YES];

                        } else{
                            //Update : As per discussed with sidharth on 14 jan 2019
                            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                            vc.opportunity = self.opportunity;
                            [self.navigationController pushViewController:vc animated:YES] ;

//                            if (_opportunity.is_time_before_48_hours) {
//                            //update: if condition removed and written before if condition as per discussed.
//                            } else{
//                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
//                                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
//                                [self.navigationController pushViewController:_financierRequestVc animated:YES];
//                            }
                        }
                        
                    }
                }
            }
            
        }
    }
}

#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodToDissmissSearchView:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (![searchOpportunityView isHidden]) {
        if (![touch.view isDescendantOfView:searchOpportunityView]) {
            return YES;
        }
    }else{
        if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
            return YES;
        }
        else if ([[touch.view superview]isKindOfClass:[ManageOpportunityCollectionViewCell class]]) {
            return NO;
        }
        else if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
        else if ([touch.view isDescendantOfView:self.view]) {
            return YES;
        }
    }
    return NO;
}

-(void)gestureHandlerMethodToDissmissSearchView:(id)sender{
    if (![searchOpportunityView isHidden]) {
        [searchOpportunityView closeSearchDrawer:sender];
    }
    
    [activeField resignFirstResponder];
    if (activeField != nil) {
        activeField.text = @"";
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    [self DropDownViewClickedWithTag:[actionList indexOfObject:selectedValue] withOpty:opportunityBeingActedUpon];
}

#pragma mark - UISegement Control
- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        searchOptyFilter.search_status=MYOPTY;
        searchOpportunityView.searchFilter = searchOptyFilter;
        [searchOpportunityView setCurrentUserOpportunity:@"My_Opportunity"];
        
    } else {
        searchOptyFilter.search_status=TEAMOPTY;
        searchOpportunityView.searchFilter = searchOptyFilter;
        [searchOpportunityView setCurrentUserOpportunity:@"Team_Opportunity"];
    }
    
    //TODO : Need to improve below code
    [opportunityPagedArray clearAllItems];
    [self loadMore:self.collectionView.dataSource];
    [self.collectionView reloadData];

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

@end
