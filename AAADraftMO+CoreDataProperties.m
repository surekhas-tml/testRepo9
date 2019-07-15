//
//  AAADraftMO+CoreDataProperties.m
//  e-guru
//
//  Created by Ganesh Patro on 26/12/16.
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
