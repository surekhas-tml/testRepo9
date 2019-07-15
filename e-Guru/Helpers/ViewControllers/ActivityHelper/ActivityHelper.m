//
//  ActivityHelper.m
//  e-guru
//
//  Created by MI iMac04 on 06/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ActivityHelper.h"
#import "NSDate+eGuruDate.h"

@implementation ActivityHelper

static ActivityHelper *sharedHelper = nil;

+ (instancetype)sharedHelper {
    @synchronized([ActivityHelper class]) {
        if (!sharedHelper) {
            sharedHelper = [[self alloc] init];
        }
        return sharedHelper;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([ActivityHelper class]) {
        NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
    return nil;
}


#pragma mark - Date Helpers

- (NSString *)getActivityFilterUTCStartDate:(NSDate *)stringStartDate {
    return [NSDate getDate:[[NSDate getSOD:stringStartDate]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
}

- (NSString *)getActivityFilterUTCEndDate:(NSDate *)stringEndDate {
    return [NSDate getDate:[[NSDate getEOD:stringEndDate]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
}

@end
