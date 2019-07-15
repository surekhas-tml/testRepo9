//
//  PPLwiseViewController.m
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "PPLwiseViewController.h"
#import "PPLwiseTableViewCell.h"
#import "PPLwiseChildTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGPagedTableView.h"
#import "PPLDataModel.h"
#import "PLDataModel.h"
#import "EGRKWebserviceRepository.h"
#import "FromToDatePopupViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "NSDate+eGuruDate.h"
#import "DashboardHelper.h"
#import "EGErrorTableViewCell.h"
#import "AppRepo.h"

static CGFloat cellDefaultHeight = 44.0f;

@interface PPLwiseViewController () <UITableViewDelegate, UITableViewDataSource, EGPagedTableViewDelegate, FromToDatePopupViewControllerDelegate>

@property (weak, nonatomic) IBOutlet EGPagedTableView *pplwiseDataTableView;

@property (strong, nonatomic) EGPagedArray *parentCellArray;
@property (strong, nonatomic) NSMutableArray *expandedIndexArray;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;

@end

@implementation PPLwiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     if ([[AppRepo sharedRepo] isDSMUser]) {
         self.noteLabel.hidden=false;
         self.currentStockLabel.hidden=false;
     }else{
         self.noteLabel.hidden=true;
         self.currentStockLabel.hidden=true;
     }
    [self.pplwiseDataTableView setPagedTableViewCallback:self];
    [self.pplwiseDataTableView setTableviewDataSource:self];
    [self setInitialDateOnDateFilterButton];
    [UtilityMethods makeUnselected:self.liveTillDateButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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

- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ] ]forKey:KEY_START_DATE];
        [_requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:[NSDate date]] forKey:KEY_END_DATE];
        [_requestDictionary setObject:@"0" forKey:KEY_OFFSET];
        if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]){
            [_requestDictionary setObject:[NSNumber numberWithInt:3] forKey:SEARCH_STATUS];
        }
        else{
             [_requestDictionary setObject:[NSNumber numberWithInt:1] forKey:SEARCH_STATUS];
        }
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
    NSString *initialFromDate = [NSDate getDate:[NSDate getNoOfMonths:2 pastDateInFormat:dateFormatddMMyyyy]InFormat:dateFormatddMMyyyy];
    NSString *initialToDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", initialFromDate, initialToDate] forState:UIControlStateNormal];
}

- (NSString *)getStringIndexFrom:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%ld", (long)indexPath.row];
}

- (CGFloat)calculateHeightForCellAtIndex:(NSIndexPath *)indexPath {
    
    if ([self shouldExpandCell:indexPath]) {
        PPLDataModel *pplDataModel = [self.parentCellArray objectAtIndex:indexPath.row];
        if (pplDataModel.plDetailsArray && [pplDataModel.plDetailsArray count] > 0) {
            return (([pplDataModel.plDetailsArray count] + 1) * cellDefaultHeight); // + 1 for the parent cell
        }
    }
    
    return cellDefaultHeight;
}

- (BOOL)shouldExpandCell:(NSIndexPath *)indexPath {
    if ([self.expandedIndexArray containsObject:[self getStringIndexFrom:indexPath]]) {
        return true;
    }
    return false;
}

- (void)addChildViewsInCell:(PPLwiseTableViewCell *)pplwiseTableViewCell atIndexPath:(NSIndexPath *)indexPath {
    PPLDataModel *pplDataModel = [self.parentCellArray objectAtIndex:indexPath.row];
    if (pplDataModel.plDetailsArray && [pplDataModel.plDetailsArray count] > 0) {
        
        // Change PPL text color
//        [pplwiseTableViewCell.pplName setTextColor:[UIColor themePrimaryColor]];
        
        NSInteger childIndex = 1;
        for (PLDataModel *plDataModel in pplDataModel.plDetailsArray) {
            PPLwiseChildTableViewCell *childView = [[PPLwiseChildTableViewCell alloc] initWithFrame:CGRectMake(0, childIndex * cellDefaultHeight, self.pplwiseDataTableView.frame.size.width, cellDefaultHeight)];
            
            [childView.plNameLabel setText:plDataModel.plName];
            [childView.c0OptyCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c0Model.optyCount]];
            [childView.c0VehicleCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c0Model.vehicleCount]];
            [childView.c1OptyCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c1Model.optyCount]];
            [childView.c1VehicleCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c1Model.vehicleCount]];
            [childView.c1AOptyCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c1AModel.optyCount]];
            [childView.c1AVehicleCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c1AModel.vehicleCount]];
            [childView.c2OptyCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c2Model.optyCount]];
            [childView.c2VehicleCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c2Model.vehicleCount]];
            [childView.c2VehicleCount setText:[UtilityMethods getDisplayStringForValue:plDataModel.c2Model.vehicleCount]];
            if ([[AppRepo sharedRepo] isDSMUser]) {
                childView.currentStockpl.hidden=false;
                [childView.currentStockpl setText:[UtilityMethods getDisplayStringForValue:plDataModel.currentStockpl]];
            }else{
                childView.currentStockpl.hidden=true;
            }
            
            // Set alternate color to cell
            if ((childIndex - 1) % 2 == 0) {
                [childView setBackgroundColor:[UIColor clearColor]];
            }
            else {
                [childView setBackgroundColor:[UIColor tableViewAlternateCellColor]];
            }
            
            [pplwiseTableViewCell.contentView addSubview:childView];
            childIndex ++;
        }
    }
}

