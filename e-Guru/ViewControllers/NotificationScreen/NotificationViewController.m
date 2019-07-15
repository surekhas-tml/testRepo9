//
//  NotificationViewController.m
//  e-guru
//
//  Created by Ashish Barve on 1/19/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationsTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGRKWebserviceRepository.h"
#import "AppRepo.h"
#import "EGNotification.h"
#import "AAANotification+CoreDataClass.h"
#import "AAANotification+CoreDataProperties.h"
#import "PushNotificationHelper.h"

#define NOTIFICATION_CELL_IDENTIFIER            @"NotificationCell"
#define DELETE_BUTTON_TEXT                      @"Delete"
#define DELETE_NOTIFICATION_SUCCESS_MESSAGE     @"Notification deleted successfully"
#define DELETE_NOTIFICATION_FAILED_MESSAGE      @"Failed to delete notification"
#define GROUP_NAME                              @"groupName"
#define GROUP_ARRAY                             @"groupArray"

@interface NotificationViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}

#pragma mark - Properties
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) AppDelegate *appDelegateObj;
@property (nonatomic) UIButton *navBarRefreshButton;
@property (nonatomic) NSMutableArray *groupedNotificationsArray;

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the UI
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UtilityMethods navigationBarSetupForController:self];
    
    [self addRefreshButtonInNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)initUI {
    
    [self.navigationController setTitle:NOTIFICATIONS];
    [self setTableViewCellHeightToAutomatic];
    [self setupRefreshControlAndAddToTableView];
    
    // Fetch the notifications either from API or DB
    if (self.appDelegateObj.hasJustLoggedIn || [[self fetchNotificationsFromDB] count] == 0) {
        
        [self fetchNotificationListFromAPIWithLoader:true];
        self.appDelegateObj.hasJustLoggedIn = false;
        
    } else {
        
        self.groupedNotificationsArray = [self getGroupedNotificationsFrom:[self fetchNotificationsFromDB]];
        [self.notificationsTableView reloadData];
    }
}

- (void)addRefreshButtonInNavigationBar {
    
    self.navBarRefreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    [self.navBarRefreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.navBarRefreshButton setBackgroundColor:[UIColor whiteColor]];
    [self.navBarRefreshButton.layer setCornerRadius:5.0f];
    [self.navBarRefreshButton setTitleColor:[UIColor navBarColor] forState:UIControlStateNormal];
    [self.navBarRefreshButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.navBarRefreshButton addTarget:self action:@selector(refreshNotificationsList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.navBarRefreshButton];
    NSMutableArray *existingButtonsArray = [self.navigationItem.rightBarButtonItems mutableCopy];
    [existingButtonsArray addObject:refreshBarButton];
    [self.navigationItem setRightBarButtonItems:existingButtonsArray];
}

- (AppDelegate *)appDelegateObj {
    if (!_appDelegateObj) {
        _appDelegateObj = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegateObj;
}

- (void)setTableViewCellHeightToAutomatic {
    self.notificationsTableView.estimatedRowHeight = 54.0f;
    self.notificationsTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupRefreshControlAndAddToTableView {
    self.refreshControl = [[UIRefreshControl alloc] init];
    // Add selector to be called when refresh control's values changes
    [self.refreshControl addTarget:self
                            action:@selector(refreshNotificationsListFromPullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // Text while refreshing
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:12.0f],
                                     NSForegroundColorAttributeName : [UIColor themePrimaryColor]
                                     };
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Getting New Notifications..."
                                                                          attributes:textAttributes];
    // Tint color
    self.refreshControl.tintColor = [UIColor themePrimaryColor];
    
    // Add the refresh control to notifications table view
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 10, .minorVersion = 0, .patchVersion = 0}]) {
        self.notificationsTableView.refreshControl = self.refreshControl;
    } else {
        [self.notificationsTableView addSubview:self.refreshControl];
    }
    
}

- (NSDate *)getDateFromStringDate:(NSString *)stringDate havingFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    return [formatter dateFromString:stringDate];
}

- (NSDate *)getTimelessDateFromDate:(NSDate *)inputDate {
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSDate *)getYesterdaysDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
}

