//
//  EGPagedCollectionViewDataSource.m
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPagedCollectionViewDataSource.h"
#import "ReachabilityManager.h"
#define EG_LOADING_VIEW     @"loading"
#define EG_ERROR_VIEW     @"error"

@interface EGPagedCollectionViewDataSource(Private)
- (BOOL)canLoadMore;
- (UICollectionViewCell *) getLoadingCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell*) getErrorCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EGPagedCollectionViewDataSource

#pragma mark - init methods
-(instancetype) init
{
    self = [super init];
    if(self) {
        [self resetData];
    }
    return self;
}

-(instancetype) initWithDataSourceCallback:(id<EGPagedCollectionViewDataSourceCallback>) dataSourceCallback
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
    _isNoData = NO;
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

#pragma mark - Collection View DataSource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSUInteger currentSize = [self.data currentSize] ;
    return ([self canLoadMore]) ? currentSize+1: currentSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger dataSize = [self.data currentSize];
    
    BOOL canLoadMore = [self canLoadMore];
    if(_isError && row == [_data currentSize]) {
        return [self getErrorCell:collectionView forIndexPath:indexPath];
    }
    else if(canLoadMore && row == dataSize) {//
        if(!self.isLoading) {
            [self loadMoreData];
        }
        return [self getLoadingCell:collectionView forIndexPath:indexPath];
    }
    else{
        return [self.dataSourceCallback collectionView:collectionView dataSource:self dataCellForRowAtIndexPath:indexPath];
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
        [_dataSourceCallback loadMore:self];
    }
}

#pragma mark - public methods
- (void) refreshData:(EGPagedArray *)freshData
{
    self.isLoading = NO;
    self.data = freshData;
}

#pragma mark - private methods

- (void) handleRefresh
{
    if(!_isLoading) {
        [self loadMoreData];
    }
}

#pragma mark - buttonAction
-(void)refreshButtonClicked:(id)sender{
    self.isLoading = NO;
    [self handleRefresh];
}

#pragma mark - Loading and Error Cells - private methods
- (UICollectionViewCell *) getErrorCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    EGErrorCollectionViewCell *cell = (EGErrorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EG_ERROR_VIEW forIndexPath:indexPath];
    
    if (cell == nil)
    {
        [collectionView registerClass:[EGErrorCollectionViewCell class] forCellWithReuseIdentifier:EG_ERROR_VIEW];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGErrorCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.refreshButton.layer.cornerRadius = 2.0f;
        
    }
    if (![[ReachabilityManager sharedInstance] isInternetAvailable]) {
        cell.messageLabel.text = @"No Internet Connection";
    }
    [cell.loaderView setHidden:true];
    [cell.refreshButton addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionViewCell *) getLoadingCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    EGLoadingCollectionViewCell *cell = (EGLoadingCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EG_LOADING_VIEW forIndexPath:indexPath];

    if (cell == nil)
    {
        [collectionView registerClass:[EGLoadingCollectionViewCell class] forCellWithReuseIdentifier:EG_LOADING_VIEW];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGLoadingCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.message = @"";
    }
    
    int totalResult = (int)[self.data totalResults];
    int totalCount = (int)[self.data currentSize];
    if (totalCount == 0) {
        cell.message.text = @"Loading...";
        cell.loadingIndicator.hidden = NO;
    }
    if (self.isNoData) {
        cell.message.text = @"No Search results Found";
        cell.loadingIndicator.hidden = YES;
    }
    
    return cell;
}


@end
