//
//  EGPagedTableView.m
//  e-guru
//
//  Created by MI iMac01 on 10/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPagedTableView.h"

@interface EGPagedTableView (Private)
- (void) initialize;
@end

@implementation EGPagedTableView

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
    _egPagedDataSource = [[EGPagedTableViewDataSource alloc] initWithDataSourceCallback:self];
}

#pragma mark - custom getter setter methods

- (void)setTableviewDataSource:(id<UITableViewDataSource>)tableviewDataSource
{
    self.dataSource = self.egPagedDataSource;
    self->_tableviewDataSource = tableviewDataSource;
}

#pragma mark - public methods
-(void)refreshData:(EGPagedArray *)freshPagedData
{
    [self.egPagedDataSource refreshData:freshPagedData];
}

-(void) reportError
{
    self.egPagedDataSource.errorMessage = nil;
    self.egPagedDataSource.isError = YES;
}

- (void)reportErrorWithMessage:(NSString *)message {
    self.egPagedDataSource.errorMessage = message;
    self.egPagedDataSource.isError = YES;
}

-(void) clearAllData{
    [self.egPagedDataSource clearAllData];
}


#pragma mark - EGPagedTableViewDataSourceCallback delegate methods
- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource
{
    if (     pagedTableViewDataSource == self.egPagedDataSource
       &&   nil != _pagedTableViewCallback
       ) {
        [self.pagedTableViewCallback loadMore:pagedTableViewDataSource];
        if ([self.pagedTableViewCallback respondsToSelector:@selector(loadMore:forTable:)]) {
            [self.pagedTableViewCallback loadMore:pagedTableViewDataSource forTable:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView dataSource:(EGPagedTableViewDataSource *) datasource dataCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableviewDataSource tableView:self cellForRowAtIndexPath:indexPath];
}

- (void)reloadTableViewData {
    [self reloadData];
}

@end
