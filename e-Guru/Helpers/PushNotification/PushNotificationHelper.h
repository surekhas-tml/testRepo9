//
//  PushNotificationHelper.h
//  e-guru
//
//  Created by Ashish Barve on 9/27/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotificationHelper : NSObject

+ (instancetype)sharedHelper;

- (void)saveFCMRegToken:(NSString *)regToken;
- (void)registerDevice;
- (void)deregisterDevice;

- (void)handleNotification:(NSDictionary *)userInfo;
- (void)performActionForNotification:(NSDictionary *)userInfo;

@end
