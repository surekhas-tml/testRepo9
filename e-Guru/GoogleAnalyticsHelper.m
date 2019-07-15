//
//  GoogleAnalyticsHelper.m
//  e-guru
//
//  Created by MI iMac01 on 31/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//
#import "GoogleAnalyticsHelper.h"
#import <Google/Analytics.h>
#import "AppRepo.h"
#import "NSString+NSStringCategory.h"
#import "Constant.h"

@implementation GoogleAnalyticsHelper

static GoogleAnalyticsHelper *sharedHelper = nil;

+ (instancetype)sharedHelper {
    @synchronized([GoogleAnalyticsHelper class]) {
        if (!sharedHelper) {
            sharedHelper = [[self alloc] init];
        }
        return sharedHelper;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([GoogleAnalyticsHelper class]) {
        NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
    return nil;
}


-(void)initializeGoogleAnalytics{
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    
    gai.logger.logLevel = kGAILogLevelNone;  //TODO:remove before app release
}


-(void)track_ScreenName:(NSString *)screenName{
    
    NSString * screenNameWithPosition;
    if ([screenName hasValue]) {
        if (![screenName isEqualToString:GA_SN_Login]) {
            screenNameWithPosition = [NSString stringWithFormat:@"%@-%@",[[AppRepo sharedRepo] getLoggedInUser].positionType,screenName];
        }
        else{
            screenNameWithPosition = GA_SN_Login;//screenName;
        }
       
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:screenNameWithPosition];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    }
    else{
        NSLog(@"screenNameWithPosition %@",screenNameWithPosition);
    }
    
    NSLog(@"-----screenNameWithPosition %@",screenNameWithPosition);

    
}


-(void)track_EventAction:(NSString *)eventAction withEventCategory:(NSString *)eventCategoty withEventResponseDetails:(NSString *)responseDetails{
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    NSString * eventLabel;
    if ([responseDetails hasValue]) {
        eventLabel = [NSString stringWithFormat:@"%@-%@ %@",[[AppRepo sharedRepo] getLoggedInUser].positionType,[[AppRepo sharedRepo] getLoggedInUser].userName,responseDetails];
    }
    else{
        eventLabel = [NSString stringWithFormat:@"%@-%@",[[AppRepo sharedRepo] getLoggedInUser].positionType,[[AppRepo sharedRepo] getLoggedInUser].userName];
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    if ([eventAction hasValue] && [eventCategoty hasValue] && [eventLabel hasValue]) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventCategoty
                                                          action:eventAction
                                                           label:eventLabel
                                                           value:nil] build]];
    }
    
}

@end
