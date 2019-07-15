//
//  NSDate+eGuruDate.m
//  e-guru
//
//  Created by local admin on 12/31/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "NSDate+eGuruDate.h"

@implementation NSDate (eGuruDate)
-(NSString *)ToUTCStringInFormat:(NSString *)format{
    //set current real date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:self];
}
-(NSString *)ToISTStringInFormat:(NSString *)format{
    //set current real date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [formatter stringFromDate:self];
}
-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

+(NSDate *)getSOD:(NSDate *)date{
    NSString * string = [NSDate getDate:date InFormat:dateFormatSODyyyyMMddTHHmmssZ];
    date = [NSDate getNSDateFromString:string havingFormat:dateFormatyyyyMMddTHHmmssZ];
    return date;
}

+(NSDate *)getEOD:(NSDate *)date{
    NSString * stringToday = [NSDate getDate:date InFormat:dateFormatEODyyyyMMddTHHmmssZ];
    date = [NSDate getNSDateFromString:stringToday havingFormat:dateFormatyyyyMMddTHHmmssZ];
    return date;
}


#pragma mark - Date Time Methods

+ (NSString *_Nullable)getNextDayDate:(NSInteger)numberOfDays inFormat:(NSString *)format {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = numberOfDays;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return [NSDate getDate:newDate InFormat:format];
}

+ (NSString *_Nullable)getCurrentDateInFormat:(NSString *_Nonnull)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *_Nullable)getDate:(NSDate *)date InFormat:(NSString *_Nonnull)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSDate *)getNSDateFromString:(NSString *)dateString havingFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}
+ (NSDate *_Nonnull )getNoOfDays:(NSInteger)numOfdays pastDateInFormat:(NSString *_Nonnull)dateFormat {
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = -1 * numOfdays;
    NSDate *pastMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    return pastMonthDate;
}

+ (NSDate *_Nonnull )getNoOfMonths:(NSInteger)numOfMonths pastDateInFormat:(NSString *_Nonnull)dateFormat {
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = -1 * numOfMonths;
    dateComponents.day = +1;
    NSDate *pastMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    return pastMonthDate;
}

+ (NSDate *_Nonnull )getCurrentMonthFirstDateInFormat:(NSString *_Nonnull)dateFormat {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * currentDateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate: [NSDate date]];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    return startOfMonth;

}

+ (NSString *)formatDate:(NSString *)dateString FromFormat:(NSString *)dateFormatSrc toFormat:(NSString *)dateFormatDest {
    NSString *str = dateString; /// here this is your date with format yyyy-MM-dd
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatSrc]; //// here set format of date which is in your output date (means above str with format)
    
    NSDate *date = [dateFormatter dateFromString: str]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatDest];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    
    return convertedString;
}

+ (NSDate *)generateCombinedDateTimeForDate:(NSDate *)date andTime:(NSDate *)time {

    NSCalendar *indianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [indianCalender components:NSCalendarUnitCalendar | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone  fromDate:date];
    NSDateComponents *timeComponents = [indianCalender components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:time];
    [components setHour:[timeComponents hour]];
    [components setMinute:[timeComponents minute]];
    NSDate *completeDateTime = [indianCalender dateFromComponents:components];

    return completeDateTime;
}


@end
