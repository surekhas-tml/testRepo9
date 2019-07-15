//
//  AAABrokerMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAABrokerMO+CoreDataProperties.h"

@implementation AAABrokerMO (CoreDataProperties)

+ (NSFetchRequest<AAABrokerMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Broker"];
}

@dynamic accountID;
@dynamic mainPhoneNumber;
@dynamic accountName;
@dynamic toOpportunity;

@end
