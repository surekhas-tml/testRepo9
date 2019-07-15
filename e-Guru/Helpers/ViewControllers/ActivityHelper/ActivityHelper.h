//
//  ActivityHelper.h
//  e-guru
//
//  Created by MI iMac04 on 06/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityHelper : NSObject

+ (instancetype)sharedHelper;

/** Get UTC formatted start date for activity filter
 @param stringStartDate String date in dateFormatyyyyMMddTHHmmssZ format
 @return Actvity start date in string format
 **/
- (NSString *)getActivityFilterUTCStartDate:(NSDate *)stringStartDate;


/** Get UTC formatted end date for activity filter
 @param stringEndDate String date in dateFormatyyyyMMddTHHmmssZ format
 @return Actvity end date in string format
 **/
- (NSString *)getActivityFilterUTCEndDate:(NSDate *)stringEndDate;

@end
