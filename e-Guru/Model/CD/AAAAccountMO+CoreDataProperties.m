//
//  AAAAccountMO+CoreDataProperties.m
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAAccountMO+CoreDataProperties.h"

@implementation AAAAccountMO (CoreDataProperties)

+ (NSFetchRequest<AAAAccountMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Account"];
}

@dynamic accountID;
@dynamic accountName;
@dynamic accountPAN;
@dynamic accountType;
@dynamic contactNumber;
@dynamic site;
@dynamic latitude;
@dynamic longitude;
@dynamic toAddress;
@dynamic toContact;
@dynamic toOpportunity;

@end
