//
//  AAAContactMO+CoreDataProperties.m
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAContactMO+CoreDataProperties.h"

@implementation AAAContactMO (CoreDataProperties)

+ (NSFetchRequest<AAAContactMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
}

@dynamic contactID;
@dynamic contactNumber;
@dynamic emailID;
@dynamic firstName;
@dynamic fullName;
@dynamic lastName;
@dynamic panNumber;
@dynamic primary_account_id;
@dynamic latitude;
@dynamic longitude;
@dynamic toAccount;
@dynamic toAddress;
@dynamic toOpportunity;

@end
