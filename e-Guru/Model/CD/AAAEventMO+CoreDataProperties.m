//
//  AAAEventMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAEventMO+CoreDataProperties.h"

@implementation AAAEventMO (CoreDataProperties)

+ (NSFetchRequest<AAAEventMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic eventName;
@dynamic eventID;

@end
