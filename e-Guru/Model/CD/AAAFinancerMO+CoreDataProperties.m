//
//  AAAFinancerMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAFinancerMO+CoreDataProperties.h"

@implementation AAAFinancerMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancerMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Financier"];
}

@dynamic financierID;
@dynamic financierName;
@dynamic toOpportunity;

@end
