//
//  NSDate+eGuruDate.h
//  e-guru
//
//  Created by local admin on 12/31/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface NSDate (eGuruDate)


-(NSString *_Nonnull)ToUTCStringInFormat:(NSString *_Nonnull)format;
-(NSString *_Nonnull)ToISTStringInFormat:(NSString *_Nonnull)format;
-(NSDate *_Nonnull) toLocalTime;
-(NSDate *_Nonnull) toGlobalTime;
+(NSDate *_Nonnull)getSOD:(NSDate *_Nonnull)date;
+(NSDate *_Nonnull)getEOD:(NSDate *_Nonnull)date;

+ (NSString *_Nullable)getNextDayDate:(NSInteger)numberOfDays inFormat:(NSString *_Nonnull)format ;
+ (NSString *_Nullable)getCurrentDateInFormat:(NSString *_Nonnull)dateFormat ;
+ (NSString *_Nullable)getDate:(NSDate *_Nonnull)date InFormat:(NSString *_Nonnull)dateFormat;

+ (NSDate *_Nonnull)getNSDateFromString:(NSString *_Nonnull)dateString havingFormat:(NSString *_Nonnull)dateFormat;
+ (NSDate *_Nonnull)getNoOfMonths:(NSInteger)numOfMonths pastDateInFormat:(NSString *_Nonnull)dateFormat;
+ (NSDate *_Nonnull )getCurrentMonthFirstDateInFormat:(NSString *_Nonnull)dateFormat;
+ (NSDate *_Nonnull )getNoOfDays:(NSInteger)numOfdays pastDateInFormat:(NSString *_Nonnull)dateFormat;
+ (NSString *_Nonnull)formatDate:(NSString *_Nonnull)dateString FromFormat:(NSString *_Nonnull)dateFormatSrc toFormat:(NSString *_Nonnull)dateFormatDest;
+ (NSDate *_Nonnull)generateCombinedDateTimeForDate:(NSDate *_Nonnull)date andTime:(NSDate *_Nonnull)time;
@end
