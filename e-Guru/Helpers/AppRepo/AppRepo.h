//
//  AppRepo.h
//  e-guru
//
//  Created by MI iMac04 on 10/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGToken.h"
#import "EGUserData.h"
#import "AAAUserDataMO+CoreDataClass.h"
#import "AAAUserDataMO+CoreDataProperties.h"
#import "AAATokenMO+CoreDataClass.h"
#import "AAATokenMO+CoreDataProperties.h"

@interface AppRepo : NSObject

+ (instancetype)sharedRepo;

- (AAATokenMO *)getTokenDetails;
- (AAAUserDataMO *)getLoggedInUser;

- (BOOL)isUserLoggedIn;
- (BOOL)isDSMUser;
- (BOOL)isDSEUser;
- (void)logoutUser;

- (void)saveTokenData:(EGToken *)token;
- (void)loginUser:(EGUserData *)userData token:(EGToken *)tokenData;
- (void)showHomeScreen;
- (void)showLoginScreen;
- (void)showCreateOptyScreen;
- (void)showPinScreen;
- (void)showPinScreenForSettingPin:(BOOL)isShownForSettingPin;
- (void)pinScreenDismissed;
- (void)pushNotificationReceivedWithDictionary:(NSDictionary *)userInfo;

@end
