//
//  AAADraftContactMO+CoreDataProperties.m
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAADraftContactMO+CoreDataProperties.h"

@implementation AAADraftContactMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftContactMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DraftContact"];
}

@dynamic draftIDContact;
@dynamic userIDLink;
@dynamic status;
@dynamic toContact;

@end
