
//
//  AppDelegate.m
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "UIResponder+UIResponder_CrashReport.h"
#import "Constant.h"
#import "LocationManagerSingleton.h"
#import "EncryptedStore.h"
#import "AppRepo.h"
#import "CreateOpportunityViewController.h"
#import "OptySyncManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ReachabilityManager.h"
#import "AAADraftMO+CoreDataClass.h"
#import "AppRepo.h"
#import "NSDate+eGuruDate.h"
#import "RootDetector.h"
#import "UtilityMethods.h"
#import "EGOfflineMasterSyncHelper.h"
#import "AccountSyncManager.h"
#import "ContactSyncManager.h"
#import "PINViewController.h"
#import <sqlite3.h>
#import <UserNotifications/UserNotifications.h>
#import "PushNotificationHelper.h"
#import "AsyncLocationManager.h"
//
@interface AppDelegate () <UISplitViewControllerDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate, LocationManagerSingletonDelegate>


@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize userName;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    //Delete Draft from DraftDB when draft.status == EGDraftStatusSyncing
    [UtilityMethods resetDraftStatus];
    
	[[ReachabilityManager sharedInstance] startWatchingNetworkChange];
	
    if([RootDetector isRooted])
    {
        [self halt];
        return NO;
    }

    if (![[AppRepo sharedRepo] isUserLoggedIn]) {
        [self.window makeKeyAndVisible];
        self.initialView = self.window.rootViewController;
    }
    else {
        [[AppRepo sharedRepo] showPinScreen];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor heddingTextColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor navBarColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setOpaque:YES];

    
    //initialise google Analytics
    [self setupGoogleAnalyticsWithTrackingID:GAnalyticsTrackingID];
    [[GoogleAnalyticsHelper sharedHelper] initializeGoogleAnalytics];
    
    // Ask for location permission
    [[LocationManagerSingleton sharedLocationInstance]setDelegate:self];
    [[LocationManagerSingleton sharedLocationInstance] setDidFindLocation:false];
    [[LocationManagerSingleton sharedLocationInstance].myLocationManager startUpdatingLocation];
	
	//Reghi
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInternetAvailable) name:NOTIFICATION_NETWORK_AVAILABLE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInternetNotAvailable) name:NOTIFICATION_NETWORK_NOT_AVAILABLE object:nil];
	
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.productAppOpty = nil;
    appDelegate.userName = nil;
    
    /*------
     * Crashlytics initialization
     */
    [Fabric with:@[[Crashlytics class]]];
    //-----------//
    
    [self syncOfflineMasterDatabase];
    
    // Register the device for receiving push notifications
    [self registerForPushNotifications];
    
    
    // If Push notification was received when app was in killed state
    if (launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSLog(@"Launch Options:%@", launchOptions);
        [[AppRepo sharedRepo] pushNotificationReceivedWithDictionary:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    return YES;
}

-(void)syncOfflineMasterDatabase{
    //OFFLINEMASTERSYNC ------------------------------
    if ([[NSUserDefaults standardUserDefaults]objectForKey:LOGINDATEANDTIME] == nil) {
        [EGOfflineMasterSyncHelper copyLocalMasterDBIntoDocumentsDirectory];
        if (([EGOfflineMasterSyncHelper isFirstLoginOfTheDay] || [EGOfflineMasterSyncHelper isLocalVersionNumberZero])&&([[AppRepo sharedRepo] isUserLoggedIn])) {
            [EGOfflineMasterSyncHelper autoSyncOfflineMaster];
        }
        else{
            [[DBManager sharedInstance] setUpDB:MASTER_DB];
        }
    }else if ([[AppRepo sharedRepo] isUserLoggedIn]){
        if ([EGOfflineMasterSyncHelper isFirstLoginOfTheDay] || [EGOfflineMasterSyncHelper isLocalVersionNumberZero]) {
            [EGOfflineMasterSyncHelper autoSyncOfflineMaster];
        }
        else{
            [[DBManager sharedInstance] setUpDB:MASTER_DB];
        }
    }
    //OFFLINEMASTERSYNC ------------------------------

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[AppRepo sharedRepo] isUserLoggedIn]) {
        [[AppRepo sharedRepo] showPinScreen];
        
        [[AsyncLocationManager sharedInstance] stopAsyncLocationFetch];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self syncOfflineMasterDatabase];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[AppRepo sharedRepo] isUserLoggedIn]) {
        [[AsyncLocationManager sharedInstance] startAsyncLocationFetch];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSDictionary *options = @{
                                  EncryptedStorePassphraseKey : [UtilityMethods getVendorID],
                                  NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES
                                  };
        self.encryptedPersistentStoreCoordinator = [EncryptedStore makeStoreWithOptions:options managedObjectModel:[self managedObjectModel]];
        if (self.encryptedPersistentStoreCoordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.encryptedPersistentStoreCoordinator];
        }
    });

    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
	
		//Select the managedObjectModel
	NSString *modelPath;
	modelPath = [[NSBundle mainBundle]
		   pathForResource:@"e_Guru" ofType:@"momd"];
	
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
	NSURL *storeURL;
	storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyStore.sqlite"];

    NSLog(@"%@",storeURL);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
               NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)copyMasterDBIntoDocumentsDirectory {
    NSString *destination = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:MASTER_DB_FULL_NAME];
    NSLog(@"DB Path:%@", destination);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *source = [[NSBundle mainBundle] pathForResource:MASTER_DB ofType:@"sqlite"];
    NSError *copyError = nil;
    NSError *removalError = nil;
    [fileManager removeItemAtPath:destination error:&removalError];
    [fileManager copyItemAtPath:source toPath:destination error:&copyError];
    if (copyError) {
        NSLog(@"%@", copyError.description);
    } else {
        NSLog(@"Offline Master DB copied into Documents directory !!");
    }
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
		[managedObjectContext save:&error];
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    if (([[url scheme] isEqualToString:@"urlschemetest"])) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *loginId = [self valueForKey:@"login" fromQueryItems:queryItems];
        NSString *param2 = [self valueForKey:@"optyinput" fromQueryItems:queryItems];
        NSString *param3 = [self valueForKey:@"token" fromQueryItems:queryItems];
        NSString *uniqueId = [self valueForKey:@"uniqueid" fromQueryItems:queryItems];
        NSLog(@"%@, %@, %@, %@", loginId, param2, param3, uniqueId);
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.userName = loginId;
        
        NSDictionary *productAppDataDict = [self parseJSONStructure:param2];
        NSLog(@"Product App Data %@",productAppDataDict);
        appDelegate.productAppOpty = [[EGOpportunity alloc] init];
        appDelegate.productAppOpty = [self fillOpportunityData:productAppDataDict];
        appDelegate.productAppOpty.productIntegrationID = uniqueId ? : @"";
        
        if (![loginId isEqual:[NSNull null]]) {//Login Id is not null
            NSLog(@"LoginId Found");
            if(appDelegate.productAppOpty){
                appDelegate.isInvokedFromProductApp = true;
                NSLog(@"Opty Found");
                if ([[AppRepo sharedRepo] isUserLoggedIn]) {// Is Current app user login?
                    NSLog(@"Current User Login");
                    // Not below method also called
                    // From PINViewController
                    [self matchLoginWithProductApp];
                }
                else{
                    NSLog(@"Current User Not Login");
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appDelegate.initialView = nil;
                    [[AppRepo sharedRepo] showLoginScreen];
                }
            }
            else{
                NSLog(@"Opty Not Found");
                [UtilityMethods alert_ShowMessage:@"Unable to read the data from the Product application." withTitle:APP_NAME andOKAction:nil];
            }
        }
        return YES;
        
    } else {
        [UtilityMethods alert_ShowMessage:@"URL Error!" withTitle:APP_NAME andOKAction:nil];
        return NO;
        
    }
}

