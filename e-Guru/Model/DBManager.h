//
//  DBManager.h
//  e-Guru
//
//  Created by admin on 29/11/16.
//  Copyright Â© 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface DBManager : NSObject{
    
}

+ (DBManager *)sharedobject;

- (void)saveContactDraft;

- (NSArray *)fetchAllDataFromFraft;

- (void)deleteDataFromDraftWithDraftID:(AAADraftMO *)draftObj;

- (void)saveAccountDraft;

- (void)saveOptyDraft;

- (void)updateDraftWithDraftID:(AAADraftMO *)draftObj;

@end
