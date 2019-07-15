//
//  PendingActivitiesListViewController.m
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "PendingActivitiesListViewController.h"
#import "UpdateActivityViewController.h"
#import "FinancierRequestViewController.h"
#import "FinancierListViewController.h"
#import "AppRepo.h"

@interface PendingActivitiesListViewController ()
{
    NSIndexPath * selectedIndexPath;
    UpdateActivityViewController *updateView;

    EGPagedArray *opportunityPagedArray;
    BOOL isQuoteSubmittedToFinancier;
}

@property (strong,nonatomic) EGPagedArray *pendingActivityArray;
@property (strong,nonatomic) FinancierRequestViewController *financierRequestVc;

@end

@implementation PendingActivitiesListViewController
@synthesize opportunity,contact,currentpendingActivityUser, financierOpportunity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self configureView];
    
    updateView=[[UpdateActivityViewController alloc]init];
    
    //** tableView datasource and delegate **//
    [self.activityTable setPagedTableViewCallback:self];
    [self.activityTable setTableviewDataSource:self];
    
    //show Financier Button
    if ([self.opportunity.salesStageName containsString:@"C1 (Quote Tendered)"]) {
        
        if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
            if([self.currentpendingActivityUser isEqual:@"Team_Activity"]) {
                self.financierButton.hidden = true;
            }
            else {
                self.financierButton.hidden = false;
            }
        } else {
            self.financierButton.hidden = false;
        }
        
    } else {
        self.financierButton.hidden = true;
    }
    
    //****//
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Pending_Activities];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [UtilityMethods navigationBarSetupForController:self];
//    [self configureView];
    
    financierOpportunity  = [[EGFinancierOpportunity alloc] init];
    
    // Added to fix issue: Pending Activity list not refreshing
    // on updating activity and returning to PendinActivitiesListViewController
    if (self.isActivityUpdated) {
        self.isActivityUpdated = false;
        [self.pendingActivityArray clearAllItems];
        [self readActivityListFromServer];
    }
}

-(void)configureView{
   
    if (self.opportunity.toContact != nil) {
        
    self.firstName.text = self.opportunity.toContact.firstName;
    self.lastname.text = self.opportunity.toContact.lastName ;
    self.mobileNumebr.text = self.opportunity.toContact.contactNumber;
    self.noOfPendingActivities.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.pendingActivityArray.count];
    } else{
        NSLog(@"toContact");
    }
        
    if([self.currentpendingActivityUser isEqual:@"Team_Activity"])
    {
        self.currentpendingActivityUser = @"Team_Activity";
        self.financierButton.hidden = true;
    }
    else
    {
        
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        self.currentpendingActivityUser = @"My_Activity";
        self.financierButton.hidden = false;
    }
    }
    
}

-(void)UpdateActivityScreen{
    [self.activityTable loadMore:self.activityTable.tableviewDataSource];
}

#pragma mark - API Call

- (void) loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource{
    [self readActivityListFromServer];
}

-(void)readActivityListFromServer{
       NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"open" forKey:@"status"];
    [dict setObject:self.opportunity.optyID forKey:@"opty_id"];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentpendingActivityUser isEqualToString:@"My_Activity"]) {
            
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
            updateView.checkuser=@"My_Activity";
            
        }else{
            [dict setObject:[NSNumber numberWithInt:2] forKey:@"search_status"];
             updateView.checkuser=@"Team_Activity";
        }
    }
    else{
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
        //updateView.checkuser=@"Team_Activity";
    }

    [[EGRKWebserviceRepository sharedRepository]getPendingActivityListForGivenOpportunity:dict andSucessAction:^(EGPagination *paginationObj) {
        NSLog(@"Sucess");
        [self activitiesFetchedWithData:paginationObj];

    } andFailuerAction:^(NSError *error) {
        
        NSLog(@"Failuer");
        [self activitiesFetchFailedWithError:error];
    }];

}

-(void)activitiesFetchedWithData:(EGPagination *)paginationObj{
    
    self.pendingActivityArray = [EGPagedArray mergeWithCopy:self.pendingActivityArray withPagination:paginationObj];
    if(nil != self.pendingActivityArray ) {
        [self.activityTable refreshData:self.pendingActivityArray ];
        [self.activityTable reloadData];
    }
    self.noOfPendingActivities.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.pendingActivityArray.count];

}
-(void)activitiesFetchFailedWithError:(NSError *)error{
    //[UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"updateActivity_Segue"]){
        if (selectedIndexPath!=nil) {
            UpdateActivityViewController *upateAct = (UpdateActivityViewController *)[segue destinationViewController];
            upateAct.pendingActivitiesViewController = self;
            upateAct.activity = [self.pendingActivityArray objectAtIndex:selectedIndexPath.row];
            upateAct.entryPoint = PENDINGSACTIVITY;
            if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
                if ([self.currentpendingActivityUser isEqualToString:@"My_Activity"]) {
            upateAct.checkuser=@"My_Activity";
                }
                else{
                     upateAct.checkuser=@"Team_Activity";
                }}else{
                     upateAct.checkuser=@"Team_Activity";
                }
        }
    }
}


