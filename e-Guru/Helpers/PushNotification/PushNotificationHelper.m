//
//  PushNotificationHelper.m
//  e-guru
//
//  Created by Ashish Barve on 9/27/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "PushNotificationHelper.h"
#import "EGRKWebserviceRepository.h"
#import "AppRepo.h"
#import "PushNotificationToken+CoreDataClass.h"
#import "PushNotificationToken+CoreDataProperties.h"
#import "NSString+NSStringCategory.h"
#import "UpdateActivityViewController.h"
#import "ActivityViewController.h"
#import "AppDelegate.h"

#define NOTIFICATION_TYPE_OPTY_LOST         @"optyLost"
#define NOTIFICATION_TYPE_INACTIVE_USER     @"inactiveUser"
#define NOTIFICATION_TYPE_FOLLOW_UP_FAILED  @"followupActivityFailed"
#define NOTIFICATION_TYPE_MISSED_ACTIVITY   @"missedActivity"
#define NOTIFICATION_TYPE_FINANCIER_STATUS  @"Financier_Status"

@implementation PushNotificationHelper

static PushNotificationHelper *sharedHelper = nil;

+ (instancetype)sharedHelper {
    @synchronized([PushNotificationHelper class]) {
        if (!sharedHelper) {
            sharedHelper = [[self alloc] init];
        }
        return sharedHelper;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([PushNotificationHelper class]) {
        NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedHelper = [super alloc];
        return sharedHelper;
    }
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)saveFCMRegToken:(NSString *)regToken {
    
    // Delete Previously stored token
    [self deleteFCMRegTokenFromDB];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PushNotificationToken *tokenObject = [NSEntityDescription insertNewObjectForEntityForName:@"PushNotificationToken" inManagedObjectContext:appdelegate.managedObjectContext];
    
    tokenObject.regTokenFCM = regToken;
    
    NSError *error = nil;
    [appdelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (NSString *)getFCMRegToken {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PushNotificationToken"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PushNotificationToken *tokenObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    return tokenObject.regTokenFCM;
}

- (void)deleteFCMRegTokenFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PushNotificationToken"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PushNotificationToken *tokenObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    if (tokenObject) {
        [appDelegate.managedObjectContext deleteObject:tokenObject];
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting user data");
        }
    }
}

- (void)registerDevice {
    
    if (![[self getFCMRegToken] hasValue]) {
        return;
    }
    
    NSDictionary *paramDict = @{
                                @"dev_id" : [UtilityMethods getVendorID],
                                @"reg_id" : [self getFCMRegToken],
                                @"name" : [[[AppRepo sharedRepo] getLoggedInUser] userName],
                                @"platform" : @"iOS"
                                };
    
    [[EGRKWebserviceRepository sharedRepository] registerDeviceForNotification:paramDict
                                                              andSuccessAction:^(NSDictionary *response) {
                                                                  NSLog(@"Device Reg Success:%@", response);
                                                              }
                                                              andFailureAction:^(NSError *error) {
                                                                  NSLog(@"Device Reg Failed:%@", error.localizedRecoverySuggestion);
                                                              }];
}

- (void)deregisterDevice {
    NSDictionary *paramDict = @{
                                @"dev_id" : [UtilityMethods getVendorID]
                                };
    
    [[EGRKWebserviceRepository sharedRepository] deRegisterDeviceFromNotification:paramDict
                                                                 andSuccessAction:^(NSDictionary *response) {
                                                                  NSLog(@"Device UnReg Success:%@", response);
                                                                 }
                                                                 andFailureAction:^(NSError *error) {
                                                                  NSLog(@"Device UnReg Failed:%@", error.localizedRecoverySuggestion);
                                                                 }];
}

- (void)handleNotification:(NSDictionary *)userInfo {
    [self showNotificationAlert:userInfo];
}

- (MasterViewController *)getMasterViewController {
    // Show Activity list
    AppDelegate *appDelegateObj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *navVC = [appDelegateObj.splitViewController.viewControllers firstObject];
    MasterViewController *master = [[navVC childViewControllers]lastObject];
    
    if ([master presentedViewController]) {
        [[master presentedViewController] dismissViewControllerAnimated:true completion:nil];
    }
    
    return master;
}

- (void)showActivityList {
    
    [[self getMasterViewController] performSegueWithIdentifier:[ACTIVITY stringByAppendingString:SEGUE] sender:nil];
}

- (void)showActivityDetail:(EGActivity *)activityObj {
    // Show the Activity
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil];
    UpdateActivityViewController *activityDetails = [storyboard instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
    activityDetails.checkuser = @"My_Activity";
    activityDetails.activity = activityObj;
    activityDetails.isInvokedFromPushNotification = true;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activityDetails];
    activityDetails.navigationItem.titleView = [[UILabel alloc] init];
    [[self getMasterViewController] presentViewController:navigationController animated:true completion:nil];
}

- (void)showTeamsActivityScreen {
    [[self getMasterViewController] openActivityScreenWithTeamsActivityForNotification:true];
}

