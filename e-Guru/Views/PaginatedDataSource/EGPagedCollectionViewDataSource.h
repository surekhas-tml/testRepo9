//
//  EGPagedCollectionViewDataSource.h
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EGErrorCollectionViewCell.h"
#import "EGLoadingCollectionViewCell.h"
#import "EGPagedArray.h"
#import "EGPagination.h"

@protocol EGPagedCollectionViewDataSourceCallback;
@interface EGPagedCollectionViewDataSource : NSObject <UICollectionViewDataSource>
{
}

-(instancetype) initWithDataSourceCallback:(id<EGPagedCollectionViewDataSourceCallback>) dataSourceCallback;

@property(nonatomic)            BOOL            isLoading;
@property(nonatomic)            BOOL            isError;
@property(nonatomic)            BOOL            isNoData;

@property(nonatomic, strong)    EGPagedArray    *data;

@property(nonatomic, weak) id<EGPagedCollectionViewDataSourceCallback> dataSourceCallback;

- (void)mergeData:(EGPagedArray *)moreData;

- (void)refreshData:(EGPagedArray *)freshData;

-(void) resetData;

- (void)mergeDataWithPagination:(EGPagination *)paginationObject;

@end
@protocol EGPagedCollectionViewDataSourceCallback<NSObject>
@required

- (void)loadMore:(EGPagedCollectionViewDataSource *)dataSource;
/*
 *  Get actual cell from derived class.
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dataSource:(EGPagedCollectionViewDataSource *) datasource dataCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

