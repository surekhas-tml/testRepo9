//
//  EGPagedTableViewDataSource.m
//  e-Guru
//
//  Created by Rajkishan on 09/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "AppDelegate.h"
#import "EGLoadingTableViewCell.h"
#import "EGPagedTableViewDataSource.h"
#import "EGErrorTableViewCell.h"
#import "EGNoSearchResultTableViewCell.h"
#import "NSString+NSStringCategory.h"


#define EG_LOADING_VIEW     @"EG_LOADING_VIEW"
#define EG_ERROR_VIEW     @"EG_ERROR_VIEW"

@interface EGPagedTableViewDataSource(Private)

- (BOOL)canLoadMore;
- (UITableViewCell*) getLoadingCell:(UITableView *)tableView;
- (UITableViewCell*) getErrorCell:(UITableView *)tableView;
- (UITableViewCell*) noResultCell:(UITableView *)tableView;
@end

@implementation EGPagedTableViewDataSource

#pragma mark - init methods
-(instancetype) init
{
    self = [super init];
    if(self) {
        [self resetData];
    }
    return self;
}

-(instancetype) initWithDataSourceCallback:(id<EGPagedTableViewDataSourceCallback>) dataSourceCallback
{
    self = [super init];
    if(self) {
        [self resetData];
        _dataSourceCallback = dataSourceCallback;
    }
    return self;
}

-(void) resetData
{
    _isError = NO;
    _isLoading = NO;
    _dataSourceCallback = nil;
    _data = [[EGPagedArray alloc] init];
}

#pragma mark - Custom setter methods
-(void) setData:(EGPagedArray *)data
{
    if (nil == data) {
        [self resetData];
        return;
    }
    _data = data;
}

#pragma mark - Table View DataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger currentSize = [self.data currentSize] ;
    if ([self.data totalResults]==0) {
        return currentSize+1;
    }
    else{
       AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (appDelegate.doNotFetchData) {
            return currentSize;
        }else{
            return ([self canLoadMore]) ? currentSize+1: currentSize;
        }
        
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger dataSize = [self.data currentSize];
    
    BOOL canLoadMore = [self canLoadMore];
    if ([self.data totalResults]==0) {
        return [self noResultCell:tableView];
    }
    else if(_isError && row == [_data currentSize]) {
        return [self getErrorCell:tableView];
    }
    else if(canLoadMore && row == dataSize) {//
        if(!self.isLoading) {
            [self loadMoreData];
        }
        return [self getLoadingCell:tableView];
    }
    else{
       return [self.dataSourceCallback tableView:tableView dataSource:self dataCellForRowAtIndexPath:indexPath];
    }
    
    
}

#pragma mark protected methods to be called from derived classes

- (void)mergeData:(EGPagedArray *) moreData
{
    _data = [EGPagedArray mergeWithCopy:_data withArray:moreData];
}

- (void)mergeDataWithPagination:(EGPagination *)paginationObject{
    EGPagedArray *otherPagedArray = [[EGPagedArray alloc] initWithArray:paginationObject.items];
    _data = [EGPagedArray mergeWithCopy:_data withArray:otherPagedArray];
}

- (BOOL) canLoadMore
{
    return(_data.totalResults == -1
           || _data.currentSize < _data.totalResults);
}

- (void)loadMoreData
{
    _isLoading = YES;
    _isError = NO;
    
    if (nil != _dataSourceCallback) {
        [_dataSourceCallback reloadTableViewData]; // Added to show loading cell on clicking error reload button
        [_dataSourceCallback loadMore:self];
    }
}

-(void)clearAllData{
    [_data clearAllItems];
}
#pragma mark - public methods
- (void) refreshData:(EGPagedArray *)freshData
{
    self.isLoading = NO;
    self.data = freshData;
}

#pragma mark - private methods

- (void)handleRefresh
{
    if(!_isLoading) {
        [self loadMoreData];
    }
}

#pragma mark - buttonAction
-(void)refreshButtonClicked:(id)sender{
    
    _isLoading = NO;
    [self handleRefresh];
}

#pragma mark - Loading and Error Cells - private methods

- (UITableViewCell *) noResultCell:(UITableView *)tableView
{
    EGNoSearchResultTableViewCell *cell = (EGNoSearchResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EG_ERROR_VIEW];
    
    //if (cell == nil)
    {
        [tableView registerClass:[EGNoSearchResultTableViewCell class] forCellReuseIdentifier:EG_ERROR_VIEW];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGNoSearchResultTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

- (UITableViewCell *) getErrorCell:(UITableView *)tableView
{
    EGErrorTableViewCell *cell = (EGErrorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EG_ERROR_VIEW];
    
    //if (cell == nil)
    {
        [tableView registerClass:[EGErrorTableViewCell class] forCellReuseIdentifier:EG_ERROR_VIEW];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGErrorTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.refreshButton.layer.cornerRadius = 5.0f;
        if ([self.errorMessage hasValue]) {
            [cell.messageLabel setText:self.errorMessage];
        }
        [cell.refreshButton addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (UITableViewCell *) getLoadingCell:(UITableView *)tableView
{
    EGLoadingTableViewCell *cell = (EGLoadingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EG_LOADING_VIEW];
    
   // if (cell == nil)
    {
        [tableView registerClass:[EGLoadingTableViewCell class] forCellReuseIdentifier:EG_LOADING_VIEW];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGLoadingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    int totalResult = (int)[self.data totalResults];
    int totalCount = (int)[self.data currentSize];
    if (totalResult == 0) {
        cell.messageLabel.text = @"No search results found";
    }
    else{
        cell.messageLabel.text = @"Loading...";

    }
    
    return cell;
}

@end
