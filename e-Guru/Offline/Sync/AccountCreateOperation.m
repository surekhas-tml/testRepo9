//
//  AccountCreateOperation.m
//  e-guru
//
//  Created by MI iMac04 on 30/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AccountCreateOperation.h"
#import "NSString+NSStringCategory.h"
#import "Constant.h"
#import "EGDraftStatus.h"
#import "AppDelegate.h"

@interface AccountCreateOperation()

@property(nonatomic) AAADraftAccountMO*    accountDraft;
@property(nonatomic) NSError*       error;
@property(nonatomic) AccountSyncStatus status;
@property(nonatomic, copy) AccountCreationCompletionBlock completionBlock;

@property (assign, readwrite, nonatomic, getter = isFinished)   BOOL finished;
@property (assign, readwrite, nonatomic, getter = isExecuting)  BOOL executing;

- (void)postAccount;
- (void)callCreateAccountAPI;

- (NSDictionary *)getRequestDictionaryFromAccount;

@end

@implementation AccountCreateOperation

@dynamic completionBlock;

#pragma mark - Synthesize

@synthesize finished=_finished;
@synthesize executing=_executing;

#pragma mark - initialization

-(instancetype) initWithAccountDraft:(AAADraftAccountMO *)accountDraft withCompletionBlock:(AccountCreationCompletionBlock)completionBlock
{
    self = [super init];
    if(self) {
        self.accountDraft = accountDraft;
        self.status = AccountSyncStatusDefault;
        self.error = nil;
        self.completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - Operation override methods

-(BOOL) isConcurrent
{
    return YES;
}

-(void) cancel
{
    [super cancel];
    if (self.executing)
    {
        self.status = AccountSyncStatusFailure;
        [self finished];
    }
}

- (void)start
{
    self.status = AccountSyncStatusInProgress;
    if (self.isFinished) {
        self.status = AccountSyncStatusFailure;
        return;
    }
    
    if (self.isCancelled) {
        self.status = AccountSyncStatusFailure;
        [self finished];
        return;
    }
    
    self.executing = YES;
    [self postAccount];
}

#pragma mark - custom getter setter methods

- (void) setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
    
    //Broadcast the status
    NSDictionary *userInfo = @{@"account_id":STR_DISPLAYABLE_VALUE(self.accountDraft.draftIDAccount),
                               @"status":[NSNumber numberWithInt:self.accountDraft.status]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if(self.status == AccountSyncStatusSuccess) {
        [self deleteDraftFromCoreData];
    }
}

- (void) setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark - private methods

- (void)postAccount
{
    NSLog(@"Draft ID: %@ ; Status: %d", self.accountDraft.draftIDAccount, self.accountDraft.status);
    EGDraftStatus draftStatus = self.accountDraft.status;
    switch (draftStatus) {
        case EGDraftStatusQueuedToSync:
        {
            self.accountDraft.status = EGDraftStatusSyncing;
            //Broadcast the status
            NSDictionary *userInfo = @{@"account_id":STR_DISPLAYABLE_VALUE(self.accountDraft.draftIDAccount),
                                       @"status":[NSNumber numberWithInt:EGDraftStatusSyncing]};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
            [self callCreateAccountAPI];
        }
            break;
            
        case EGDraftStatusSyncing:
        case EGDraftStatusSyncFailed:
        case EGDraftStatusSavedAsDraft:
        case EGDraftStatusDefault:
        default:
            self.status = AccountSyncStatusFailure;
            [self finished]; //Do nothing and exit.
            return;
    }
}

- (void)callCompletionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionBlock) {
            self.completionBlock(self.accountDraft, self.status, self.error);
        }
    });
}

- (void)finished
{
    self.executing = NO;
    self.finished = YES;
    [self callCompletionBlock];
}

#pragma mark - private - core data persistence
- (void)deleteDraftFromCoreData
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.accountDraft) {
        [appDelegate.managedObjectContext deleteObject:self.accountDraft];
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

- (void)saveDraftFromCoreData
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.accountDraft) {
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

- (void)callCreateAccountAPI {
    
    AAAAccountMO *account = self.accountDraft.toAccount;
    if(nil == account || [account.accountID hasValue]) {
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] createAccount:[self getRequestDictionaryFromAccount] withShowLoading:NO andSucessAction:^(NSDictionary *contactDict) {
        NSString *accountID = [contactDict objectForKey:@"id"];
        account.accountID = accountID;
        [self saveDraftFromCoreData];
        NSLog(@"Account Created Successfully with id --- %@", accountID);
        self.status = AccountSyncStatusSuccess;
        self.accountDraft.status = EGDraftStatusSyncSuccess;
        [self finished];
        
    } andFailuerAction:^(NSError *error) {
        self.accountDraft.status = EGDraftStatusSyncFailed;
        self.status = AccountSyncStatusFailure;
        [self finished];
        NSLog(@"Failed to create account -- %@", error);
        
    }];
}

- (NSDictionary *)getRequestDictionaryFromAccount
{
    
    AAAContactMO *contact = [[self.accountDraft.toAccount.toContact allObjects] objectAtIndex:0];
    NSString *contactID = contact.contactID;
    AAAAccountMO *account = self.accountDraft.toAccount;
    
    NSDictionary *requestDictionary = nil;
    if (nil != account) {
        requestDictionary = @{
                              @"latitude" : STR_DISPLAYABLE_VALUE(account.latitude),
                              @"longitude" : STR_DISPLAYABLE_VALUE(account.longitude),
                              @"account_name": STR_DISPLAYABLE_VALUE(account.accountName),
                              @"site_name" : STR_DISPLAYABLE_VALUE(account.site),
                              @"main_phone_number" : STR_DISPLAYABLE_VALUE(account.contactNumber),
                              @"primary_contact" : @{
                                      @"contact_id" : STR_DISPLAYABLE_VALUE(contactID)
                                      },
                              @"address" : @{
                                      @"country": @"India",
                                      @"state" : @{
                                              @"code":STR_DISPLAYABLE_VALUE(account.toAddress.toState.code) ,
                                              @"name":STR_DISPLAYABLE_VALUE(account.toAddress.toState.name)
                                              },
                                      @"district" : STR_DISPLAYABLE_VALUE(account.toAddress.district),
                                      @"city" : STR_DISPLAYABLE_VALUE(account.toAddress.city),
                                      @"taluka" : STR_DISPLAYABLE_VALUE(account.toAddress.toTaluka.talukaName),
                                      @"area" : STR_DISPLAYABLE_VALUE(account.toAddress.area),
                                      @"panchayat" : STR_DISPLAYABLE_VALUE(account.toAddress.panchayat),
                                      @"pincode" : STR_DISPLAYABLE_VALUE(account.toAddress.pin),
                                      @"address_line_1" : STR_DISPLAYABLE_VALUE(account.toAddress.addressLine1),
                                      @"address_line_2" : STR_DISPLAYABLE_VALUE(account.toAddress.addressLine2)
                                      }
                              };
    }
    
    return requestDictionary;
    
}

@end
