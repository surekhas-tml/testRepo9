//
//  AAATalukaMO+CoreDataProperties.m
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAATalukaMO+CoreDataProperties.h"

@implementation AAATalukaMO (CoreDataProperties)

+ (NSFetchRequest<AAATalukaMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Taluka"];
}

@dynamic city;
@dynamic district;
@dynamic talukaName;
@dynamic toState;

@end
