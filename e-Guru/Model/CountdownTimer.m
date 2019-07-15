//
//  CountdownTimer.m
//  e-guru
//
//  Created by Admin on 08/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "CountdownTimer.h"
#import "Constant.h"

@interface CountdownTimer () {

    NSString *endDateTime;
    NSString *startDateTime;
    
    int interval;
    int minutes;
    int hours;
    int days;
}

// The repeating timer is a assign/weak property.
@property (assign) NSTimer *countdownTimer;
@property (weak, nonatomic) UILabel *updatingLabel;

@end

@implementation CountdownTimer

- (void)startCountdownTimerFordemo:(NSString *)startDate andEndDate:(NSString *)endDate withUpdatingLable:(UILabel *)label
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatyyyyMMddThhmmssssssssZ];   // dateFormatyyyyMMddTHHmmssZ
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    self.updatingLabel = nil;
    self.updatingLabel = label;
    
    // Cancel a preexisting timer.
    [self.countdownTimer invalidate];
    
    startDateTime      = endDate;
    endDateTime        = [dateFormatter stringFromDate:[NSDate date]];
    
    if (endDateTime == nil || [endDateTime isEqualToString:@"-"]) {
        endDateTime = [dateFormatter stringFromDate:[NSDate date]];
    } else if (endDateTime == nil || [endDateTime isEqualToString:@"-"]) {
         startDateTime = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    [self calculateTimeDifferance:startDateTime fromTime:endDateTime]; 
    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRemainingTime:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    
    [self.countdownTimer fire];
}

- (void)updateRemainingTime:(NSTimer*)theTimer{
    interval++;
    
    minutes = interval / 60;
    hours = minutes / 60;
    days = minutes / 1440;

    if (interval >= 0 && !(interval > 59)) {
        self.updatingLabel.text = [NSString stringWithFormat:@"%d Sec", interval];
  
    } else if (interval > 59 && minutes < 60) {
        self.updatingLabel.text = [NSString stringWithFormat:@"%d Min", minutes];

    } else if(minutes > 60 && hours < 25){
        self.updatingLabel.text = [NSString stringWithFormat:@"%d Hr", hours];
        
    } else if(hours > 24){
        days = (hours/24);
        self.updatingLabel.text = [NSString stringWithFormat:@"%d Days", days];
    }
    
}

-(void)calculateTimeDifferance:(NSString *)startTime fromTime:(NSString *)endTime{
    self.updatingLabel.text = @"";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dateFormatyyyyMMddThhmmssssssssZ];

//    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60*60*5.5]];
    
    NSDate *startDate = [dateFormat dateFromString:startDateTime];
    NSDate *endDate = [dateFormat dateFromString:endDateTime];
    
    interval = (int)[endDate timeIntervalSinceDate:startDate];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSLog(@"interval in seconds %d",interval - (int)timeZoneSeconds);
    interval = interval - ((5*60*60) + (30*60));
}

//- (void)timerTick:(NSTimer *)timer
//{
//    timeSec++;
//    if (timeSec == 60) {
//        timeSec = 0;
//        timeMin++;
//    }
//    //Format the string 00:00
//    timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
//}

@end
