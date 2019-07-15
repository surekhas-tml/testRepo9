//
//  AAADraftMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/27/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAADraftMO+CoreDataProperties.h"

@implementation AAADraftMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Draft"];
}

@dynamic draftID;
@dynamic status;
@dynamic userIDLink;
@dynamic toOpportunity;

@end
