//
//  GoogleAnalyticsHelper.h
//  e-guru
//
//  Created by MI iMac01 on 31/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsHelper : NSObject

+ (instancetype)sharedHelper;

-(void)initializeGoogleAnalytics;
-(void)track_ScreenName:(NSString *)screenName;
-(void)track_EventAction:(NSString *)eventAction withEventCategory:(NSString *)eventCategoty withEventResponseDetails:(NSString *)responseDetails;
@end
