//
//  EGPagedTableViewDataSource.h
//  e-Guru
//
//  Created by Rajkishan on 09/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGPagedArray.h"
#import "EGPagination.h"

@protocol EGPagedTableViewDataSourceCallback;

@interface EGPagedTableViewDataSource : NSObject <UITableViewDataSource>
{
}

-(instancetype) initWithDataSourceCallback:(id<EGPagedTableViewDataSourceCallback>) dataSourceCallback;

@property(nonatomic)            BOOL            isLoading;
@property(nonatomic)            BOOL            isError;

@property(nonatomic, strong)    EGPagedArray    *data;
@property (nonatomic, strong) NSString *errorMessage;

@property(nonatomic, weak) id<EGPagedTableViewDataSourceCallback> dataSourceCallback;

- (void)mergeData:(EGPagedArray *)moreData;

- (void)refreshData:(EGPagedArray *)freshData;

- (void)mergeDataWithPagination:(EGPagination *)paginationObject;

-(void)clearAllData;
@end

@protocol EGPagedTableViewDataSourceCallback <NSObject>

@required

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource;
- (void)reloadTableViewData;
/*
 *  Get actual cell from derived class.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView dataSource:(EGPagedTableViewDataSource *) datasource dataCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

