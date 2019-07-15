//
//  EGPagedCollectionView.m
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPagedCollectionView.h"

@interface EGPagedCollectionView(Private)
- (void) initialize;
@end

@implementation EGPagedCollectionView

@synthesize egPagedDataSource = _egPagedDataSource;

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    _egPagedDataSource = [[EGPagedCollectionViewDataSource alloc] initWithDataSourceCallback:self];
}

#pragma mark - custom getter setter methods
- (void)setCollectionViewDataSource:(id<UICollectionViewDataSource>)collectionviewDataSource
{
    self.dataSource = self.egPagedDataSource;
    self->_collectionViewDataSource = collectionviewDataSource;
}

#pragma mark - public methods
-(void)refreshData:(EGPagedArray *)freshPagedData
{
    [self.egPagedDataSource refreshData:freshPagedData];
}

-(void) reportError
{
    self.egPagedDataSource.isError = YES;
}
-(void) reportNoResults
{
    self.egPagedDataSource.isNoData = YES;
}
-(void) resetNoResults
{
    self.egPagedDataSource.isNoData = NO;
}
#pragma mark - EGPagedCollectionViewDataSourceCallback delegate methods
- (void)loadMore:(EGPagedCollectionViewDataSource *)dataSource
{
    if (     dataSource == self.egPagedDataSource
        &&   nil != _pagedCollectionViewCallback
        ) {
        [self.pagedCollectionViewCallback loadMore:dataSource];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dataSource:(EGPagedCollectionViewDataSource *) datasource dataCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDataSource collectionView:self cellForItemAtIndexPath:indexPath];
}

@end
