//
//  ActualVsTargetViewController.m
//  e-guru
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ActualVsTargetViewController.h"
#import "ActualVsTargetTableViewCell.h"
#import "AppRepo.h"
#import "EGRKWebserviceRepository.h"
#import "DashboardHelper.h"
#import "NSDate+eGuruDate.h"
@interface ActualVsTargetViewController ()<EGPagedTableViewDelegate>{

    NSString *mToDate;
    NSString  *mFromDate;

}
@property (strong, nonatomic) EGPagedArray *DSEwiseDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;
@end

@implementation ActualVsTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.TargetVsActualTableView setPagedTableViewCallback:self];
    [self.TargetVsActualTableView setTableviewDataSource:self];
    [self setInitialDateOnDateFilterButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ]] forKey:KEY_START_DATE];
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:[NSDate date]] forKey:KEY_END_DATE];
       // [_requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].positionID forKey:POSITION_ID];
       // [_requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].positionType forKey:POSITION_TYPE];
        [_requestDictionary setObject:@"0" forKey:KEY_OFFSET];
        [_requestDictionary setObject:@"20" forKey:KEY_SIZE];
    }
    return _requestDictionary;
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    self.DSEwiseDataList = [EGPagedArray mergeWithCopy:self.DSEwiseDataList withPagination:paginationObj];
    if(self.DSEwiseDataList) {
        [self.TargetVsActualTableView refreshData:self.DSEwiseDataList];
        [self.TargetVsActualTableView reloadData];
    }
}
#pragma mark - UITableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [self.DSEwiseDataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActualVsTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TargetVsActualCell"];
    EGDse *dse = [self.DSEwiseDataList objectAtIndex:indexPath.row] ;
    cell.DSERetailLabel.text = dse.Actual_target;
    cell.DSEStretchLabel.text = dse.Stretch_target;
    cell.c0OptyLabel.text = dse.c0Model.optyCount;
    cell.c1OptyLabel.text = dse.c1Model.optyCount;
    cell.c1AOptyLabel.text = dse.c1AModel.optyCount;
    cell.c2OptyLabel.text = dse.c2Model.optyCount;
    cell.c0VehicleCountLabel.text = dse.c0Model.vehicleCount;
    cell.c1VehicleCountLabel.text = dse.c1Model.vehicleCount;
    cell.c1AVehicleCountLabel.text = dse.c1AModel.vehicleCount;
    cell.c2VehicleCountLabel.text = dse.c2Model.vehicleCount;
    cell.invoiceLabel.text = dse.Retail;
    return cell;
}


#pragma mark - EGPagedTableViewDelegate Method
- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:KEY_OFFSET];
    [self getactualvstargetData:self.requestDictionary];
}

#pragma mark - Private Methods

- (void)setInitialDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatddMMyyyy]toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    
    [self.dateLabel setText:[NSString stringWithFormat:@"%@ to %@",initialFromDate,initialToDate]];
    
    
    mToDate = [[DashboardHelper sharedHelper] getFilterUTCEndDate:[NSDate date]];
    mFromDate = [[DashboardHelper sharedHelper] getFilterUTCStartDate:[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ]];
}

#pragma mark - API Calls

- (void)getactualvstargetData:(NSDictionary *)requestDictionary {
    [[EGRKWebserviceRepository sharedRepository] getDSEwisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
            } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.TargetVsActualTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.TargetVsActualTableView reloadData];
    }];
    
}


@end
