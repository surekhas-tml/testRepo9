//
//  DashboardHelper.m
//  e-guru
//
//  Created by MI iMac04 on 06/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "DashboardHelper.h"
#import "NSDate+eGuruDate.h"
#import "EGErrorTableViewCell.h"

@implementation DashboardHelper

static DashboardHelper *sharedHelper = nil;

+ (instancetype)sharedHelper {
    @synchronized([DashboardHelper class]) {
        if (!sharedHelper) {
            sharedHelper = [[self alloc] init];
        }
        return sharedHelper;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([DashboardHelper class]) {
        NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
    return nil;
}


#pragma mark - Date Helpers

- (NSString *)getFilterUTCStartDate:(NSDate *)stringStartDate {
    return [NSDate getDate:[[NSDate getSOD:[stringStartDate toLocalTime]] toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
}

- (NSString *)getFilterUTCEndDate:(NSDate *)stringEndDate {
    return [NSDate getDate:[[NSDate getEOD:[stringEndDate toLocalTime]] toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
}

#pragma mark - EGPagedTableView Helpers

- (BOOL)errorCellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[EGErrorTableViewCell class]]) {
        return true;
    }
    return false;
}

@end
