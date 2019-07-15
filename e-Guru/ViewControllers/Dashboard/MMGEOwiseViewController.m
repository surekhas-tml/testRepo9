//
//  MMGEOwiseViewController.m
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "MMGEOwiseViewController.h"
#import "MMGEOwiseTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGRKWebserviceRepository.h"
#import "PipelineModel.h"
#import "FromToDatePopupViewController.h"
#import "NSDate+eGuruDate.h"
#import "DashboardHelper.h"
#import "AppRepo.h"

@interface MMGEOwiseViewController () <UITableViewDataSource, EGPagedTableViewDelegate, FromToDatePopupViewControllerDelegate>

@property (strong, nonatomic) EGPagedArray *mmGeowiseDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;

@end

@implementation MMGEOwiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mmGeowiseTableView setPagedTableViewCallback:self];
    [self.mmGeowiseTableView setTableviewDataSource:self];
    [self setInitialDateOnDateFilterButton];
    [UtilityMethods makeUnselected:self.liveTillDateButton];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
        [_requestDictionary setObject:@"0" forKey:KEY_OFFSET];
        if (![[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]){
            [_requestDictionary setObject:[NSNumber numberWithInt:1] forKey:SEARCH_STATUS];
        }
        
    }
    return _requestDictionary;
}

- (EGPagedArray *)mmGeowiseDataList {
    if (!_mmGeowiseDataList) {
        _mmGeowiseDataList = [[EGPagedArray alloc] init];
    }
    return _mmGeowiseDataList;
}

#pragma mark - Private Methods

- (void)setInitialDateOnDateFilterButton {
    NSString *initialFromDate = [NSDate getDate:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatddMMyyyy]toLocalTime] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)setLiveTillDateOnDateFilterButton {
    
    NSString *initialFromDate = [NSDate getDate:[NSDate getNoOfMonths:2 pastDateInFormat:dateFormatddMMyyyy] InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.mmGeowiseDataList = [EGPagedArray mergeWithCopy:self.mmGeowiseDataList withPagination:paginationObj];
    if(self.mmGeowiseDataList) {
        [self.mmGeowiseTableView refreshData:self.mmGeowiseDataList];
        [self.mmGeowiseTableView reloadData];
    }
}

- (void)setupCell:(MMGEOwiseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PipelineModel *model = [self.mmGeowiseDataList objectAtIndex:indexPath.row];
    [cell.mmGeoNameLabel setText:model.name];
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

#pragma mark - EGPagedTableViewDelegate Method

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    [self getMMGeowiseData:self.requestDictionary];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mmGeowiseDataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMGEOwiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmgeowiseCell"];
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - FromToDatePopupViewControllerDelegate

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate {
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", fromDate, toDate] forState:UIControlStateNormal];
    [self.mmGeowiseDataList clearAllItems];

    NSDate *formattedFromDate = [NSDate getNSDateFromString:fromDate havingFormat:dateFormatddMMyyyy];
    NSDate *formattedToDate = [NSDate getNSDateFromString:toDate havingFormat:dateFormatddMMyyyy];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getMMGeowiseData:self.requestDictionary];
}

#pragma mark - IBAction
- (IBAction)filterButtonTapped:(id)sender {
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
    
    [self.mmGeowiseDataList clearAllItems];
    
    NSDate *formattedFromDate = [NSDate getNoOfMonths:2 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ];
    NSDate *formattedToDate = [NSDate date];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getMMGeowiseData:self.requestDictionary];
}


#pragma mark - API Calls

- (void)getMMGeowiseData:(NSDictionary *)requestDictionary {
    
    [[EGRKWebserviceRepository sharedRepository] getMMGeowisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.mmGeowiseTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.mmGeowiseTableView reloadData];
    }];
    
}


@end
