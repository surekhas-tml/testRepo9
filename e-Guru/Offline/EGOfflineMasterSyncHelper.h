//
//  EGOfflineMasterSyncHelper.h
//  e-guru
//
//  Created by Juili on 08/05/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface EGOfflineMasterSyncHelper : NSObject<NSURLSessionDownloadDelegate,NSURLSessionDelegate>
+ (dispatch_queue_t) offlineDBQueue;
+ (void)copyLocalMasterDBIntoDocumentsDirectory;

+(void)autoSyncOfflineMaster;
+(void)forceSyncOfflineMaster;

+(BOOL)isFirstLoginOfTheDay;
+(BOOL)isLocalVersionNumberZero;
+(BOOL) dispatch_queue_is_empty;
+(void) disableQueueIntake;
+(void) enableQueueIntake;

@end