- (void)showNotificationAlert:(NSDictionary *)userInfo {
    
    NSString *message = [userInfo objectForKey:@"message"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionView = [UIAlertAction actionWithTitle:@"View"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self performActionForNotification:userInfo];
                                                       }];
    
    UIAlertAction *actionDismiss = [UIAlertAction actionWithTitle:@"Dismiss"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    
    if ([self doesNotificationRequiresAction:userInfo]) {
        [alertController addAction:actionView];
    }
    
    [alertController addAction:actionDismiss];
    
    
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController
//                                                                                     animated:YES
//                                                                                   completion:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.splitViewController == nil) {
        appDelegate.splitViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }else{
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }
    
    appDelegate.window.rootViewController = appDelegate.splitViewController;
    [appDelegate.window makeKeyAndVisible];
    
    if ([[[appDelegate.navigationController viewControllers] firstObject] presentedViewController]) {
        [[[[appDelegate.navigationController viewControllers] firstObject] presentedViewController] presentViewController:alertController animated:true completion:nil];
    } else {
        [[[appDelegate.navigationController viewControllers] firstObject] presentViewController:alertController animated:true completion:nil];
    }
}

- (void)performActionForNotification:(NSDictionary *)userInfo {
    NSString *activityType = [userInfo objectForKey:@"action"];
    
    if ([activityType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_FOLLOW_UP_FAILED]) {
        [self showActivityList];
    } else if ([activityType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_MISSED_ACTIVITY]) {
        [self fetchActivityWithActivityID:[userInfo objectForKey:@"activity_id"]];
    } else if ([activityType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_OPTY_LOST]) {
        [self fetchOpportunityWithOptyID:[userInfo objectForKey:@"opty_id"]];
    } else if ([activityType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_INACTIVE_USER]) {
        [self showTeamsActivityScreen];
    } else if ([activityType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_FINANCIER_STATUS]){
        NSLog(@"api mssg will come here in notification");
        [UtilityMethods showAlertMessageOnWindowWithMessage:[NSString stringWithFormat:@"No details found for activity having ID %@", [userInfo objectForKey:@"msg"]]
                                                    handler:^(UIAlertAction * _Nullable action) {
                                                    }];
    }
}

- (BOOL)doesNotificationRequiresAction:(NSDictionary *)userInfo {
    
    // If action is not set or is empty return false
    if (![userInfo objectForKey:@"action"] || ![[userInfo objectForKey:@"action"] hasValue]) {
        return false;
    }
    
    NSString *actionType = [userInfo objectForKey:@"action"];
    
    if ([actionType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_FOLLOW_UP_FAILED]) {
        return true;
    } else if ([actionType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_MISSED_ACTIVITY]) {
        return true;
    } else if ([actionType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_OPTY_LOST]) {
        return true;
    } else if ([actionType isCaseInsesitiveEqualTo:NOTIFICATION_TYPE_INACTIVE_USER]) {
        return true;
    }
    
    return false;
}

- (void)openOpportunityDetailsScreen:(EGOpportunity *)opportunity {
    
    OpportunityDetailsViewController * optyViewController = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"opportunityDetails"];
    optyViewController.opportunity = opportunity;
    optyViewController.showOpty = @"Team_Opportunity";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:optyViewController];
    optyViewController.navigationItem.titleView = [[UILabel alloc] init];
    [[self getMasterViewController] presentViewController:navigationController animated:true completion:nil];
}

#pragma mark - API Requests

- (void)fetchActivityWithActivityID:(NSString *)activityID {
    
    NSDictionary *requestDict = @{
                                  @"activity_id" : activityID
                                  };
    
    [UtilityMethods showProgressHUD:true];
    [[EGRKWebserviceRepository sharedRepository] searchActivity:requestDict
                                                andSucessAction:^(EGPagination *paginationObj) {
                                                    [UtilityMethods hideProgressHUD];
                                                    if ([paginationObj totalResults] > 0) {
                                                        [self showActivityDetail:[[paginationObj items] objectAtIndex:0]];
                                                    } else {
                                                        [UtilityMethods showAlertMessageOnWindowWithMessage:[NSString stringWithFormat:@"No details found for activity having ID %@", activityID]
                                                                                                    handler:^(UIAlertAction * _Nullable action) {
                                                            
                                                                                                    }];
                                                    }
                                                }
                                               andFailuerAction:^(NSError *error) {
                                                   [UtilityMethods hideProgressHUD];
                                                   if (error.localizedDescription) {
                                                       [UtilityMethods showAlertMessageOnWindowWithMessage:error.localizedDescription handler:^(UIAlertAction * _Nullable action) {
                                                           
                                                       }];
                                                   }
                                               }];
}

- (void)fetchOpportunityWithOptyID:(NSString *)optyID {
    
    [UtilityMethods showProgressHUD:true];
    [[EGRKWebserviceRepository sharedRepository]searchOpportunity:@{ @"opty_id" : optyID } andSucessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        if (paginationObj && paginationObj.totalResults > 0 && paginationObj.items && paginationObj.items.count > 0) {
            EGOpportunity *searchedOpty = [paginationObj.items objectAtIndex:0];
            [self openOpportunityDetailsScreen:searchedOpty];
        } else {
            
            [UtilityMethods showAlertMessageOnWindowWithMessage:[NSString stringWithFormat:@"No details found for opportunity having ID %@", optyID]
                                                        handler:^(UIAlertAction * _Nullable action) {
                                                            
                                                        }];
        }
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        if (error.localizedDescription) {
            [UtilityMethods showAlertMessageOnWindowWithMessage:error.localizedDescription handler:^(UIAlertAction * _Nullable action) {
                
            }];
        }
    }];
}

@end
