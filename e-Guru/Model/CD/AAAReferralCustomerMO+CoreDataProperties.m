//
//  AAAReferralCustomerMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAReferralCustomerMO+CoreDataProperties.h"

@implementation AAAReferralCustomerMO (CoreDataProperties)

+ (NSFetchRequest<AAAReferralCustomerMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ReferralCustomer"];
}

@dynamic refferalCellPhoneNumber;
@dynamic refferalFirstName;
@dynamic refferalLastName;
@dynamic refferalrowID;
@dynamic toOpportunity;

@end
