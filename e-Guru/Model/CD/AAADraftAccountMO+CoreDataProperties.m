//
//  AAADraftAccountMO+CoreDataProperties.m
//  e-guru
//
//  Created by MI iMac04 on 31/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAADraftAccountMO+CoreDataProperties.h"

@implementation AAADraftAccountMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftAccountMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DraftAccount"];
}

@dynamic draftIDAccount;
@dynamic userIDLink;
@dynamic status;
@dynamic toAccount;

@end
