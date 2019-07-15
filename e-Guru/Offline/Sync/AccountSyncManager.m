//
//  AccountSyncManager.m
//  e-guru
//
//  Created by MI iMac04 on 30/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AccountSyncManager.h"
#import "UtilityMethods.h"
#import "EGDraftStatus.h"
#import "AccountCreateOperation.h"
#import "AppRepo.h"

typedef NS_ENUM(NSInteger, AccountSyncManagerStatus)
{
    AccountSyncManagerStatusDefault,
    AccountSyncManagerStatusInProgress,
    AccountSyncManagerStatusCompleteWithSuccess,
    AccountSyncManagerStatusCompleteWithFailure
};

typedef void (^QueuedDraftsReadBlock) (NSArray *);

@interface AccountSyncManager()

@property(nonatomic)    AccountSyncManagerStatus   syncStatus;
@property(nonatomic)    NSOperationQueue*       syncOperationQueue;
@property(nonatomic)    NSDate*                 lastSyncedDateTime;
@property               dispatch_queue_t        syncManagerQueue;

-(void) doSync;

@end

@implementation AccountSyncManager

#pragma mark - initialization
-(instancetype) init
{
    self = [super init];
    if(self) {
        self.syncStatus = AccountSyncManagerStatusDefault;
        self.lastSyncedDateTime = [NSDate distantPast];
        self.syncManagerQueue = dispatch_queue_create("com.tatamotors.egurucrm.accountsyncmanager", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

+(AccountSyncManager *) sharedSyncManager {
    static AccountSyncManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - public methods

-(void) start
{
    dispatch_async(self.syncManagerQueue, ^{
        [self doSync];
    });
}


/*
 *  Create an op-queue and read queued drafts.
 *  each opty to be synced through OptyCreationOperation.
 */
-(void) doSync
{
    if(self.syncStatus != AccountSyncManagerStatusInProgress) {
        [self getDraftsToSync:^(NSArray *queuedDrafts) {
            [self queuAllSyncOperations:queuedDrafts];
        }];
    }
}

#pragma mark - property getter setter
-(NSOperationQueue *) syncOperationQueue
{
    if(nil == _syncOperationQueue) {
        _syncOperationQueue = [[NSOperationQueue alloc] init];
        _syncOperationQueue.maxConcurrentOperationCount = 5;
    }
    return _syncOperationQueue;
}

#pragma mark - private methods
-(void) getDraftsToSync:(QueuedDraftsReadBlock) readCompletionBlock
{
    NSFetchRequest *fetchRequest = [AAADraftAccountMO fetchRequest];
    
    NSPredicate *predicateUserId = [NSPredicate predicateWithFormat:@"userIDLink == %@", [[AppRepo sharedRepo] getLoggedInUser].userName];
    NSPredicate *predicateStatus = [NSPredicate predicateWithFormat:@"status==%d",EGDraftStatusQueuedToSync];
    
    NSPredicate *predicateSearch = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateUserId, predicateStatus]];
    
    [fetchRequest setPredicate:predicateSearch];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; //AppDelegate instance;
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    NSArray *queuedDrafts = nil;
    
    queuedDrafts = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(nil != error) {
        NSLog(@"Error while reading queued drafts. Error message - %@", error.description);
    }
    
    [context performBlockAndWait:^{
        NSError *error = nil;
        NSArray *queuedDrafts = nil;
        
        queuedDrafts = [context executeFetchRequest:fetchRequest error:&error];
        if(nil != error) {
            NSLog(@"Error while reading queued drafts. Error message - %@", error.description);
        }
        
        dispatch_async(self.syncManagerQueue, ^{
            if(nil != readCompletionBlock) {
                readCompletionBlock(queuedDrafts);
            }
        });
    }];
}

-(void) queuAllSyncOperations:(NSArray *) queuedDrafts
{
    for (AAADraftAccountMO *accountDraft in queuedDrafts) {
        AccountCreateOperation *accountCreateOperation = [[AccountCreateOperation alloc] initWithAccountDraft:accountDraft withCompletionBlock:nil];
        [self.syncOperationQueue addOperation: accountCreateOperation];
    }
}

@end
