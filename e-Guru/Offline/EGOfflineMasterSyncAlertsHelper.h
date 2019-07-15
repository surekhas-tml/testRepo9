//
//  EGOfflineMasterSyncAlertsHelper.h
//  e-guru
//
//  Created by MI iMac04 on 26/06/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EGOfflineMasterSyncAlertsHelper : NSObject

+ (instancetype)sharedInstance;

- (void)showSyncStartedAlert;
- (void)showSyncCompletedAlert;
- (void)showSyncErrorAlert;
- (void)showSyncFailedDueToInternetAlert;
- (void)showSyncErrorAlertWithMessage:(NSString *)errorMessage;

- (void)pinScreenHasBeenDismissed;

@property (nonatomic, strong) UIAlertController *syncStartedAlertController;
@property (nonatomic, strong) UIAlertController *syncCompletedAlertController;
@property (nonatomic, strong) UIAlertController *syncErrorAlertController;

@end
