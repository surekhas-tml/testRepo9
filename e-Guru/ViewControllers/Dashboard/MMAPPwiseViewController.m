//
//  MMAPPwiseViewController.m
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "MMAPPwiseViewController.h"
#import "MMAPPwiseTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "UtilityMethods.h"
#import "PipelineModel.h"
#import "FromToDatePopupViewController.h"
#import "NSDate+eGuruDate.h"
#import "DashboardHelper.h"
#import "AppRepo.h"

@interface MMAPPwiseViewController () <UITableViewDataSource, EGPagedTableViewDelegate, FromToDatePopupViewControllerDelegate>

@property (strong, nonatomic) EGPagedArray *mmAppwiseDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;

@end

@implementation MMAPPwiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mmAppwiseTableView setPagedTableViewCallback:self];
    [self.mmAppwiseTableView setTableviewDataSource:self];
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
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ]] forKey:@"start_date"];
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:[NSDate date]] forKey:@"end_date"];
        [_requestDictionary setObject:@"0" forKey:@"offset"];
        if (![[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]){
            [_requestDictionary setObject:[NSNumber numberWithInt:1] forKey:SEARCH_STATUS];
        }
    }
    return _requestDictionary;
}

- (EGPagedArray *)mmAppwiseDataList {
    if (!_mmAppwiseDataList) {
        _mmAppwiseDataList = [[EGPagedArray alloc] init];
    }
    return _mmAppwiseDataList;
}

#pragma mark - Private Methdos

- (void)setInitialDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatddMMyyyy]toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)setLiveTillDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[NSDate getNoOfMonths:2 pastDateInFormat:dateFormatddMMyyyy] InFormat:dateFormatddMMyyyy];
;
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.mmAppwiseDataList = [EGPagedArray mergeWithCopy:self.mmAppwiseDataList withPagination:paginationObj];
    if(self.mmAppwiseDataList) {
        [self.mmAppwiseTableView refreshData:self.mmAppwiseDataList];
        [self.mmAppwiseTableView reloadData];
    }
}

- (void)setupCell:(MMAPPwiseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PipelineModel *model = [self.mmAppwiseDataList objectAtIndex:indexPath.row];
    [cell.mmApplicationNameLabel setText:model.name];
    [cell.c0Label setText:[UtilityMethods getDisplayStringForValue:model.c0Model.optyCount]];
    [cell.c1Label setText:[UtilityMethods getDisplayStringForValue:model.c1Model.optyCount]];
    [cell.c1ALabel setText:[UtilityMethods getDisplayStringForValue:model.c1AModel.optyCount]];
    [cell.c2Label setText:[UtilityMethods getDisplayStringForValue:model.c2Model.optyCount]];
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor tableViewAlternateCellColor]];
    }
}

#pragma mark - EGPagedTableViewDelegate Methods

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    [self getMMAppwiseData:self.requestDictionary];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mmAppwiseDataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMAPPwiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmappwiseCell"];
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - FromToDatePopupViewControllerDelegate

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate {
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", fromDate, toDate] forState:UIControlStateNormal];
    [self.mmAppwiseDataList clearAllItems];
    
    NSDate *formattedToDate = [NSDate getNSDateFromString:toDate havingFormat:dateFormatddMMyyyy];
    NSDate *formattedFromDate = [NSDate getNSDateFromString:fromDate havingFormat:dateFormatddMMyyyy];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getMMAppwiseData:self.requestDictionary];
}

#pragma mark - IBAction

- (IBAction)dateFilterButtonTapped:(id)sender {
    
    [UtilityMethods makeSelected:self.dateFilterButton];
    [UtilityMethods makeUnselected:self.liveTillDateButton];
    
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
    
    [self.mmAppwiseDataList clearAllItems];
    
    NSDate *formattedToDate = [NSDate date];
    NSDate *formattedFromDate = [NSDate getNoOfMonths:2 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getMMAppwiseData:self.requestDictionary];
}


#pragma mark - API Calls

- (void)getMMAppwiseData:(NSDictionary *)requestDictionary {
    
    [[EGRKWebserviceRepository sharedRepository] getMMAPPwisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.mmAppwiseTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.mmAppwiseTableView reloadData];
    }];
}

@end
