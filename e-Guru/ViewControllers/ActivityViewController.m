//
//  ActivityViewController.m
//  e-guru
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ScreenshotCapture.h"
#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityTableViewCellDSM.h"
#import "NSString+NSStringCategory.h"
#import "NSDate+eGuruDate.h"
#import "ActivityHelper.h"
#import "EGErrorTableViewCell.h"


#define RESULTS_LIMIT 20

@interface ActivityViewController () <EGPagedTableViewDelegate>
{          AppDelegate *appDelegate;

    UITapGestureRecognizer *tapRecognizer;
}


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self addGestureRecogniserToView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.showDayViewButton.hidden = YES;
    self.showDayViewButton.layer.cornerRadius = 5.0f;
    //self.calenderView.layer.cornerRadius = 5.0f;
    [self.calenderView setImageEdgeInsets:UIEdgeInsetsZero];
    [self.calenderContainer setHidden:YES];
    [self.tableView setHidden:NO];
    [self.legendsCal setHidden:YES];

    if (self.invokedFrom != Dashboard) {
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Activities];
        [UtilityMethods navigationBarSetupForController:self];
    }
    else{
    }
    
        [self.calenderView setHidden:NO];
        [self addChildViewController:self.myCalVC];
        [self.calenderContainer addSubview:self.myCalVC.view];
        [self.myCalVC.view setFrame:self.calenderContainer.bounds];
        [self.myCalVC didMoveToParentViewController:self];

    // Handle the case of screen invoked due to Push Notifications
    [self handleNotificationCallIfAny];
    
    [self.tableView setPagedTableViewCallback:self];
    [self.tableView setTableviewDataSource:self];
    [self setDateRange:[NSString stringWithFormat:@"%@ to %@", [NSDate getDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatddMMyyyy] InFormat:dateFormatddMMyyyy], [NSDate getCurrentDateInFormat:dateFormatddMMyyyy]]];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        self.switchButtonLeading.constant = self.buttonSpace.constant;
    }else{
        self.activitySwitchDSE_DSM.hidden = YES;
    }
    
    [self configureView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateTableView];
    [UtilityMethods navigationBarSetupForController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCalenderSwitchedValueChanged:) name:ACTIVITY_CALENDER_SWITCH object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_CALENDER_SWITCH object:nil];
}
- (void)onCalenderSwitchedValueChanged:(NSNotification *)notification {
    [self.showDayViewButton setUserInteractionEnabled:YES];
}

- (void)handleNotificationCallIfAny {
    
    if (self.shouldShowTeamsActivity) {
        
        self.isdsmdseactivity = TEAMACTIVITY;
        [self.activitySwitchDSE_DSM setSelectedSegmentIndex:1];
        [activityView setCurrentUser:@"Team_Activity"];
        [self.myCalVC setActivity:@"Team_Activity"];
        [self.myCalVC refreshMode];
        
        self.shouldShowTeamsActivity = false;
    }
}

-(EGCalenderViewCollectionViewController *)myCalVC{
    if (_myCalVC == nil) {
        _myCalVC = [[EGCalenderViewCollectionViewController alloc] init];
        _myCalVC.viewMode =  MSDayView;
        _myCalVC.activity = @"My_Activity";
        _myCalVC.invokedFrom = Dashboard;
        _myCalVC.dashboardViewController = self.dashboardViewController;
        _myCalVC.activityViewController = self;
    }
    return _myCalVC;
}
- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:@"" forKey:@"taluka"];
        [_requestDictionary setObject:@"" forKey:@"type"];
        [_requestDictionary setObject:@"Open" forKey:@"status"];
        [_requestDictionary setObject:@"0" forKey:@"offset"];
        [_requestDictionary setObject:GTME_APP forKey:@"app_name"];
        
        NSString * dateString = [[ActivityHelper sharedHelper] getActivityFilterUTCStartDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ]];

        if ([dateString length] > 0) {
            dateString = [dateString substringToIndex:[dateString length] - 2];
        }
        dateString = [NSString stringWithFormat:@"%@1Z",dateString];
        [_requestDictionary setObject:dateString forKey:@"start_date"];

        [_requestDictionary setObject:[[ActivityHelper sharedHelper] getActivityFilterUTCEndDate:[NSDate date]] forKey:@"end_date"];
        
        [_requestDictionary setObject:@"" forKey:@"stg_name_s"];
        [_requestDictionary setObject:@"" forKey:@"ppl"];
        [_requestDictionary setObject:@"20" forKey:@"size"];
        
       
        if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM])
        {
            activityView.currentActivityUser = @"My_Activity";
            
            self.isdsmdseactivity=MYACTIVITY;
           [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity] forKey:@"search_status"];

        }else{
            activityView.currentActivityUser = @"Team_Activity";
            self.isdsmdseactivity=TEAMACTIVITY;

           [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity] forKey:@"search_status"];

        }
    }
    return _requestDictionary;
}

