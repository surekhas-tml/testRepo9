//
//  AppRepo.m
//  e-guru
//
//  Created by MI iMac04 on 10/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AppRepo.h"
#import "AppDelegate.h"
#import "NSString+NSStringCategory.h"
#import "Constant.h"
#import "PINViewController.h"
#import "DropDownViewController.h"
#import "PushNotificationHelper.h"
#import "MasterViewController.h"
#import "NotificationViewController.h"

@interface AppRepo() {
    BOOL isPINScreenVisible;
}

@property (nonatomic, strong) AAATokenMO *token;
@property (nonatomic, strong) AAAUserDataMO *userData;
@property (nonatomic, strong) NSDictionary *notificationDict;
@property (nonatomic, assign) BOOL hasPushNotificationToHandle;

@end

@implementation AppRepo

static AppRepo *sharedRepo = nil;

+ (instancetype)sharedRepo {
    @synchronized([AppRepo class]) {
        if (!sharedRepo) {
            sharedRepo = [[self alloc] init];
        }
        return sharedRepo;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([AppRepo class]) {
        NSAssert(sharedRepo == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedRepo = [super alloc];
        return sharedRepo;
    }
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasPushNotificationToHandle = false;
        self.notificationDict = [[NSDictionary alloc] init];
        self.token = [self getTokenFromDB];
        self.userData = [self getUserDataFromDB];
        NSLog(@"%@",self.userData.positionType);
        
        NSLog(@"User State : %@",self.userData.userState);
        NSLog(@" Token :%@",self.token);
        NSLog(@"LOB NAme :%@",self.userData.lobName);
//        NSLog(@"state name : %@",self.userData.)
        
        isPINScreenVisible = false;
    }
    return self;
}

- (AAATokenMO *)getTokenDetails {
    return self.token;
}

- (AAAUserDataMO *)getLoggedInUser {
    return self.userData;
}

- (BOOL)isUserLoggedIn {
    
    if ([self getUserDataFromDB] && [[self getUserDataFromDB].employeeRowID hasValue]) {
        return true;
    }
    
    return false;
}

- (void)loginUser:(EGUserData *)userData token:(EGToken *)tokenData {
    [self saveTokenData:tokenData];
    [self saveUserData:userData];
//     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (appDelegate.productAppOpty == nil) {
//            [self showHomeScreen];
//    }
//    else{
//        [self showCreateOptyScreen];
//    }
    
    [self showPinScreenForSettingPin:true];
}

- (void)logoutUser {
    [self deleteUserDataFromDB];
    [self deleteTokenFromDB];
    [self showLoginScreen];
    [NotificationViewController deleteAllNotificationsFromDB];
    
    // Deregister the device for Push Notifications
    [[PushNotificationHelper sharedHelper] deregisterDevice];
    
    sharedRepo = nil;
}

- (void)saveTokenData:(EGToken *)token {
    // Delete previously store user data
    [self deleteTokenFromDB];
    // Save new user's data
    [self saveTokenDataInDB:token];
    self.token = [self getTokenFromDB];
}

- (void)saveUserData:(EGUserData *)userData {
    // Delete any previously shore token
    [self deleteUserDataFromDB];
    // Save newly generated token
    [self saveUserDataInDB:userData];
    self.userData = [self getUserDataFromDB];
}

- (BOOL)isDSMUser {
    if ([self.userData.positionType isEqualToString:PostionforDSM]) {
        return true;
    }
    else {
        return false;
    }

}
- (BOOL)isDSEUser {
    if ([self.userData.positionType isEqualToString:PostionforDSE]) {
        return true;
    }
    else {
        return false;
    }
    
}

#pragma mark - User Data Operations

- (void)saveUserDataInDB:(EGUserData *)userData {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AAAUserDataMO *userDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:appdelegate.managedObjectContext];
    
    userDataObject.lob = userData.lob;
    userDataObject.positionType = userData.positionType;
    userDataObject.primaryPositionID = userData.primaryPositionID;
    userDataObject.primaryEmployeeID = userData.primaryEmployeeID;
    userDataObject.positionID = userData.positionID;
    userDataObject.lobName = userData.lobName;
    userDataObject.lobRowID = userData.lobRowID;
    userDataObject.lobBUUnit = userData.lobBUUnit;
    userDataObject.organizationID = userData.organizationID;
    userDataObject.dsmName = userData.dsmName;
    userDataObject.lobServiceTaxFlag = userData.lobServiceTaxFlag;
    userDataObject.positionName = userData.positionName;
    userDataObject.employeeRowID = userData.employeeRowID;
    userDataObject.userName = userData.userName;
    userDataObject.primaryEmployeeCellNum = userData.primaryEmployeeCellNum;
    userDataObject.organisationName = userData.organizationName;
    userDataObject.dealerCode = userData.dealerCode;
    userDataObject.userState = userData.userState;
    NSError *error = nil;
    [appdelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (AAAUserDataMO *)getUserDataFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserData"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AAAUserDataMO *userDataObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    return userDataObject;
}

- (void)deleteUserDataFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserData"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AAAUserDataMO *userDataObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    if (userDataObject) {
        [appDelegate.managedObjectContext deleteObject:userDataObject];
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting user data");
        }
    }
}

