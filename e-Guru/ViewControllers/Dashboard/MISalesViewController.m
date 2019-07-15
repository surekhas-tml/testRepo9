//
//  MISalesViewController.m
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "MISalesViewController.h"
#import "MISalesTableViewCell.h"
#import "MISalesDetailsViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "UtilityMethods.h"
#import "EGDse.h"
#import "AppRepo.h"
#import "FromToDatePopupViewController.h"
#import "EGPagination.h"
#import "EGPagedArray.h"
#import "NSDate+eGuruDate.h"
#import "DashboardHelper.h"
#import "EGMisSummary.h"

@interface MISalesViewController () <UITableViewDataSource, EGPagedTableViewDelegate, FromToDatePopupViewControllerDelegate> {
    
    NSString *mToDate;
    NSString  *mFromDate;
}

@property (strong, nonatomic) EGPagedArray *MISSaleswiseDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;

@end

@implementation MISalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setInitialDateOnDateFilterButton];
    [self.MIStableview setPagedTableViewCallback:self];
    [self.MIStableview setTableviewDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:mFromDate forKey:KEY_START_DATE];
        [_requestDictionary setObject:mToDate forKey:KEY_END_DATE];
        [_requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].positionID forKey:POSITION_ID];
        [_requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].positionType forKey:POSITION_TYPE];
    }
    return _requestDictionary;
}

- (EGPagedArray *)MISSaleswiseDataList {
    if (!_MISSaleswiseDataList) {
        _MISSaleswiseDataList = [[EGPagedArray alloc] init];
    }
    return _MISSaleswiseDataList;
}

#pragma mark - Private Methods

- (void)setInitialDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatddMMyyyy]toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ To %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
    
    mToDate = [[DashboardHelper sharedHelper] getFilterUTCEndDate:[NSDate date]];
    mFromDate = [[DashboardHelper sharedHelper] getFilterUTCStartDate:[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ]];
}

- (void)setLiveTillDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[NSDate getNoOfMonths:2 pastDateInFormat:dateFormatddMMyyyy] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ To %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    self.MISSaleswiseDataList = [EGPagedArray mergeWithCopy:self.MISSaleswiseDataList withPagination:paginationObj];
    if(self.MISSaleswiseDataList) {
        [self.MIStableview refreshData:self.MISSaleswiseDataList];
        [self.MIStableview reloadData];
    }
}

#pragma mark - EGPagedTableViewDelegate Method

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    [self getDSEMISwiseData:self.requestDictionary];
    [self.MIStableview reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.MISSaleswiseDataList count];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MISalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"miSalesCell"];
    
    EGMisSummary *missummary = [self.MISSaleswiseDataList objectAtIndex:indexPath.row] ;
    cell.dealerNameLabel.text=missummary.DealerName;
    cell.lobLabel.text =   missummary.LOB;
    cell.pplLabel.text =  missummary.PPL;
    cell.dseLabel.text =  missummary.dseName;
    cell.nnewInvoiceLabel.text =  missummary.NewInvoiceCount;
    cell.cancelInvoiceLabel.text =  missummary.CancelledCount;
    cell.netInvoiceLabel.text =  missummary.NetInvoice;
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor tableViewAlternateCellColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.MISSaleswiseDataList && [self.MISSaleswiseDataList count]!=0){
    EGMisSummary *missummary = [self.MISSaleswiseDataList objectAtIndex:indexPath.row] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    MISalesDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MISalesDetailsViewController"];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.dashboardNavigationController pushViewController:vc animated:YES];
    vc.fromToTillDateString = self.dateFilterButton.titleLabel.text;
    vc.dseUserID=missummary.dseUserID;
    vc.dseName=missummary.dseName;
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Details withEventCategory:GA_CL_Dashboard withEventResponseDetails:nil];
    }
}

#pragma mark - FromToDatePopupViewControllerDelegate

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate {
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ To %@", fromDate, toDate] forState:UIControlStateNormal];
    [self.MISSaleswiseDataList clearAllItems];
    
    NSDate *formattedFromDate = [NSDate getNSDateFromString:fromDate havingFormat:dateFormatddMMyyyy];
    NSDate *formattedToDate = [NSDate getNSDateFromString:toDate havingFormat:dateFormatddMMyyyy];
    
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Search withEventCategory:GA_CL_Dashboard withEventResponseDetails:nil];

    [self getDSEMISwiseData:self.requestDictionary];
}

#pragma mark - API Calls

- (void)getDSEMISwiseData:(NSDictionary *)requestDictionary {
    
    [[EGRKWebserviceRepository sharedRepository] getDSEMiswisePipeline:nil andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Search withEventCategory:GA_CL_Dashboard withEventResponseDetails:GA_EA_Dashboard_MisSales_Search_Successful];

    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.MIStableview reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.MIStableview reloadData];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Details withEventCategory:GA_CL_Dashboard withEventResponseDetails:GA_EA_Dashboard_MisSales_Search_Failed];

    }];
    
    
}

@end
