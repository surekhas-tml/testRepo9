//
//  OptyCreateOperation.h
//  e-Guru
//
//  Created by Rajkishan on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOpportunity.h"
#import "AAADraftMO+CoreDataClass.h"
#import "NSDate+eGuruDate.h"

typedef NS_ENUM(NSInteger, OptySyncStatus) {
    OptySyncStatusDefault,
    OptySyncStatusInProgress,
    OptySyncStatusSuccess,
    OptySyncStatusFailure
};

typedef void(^OptyCreationCompletionBlock) (AAADraftMO *, OptySyncStatus, NSError*);

/*
 *  Operation creates opty through the passed opportunity model.
 *  Operation to remain in run status until the API is complete.
 *  Success/failure callbacks provided.
 */
@interface OptyCreateOperation : NSOperation

-(instancetype) initWithOpportunityDraft:(AAADraftMO *)optyDraft withCompletionBlock:(OptyCreationCompletionBlock)completionBlock;

@end