- (void)configureView {
    // Show Default Filter Applied : Status - Open
    [self.appliedFilterLabel setText:[NSString stringWithFormat:@"%@ Activity Status : Open", TEXT_FILTER_APPLIED]];
    [self.filterSeparator setHidden:false];
}
//To check that is opportunity is not associated with curren activity then consider its backend added activity
-(BOOL)isGTMEActivity:(EGActivity *)activity{
    
    if (((activity.toOpportunity.optyID.length == 0) || [activity.toOpportunity.optyID isEqualToString:@""]))  {
        return YES;
    } else {
        return NO;
    }
}

- (void)setDateRange:(NSString *)dateRange {
    [self.dateRangeLabel setText:dateRange];
}
- (void)showFilter:(NSString *)filterText {
    [self.appliedFilterLabel setHidden:false];
    [self.filterSeparator setHidden:false];
    [self.appliedFilterLabel setText:filterText];
}

- (void)hideFilter {
    [self.appliedFilterLabel setHidden:true];
    [self.filterSeparator setHidden:true];
}

- (void)searchWithActivityDictionary:(NSDictionary *)searchQuery {
    self.requestDictionary = [NSMutableDictionary dictionaryWithDictionary:searchQuery];
    if ([self.calenderContainer isHidden]) {
        [_activityList clearAllItems];
        [self.tableView reloadData];
    }
    else{
        [self.myCalVC filterAppliedWithQueryParams:searchQuery];
    }
}

- (void)searchActivityWithQueryParameters:(NSDictionary *)queryParams {
    NSString  *offset = [queryParams objectForKey:@"offset"];
    if ([offset integerValue] == 0) {
        [self.activityList clearAllItems];
        [self.tableView reloadData];
    }
    [[EGRKWebserviceRepository sharedRepository]searchActivity:queryParams andSucessAction:^(EGPagination *paginationObj) {
        
        [self loadResultInTableView:paginationObj];
        if (self.filterApplied) {
            [self.activitiesMissedLabel setHidden:true];
        }
        else {
            [self.activitiesMissedLabel setHidden:false];
            [self.activitiesMissedLabel setText:[NSString stringWithFormat:@"Activities missed in last 30 days: %@", paginationObj.totalResultsString]];
        }
        
        } andFailuerAction:^(NSError *error) {
            [self activitySearchFailedWithErrorMessage:error];
            [self.tableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
            [self.tableView reloadData];
        }];
}

-(void)activitySearchFailedWithErrorMessage:(NSError *)error{
    //[UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];

    [ScreenshotCapture takeScreenshotOfView:self.view];
    appDelegate.screenNameForReportIssue = @"Search Activity";

    [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

}

- (void)viewDidAppear:(BOOL)animated{
    [self searchViewConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchViewConfiguration{
    
    activityView = [[ActivityView alloc]initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    activityView.delegate = self;
    [activityView setHidden:YES];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        activityView.currentActivityUser = @"My_Activity";
    }
    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:activityView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                         constant:0];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint]];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {    
    self.activityList = [EGPagedArray mergeWithCopy:self.activityList withPagination:paginationObj];
    if(self.activityList) {
        [self.tableView refreshData:self.activityList];
        [self.tableView reloadData];
    }
}

#pragma mark - EGPagedTableViewDelegate Method

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    if ([[AppRepo sharedRepo] isDSMUser]){
    if (self.activitySwitchDSE_DSM.selectedSegmentIndex == 0) {
        self.isdsmdseactivity=MYACTIVITY;
        [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity] forKey:@"search_status"];
    }else{
       self.isdsmdseactivity=TEAMACTIVITY;
        [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity] forKey:@"search_status"];
    }}else{
        self.isdsmdseactivity=MYACTIVITY;
        [_requestDictionary setObject:[NSNumber numberWithInt:self.isdsmdseactivity] forKey:@"search_status"];
    }
    [self searchActivityWithQueryParameters:self.requestDictionary];
}

