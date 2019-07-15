//
//  AccountCreateOperation.h
//  e-guru
//
//  Created by MI iMac04 on 30/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAADraftAccountMO+CoreDataClass.h"


typedef NS_ENUM(NSInteger, AccountSyncStatus) {
    AccountSyncStatusDefault,
    AccountSyncStatusInProgress,
    AccountSyncStatusSuccess,
    AccountSyncStatusFailure
};

typedef void(^AccountCreationCompletionBlock) (AAADraftAccountMO *, AccountSyncStatus, NSError*);

@interface AccountCreateOperation : NSOperation


/*
 *  Operation creates account through the passed account model.
 *  Operation to remain in run status until the API is complete.
 *  Success/failure callbacks provided.
 */
-(instancetype) initWithAccountDraft:(AAADraftAccountMO *)accountDraft withCompletionBlock:(AccountCreationCompletionBlock)completionBlock;

@end
