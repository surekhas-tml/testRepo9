//
//  ContactCreateOperation.h
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAADraftContactMO+CoreDataClass.h"

typedef NS_ENUM(NSInteger, ContactSyncStatus) {
    ContactSyncStatusDefault,
    ContactSyncStatusInProgress,
    ContactSyncStatusSuccess,
    ContactSyncStatusFailure
};

typedef void(^ContactCreationCompletionBlock) (AAADraftContactMO *, ContactSyncStatus, NSError*);

@interface ContactCreateOperation : NSOperation

/*
 *  Operation creates contact through the passed contact model.
 *  Operation to remain in run status until the API is complete.
 *  Success/failure callbacks provided.
 */
-(instancetype) initWithContactDraft:(AAADraftContactMO *)contactDraft withCompletionBlock:(ContactCreationCompletionBlock)completionBlock;

@end
