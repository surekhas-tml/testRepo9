//
//  AAAStateMO+CoreDataProperties.m
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAStateMO+CoreDataProperties.h"

@implementation AAAStateMO (CoreDataProperties)

+ (NSFetchRequest<AAAStateMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"State"];
}

@dynamic code;
@dynamic name;
@dynamic toAddress;

@end