- (NSString *)getLocalDateInStringFromUTCDate:(NSDate *)utcDate {
    
    NSDate *dateInLocalTimezone = [self getLocalDateFromUTCDate:utcDate];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setDateFormat:@"hh:mm:ss a"];
    return  [localDateFormatter stringFromDate:dateInLocalTimezone];
}

- (NSDate *)getLocalDateFromUTCDate:(NSDate *)utcDate {
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [utcDate dateByAddingTimeInterval:timeZoneSeconds];
    return dateInLocalTimezone;
}

- (NSString *)getGroupNameFromDate:(NSDate *)inputDate {
    NSDate *todaysDate = [self getTimelessDateFromDate:[NSDate date]];
    NSDate *yesterdaysDate = [self getTimelessDateFromDate:[self getYesterdaysDate]];
    if ([inputDate compare:todaysDate] == NSOrderedSame) {
        return @"Today";
    } else if ([inputDate compare:yesterdaysDate] == NSOrderedSame) {
        return @"Yesterday";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatddMMyyyy];
        return [dateFormatter stringFromDate:inputDate];
    }
}

- (NSMutableDictionary *)getGroupDictionaryForDate:(NSDate *)date andArray:(NSMutableArray *)groupArray {
    NSMutableDictionary *groupDictionary = [[NSMutableDictionary alloc] init];
    
    [groupDictionary setValue:[self getGroupNameFromDate:date] forKey:GROUP_NAME];
    [groupDictionary setValue:groupArray forKey:GROUP_ARRAY];
    
    return groupDictionary;
}

- (NSMutableArray *)getGroupedNotificationsFrom:(NSMutableArray *)nonGroupedArray {
    
    NSMutableArray *groupedNotificationArray = [[NSMutableArray alloc] init];
    NSMutableArray *sameDateNotificationsArray = [[NSMutableArray alloc] init];
    NSDate *currentDate = [self getTimelessDateFromDate:[NSDate date]];
    
    for (AAANotification *notificationObj in nonGroupedArray) {
        
        NSDate *timelessNotificationDate = [self getTimelessDateFromDate:notificationObj.sentDateIST];
        
        if ([currentDate compare:timelessNotificationDate] != NSOrderedSame) {
            
            if ([sameDateNotificationsArray count] > 0) {
                [groupedNotificationArray addObject:[self getGroupDictionaryForDate:currentDate andArray:[sameDateNotificationsArray mutableCopy]]];
            }
            
            [sameDateNotificationsArray removeAllObjects];
            
            currentDate = timelessNotificationDate;
        }
        
        [sameDateNotificationsArray addObject:notificationObj];
    }
    
    // Add the last notifications group to the grouped notification array
    [groupedNotificationArray addObject:[self getGroupDictionaryForDate:currentDate andArray:sameDateNotificationsArray]];
    
    return groupedNotificationArray;
}

- (AAANotification *)getNotificationObjectFromGroupedArrayAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *groupDictionary = [self.groupedNotificationsArray objectAtIndex:indexPath.section];
    NSMutableArray *notificationsArray = [groupDictionary valueForKey:GROUP_ARRAY];
    
    return [notificationsArray objectAtIndex:indexPath.row];
}

- (void)deleteNotificationObjectFromGroupedArrayAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *groupDictionary = [self.groupedNotificationsArray objectAtIndex:indexPath.section];
    NSMutableArray *notificationsArray = [groupDictionary valueForKey:GROUP_ARRAY];
    
    [notificationsArray removeObjectAtIndex:indexPath.row];
}

- (void)showDeleteNotificationConfirmation:(NSIndexPath *)indexPath {
    
    [UtilityMethods alert_showMessage:@"Do you want to delete this notification?"
                            withTitle:APP_NAME
                          andOKAction:^{
                              // Make API call to delete the notification
                              [self deleteNotificationAtIndexPath:indexPath];
                          }
                          andNoAction:^{
                              
                          }];
}

- (void)showAlertForError:(NSError *)error {
    if (error.localizedDescription) {
        [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
            
        }];
    }
}

- (void)showOKAlertWithMessage:(NSString *)message {
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        
    }];
}

- (void)adjustNotificationTableViewAfterAPICall {
    
    [self.notificationsTableView reloadData];
    [self.refreshControl endRefreshing];
    
    // Make the table view scroll to top
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.notificationsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
}

#pragma mark - Core Data Operations

