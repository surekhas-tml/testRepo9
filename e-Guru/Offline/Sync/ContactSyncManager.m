//
//  ContactSyncManager.m
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ContactSyncManager.h"
#import "UtilityMethods.h"
#import "EGDraftStatus.h"
#import "ContactCreateOperation.h"
#import "AppRepo.h"

typedef NS_ENUM(NSInteger, ContactSyncManagerStatus)
{
    ContactSyncManagerStatusDefault,
    ContactSyncManagerStatusInProgress,
    ContactSyncManagerStatusCompleteWithSuccess,
    ContactSyncManagerStatusCompleteWithFailure
};

typedef void (^QueuedDraftsReadBlock) (NSArray *);

@interface ContactSyncManager()

@property(nonatomic)    ContactSyncManagerStatus   syncStatus;
@property(nonatomic)    NSOperationQueue*       syncOperationQueue;
@property(nonatomic)    NSDate*                 lastSyncedDateTime;
@property               dispatch_queue_t        syncManagerQueue;

-(void) doSync;

@end

@implementation ContactSyncManager

#pragma mark - initialization
-(instancetype) init
{
    self = [super init];
    if(self) {
        self.syncStatus = ContactSyncManagerStatusDefault;
        self.lastSyncedDateTime = [NSDate distantPast];
        self.syncManagerQueue = dispatch_queue_create("com.tatamotors.egurucrm.contactsyncmanager", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

+(ContactSyncManager *) sharedSyncManager {
    static ContactSyncManager *sharedMyManager = nil;
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
    if(self.syncStatus != ContactSyncManagerStatusInProgress) {
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
    NSFetchRequest *fetchRequest = [AAADraftContactMO fetchRequest];
    
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
    for (AAADraftContactMO *contactDraft in queuedDrafts) {
        ContactCreateOperation *contactCreateOperation = [[ContactCreateOperation alloc] initWithContactDraft:contactDraft withCompletionBlock:nil];
        [self.syncOperationQueue addOperation: contactCreateOperation];
    }
}

@end