#pragma mark - Token Operations

- (void)saveTokenDataInDB:(EGToken *)token {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AAATokenMO *tokenObject = [NSEntityDescription insertNewObjectForEntityForName:@"Token" inManagedObjectContext:appdelegate.managedObjectContext];
    tokenObject.accessToken = token.accessToken;
    tokenObject.expiresIn = token.expiresIn;
    tokenObject.refreshToken = token.refreshToken;
    tokenObject.scope = token.scope;
    tokenObject.tokenType = token.tokenType;
    
    NSError *error = nil;
    [appdelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (AAATokenMO *)getTokenFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Token"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AAATokenMO *tokenObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    return tokenObject;
}

- (void)deleteTokenFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Token"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AAAUserDataMO *tokenObject = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    if (tokenObject) {
        [appDelegate.managedObjectContext deleteObject:tokenObject];
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting token");
        }
    }
}

#pragma mark - Login Screen

- (void)showLoginScreen {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.initialView == nil) {
        appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateInitialViewController];
    }else {
        appDelegate.window.rootViewController = appDelegate.initialView;
    }
    [appDelegate.window makeKeyAndVisible];
}

#pragma mark - Home Screen

- (void)showHomeScreen {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.splitViewController == nil) {
        appDelegate.splitViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }else{
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
        MasterViewController *masterViewController = [[appDelegate.navigationController viewControllers]firstObject];
        
        // When push notification is received and Update Activity screen is displayed then on clicking home button from that screen home screen was not seen, to avoid that below code is written
        // Start
        if ([masterViewController presentedViewController]) {
            [[masterViewController presentedViewController] dismissViewControllerAnimated:true completion:nil];
        }
        // End
        
        [masterViewController performSegueWithIdentifier:[HOME stringByAppendingString:SEGUE] sender:nil];
    }
    appDelegate.window.rootViewController = appDelegate.splitViewController;
    [appDelegate.window makeKeyAndVisible];
}

- (void)showCreateOptyScreen {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.splitViewController == nil) {
        appDelegate.splitViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }else{
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }
    [[[appDelegate.navigationController viewControllers]firstObject] performSegueWithIdentifier:[CREATEOPTY stringByAppendingString:SEGUE] sender:appDelegate.productAppOpty];
    appDelegate.window.rootViewController = appDelegate.splitViewController;
    [appDelegate.window makeKeyAndVisible];
}

- (void)showPinScreen {
    [self showPinScreenForSettingPin:false];
}

- (void)showPinScreenForSettingPin:(BOOL)isShownForSettingPin {
    // Set PINScreenVisible flag to true
    isPINScreenVisible = true;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PINViewController" bundle:nil];
    PINViewController *pinViewController = [storyboard instantiateViewControllerWithIdentifier:@"pinViewController"];
    pinViewController.calledForSettingPIN = isShownForSettingPin;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.splitViewController == nil) {
        appDelegate.splitViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }else{
        appDelegate.navigationController = [[appDelegate.splitViewController viewControllers]firstObject];
    }
    
    // Dismiss AlertControllers if any
    [self removeAlertViewController];
    
    // Dismiss DropDownViewController if any
    [self removeDropDownViewController];
    
    // Don't present PIN Screen if already presented
    if (![[[[appDelegate.navigationController viewControllers] firstObject] presentedViewController] isKindOfClass:[PINViewController class]]) {
        appDelegate.window.rootViewController = appDelegate.splitViewController;
        [appDelegate.window makeKeyAndVisible];
        
        if ([[[appDelegate.navigationController viewControllers] firstObject] presentedViewController]) {
            [[[[appDelegate.navigationController viewControllers] firstObject] presentedViewController] presentViewController:pinViewController animated:false completion:nil];
        } else {
            [[[appDelegate.navigationController viewControllers] firstObject] presentViewController:pinViewController animated:false completion:nil];
        }
    }
}

- (void)removeAlertViewController {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([[rootViewController presentedViewController] isKindOfClass:[UIAlertController class]]) {
        [[rootViewController presentedViewController] dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)removeDropDownViewController  {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *viewController = [[[appDelegate.navigationController viewControllers] firstObject] presentedViewController];
    if ([viewController isKindOfClass:[DropDownViewController class]]) {
        [viewController dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)pinScreenDismissed {
    // Set PINScreenVisible flag to false
    isPINScreenVisible = false;
    
    if (self.hasPushNotificationToHandle) {
        [self handlePushNotification:self.notificationDict];
    }
}

#pragma mark - Push Notifications

- (void)pushNotificationReceivedWithDictionary:(NSDictionary *)userInfo {
    self.hasPushNotificationToHandle = true;
    self.notificationDict = userInfo;
    if (!isPINScreenVisible) {
        [self handlePushNotification:userInfo];
    }
}

- (void)handlePushNotification:(NSDictionary *)userInfo {
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    // Remove all dropdowns and alert controllers as the app has opened from push notification since the notification may/may not require the opening of a diffrent screen based on the action type of the notification
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeAlertViewController];
        [self removeDropDownViewController];
    });
    
    delayInSeconds = 2.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [[PushNotificationHelper sharedHelper] handleNotification:userInfo];
    });
}

@end