//- (void)removeChildViewInCell:(FinancierListTableViewCell *)financierListTableViewCell atIndexPath:(NSIndexPath *)indexPath {
//    // Reset PPL text color
////    [financierListTableViewCell.finan setTextColor:[UIColor blackColor]];
//    // Iterate to remove child views
//    for (UIView *childView in [financierListTableViewCell.contentView subviews]) {
//        if ([childView isKindOfClass:[PPLwiseChildTableViewCell class]]) {
//            [childView removeFromSuperview];
//        }
//    }
//}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.parentCellArray = [EGPagedArray mergeWithCopy:self.parentCellArray withPagination:paginationObj];
    if(self.parentCellArray) {
        [self.pplwiseDataTableView refreshData:self.parentCellArray];
        [self.pplwiseDataTableView reloadData];
    }
}

- (void)setupCell:(PPLwiseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PPLDataModel *pplDataModel = [self.parentCellArray objectAtIndex:indexPath.row];
    
    // Set border color for parent cell
    [cell setBorder];
    
    [cell.pplName setText:pplDataModel.pplName];
    [cell.c0OptyCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c0Model.optyCount]];
    [cell.c0VehicleCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c0Model.vehicleCount]];
    [cell.c1OptyCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c1Model.optyCount]];
    [cell.c1VehicleCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c1Model.vehicleCount]];
    [cell.c1AOptyCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c1AModel.optyCount]];
    [cell.c1AVehicleCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c1AModel.vehicleCount]];
    [cell.c2OptyCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c2Model.optyCount]];
    [cell.c2VehicleCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.c2Model.vehicleCount]];
    if ([[AppRepo sharedRepo] isDSMUser]) {
        cell.currentStockCount.hidden=false;
    [cell.currentStockCount setText:[UtilityMethods getDisplayStringForValue:pplDataModel.currentStock]];
    }else{
        cell.currentStockCount.hidden=true;
    }
    
    if ([self shouldExpandCell:indexPath]) {
        [cell.caretButton setSelected:true];
//        [self removeChildViewInCell:cell atIndexPath:indexPath];
        [self addChildViewsInCell:cell atIndexPath:indexPath];
    }
    else {
        [cell.caretButton setSelected:false];
//        [self removeChildViewInCell:cell atIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parentCellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PPLwiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pplwiseCell"];
    [self setupCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeightForCellAtIndex:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Don't do anything if error cell is clicked
    if ([[DashboardHelper sharedHelper] errorCellInTableView:tableView atIndexPath:indexPath]) {
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

#pragma mark - EGPagedTableViewDelegate

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:KEY_OFFSET];
    [self getPPLwiseData:self.requestDictionary];
}

#pragma mark - FromToDatePopupViewControllerDelegate

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate {
    [self.dateFilterButton setTitle:[NSString stringWithFormat:@"%@ to %@", fromDate, toDate] forState:UIControlStateNormal];
    [self.parentCellArray clearAllItems];
    
    NSDate *formattedToDate = [[NSDate getNSDateFromString:toDate havingFormat:dateFormatddMMyyyy]toGlobalTime];
    NSDate *formattedFromDate = [[NSDate getNSDateFromString:fromDate havingFormat:dateFormatddMMyyyy]toGlobalTime];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getPPLwiseData:self.requestDictionary];
}

#pragma mark - IBActions

- (IBAction)dateFilterClicked:(id)sender {
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

- (IBAction)liveTillDateClicked:(id)sender {
    [self setLiveTillDateOnDateFilterButton];
    [UtilityMethods makeSelected:self.liveTillDateButton];
    [UtilityMethods makeUnselected:self.dateFilterButton];
    
    [self.parentCellArray clearAllItems];
    
    NSDate *formattedFromDate = [NSDate getNoOfMonths:2 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ];
    NSDate *formattedToDate = [NSDate date];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCEndDate:formattedToDate] forKey:KEY_END_DATE];
    [self.requestDictionary setObject:[[DashboardHelper sharedHelper] getFilterUTCStartDate:formattedFromDate] forKey:KEY_START_DATE];
    [self.requestDictionary setObject:@"0" forKey:KEY_OFFSET];
    
    [UtilityMethods showProgressHUD:true];
    [self getPPLwiseData:self.requestDictionary];
}

#pragma mark - API Calls

- (void)getPPLwiseData:(NSDictionary *)requestDictionary {
    
    [[EGRKWebserviceRepository sharedRepository] getPPLwisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        
        // This data clearing is done to prevent redundat data in the parent cell array.
        // Redundant data comes when we come to dashboard screen and PPLwise data is
        // loading and at the same time filter/live till date is applied.
        NSString  *offset = [requestDictionary objectForKey:@"offset"];
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


@end