- (EGOpportunity*) fillOpportunityData:(NSDictionary*) dictionary {
    EGOpportunity *egOpportunity = [[EGOpportunity alloc] init];
    
    NSArray *customerDataArray = [dictionary objectForKey:@"customer_data"];
    
    if (customerDataArray.count) {
        NSDictionary *customerDataDictionary = [customerDataArray objectAtIndex:0];
        if (customerDataDictionary.count) {
            // Contact Population
            egOpportunity.toContact = [[EGContact alloc] init];
            egOpportunity.toVCNumber = [[EGVCNumber alloc] init];
            egOpportunity.toLOBInfo = [[EGLOBInfo alloc] init];
            
            
            egOpportunity.toContact.firstName = [[customerDataDictionary objectForKey:@"customer_first_name"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"customer_first_name"];
            egOpportunity.toContact.lastName = [[customerDataDictionary objectForKey:@"customer_last_name"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"customer_last_name"];
            egOpportunity.toContact.contactNumber = [[customerDataDictionary objectForKey:@"mobile_number"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"mobile_number"];
            egOpportunity.toContact.emailID = [[customerDataDictionary objectForKey:@"email"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"email"];
            egOpportunity.vhApplication = [[customerDataDictionary objectForKey:@"vehicle_application"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"vehicle_application"];
            egOpportunity.customerType = [[customerDataDictionary objectForKey:@"customer_type"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"customer_type"];
            egOpportunity.toVCNumber.vcNumber = [[customerDataDictionary objectForKey:@"selected_vehicle_vc_no"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"selected_vehicle_vc_no"];
            egOpportunity.toLOBInfo.vehicleApplication = [[customerDataDictionary objectForKey:@"vehicle_application"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"vehicle_application"];
            egOpportunity.toLOBInfo.usageCategory = [[customerDataDictionary objectForKey:@"usage_category"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"usage_category"];
            egOpportunity.toLOBInfo.customerType = [[customerDataDictionary objectForKey:@"customer_type"] length] == 0 ? @"" : [customerDataDictionary objectForKey:@"customer_type"];

        }
    }
    return egOpportunity;
}

- (NSDictionary*) parseJSONStructure:(NSString *) jsonString {
    NSString *text = [jsonString stringByRemovingPercentEncoding];
    NSData *jsonData = [NSData dataWithBytes:[text UTF8String] length:[text length]];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    return dict;
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
}

#pragma mark - PIN Screen

- (void)matchLoginWithProductApp {
    
    
//    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
//        return;
//    }
    
    if ([userName isEqualToString:[[AppRepo sharedRepo] getLoggedInUser].userName]) {
        //Check the user name is equal to current user name
        NSLog(@"User Name Same");
        // USE egOpportunity object & navigate to the Create Opportunity Screens.
        [[AppRepo sharedRepo] showCreateOptyScreen];
    }
    else{
        NSLog(@"User Name Not Same");
        NSString *msgStr;
        if (![userName isEqual:[NSNull null]] && ![userName isEqualToString:@""]) {
            
            msgStr =[NSString stringWithFormat:@"You are logged in as a different user, this operation will log out and authenticate against %@. Do you want to continue?",userName];
        }
        else{
            
            msgStr =[NSString stringWithFormat:@"You are logged in as a different user, this operation will log out you from the application. Do you want to continue?"];
        }
        
        [UtilityMethods alert_showMessage:msgStr withTitle:APP_NAME andOKAction:^{
            [[AppRepo sharedRepo] logoutUser];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.initialView = nil;
            [[AppRepo sharedRepo] showLoginScreen];
        }andNoAction:^{
            self.userName = nil;
            self.productAppOpty = nil;
        }];
    }
}

- (void)showPINScreen {
    
    if (self.splitViewController && [self.splitViewController.viewControllers count] > 1 && [[self.splitViewController.viewControllers objectAtIndex:1] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = [self.splitViewController.viewControllers objectAtIndex:1];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PINViewController" bundle:nil];
        PINViewController *pinViewController = [storyboard instantiateViewControllerWithIdentifier:@"pinViewController"];
        [[navigationController.viewControllers objectAtIndex:0] presentViewController:pinViewController animated:NO completion:nil];
    }
}

#pragma mark - Internet Availablity Callbacks
- (void)onInternetAvailable {
	[[OptySyncManager sharedSyncManager] start];
    [[AccountSyncManager sharedSyncManager] start];
    [[ContactSyncManager sharedSyncManager] start];
}

- (void)onInternetNotAvailable {
	
}

- (void) halt {
    [UtilityMethods alert_ShowMessage:@"You are not allowed to use the app on a rooted device" withTitle:@"Error" andOKAction:^{
        exit(0);
    }];
}

#pragma mark - Push Notifications
- (void)registerForPushNotifications {

    // Configure FCM for push notifications
    FIROptions *firOptions = [[FIROptions alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleService-FCM-Info" ofType:@".plist"]];
    [FIRApp configureWithOptions:firOptions];
    [FIRMessaging messaging].remoteMessageDelegate = self;

    
    // Register for notification indicating Firebase Registration Token Generated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fcmTokenReceived:)
                                                 name:kFIRInstanceIDTokenRefreshNotification
                                               object:nil];
    
    // iOS 10.0 and Above
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 10, .minorVersion = 0, .patchVersion = 0}]) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                                                                               UNAuthorizationOptionAlert |
                                                                                               UNAuthorizationOptionSound)
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                if (!error) {
                                                                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                                }else{
                                                                                    NSLog(@"%@", error);
                                                                                }
                                                                            }];
    }
    // iOS 9.0 and Above
    else if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 0, .patchVersion = 0}]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:([UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                                                                           UIUserNotificationTypeAlert |
                                                                                                                           UIUserNotificationTypeBadge)
                                                                                                               categories:nil])];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

//    // iOS 8 or later
//    // [START register_for_notifications]
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//        UIUserNotificationType allNotificationTypes =
//        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        // iOS 10 or later
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        // For iOS 10 display notification (sent via APNS)
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        }];
//#endif
//    }
//    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device Token:%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Notification Error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"User Info:%@", userInfo);
    [[AppRepo sharedRepo] pushNotificationReceivedWithDictionary:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"Notification Response:%@", response);
    [[AppRepo sharedRepo] pushNotificationReceivedWithDictionary:response.notification.request.content.userInfo];
}

#pragma mark - FIRMessagingDelegate

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"FCM Message:%@", remoteMessage.appData);
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)fcmTokenReceived:(NSNotification *)notification {
    NSLog(@"FCM Token:%@", [[FIRInstanceID instanceID] token]);
    
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Save the FCM Token in core data
    [[PushNotificationHelper sharedHelper] saveFCMRegToken:[[FIRInstanceID instanceID] token]];
    
    if ([[AppRepo sharedRepo] isUserLoggedIn]) {
        
        // Register the device for Push Notification
        [[PushNotificationHelper sharedHelper] registerDevice];
    }
}

@end
