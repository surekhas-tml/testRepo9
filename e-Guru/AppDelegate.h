//
//  AppDelegate.h
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "EGOpportunity.h"
#import "EGFinancierOpportunity.h"

#import "EGContact.h"
#import "EGAccount.h"
#import "EGAddress.h"
#import "EGCampaign.h"
#import "EGActivity.h"
#import "EGFinancier.h"
#import "EGRKWebserviceRepository.h"
#import <RestKit/RestKit.h>
#import "GoogleAnalyticsHelper.h"
#import "DBManager.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *initialView;

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic,strong ) UISplitViewController *splitViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UINavigationController *dashboardNavigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) BOOL isInvokedFromProductApp;
@property (strong, nonatomic) NSString *screenNameForReportIssue;

@property (nonatomic,strong) EGOpportunity *productAppOpty;
@property(nonatomic) BOOL doNotFetchData;
@property (assign, nonatomic) BOOL shouldRefreshNFASummaryView;
@property (nonatomic) NSPersistentStoreCoordinator *encryptedPersistentStoreCoordinator;
@property (nonatomic, assign) BOOL hasJustLoggedIn;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)matchLoginWithProductApp;
@end