-(void)updateTableView{
    if (_activityList.count > 0) {
        [_activityList clearAllItems];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activityList currentSize];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if ([[AppRepo sharedRepo] isDSMUser] && _activitySwitchDSE_DSM.selectedSegmentIndex == 1)   {
        
        ActivityTableViewCellDSM *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCellIdentifierDSM"];
        if (cell == nil) {
            cell = [[ActivityTableViewCellDSM alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCellIdentifierDSM"];
        }
        EGActivity *activity = [self.activityList objectAtIndex:indexPath.row];
        cell.pplLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.ppl];
        
        NSString * fullName = [NSString stringWithFormat:@"%@ %@",[UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.firstName],[UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.lastName]];
        
        cell.contactNameLabel.text = [UtilityMethods getDisplayStringForValue:fullName];
        cell.mobileNumberLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.contactNumber];
        cell.salesStageLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.salesStageName];
        cell.activityTypeLabel.text = [UtilityMethods getDisplayStringForValue:activity.activityType];
        cell.pplLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.ppl];
        cell.dseName.text =  [[[UtilityMethods getDisplayStringForValue:activity.toOpportunity.leadAssignedName] stringByAppendingString:@" "] stringByAppendingString: [UtilityMethods getDisplayStringForValue:activity.toOpportunity.leadAssignedLastName]];
        cell.plannedDateAndTime.text = [activity planedDateSystemTimeInFormat:activityListDateFormat];
        if ( fmod(indexPath.row,2) == 0) {
            cell.backgroundColor = [UIColor clearColor];
        }else{
            cell.backgroundColor = [UIColor tableViewAlternateCellColor];
        }
        
        if ([self isGTMEActivity:activity]){
            if (activity.stakeholderResponse != nil) {
                
                NSDictionary *dic = [UtilityMethods getJSONFrom:activity.stakeholderResponse];
                
                NSString * fullName = [NSString stringWithFormat:@"%@ %@",dic[@"first_name"],dic[@"last_name"]];
                
                cell.contactNameLabel.text = [UtilityMethods getDisplayStringForValue:fullName];
                cell.mobileNumberLabel.text = [UtilityMethods getDisplayStringForValue:dic[@"contact_no"]];
            }
        }
        
        return cell;
    }
    else {
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCellIdentifier"];
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCellIdentifier"];
        }
        EGActivity *activity = [self.activityList objectAtIndex:indexPath.row];
        cell.pplLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.ppl];
        NSString * fullName = [NSString stringWithFormat:@"%@ %@",[UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.firstName],[UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.lastName]];
        
        cell.contactNameLabel.text = [UtilityMethods getDisplayStringForValue:fullName];
        cell.mobileNumberLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.toContact.contactNumber];
        cell.salesStageLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.salesStageName];
        cell.activityTypeLabel.text = [UtilityMethods getDisplayStringForValue:activity.activityType];
        cell.pplLabel.text = [UtilityMethods getDisplayStringForValue:activity.toOpportunity.ppl];
        cell.plannedDateAndTime.text = [activity planedDateSystemTimeInFormat:activityListDateFormat];
        if ( fmod(indexPath.row,2) == 0) {
            cell.backgroundColor = [UIColor clearColor];
        }else{
            cell.backgroundColor = [UIColor tableViewAlternateCellColor];
        }
        
        if ([self isGTMEActivity:activity]){
            if (activity.stakeholderResponse != nil) {

                NSDictionary *dic = [UtilityMethods getJSONFrom:activity.stakeholderResponse];
              
                NSString * fullName = [NSString stringWithFormat:@"%@ %@",dic[@"first_name"],dic[@"last_name"]];
                
                cell.contactNameLabel.text = [UtilityMethods getDisplayStringForValue:fullName];
                cell.mobileNumberLabel.text = [UtilityMethods getDisplayStringForValue:dic[@"contact_no"]];
            }
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActivityTableHederView *activityHeader;

    if ([[AppRepo sharedRepo] isDSMUser]) {
        
        if (_activitySwitchDSE_DSM.selectedSegmentIndex == 0) {
            
            activityHeader = [[ActivityTableHederView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30) withActivity:@"My_Activity"];
        }
        else{
            activityHeader = [[ActivityTableHederView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30) withActivity:@"Team_Activity"];
        }
        return activityHeader;
    }
    else {
        
        activityHeader = [[ActivityTableHederView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30) withActivity:@"My_Activity"];
        return activityHeader;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell isKindOfClass:[EGErrorTableViewCell class]]) {
        if ([[AppRepo sharedRepo] isDSMUser]) {
            UpdateActivityViewController *activityDetails = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
            activityDetails.activity = [self.activityList objectAtIndex:indexPath.row];
            activityDetails.entryPoint = ACTIVITY;
            if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
                if ([self.myCalVC.activity isEqualToString:@"My_Activity"]) {
                    activityDetails.checkuser=@"My_Activity";
                }
                else{
                    activityDetails.checkuser=@"Team_Activity";
                }}else{
                    activityDetails.checkuser=@"Team_Activity";
                }

            if (self.invokedFrom == Dashboard && self.dashboardViewController) {
                [self.dashboardViewController.navigationController pushViewController:activityDetails animated:true];
            }
            else {
                [self.navigationController pushViewController:activityDetails animated:YES];
            }
        }
        else{
            
            UpdateActivityViewController *activityDetails = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
            activityDetails.activity = [self.activityList objectAtIndex:indexPath.row];
            activityDetails.entryPoint = ACTIVITY;
            if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
                if ([self.myCalVC.activity isEqualToString:@"My_Activity"]) {
                    activityDetails.checkuser=@"My_Activity";
                }
                else{
                    activityDetails.checkuser=@"Team_Activity";
                }}else{
                    activityDetails.checkuser=@"Team_Activity";
                }
            if (self.invokedFrom == Dashboard && self.dashboardViewController) {
                [self.dashboardViewController.navigationController pushViewController:activityDetails animated:true];
            }
            else {
                [self.navigationController pushViewController:activityDetails animated:YES];
            }
        }
    }
}