- (void)insertNotificationInDB:(NSMutableArray *)notificationArray insertSuccessful:(void (^)())insertSuccessful insertFailed:(void (^)())insertFailed {
    
    for (EGNotification *notificationObj in notificationArray) {
        AAANotification *cdNotificationObj = [NSEntityDescription insertNewObjectForEntityForName:E_NOTIFICATION
                                                                          inManagedObjectContext:self.appDelegateObj.managedObjectContext];
        
        cdNotificationObj.notificationID = notificationObj.notificationID;
        cdNotificationObj.loginID = notificationObj.loginID;
        cdNotificationObj.activityID = notificationObj.activityID;
        cdNotificationObj.sentDate = [self getDateFromStringDate:notificationObj.strSentDate havingFormat:dateFormatyyyyMMddTHHmmssZ];
        cdNotificationObj.sentDateIST = [self getLocalDateFromUTCDate:cdNotificationObj.sentDate];
        cdNotificationObj.strSentDate = notificationObj.strSentDate;
        cdNotificationObj.strIsActiveFlag = notificationObj.strIsActiveFlag;
        cdNotificationObj.actionName = notificationObj.actionName;
        cdNotificationObj.action = notificationObj.action;
        cdNotificationObj.message = notificationObj.message;
        cdNotificationObj.optyID = notificationObj.optyID;
    }
    
    NSError *error = nil;
    [self.appDelegateObj.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Failed to save notifications in DB");
        insertFailed();
    } else {
        insertSuccessful();
    }
}

- (NSMutableArray *)fetchNotificationsFromDB {
    
    NSFetchRequest *notificationFetchRequest = [AAANotification fetchRequest];
    NSError *error;
    NSArray *fetchedNotificationsArray = [self.appDelegateObj.managedObjectContext executeFetchRequest:notificationFetchRequest error:&error];
    
    if (error) {
        NSLog(@"Failed to fetch notifications from DB");
        return nil;
    }
    else {
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sentDate" ascending:NO];
        return [[fetchedNotificationsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
    }
    
}

// This method is for performing deletion from outside this class
+ (void)deleteAllNotificationsFromDB {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *notificationFetchRequest = [AAANotification fetchRequest];
    NSError *error;
    NSArray *fetchedNotificationsArray = [appDelegate.managedObjectContext executeFetchRequest:notificationFetchRequest error:&error];
    
    if (!error) {
        
        for (NSManagedObject *notification in fetchedNotificationsArray) {
            [appDelegate.managedObjectContext deleteObject:notification];
        }
        
        NSError *deleteError;
        [appDelegate.managedObjectContext save:&deleteError];
    }
}

- (void)deleteAllNotificationSuccessful:(void(^)())deleteSuccessful deleteFailed:(void(^)())deleteFailed {
    
    NSMutableArray *notificationsArray = [self fetchNotificationsFromDB];
    if (notificationsArray) {
        for (NSManagedObject *notification in notificationsArray) {
            [self.appDelegateObj.managedObjectContext deleteObject:notification];
        }
        
        NSError *error;
        [self.appDelegateObj.managedObjectContext save:&error];
        if (!error) {
            deleteSuccessful();
        } else {
            deleteFailed();
        }
    } else {
        deleteSuccessful();
    }
}

- (void)deleteNotificationFromDBHavingID:(NSString *)notificationID deleteSuccessful:(void(^)())successBlock deleteFailed:(void(^)())failureBlock {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:E_NOTIFICATION];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notificationID == %@", notificationID];
    
    fetchRequest.predicate = predicate;
    
    NSError *fetchError;
    NSArray *notificationArray = [self.appDelegateObj.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (!fetchError) {
        for (NSManagedObject *notification in notificationArray) {
            [self.appDelegateObj.managedObjectContext deleteObject:notification];
        }
        
        NSError *saveError;
        [self.appDelegateObj.managedObjectContext save:&saveError];
        if (!saveError) {
            successBlock();
        } else {
            failureBlock();
        }
        
    } else {
        failureBlock();
    }
}

#pragma mark - Selector Methods

- (void)refreshNotificationsListFromPullToRefresh {
    [self fetchNotificationListFromAPIWithLoader:false];
}

- (void)refreshNotificationsList {
    [self fetchNotificationListFromAPIWithLoader:true];
}

#pragma mark - IBActions

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationsTableViewCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:NOTIFICATION_CELL_IDENTIFIER forIndexPath:indexPath];
    
    AAANotification *notificationObj = [self getNotificationObjectFromGroupedArrayAtIndexPath:indexPath];
    notificationCell.notificationTime.text = [self getLocalDateInStringFromUTCDate:notificationObj.sentDate];
    notificationCell.notificationTextLabel.text = notificationObj.message;
    return notificationCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *groupDictionary = [self.groupedNotificationsArray objectAtIndex:section];
    return [[groupDictionary valueForKey:GROUP_ARRAY] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedNotificationsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableDictionary *groupDictionary = [self.groupedNotificationsArray objectAtIndex:section];
    return [groupDictionary valueForKey:GROUP_NAME];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AAANotification *selectedNotification = [self getNotificationObjectFromGroupedArrayAtIndexPath:indexPath];
    
    NSDictionary *userInfo = @{
                               @"action" : selectedNotification.actionName,
                               @"opty_id" : selectedNotification.optyID,
                               @"activity_id" : selectedNotification.activityID
                               };
    
    [[PushNotificationHelper sharedHelper] performActionForNotification:userInfo];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              // Show delete notification confirmation
                                                                              [self showDeleteNotificationConfirmation:indexPath];
                                                                          }];
    return @[actionDelete];
}

