//
//  EGPagedCollectionView.h
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedCollectionViewDataSource.h"

@protocol EGPagedCollectionViewDelegate;
@interface EGPagedCollectionView : UICollectionView<EGPagedCollectionViewDataSourceCallback>
{
@private
    EGPagedCollectionViewDataSource*             _egPagedDataSource;
    __weak id<EGPagedCollectionViewDelegate>     _pagedCollectionViewCallback;
}

- (void)setCollectionViewDataSource:(id<UICollectionViewDataSource>)collectionviewDataSource;

@property(nonatomic, weak) id<UICollectionViewDataSource>                collectionViewDataSource;
@property(nonatomic, weak) id<EGPagedCollectionViewDelegate>             pagedCollectionViewCallback;
@property(nonatomic, strong, readonly) EGPagedCollectionViewDataSource * egPagedDataSource;
/*
 *  Consumer to call this method whenever there is a change in the PagedArray cached with the consumer.
 */
-(void) refreshData:(EGPagedArray *)freshPagedData;
-(void) reportError;
-(void) reportNoResults;
-(void) resetNoResults;
@end

/*** Protocol to be implemented by the consumer of this custom Table-View   ***/

@protocol EGPagedCollectionViewDelegate <NSObject>

@required
/**
 *On call of this method, consumers to fetch more data and then reload the tableview.
 */
- (void)loadMore:(EGPagedCollectionViewDataSource *)dataSource;
@end


