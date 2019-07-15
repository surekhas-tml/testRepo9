//
//  EGOfflineMasterSyncHelper.m
//  e-guru
//
//  Created by Juili on 08/05/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGOfflineMasterSyncHelper.h"
#import "Constant.h"
#import <sqlite3.h>
#import "DBManager.h"
#import "UtilityMethods.h"
#import "AppRepo.h"
#import "EGOfflineMasterSyncAlertsHelper.h"



@implementation EGOfflineMasterSyncHelper

#pragma - mark dbQueue
static dispatch_queue_t queue;
static int count;

+ (dispatch_queue_t) offlineDBQueue {
    static dispatch_once_t queueCreationGuard;
    @synchronized (self) {
        if (queue == nil) {
            dispatch_once(&queueCreationGuard, ^{
                queue = dispatch_queue_create("com.tatamotors.eGuru.offlineDBqueue", 0);
            });
        }else{
            return queue;
        }
    }

    return queue;
}

+(BOOL) dispatch_queue_is_empty{
    return count > 0 ? NO :YES;
}
+(void) disableQueueIntake{
     count = 1;
}
+(void) enableQueueIntake{
    count = 0;
}
#pragma - mark offline Version Number Methods

+ (NSString *) resetSharedVersionNumber {
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:DBVERSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY];
}

+ (NSString *) versionNumber {
    if ([[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY] == nil) {
        [EGOfflineMasterSyncHelper resetSharedVersionNumber];
    }
    return [[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY];
}


#pragma - mark User Login Time Methods
+(void)setUserLoginTimeInformation{
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:LOGINDATEANDTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(NSDate *)getUserLoginTimeInformation{
    
    NSDate *pastLoginDate = (NSDate *)[[NSUserDefaults standardUserDefaults]objectForKey:LOGINDATEANDTIME];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:LOGINDATEANDTIME] == nil) {
        [EGOfflineMasterSyncHelper setUserLoginTimeInformation];
    }
    return pastLoginDate;
}

#pragma - mark is offline Sync required check Methods

+(BOOL)isFirstLoginOfTheDay{
    NSLog(@"Local DB Version %@" ,[[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY] );

    NSDate *pastLoginDate = [EGOfflineMasterSyncHelper getUserLoginTimeInformation];
    if (pastLoginDate != nil) {
        return ![[NSCalendar currentCalendar] isDate:pastLoginDate inSameDayAsDate:[NSDate date]];
    }else{
        return YES;
    }
}


+(BOOL)isLocalVersionNumberZero{
    NSLog(@"Local DB Version %@" ,[[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY] );
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:DBVERSION_KEY] intValue] == 0) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma - mark offline data download Methods

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(void)downloadLatestOfflineMasterForAutoSync:(BOOL) isAutoSync {

    [[EGRKWebserviceRepository sharedRepository]getOfflineSyncInformation:@{
                                                                           @"current_db_ver":[EGOfflineMasterSyncHelper versionNumber],
                                                                           @"platform":@"ios"
                                                                            }
                                                         andSuccessAction:^(NSDictionary *response) {
                                                             NSString * urlString = [response objectForKey:@"filepath"];
                                                             
                                                             if (urlString != nil) {
                                                                 [[NSUserDefaults standardUserDefaults]setValue:[response objectForKey:@"latest_db_version"] forKey:DBVERSION_KEY];
                                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                                 if (isAutoSync) {
                                                                     [EGOfflineMasterSyncHelper showSyncStartedAlert];
                                                                 }
                                                                 [self downloadSqliteFileFromURL:urlString];
                                                                 
                                                             }else{
                                                                 //No action
                                                                 [EGOfflineMasterSyncHelper resetTaskUnderProcessStatus];
                                                             }
                                                         }
                                                         andFailureAction:^(NSError *error) {
                                                             [EGOfflineMasterSyncHelper resetTaskUnderProcessStatus];
                                                             [EGOfflineMasterSyncHelper showSyncErrorAlert:error];
                                                             NSLog(@"Offline DB Sync Error:%@", error.localizedDescription);
                                                         }];
}

#pragma - mark File Download


+(void)downloadSqliteFileFromURL:(NSString *)downloadLink{
    [[[EGOfflineMasterSyncHelper alloc]init] downloadOfflineMasterFile:downloadLink];
}


- (void)downloadOfflineMasterFile:(NSString *)downloadLink{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadLink]];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDownloadTask* task = [session downloadTaskWithRequest:request];
    [task setTaskDescription:SYNC];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [task resume];
    }


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    [self masterDownloaded:[NSData dataWithContentsOfURL:location]];
    NSLog(@"File saved at %@",location);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    CGFloat percentDone = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    NSLog(@"Downloaded :  %f",percentDone);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [task cancel];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(error){
        [self masterDownloaded:error];
        [EGOfflineMasterSyncHelper showSyncErrorAlert:error];
    }
}

- (void)masterDownloaded:(id)response {
    
    if ([response isKindOfClass:[NSData class]]) {
        NSData *dbFile = response;
        NSString *resourceDocPath = [[[EGOfflineMasterSyncHelper applicationDocumentsDirectory] path] stringByAppendingPathComponent:TEMP_MASTER_DB_FullName];
        [dbFile writeToFile:resourceDocPath atomically:YES];
        [UtilityMethods RunOnOfflineDBThread:^{
            [EGOfflineMasterSyncHelper copyMasterDBIntoDocumentsDirectory];
            [[DBManager sharedInstance] setUpDB:MASTER_DB];
            [EGOfflineMasterSyncHelper resetTaskUnderProcessStatus];
            [EGOfflineMasterSyncHelper showSyncCompletedAlert];
        }];
    }else{
        [EGOfflineMasterSyncHelper resetTaskUnderProcessStatus];
        [EGOfflineMasterSyncHelper resetSharedVersionNumber];
    }
}

