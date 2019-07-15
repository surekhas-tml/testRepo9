//
//  AAAFinancierContactMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierContactMO+CoreDataProperties.h"

@implementation AAAFinancierContactMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierContactMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierContact"];
}

@dynamic relationship_type;
@dynamic taluka;
@dynamic contact_id;
@dynamic date_of_birth;
@dynamic gender;

@dynamic pan_number_individual;
@dynamic address2;
@dynamic address1;
@dynamic occupation;

@dynamic state;
@dynamic firstName;
@dynamic district;
@dynamic lastName;
@dynamic area;
@dynamic title;
@dynamic pincode;
@dynamic mobileno;
@dynamic citytownvillage;

@dynamic toOpportunity;

@end
