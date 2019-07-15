//
//  EGActivity.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGActivity.h"

@implementation EGActivity
@synthesize activityDescription;
@synthesize activityID;
@synthesize activityType;
@synthesize creationDate;
@synthesize creationTime;
@synthesize planedDate = _planedDate;
@synthesize planedTime = _planedTime;
@synthesize status;
@synthesize taluka;
@synthesize endDate;
@synthesize endTime;
@synthesize toOpportunity;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.activityDescription = @"";
        self.activityID = @"";
        self.activityType = @"";
        self.creationDate = @"";
        self.creationTime = @"";
        self.planedDate = @"";
        self.planedTime = @"";
        self.status = @"";
        self.taluka = @"";
        self.endDate = @"";
        self.endTime = @"";
        self.junk = @"";


    }
    return self;
}

-(instancetype)initWithObject:(AAAActivityMO *)object{
    self = [super init];
    if (self) {
        self.activityDescription = object.activityDescription;
        self.activityID = object.activityID;
        self.activityType = object.activityType;
        self.creationDate = object.creationDate;
        self.creationTime = object.creationTime;
        self.planedDate = object.planedDate;
        self.planedTime = object.planedTime;
        self.status = object.status;
        self.taluka = object.taluka;
        self.endDate = object.endDate;
        self.endTime = object.endTime;
        }
    return self;
}

-(void)setPlanedDate:(NSString *)planedDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your output date (means above str with format)
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormatter dateFromString: planedDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    _planedDate = convertedString;
    [self setPlanedTime:planedDate];

}
-(NSString *)planedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString: _planedDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
}
-(NSString *)planedDateTimeInFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString: _planedDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setDateFormat:format];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
}
-(NSString *)planedDateSystemTime{
    return _planedDate;
}
-(NSString *)planedDateSystemTimeInFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString: _planedDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:format];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
    return _planedDate;
}

-(void)setPlanedTime:(NSString *)planedTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormatter dateFromString:planedTime]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:timeFormatHHmm];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    _planedTime = convertedString;
    
}
-(NSString *)planedTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:timeFormatHHmm]; //// here set format of date which is in your output date (means above str with format)
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString: _planedTime]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setDateFormat:timeFormatHHmm];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
}
-(NSString *)planedTimeSystemTime{
    return _planedTime;
}
@end
