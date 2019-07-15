//
//  AAAAddressMO+CoreDataProperties.m
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAAddressMO+CoreDataProperties.h"

@implementation AAAAddressMO (CoreDataProperties)

+ (NSFetchRequest<AAAAddressMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Address"];
}

@dynamic addressID;
@dynamic addressLine1;
@dynamic addressLine2;
@dynamic area;
@dynamic city;
@dynamic district;
@dynamic panchayat;
@dynamic pin;
@dynamic toAccount;
@dynamic toContact;
@dynamic toState;
@dynamic toTaluka;

@end