#pragma mark - Table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pendingActivityArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PendingActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if (cell == nil) {
        cell = [[PendingActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    if ( fmod(indexPath.row,2) != 0) {
        cell.backgroundColor = [UIColor tableDarkRowColor];
    }else{
        cell.backgroundColor = [UIColor tableLightRowColor];
    }
    cell.editActivityButton.tag = indexPath.row;

    if ([self.pendingActivityArray count]) {
        if ([[self.pendingActivityArray objectAtIndex:0]isKindOfClass:[EGActivity class]]) {
            EGActivity *activity = [self.pendingActivityArray objectAtIndex:indexPath.row];
            
            cell.plannedDate.text = [activity planedDateSystemTimeInFormat:dateFormatddMMyyyy];
            cell.plannedTime.text = [activity planedDateSystemTimeInFormat:pendingActivityTimeFormat];
            cell.activityType.text = activity.activityType;
            cell.activityStatus.text = activity.status;
            cell.comment.text = activity.activityDescription;
        }
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[PendingActivityTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"updateActivity_Segue" sender:self];
    
    
}

#pragma mark - Button Events
- (IBAction)financerBttonClicked:(id)sender {
    [UtilityMethods showProgressHUD:YES];
    int searchStatus = 1;
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
       searchStatus = [self.currentpendingActivityUser isEqual:@"Team_Activity"] ? 2 : 1;
    } else {
        searchStatus = 1;
    }
    NSDictionary *queryParams = @{@"sales_stage_name" : @[@"C1 (Quote Tendered)"],
                                  @"is_quote_submitted_to_financier" : @(opportunity.is_quote_submitted_to_financier),
                                  @"opty_id": opportunity.optyID,
                                  @"search_status": [NSNumber numberWithInt:searchStatus],
                                  };
    [self searchFinancierOptyWithParam:queryParams];

}

#pragma mark - Api Calls
-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
    
    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination *oportunity){
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self opportunitySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [self financierOpptySearcheFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)financierOpptySearcheFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods hideProgressHUD];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"Pending Financier button clicked";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}

-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
    [UtilityMethods hideProgressHUD];
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    
    if ([opportunityPagedArray count] == 0) {
        NSLog(@"opty of Financier search is:%@", opportunityPagedArray);
        
    }else{
        
        if(nil != opportunityPagedArray) {
            
                self.financierOpportunity = [opportunityPagedArray objectAtIndex:0];
                if (!opportunity.is_quote_submitted_to_financier) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                    self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                    self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                    [self.navigationController pushViewController:_financierRequestVc animated:YES];
                    
                } else {
                    
                    if (!opportunity.is_eligible_for_insert_quote) {
                        FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                        vc.opportunity = self.opportunity;
                        [self.navigationController pushViewController:vc animated:YES] ;
                        
                    } else {
                        if (opportunity.is_Any_Case_Approved) {
                            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                            vc.opportunity = self.opportunity;
                            [self.navigationController pushViewController:vc animated:YES] ;
                            
                        } else {
                            if (opportunity.is_first_case_rejected) {
                                //old logic now changed on 28January2019 as per android
//                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
//                                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                                FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                                vc.opportunity = self.opportunity;
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            } else{
                                if (opportunity.is_time_before_48_hours) {
                                    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                                    vc.opportunity = self.opportunity;
                                    [self.navigationController pushViewController:vc animated:YES] ;
                                } else{
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                                    self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                                    self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                                    [self.navigationController pushViewController:_financierRequestVc animated:YES];
                                    
                                }
                            }
                            
                        }
                    }
                }

            //old
         /*   self.financierOpportunity = [opportunityPagedArray objectAtIndex:0];
            
            if (!opportunity.is_quote_submitted_to_financier) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                [self.navigationController pushViewController:_financierRequestVc animated:YES];
                
            } else {
                
                if (opportunity.is_Any_Case_Approved) {
                    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                    vc.opportunity = self.opportunity;
                    [self.navigationController pushViewController:vc animated:YES] ;
                    
                } else {
                    
                    if (opportunity.is_time_before_48_hours) {
                        FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                        vc.opportunity = self.opportunity; //old
                        [self.navigationController pushViewController:vc animated:YES] ;
                        
                    } else {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                        self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                        self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                        [self.navigationController pushViewController:_financierRequestVc animated:YES];
                    }
                }
            }
            */
        }
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



@end
