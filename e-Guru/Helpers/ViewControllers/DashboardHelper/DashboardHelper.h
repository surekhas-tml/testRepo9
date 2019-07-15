//
//  DashboardHelper.h
//  e-guru
//
//  Created by MI iMac04 on 06/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DashboardHelper : NSObject

+ (instancetype)sharedHelper;

/** Get UTC formatted start date for dashboard filter
 @param stringStartDate String date in dateFormatyyyyMMddTHHmmssZ format
 @return Start date in string format
 **/
- (NSString *)getFilterUTCStartDate:(NSDate *)stringStartDate;


/** Get UTC formatted end date for dashboard filter
 @param stringEndDate String date in dateFormatyyyyMMddTHHmmssZ format
 @return End date in string format
 **/
- (NSString *)getFilterUTCEndDate:(NSDate *)stringEndDate;

- (BOOL)errorCellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
