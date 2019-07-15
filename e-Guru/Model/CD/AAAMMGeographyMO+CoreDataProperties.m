//
//  AAAMMGeographyMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAMMGeographyMO+CoreDataProperties.h"

@implementation AAAMMGeographyMO (CoreDataProperties)

+ (NSFetchRequest<AAAMMGeographyMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MMGeography"];
}

@dynamic lobName;
@dynamic geographyName;
@dynamic toOpportunity;

@end
