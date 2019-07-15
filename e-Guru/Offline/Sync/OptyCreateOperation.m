//
//  OptyCreateOperation.m
//  e-Guru
//
//  Created by Rajkishan on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "OptyCreateOperation.h"
#import "EGDraftStatus.h"
#import "EGActivity.h"
#import "NSString+NSStringCategory.h"

@interface OptyCreateOperation()

@property(nonatomic) AAADraftMO*    optyDraft;
@property(nonatomic) NSError*       error;
@property(nonatomic) OptySyncStatus status;
@property(nonatomic, copy) OptyCreationCompletionBlock completionBlock;

@property (assign, readwrite, nonatomic, getter = isFinished)   BOOL finished;
@property (assign, readwrite, nonatomic, getter = isExecuting)  BOOL executing;

- (void)postOpty;
- (void)callCreateOpportunityAPI;
- (void)checkAndCallCreateAccountAPI;

- (NSDictionary *)getRequestDictionaryFromContactModel;
- (NSDictionary *)getRequestDictionaryFromAccount;

@end

@implementation OptyCreateOperation

@dynamic completionBlock;

#pragma mark - Synthesize

@synthesize finished=_finished;
@synthesize executing=_executing;

#pragma mark - initialization

-(instancetype) initWithOpportunityDraft:(AAADraftMO *)optyDraft withCompletionBlock:(OptyCreationCompletionBlock)completionBlock
{
    self = [super init];
    if(self) {
        self.optyDraft = optyDraft;
        self.status = OptySyncStatusDefault;
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
        self.status = OptySyncStatusFailure;
        [self finished];
    }
}

- (void)start
{
    self.status = OptySyncStatusInProgress;
    if (self.isFinished) {
        self.status = OptySyncStatusFailure;
        return;
    }
    
    if (self.isCancelled) {
        self.status = OptySyncStatusFailure;
        [self finished];
        return;
    }
    
    self.executing = YES;
    [self postOpty];
}

#pragma mark - custom getter setter methods

- (void) setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
	
	//Broadcast the status
	NSDictionary *userInfo = @{@"opty_id":STR_DISPLAYABLE_VALUE(self.optyDraft.draftID),
							   @"status":[NSNumber numberWithInt:self.optyDraft.status]};
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if(self.status == OptySyncStatusSuccess) {
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

- (void)postOpty
{
    NSLog(@"Draft ID: %@ ; Status: %d", self.optyDraft.draftID, self.optyDraft.status);
    EGDraftStatus draftStatus = self.optyDraft.status;
    switch (draftStatus) {
        case EGDraftStatusQueuedToSync:
            {
                self.optyDraft.status = EGDraftStatusSyncing;
                //Broadcast the status
                NSDictionary *userInfo = @{@"opty_id":STR_DISPLAYABLE_VALUE(self.optyDraft.draftID),
                                           @"status":[NSNumber numberWithInt:EGDraftStatusSyncing]};
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
                [self checkAndCallCreateContactAPI];
            }
            break;
        
        case EGDraftStatusSyncing:
        case EGDraftStatusSyncFailed:
        case EGDraftStatusSavedAsDraft:
        case EGDraftStatusDefault:
        default:
            self.status = OptySyncStatusFailure;
            [self finished]; //Do nothing and exit.
            return;
    }
}

- (void)callCompletionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionBlock) {
            self.completionBlock(self.optyDraft, self.status, self.error);
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
    if (self.optyDraft) {
        [appDelegate.managedObjectContext deleteObject:self.optyDraft];
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

- (void)saveDraftFromCoreData
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.optyDraft) {
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

#pragma mark - private - Opty post APIs related
- (void)callCreateActivityAPIForOpportunity:(NSString *)opportunityID {
    if([opportunityID hasValue]) {
        NSString *completeDateTime = [NSDate getNextDayDate:2 inFormat:dateFormatMMddyyyyHHmmss];
        NSDate *date = [NSDate getNSDateFromString:completeDateTime havingFormat:dateFormatMMddyyyyHHmmss];
        completeDateTime = [date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];
        NSString *completeDateTimeUTC = [date ToUTCStringInFormat:dateFormatyyyyMMddTHHmmssZ];
        
        EGActivity* activity = [[EGActivity alloc] init];
        self.optyDraft.toOpportunity.optyID = opportunityID;
        self.optyDraft.toOpportunity.toLastDoneActivity.status = @"Open";
        activity.status = @"Open";
        activity.activityType = @"Follow-Up";
        [activity setPlanedDate:completeDateTimeUTC];
        activity.activityDescription = @"";
        
        NSDictionary *inputDictionary = @{
                                          @"opty": @{
                                                  @"opportunity_id" : opportunityID
                                                  },
                                          @"status": @"Open",
                                          @"type": @"Follow-Up",
                                          @"start_date": [activity planedDateTimeInFormat:dateFormatMMddyyyyHHmmss],
                                          @"comments" : @"",
                                          @"contact_id" : self.optyDraft.toOpportunity.toContact.contactID
                                          };
        
        [[EGRKWebserviceRepository sharedRepository]createActivity:inputDictionary withLoadingView:NO
                                                   andSucessAction:^(id activity) {
                                                       NSLog(@"Activity Created");
                                                       self.status = OptySyncStatusSuccess;
                                                       self.optyDraft.status = EGDraftStatusSyncSuccess;
                                                       [self finished];
                                                       
                                                   } andFailuerAction:^(NSError *error) {
                                                       NSLog(@"Activity Created");
                                                       self.optyDraft.status = EGDraftStatusSyncSuccess;
                                                       self.status = OptySyncStatusSuccess;
                                                       [self finished];
                                                   }];
    }
}

- (void)checkAndCallCreateContactAPI {
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Offline_Opportunity_Sync_Started withEventCategory:GA_CL_OfflineOpportunity withEventResponseDetails:nil];

    AAAContactMO *contact = self.optyDraft.toOpportunity.toContact;
    if(nil == contact || [contact.contactID hasValue]) {
        
        //[self performSelector:@selector(checkAndCallCreateAccountAPI) withObject:self afterDelay:2.0];
        [NSThread sleepForTimeInterval:2.0];
        [self checkAndCallCreateAccountAPI];
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] createContact:[self getRequestDictionaryFromContactModel] withShowLoading:NO andSucessAction:
        ^(NSDictionary *contactDict) {
            NSString *contactId = [contactDict objectForKey:@"id"];
			NSLog(@"Contact Created Successfully with id --- %@", contactId);
            contact.contactID = contactId;
            [self saveDraftFromCoreData];
            
            //[self performSelector:@selector(checkAndCallCreateAccountAPI) withObject:self afterDelay:2.0];
            [NSThread sleepForTimeInterval:2.0];
            [self checkAndCallCreateAccountAPI];
        } andFailuerAction:^(NSError *error) {
            self.optyDraft.status = EGDraftStatusSyncFailed;
            self.status = OptySyncStatusFailure;
            [self finished];
			NSLog(@"Failed to create contact -- %@", error);
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Offline_Opportunity_Sync_Finished withEventCategory:GA_CL_OfflineOpportunity withEventResponseDetails:GA_EA_Create_Opportunity_Failed];

        }];
}

