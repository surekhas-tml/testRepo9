//
//  ProspectViewController+CreateContact.h
//  e-Guru
//
//  Created by Juili on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ProspectViewController.h"
#import "UtilityMethods.h"
#import "EGDraftStatus.h"

@import Contacts;

@interface ProspectViewController (CreateContact)

- (void)saveContact:(EGDraftStatus) draftStatus;
- (void)updateContact:(EGDraftStatus) draftStatus;

@end