#pragma - mark File Operations

+ (void)copyLocalMasterDBIntoDocumentsDirectory {
    NSString *destination = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:MASTER_DB_FULL_NAME];
    NSLog(@"DB Path:%@", destination);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *source = [[NSBundle mainBundle] pathForResource:MASTER_DB ofType:@"sqlite"];
       if([fileManager fileExistsAtPath:source]){
    NSError *copyError = nil;
    NSError *removalError = nil;
    [fileManager removeItemAtPath:destination error:&removalError];
    [fileManager copyItemAtPath:source toPath:destination error:&copyError];
    if (copyError) {
        NSLog(@"%@", copyError.description);
    } else {
        NSLog(@"Local Offline Master DB copied into Documents directory !!");
    }
       }else{
           [UtilityMethods alert_ShowMessage:@"Local DB Courrupted Please Re-install the application" withTitle:@"Alert !!" andOKAction:nil];
       }
}

+ (void)copyMasterDBIntoDocumentsDirectory {
    __block NSError *copyError = nil;
    __block NSError *removalError = nil;
    
    NSString *destination = [[[EGOfflineMasterSyncHelper applicationDocumentsDirectory] path] stringByAppendingPathComponent:MASTER_DB_FULL_NAME];
    NSLog(@"DB Path:%@", destination);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *source = [[[EGOfflineMasterSyncHelper applicationDocumentsDirectory] path] stringByAppendingPathComponent:TEMP_MASTER_DB_FullName];
    if([fileManager fileExistsAtPath:source]){
        [fileManager removeItemAtPath:destination error:&removalError];
        [fileManager copyItemAtPath:source toPath:destination error:&copyError];
        if (copyError) {
            NSLog(@"%@", copyError.description);
            [EGOfflineMasterSyncHelper resetSharedVersionNumber];
        } else {
            [fileManager removeItemAtPath:source error:&removalError];
            [fileManager removeItemAtPath:[[NSBundle mainBundle] pathForResource:MASTER_DB ofType:@"sqlite"] error:&removalError];
            NSLog(@"Offline Master DB copied into Documents directory !!  current_db_ver : %@",[EGOfflineMasterSyncHelper versionNumber]);
            if([fileManager fileExistsAtPath:[[NSBundle mainBundle] pathForResource:MASTER_DB ofType:@"sqlite"]]){
                NSLog(@"delete Error");
            }
        }
    }else{
        [EGOfflineMasterSyncHelper resetSharedVersionNumber];
        [UtilityMethods alert_ShowMessage:@"Local DB Courrupted Please Restart the application" withTitle:@"Alert !!" andOKAction:^{
            [[EGRKWebserviceRepository sharedRepository] performLogoutWithSuccessAction:^(id response) {
                [[AppRepo sharedRepo] logoutUser];
            } andFailureAction:^(NSError *error) {
                [[AppRepo sharedRepo] logoutUser];
            }];
        }];
    }
}

#pragma - mark Manual Master Sync

+(void)autoSyncOfflineMaster{
    [UtilityMethods RunOnBackgroundThread:^{
        [EGOfflineMasterSyncHelper setTaskUnderProcessStatus];
        [EGOfflineMasterSyncHelper downloadLatestOfflineMasterForAutoSync:true];
        [[DBManager sharedInstance] setUpDB:MASTER_DB];
    }];
}
+(void)forceSyncOfflineMaster{
        [EGOfflineMasterSyncHelper setTaskUnderProcessStatus];
        [EGOfflineMasterSyncHelper resetSharedVersionNumber];
        [EGOfflineMasterSyncHelper showSyncStartedAlert];
        NSLog(@"Downloading OfflineMaster");
        [UtilityMethods RunOnBackgroundThread:^{
            [EGOfflineMasterSyncHelper downloadLatestOfflineMasterForAutoSync:false];
            [[DBManager sharedInstance] setUpDB:MASTER_DB];
        }];
}

+(void)setTaskUnderProcessStatus{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SyncOFF"
     object:self];
     [EGOfflineMasterSyncHelper disableQueueIntake];
}

+(void)resetTaskUnderProcessStatus{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SyncON"
     object:self];
    [EGOfflineMasterSyncHelper enableQueueIntake];

}

#pragma mark - Sync Status Alerts

+ (void)showSyncStartedAlert {
    [[EGOfflineMasterSyncAlertsHelper sharedInstance] showSyncStartedAlert];
}

+ (void)showSyncCompletedAlert {
    [[EGOfflineMasterSyncAlertsHelper sharedInstance] showSyncCompletedAlert];
}

+ (void)showSyncErrorAlert:(NSError *)error {
    if (!error) {
        return;
    }
    
    double delayInSeconds = 0.5;
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        
        if (error.code == -1005 || error.code == -1009) { // Failed as Internet Connection lost
            [[EGOfflineMasterSyncAlertsHelper sharedInstance] showSyncFailedDueToInternetAlert];
        }
        else { // Failed due to some other reason
            if (error.localizedDescription) {
                [[EGOfflineMasterSyncAlertsHelper sharedInstance] showSyncErrorAlertWithMessage:error.localizedDescription];
            }
            else {
                [[EGOfflineMasterSyncAlertsHelper sharedInstance] showSyncErrorAlert];
            }
        }
        
    });
}

@end
