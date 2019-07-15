//
//  DSEwiseViewController.m
//  e-guru
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DSEwiseViewController.h"
#import "DSEwiseTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGRKWebserviceRepository.h"
#import "PipelineModel.h"
#import "FromToDatePopupViewController.h"
#import "AppRepo.h"
#import "NSDate+eGuruDate.h"
#import "DashboardHelper.h"

@interface DSEwiseViewController () <FromToDatePopupViewControllerDelegate, EGPagedTableViewDelegate>

@property (strong, nonatomic) EGPagedArray *DSEwiseDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;


@end

@implementation DSEwiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.DSEwiseTableView setPagedTableViewCallback:self];
    [self.DSEwiseTableView setTableviewDataSource:self];
    [self setInitialDateOnDateFilterButton];
    [UtilityMethods makeUnselected:self.liveTillDateButton];
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

#pragma mark - Private Methods

- (void)setInitialDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatddMMyyyy]toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)setLiveTillDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getNoOfMonths:2 pastDateInFormat:dateFormatddMMyyyy] toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getDate:[NSDate date] InFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    self.DSEwiseDataList = [EGPagedArray mergeWithCopy:self.DSEwiseDataList withPagination:paginationObj];
    if(self.DSEwiseDataList) {
        [self.DSEwiseTableView refreshData:self.DSEwiseDataList];
        [self.DSEwiseTableView reloadData];
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
    DSEwiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSEwiseCell"];
    EGDse *dse = [self.DSEwiseDataList objectAtIndex:indexPath.row] ;
    cell.DSENameLabel.text = dse.DSEName;
    cell.c0Label.text = dse.c0Model.optyCount;
    cell.c1Label.text = dse.c1Model.optyCount;
    cell.c1ALabel.text = dse.c1AModel.optyCount;
    cell.c2Label.text = dse.c2Model.optyCount;
    cell.c0qtyLabel.text = dse.c0Model.vehicleCount;
    cell.c1qtyLabel.text = dse.c1Model.vehicleCount;
    cell.c1AqtyLabel.text = dse.c1AModel.vehicleCount;
    cell.c2qtyLabel.text = dse.c2Model.vehicleCount;
    cell.R1Label.text = dse.Actual_target;
    cell.R2Label.text = dse.Stretch_target;
    cell.retailLabel.text = dse.Retail;
    return cell;
}
#pragma mark - FromToDatePopupViewControllerDelegate

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate {
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", fromDate, toDate] forState:UIControlStateNormal];
    
    NSDate *formattedToDate = [NSDate getNSDateFromString:toDate havingFormat:dateFormatddMMyyyy];
    NSDate *formattedFromDate = [NSDate getNSDateFromString:fromDate havingFormat:dateFormatddMMyyyy];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self getDSEwiseData:self.requestDictionary];
}

#pragma mark - EGPagedTableViewDelegate Method
- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:KEY_OFFSET];
    [self getDSEwiseData:self.requestDictionary];
}

#pragma mark - IBAction
- (IBAction)filterButtonTapped:(id)sender {
    [UtilityMethods makeSelected:self.dateFilterButton];
    [UtilityMethods makeUnselected:self.liveTillDateButton];
    [self.DSEwiseDataList clearAllItems];
    
    FromToDatePopupViewController *datePopupViewController = [[FromToDatePopupViewController alloc] init];
    [datePopupViewController setDelegate:self];
    
    NSArray *filterComponentArray = [UtilityMethods getFromDateAndToDateFromString:self.dateFilterButton.titleLabel.text];
    if (filterComponentArray) {
        datePopupViewController.currentfromDateString = [filterComponentArray objectAtIndex:0];
        datePopupViewController.currentToDateString = [filterComponentArray objectAtIndex:1];
    }
    
    [datePopupViewController showDatePopupfromViewController:self];
}


- (IBAction)liveTillDateButtonTapped:(id)sender {
    [self setLiveTillDateOnDateFilterButton];
    
    [UtilityMethods makeSelected:self.liveTillDateButton];
    [UtilityMethods makeUnselected:self.dateFilterButton];
    [self.DSEwiseDataList clearAllItems];
    
    NSDate *formattedToDate = [NSDate date];
    NSDate *formattedFromDate = [NSDate getNoOfMonths:2 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ];
    
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    
    [UtilityMethods showProgressHUD:true];
    [self getDSEwiseData:self.requestDictionary];
}


#pragma mark - API Calls

- (void)getDSEwiseData:(NSDictionary *)requestDictionary {
    [[EGRKWebserviceRepository sharedRepository] getDSEwisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.DSEwiseTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.DSEwiseTableView reloadData];
    }];
    
    }


@end
