//
//  AAATGMMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAATGMMO+CoreDataProperties.h"

@implementation AAATGMMO (CoreDataProperties)

+ (NSFetchRequest<AAATGMMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TGM"];
}

@dynamic accountID;
@dynamic accountName;
@dynamic mainPhoneNumber;
@dynamic toOpportunity;

@end