- (void)checkAndCallCreateAccountAPI
{
    AAAAccountMO *account = self.optyDraft.toOpportunity.toAccount;
    if(nil == account || [account.accountID hasValue]) {
        
        //[self performSelector:@selector(callCreateOpportunityAPI) withObject:self afterDelay:2.0];
        [NSThread sleepForTimeInterval:2.0];
        [self callCreateOpportunityAPI];
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] createAccount:[self getRequestDictionaryFromAccount] withShowLoading:NO andSucessAction:^(NSDictionary *contactDict) {
        NSString *accountID = [contactDict objectForKey:@"id"];
        account.accountID = accountID;
		[self saveDraftFromCoreData];
		NSLog(@"Account Created Successfully with id --- %@", accountID);
        
		//[self performSelector:@selector(callCreateOpportunityAPI) withObject:self afterDelay:2.0];
        [NSThread sleepForTimeInterval:2.0];
        [self callCreateOpportunityAPI];
    } andFailuerAction:^(NSError *error) {
        self.optyDraft.status = EGDraftStatusSyncFailed;
        self.status = OptySyncStatusFailure;
        [self finished];
		NSLog(@"Failed to create account -- %@", error);
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Offline_Opportunity_Sync_Finished withEventCategory:GA_CL_OfflineOpportunity withEventResponseDetails:GA_EA_Create_Opportunity_Failed];

    }];
}

- (void)callCreateOpportunityAPI {
    AAAOpportunityMO *opty = self.optyDraft.toOpportunity;
    if(nil == opty || [opty.optyID hasValue]) {
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] createOpportunity:[self getRequestDictionaryFromOpportunityModel] withShowLoading:NO
                                                  andSuccessAction:^(NSDictionary *responseDictionary) {
                                                      NSString *optyID = [responseDictionary objectForKey:@"id"];
													  
													  NSLog(@"Opty Created Successfully with id --- %@", optyID);
													  
                                                      opty.optyID = optyID;
                                                      self.optyDraft.status = EGDraftStatusSyncSuccess;
                                                      [self saveDraftFromCoreData];
                                                      [self callCreateActivityAPIForOpportunity:optyID];
                                                      
                                                      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Offline_Opportunity_Sync_Finished withEventCategory:GA_CL_OfflineOpportunity withEventResponseDetails:GA_EA_Create_Opportunity_Successful];

                                                  }
                                                  andFailuerAction:^(NSError *error) {
                                                      self.optyDraft.status = EGDraftStatusSyncFailed;
                                                      self.status = OptySyncStatusFailure;
                                                      [self finished];
													  NSLog(@"Failed to create opportunity -- %@", error);
                                                      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Offline_Opportunity_Sync_Finished withEventCategory:GA_CL_OfflineOpportunity withEventResponseDetails:GA_EA_Create_Opportunity_Failed];

                                                  }];
}

#pragma mark - API request body formation methods

- (NSDictionary *)getRequestDictionaryFromContactModel {
    AAAContactMO *contact = self.optyDraft.toOpportunity.toContact;
    
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

- (NSDictionary *)getRequestDictionaryFromAccount
{

    AAAContactMO *contact = self.optyDraft.toOpportunity.toContact;
    NSString *contactID = contact.contactID;
    AAAAccountMO *account = self.optyDraft.toOpportunity.toAccount;
    
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

- (NSDictionary *)getRequestDictionaryFromOpportunityModel {
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] opportunityMapping] inverseMapping]
                                                                                   objectClass:[EGOpportunity class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    EGOpportunity *opportunity = [[EGOpportunity alloc] initWithObject:self.optyDraft.toOpportunity];
    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:opportunity requestDescriptor:requestDescriptor error:nil];
    
    
    [parametersDictionary setValue:self.optyDraft.toOpportunity.latitude forKey:@"latitude"];
    [parametersDictionary setValue:self.optyDraft.toOpportunity.longitude forKey:@"longitude"];
    
    return parametersDictionary;
}

@end
