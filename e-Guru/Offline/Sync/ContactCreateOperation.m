//
//  ContactCreateOperation.m
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ContactCreateOperation.h"
#import "NSString+NSStringCategory.h"
#import "Constant.h"
#import "EGDraftStatus.h"
#import "AppDelegate.h"

@interface ContactCreateOperation()

@property(nonatomic) AAADraftContactMO*    contactDraft;
@property(nonatomic) NSError*       error;
@property(nonatomic) ContactSyncStatus status;
@property(nonatomic, copy) ContactCreationCompletionBlock completionBlock;

@property (assign, readwrite, nonatomic, getter = isFinished)   BOOL finished;
@property (assign, readwrite, nonatomic, getter = isExecuting)  BOOL executing;

- (void)postContact;
- (void)callCreateContactAPI;

- (NSDictionary *)getRequestDictionaryFromContact;

@end

@implementation ContactCreateOperation

@dynamic completionBlock;

#pragma mark - Synthesize

@synthesize finished=_finished;
@synthesize executing=_executing;

#pragma mark - initialization

-(instancetype) initWithContactDraft:(AAADraftContactMO *)contactDraft withCompletionBlock:(ContactCreationCompletionBlock)completionBlock
{
    self = [super init];
    if(self) {
        self.contactDraft = contactDraft;
        self.status = ContactSyncStatusDefault;
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
        self.status = ContactSyncStatusFailure;
        [self finished];
    }
}

- (void)start
{
    self.status = ContactSyncStatusInProgress;
    if (self.isFinished) {
        self.status = ContactSyncStatusFailure;
        return;
    }
    
    if (self.isCancelled) {
        self.status = ContactSyncStatusFailure;
        [self finished];
        return;
    }
    
    self.executing = YES;
    [self postContact];
}

#pragma mark - custom getter setter methods

- (void) setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
    
    //Broadcast the status
    NSDictionary *userInfo = @{@"contact_id":STR_DISPLAYABLE_VALUE(self.contactDraft.draftIDContact),
                               @"status":[NSNumber numberWithInt:self.contactDraft.status]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if(self.status == ContactSyncStatusSuccess) {
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

- (void)postContact
{
    NSLog(@"Draft ID: %@ ; Status: %d", self.contactDraft.draftIDContact, self.contactDraft.status);
    EGDraftStatus draftStatus = self.contactDraft.status;
    switch (draftStatus) {
        case EGDraftStatusQueuedToSync:
        {
            self.contactDraft.status = EGDraftStatusSyncing;
            //Broadcast the status
            NSDictionary *userInfo = @{@"contact_id":STR_DISPLAYABLE_VALUE(self.contactDraft.draftIDContact),
                                       @"status":[NSNumber numberWithInt:EGDraftStatusSyncing]};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
            [self callCreateContactAPI];
        }
            break;
            
        case EGDraftStatusSyncing:
        case EGDraftStatusSyncFailed:
        case EGDraftStatusSavedAsDraft:
        case EGDraftStatusDefault:
        default:
            self.status = ContactSyncStatusFailure;
            [self finished]; //Do nothing and exit.
            return;
    }
}

- (void)callCompletionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionBlock) {
            self.completionBlock(self.contactDraft, self.status, self.error);
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
    if (self.contactDraft) {
        [appDelegate.managedObjectContext deleteObject:self.contactDraft];
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

- (void)saveDraftFromCoreData
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.contactDraft) {
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

- (void)callCreateContactAPI {
    
    AAAContactMO *contact = self.contactDraft.toContact;
    if(nil == contact || [contact.contactID hasValue]) {
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] createContact:[self getRequestDictionaryFromContact] withShowLoading:NO andSucessAction:^(NSDictionary *contactDict) {
        NSString *contactID = [contactDict objectForKey:@"id"];
        contact.contactID = contactID;
        [self saveDraftFromCoreData];
        NSLog(@"Contact Created Successfully with id --- %@", contactID);
        self.status = ContactSyncStatusSuccess;
        self.contactDraft.status = EGDraftStatusSyncSuccess;
        [self finished];
        
    } andFailuerAction:^(NSError *error) {
        self.contactDraft.status = EGDraftStatusSyncFailed;
        self.status = ContactSyncStatusFailure;
        [self finished];
        NSLog(@"Failed to create contact -- %@", error);
        
    }];
}

- (NSDictionary *)getRequestDictionaryFromContact
{
    AAAContactMO *contact = self.contactDraft.toContact;
    
    return @{
             @"latitude" : STR_DISPLAYABLE_VALUE(contact.latitude),
             @"longitude" : STR_DISPLAYABLE_VALUE(contact.longitude),
             @"first_name": STR_DISPLAYABLE_VALUE(contact.firstName),
             @"last_name" : STR_DISPLAYABLE_VALUE(contact.lastName),
             @"mobile_number" : STR_DISPLAYABLE_VALUE(contact.contactNumber),
             @"email" : STR_DISPLAYABLE_VALUE(contact.emailID),
             @"pan" : STR_DISPLAYABLE_VALUE(contact.panNumber),
             @"address" : @{
                     @"state" : @{
                             @"code":STR_DISPLAYABLE_VALUE(contact.toAddress.toState.code),
                             @"name":STR_DISPLAYABLE_VALUE(contact.toAddress.toState.name)
                             },
                     @"district" : STR_DISPLAYABLE_VALUE(contact.toAddress.district),
                     @"city" : STR_DISPLAYABLE_VALUE(contact.toAddress.city),
                     @"taluka" : STR_DISPLAYABLE_VALUE(contact.toAddress.toTaluka.talukaName),
                     @"area" : STR_DISPLAYABLE_VALUE(contact.toAddress.area),
                     @"tehsil" : STR_DISPLAYABLE_VALUE(contact.toAddress.toTaluka.talukaName),
                     @"pincode" : STR_DISPLAYABLE_VALUE(contact.toAddress.pin ),
                     @"panchayat" : STR_DISPLAYABLE_VALUE(contact.toAddress.panchayat ),
                     @"address_line_1" : STR_DISPLAYABLE_VALUE(contact.toAddress.addressLine1),
                     @"address_line_2" : STR_DISPLAYABLE_VALUE(contact.toAddress.addressLine2)
                     }
             };
}

@end
