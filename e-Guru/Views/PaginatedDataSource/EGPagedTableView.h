//
//  EGPagedTableView.h
//  e-guru
//
//  Created by Rajkishan on 10/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableViewDataSource.h"

@protocol EGPagedTableViewDelegate;

@interface EGPagedTableView : UITableView<EGPagedTableViewDataSourceCallback>
{
@private
    EGPagedTableViewDataSource*             _egPagedDataSource;
    __weak id<EGPagedTableViewDelegate>     _pagedTableViewCallback;
}

@property(nonatomic, weak) id<UITableViewDataSource>                tableviewDataSource;
@property(nonatomic, weak) id<EGPagedTableViewDelegate>             pagedTableViewCallback;
@property(nonatomic, strong, readonly) EGPagedTableViewDataSource * egPagedDataSource;

/*
 *  Consumer to call this method whenever there is a change in the PagedArray cached with the consumer.
 */
-(void) refreshData:(EGPagedArray *)freshPagedData;
-(void) reportError;
-(void) clearAllData;
- (void)reportErrorWithMessage:(NSString *)message;
@end

/*** Protocol to be implemented by the consumer of this custom Table-View   ***/

@protocol EGPagedTableViewDelegate <NSObject>

@required
/**
 *On call of this method, consumers to fetch more data and then reload the tableview.
 */
- (void)loadMore:(EGPagedTableViewDataSource *)tableView;

@optional
- (void)loadMore:(EGPagedTableViewDataSource *)dataSource forTable:(UITableView *)tableView;

@end


//-(void) loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource;
//-(void) showMore:(EGPagination *)paginatedData;
