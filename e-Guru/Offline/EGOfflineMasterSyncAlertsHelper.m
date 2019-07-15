//
//  EGOfflineMasterSyncAlertsHelper.m
//  e-guru
//
//  Created by MI iMac04 on 26/06/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGOfflineMasterSyncAlertsHelper.h"
#import "Constant.h"
#import "NSString+NSStringCategory.h"

@interface EGOfflineMasterSyncAlertsHelper()

@property (nonatomic, assign) BOOL wasSyncStartAlertShown;
@property (nonatomic, assign) BOOL wasSyncCompletedAlertShown;
@property (nonatomic, assign) BOOL wasSyncFailureAlertShown;

@end

@implementation EGOfflineMasterSyncAlertsHelper

static EGOfflineMasterSyncAlertsHelper *sharedInstance = nil;

+ (instancetype)sharedInstance {
    @synchronized([EGOfflineMasterSyncAlertsHelper class]) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
        return sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([EGOfflineMasterSyncAlertsHelper class]) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.syncStartedAlertController = [self getAlertControllerWithMessage:MESSAGE_OFFLINE_MASTER_SYNC_STARTED];
        self.syncCompletedAlertController = [self getAlertControllerWithMessage:MESSAGE_OFFLINE_MASTER_SYNC_COMPLETED];
        self.syncErrorAlertController = [self getAlertControllerWithMessage:MESSAGE_OFFLINE_MASTER_SYNC_FAILED];
    }
    return self;
}

#pragma mark - Public Methods

- (void)showSyncStartedAlert {
    [self dismissAllSyncRelatedAlerts];
    
    self.wasSyncStartAlertShown = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.syncStartedAlertController
                                                                                         animated:YES
                                                                                       completion:nil];
    });
}

- (void)showSyncCompletedAlert {
    [self dismissAllSyncRelatedAlerts];
    
    self.wasSyncCompletedAlertShown = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.syncCompletedAlertController
                                                                                         animated:YES
                                                                                       completion:nil];
    });
}

- (void)showSyncErrorAlertWithMessage:(NSString *)errorMessage {
    [self dismissAllSyncRelatedAlerts];
    
    self.wasSyncFailureAlertShown = true;
    [self.syncErrorAlertController setTitle:ALERT_TITLE_OFFLINE_MASTER_SYNC];
    [self.syncErrorAlertController setMessage:errorMessage];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.syncErrorAlertController
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)showSyncErrorAlert {
    [self dismissAllSyncRelatedAlerts];
    
    self.wasSyncFailureAlertShown = true;
    [self.syncErrorAlertController setTitle:ALERT_TITLE_OFFLINE_MASTER_SYNC];
    [self.syncErrorAlertController setMessage:MESSAGE_OFFLINE_MASTER_SYNC_FAILED];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.syncErrorAlertController
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)showSyncFailedDueToInternetAlert {
    [self dismissAllSyncRelatedAlerts];
    
    self.wasSyncFailureAlertShown = true;
    [self.syncErrorAlertController setTitle:ALERT_TITLE_OFFLINE_MASTER_SYNC_INTERNET_LOST];
    [self.syncErrorAlertController setMessage:MESSAGE_OFFLINE_MASTER_SYNC_FAILED_DUE_TO_INTERNET];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.syncErrorAlertController
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)dismissSyncStartedAlert {
    [self.syncStartedAlertController dismissViewControllerAnimated:true completion:nil];
    self.wasSyncStartAlertShown = false;
}

- (void)dismissSyncCompletedAlert {
    [self.syncCompletedAlertController dismissViewControllerAnimated:true completion:nil];
    self.wasSyncCompletedAlertShown = false;
}

- (void)dismissSyncFailedAlert {
    [self.syncErrorAlertController dismissViewControllerAnimated:true completion:nil];
    self.wasSyncFailureAlertShown = false;
}

- (void)dismissAllSyncRelatedAlerts {
    [self dismissSyncStartedAlert];
    [self dismissSyncCompletedAlert];
    [self dismissSyncFailedAlert];
}

- (void)pinScreenHasBeenDismissed {
    
    UIAlertController *cachedAlertController = nil;
    
    if (self.wasSyncStartAlertShown) {
        cachedAlertController = self.syncStartedAlertController;
    }
    else if (self.wasSyncCompletedAlertShown) {
        cachedAlertController = self.syncCompletedAlertController;
    }
    else if (self.wasSyncFailureAlertShown) {
        cachedAlertController = self.syncErrorAlertController;
    }
    
    if (cachedAlertController) {
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:cachedAlertController
                                                                                         animated:YES
                                                                                       completion:nil];
    }
    
}

#pragma mark - Private Methods

- (UIAlertController *)getAlertControllerWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE_OFFLINE_MASTER_SYNC
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          if ([message isEqualToString:MESSAGE_OFFLINE_MASTER_SYNC_STARTED]) {
                                                              self.wasSyncStartAlertShown = false;
                                                          }
                                                          else if ([message isEqualToString:MESSAGE_OFFLINE_MASTER_SYNC_COMPLETED]) {
                                                              self.wasSyncCompletedAlertShown = false;
                                                          }
                                                          else {
                                                              self.wasSyncFailureAlertShown = false;
                                                          }
                                                          
                                                      }]];
    return alertController;
}

@end
