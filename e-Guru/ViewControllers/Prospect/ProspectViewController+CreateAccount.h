//
//  ProspectViewController+CreateAccount.h
//  e-Guru
//
//  Created by Juili on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ProspectViewController.h"
#import "AAAAccountMO+CoreDataClass.h"
#import "AAAStateMO+CoreDataClass.h"
#import "AAATalukaMO+CoreDataClass.h"
#import "EGDraftStatus.h"

@interface ProspectViewController (CreateAccount)
- (void)saveAccountdraft:(EGDraftStatus) draftStatus;
- (void)updateAccountDraft:(EGDraftStatus) draftStatus;

@end
 