#pragma mark - API Calls

- (void)fetchNotificationListFromAPIWithLoader:(BOOL) showLoader {
    
    [self.navBarRefreshButton setEnabled:false];
    
    if (showLoader) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
    }
    
    NSDictionary *requestDictionary = @{
                                        @"login_id" : [[[AppRepo sharedRepo] getLoggedInUser] userName]
                                        };
    
    [[EGRKWebserviceRepository sharedRepository] getNotificationList:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        
        [self.navBarRefreshButton setEnabled:true];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        [self deleteAllNotificationSuccessful:^{
            
            if (paginationObj.items.count == 0) {
                [self showOKAlertWithMessage:@"No notifications available right now"];
                return;
            }
            
            [self insertNotificationInDB:paginationObj.items insertSuccessful:^{
                self.groupedNotificationsArray = [self getGroupedNotificationsFrom:[self fetchNotificationsFromDB]];
                [self adjustNotificationTableViewAfterAPICall];
                
            } insertFailed:^{
                [self.refreshControl endRefreshing];
            }];
            
        } deleteFailed:^{
            [self.refreshControl endRefreshing];
        }];
        
    } andFailuerAction:^(NSError *error) {
        [self.navBarRefreshButton setEnabled:true];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [self.refreshControl endRefreshing];
        [self showAlertForError:error];
    }];
}

- (void)deleteNotificationAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the notification object to be deleted
    AAANotification *notification = [self getNotificationObjectFromGroupedArrayAtIndexPath:indexPath];
    
    // Prepare request dictionary
    NSDictionary *requestDictionary = @{
                                        @"notification_id" : notification.notificationID,
                                        @"is_active" : @"N"
                                        };
    
    // Make API Call to delete notification
    [[EGRKWebserviceRepository sharedRepository] deleteNotification:requestDictionary andSucessAction:^(NSDictionary *responseDict) {
        if ([responseDict valueForKey:@"status"] && [[responseDict valueForKey:@"status"] integerValue] == 1) {
            
            [self deleteNotificationFromDBHavingID:notification.notificationID deleteSuccessful:^{
                
                [self deleteNotificationObjectFromGroupedArrayAtIndexPath:indexPath];
                
                [self.notificationsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                // Notify user that notification has been deleted successfully
                [UtilityMethods showToastWithMessage:DELETE_NOTIFICATION_SUCCESS_MESSAGE];
                
            } deleteFailed:^{
                
                // Notify user that notification deletion has failed
                [UtilityMethods alert_ShowMessage:DELETE_NOTIFICATION_FAILED_MESSAGE withTitle:APP_NAME andOKAction:^{
                    
                }];
            }];
            
        } else {
            // Notify user that notification deletion has failed
            [UtilityMethods alert_ShowMessage:DELETE_NOTIFICATION_FAILED_MESSAGE withTitle:APP_NAME andOKAction:^{
                
            }];
        }
    } andFailuerAction:^(NSError *error) {
        NSLog(@"Failure:%@", error);
        [self showAlertForError:error];
    }];
}

@end
