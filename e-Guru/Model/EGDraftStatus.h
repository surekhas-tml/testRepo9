//
//  DraftStatus.h
//  e-Guru
//
//  Created by Rajkishan on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EGDraftStatus) {
    EGDraftStatusDefault,
    EGDraftStatusSavedAsDraft,
    EGDraftStatusQueuedToSync,
    EGDraftStatusSyncing,
    EGDraftStatusSyncFailed,
    EGDraftStatusSyncSuccess
};