-(void)activityFilterButtonClickedWithTag:(long)tag{
    NSLog(@"CDCD");
}
#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

#pragma mark - search Drawer Open Close Action Methods


- (IBAction)ActivitySearchOpenDrawea:(id)sender {
    
    
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromRight;
        animation.duration = 0.2;
        [activityView.layer addAnimation:animation forKey:nil];
        [UIView transitionWithView:activityView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [activityView setHidden:!activityView.hidden];
                        }
                        completion:^(BOOL finished) {
                            NSLog(@"Search Open");
                        }];
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
    if (![activityView isHidden]) {
        if (![touch.view isDescendantOfView:activityView]) {
            return YES;
        }
    }else{
        return NO;
    }
    return NO;
}
-(void)gestureHandlerMethodToDissmissSearchView:(id)sender{
    if (![activityView isHidden]) {
        [activityView CloseDrawer:sender];
    }
}

- (IBAction)showOrHideCalenderView:(id)sender {
    
    [self.showDayViewButton setHidden:!self.showDayViewButton.isHidden];
    [self.calenderContainer setHidden:!self.calenderContainer.isHidden];
    [self.legendsCal setHidden:self.calenderContainer.isHidden];
    [self.tableView setHidden:!self.tableView.isHidden];

    if (self.calenderContainer.isHidden) {
        //self.leadingSpace.constant = 5;
        self.switchButtonLeading.constant = self.buttonSpace.constant;
        self.filterApplied = NO;
        [self.calenderView setImage:[UIImage imageNamed:@"calView"] forState:UIControlStateNormal];
        if (self.filterApplied) {
            [self.activitiesMissedLabel setHidden:true];
        }
        else {
            [self.activitiesMissedLabel setHidden:false];
        }
    }else{
        self.switchButtonLeading.constant = (self.buttonSpace.constant * 2) + self.switchButtonWidth.constant;
        self.filterApplied = YES;
        [self.calenderView setImage:[UIImage imageNamed:@"listViewImage"] forState:UIControlStateNormal];
        [self.activitiesMissedLabel setHidden:true];
    }

}
- (IBAction)showDayOrWeekView:(id)sender {
    [self.showDayViewButton setUserInteractionEnabled:NO];
    NSLog(@"---showDayOrWeekView");
    if ([self.myCalVC.viewMode isEqualToString:MSWeekView]) {

        self.myCalVC.viewMode =  MSDayView;
        [self.showDayViewButton setTitle:@"Switch to Week View" forState:UIControlStateNormal];
    }else if ([self.myCalVC.viewMode isEqualToString:MSDayView]) {

        self.myCalVC.viewMode = MSWeekView;
        [self.showDayViewButton setTitle:@"Switch to Day View" forState:UIControlStateNormal];
    }
    [self.myCalVC refreshMode];

}

- (void)toggleDayViewButton:(BOOL)enable {
    if (enable) {
        [self.showDayViewButton setBackgroundColor:[UIColor themePrimaryColor]];
        [self.showDayViewButton setEnabled:true];
    }
    else {
        
        [self.showDayViewButton setBackgroundColor:[UIColor themeDisabledColor]];
        [self.showDayViewButton setEnabled:false];
    }
}
#pragma mark - Activity UISegement Control
- (IBAction)activitySegmentSwitch:(UISegmentedControl *)sender {
    
    if (![activityView isHidden]) {
        [activityView CloseDrawer:sender];
    }
    
    if (sender.selectedSegmentIndex == 0) {//My Activity

        [activityView setCurrentUser:@"My_Activity"];
        
       
        self.myCalVC.activity = @"My_Activity";
    }
    else{//Team Opportunity
        [activityView setCurrentUser:@"Team_Activity"];
       
        self.myCalVC.activity = @"Team_Activity";
    }

    [_activityList clearAllItems];
    [self.tableView reloadData];
    
//    [self loadMore:self.tableView.dataSource];
    

    //Refrersh Calender View
    [self.myCalVC refreshMode];
}
@end
