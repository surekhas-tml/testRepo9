//
//  EventDBHelper.m
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EventDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"
#import "EGEvent.h"
#import "AppRepo.h"
#import "AAAUserDataMO+CoreDataClass.h"
#import "AAAUserDataMO+CoreDataProperties.h"
#import "Constant.h"

#define TBL_EVENTS	 @"EVENTS"

#define COL_EVENT_NAME      @"EVENT_NAME"
#define COL_EVENT_ID        @"EVENT_ID"
#define COL_BU_ID           @"BU_ID"
#define COL_POSITION_ID     @"PR_POSTN_ID"
#define COL_START_DATE      @"PG_STDT_dt"
#define COL_END_DATE        @"PG_EDDT_dt"
#define COL_STATUS          @"STATUS_CD"

@implementation EventDBHelper

- (NSArray *)fetchAllEvents {
    AAAUserDataMO *loggedInUser = [[AppRepo sharedRepo] getLoggedInUser];
    NSMutableArray *arrEvents = [NSMutableArray new];
    NSString *strSelectStatement = [NSString
                                    stringWithFormat:@"select DISTINCT * from %@ WHERE %@ = \"%@\" AND (%@ <> \"Hidden\" OR %@ = \"%@\") AND (%@ IN (\"Approved\",\"Executed\")) AND %@ >= \"%@\" AND %@ <= \"%@\"", TBL_EVENTS, COL_BU_ID, loggedInUser.organizationID, COL_STATUS, COL_POSITION_ID, loggedInUser.primaryPositionID, COL_STATUS, COL_START_DATE, [EventDBHelper getStartDate], COL_END_DATE, [EventDBHelper getEndDate]];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        EGEvent *egEvent = [EGEvent new];
        egEvent.mEventName = [rs stringForColumn:COL_EVENT_NAME];
        egEvent.mEventID = [rs stringForColumn:COL_EVENT_ID];
        [arrEvents addObject:egEvent];
    }
    [db close];
    
    return arrEvents;
}

+ (NSString *)getStartDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:currentDateComponents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];
    return [dateFormatter stringFromDate:startDate];
}

+ (NSString *)getEndDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [currentDateComponents setMonth:[currentDateComponents month] + 1];
    [currentDateComponents setDay: 0];
    
    NSDate *endDate = [calendar dateFromComponents:currentDateComponents];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];
    return [dateFormatter stringFromDate:endDate];
}

@end
