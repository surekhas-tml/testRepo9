//
//  AAAActivityMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAActivityMO+CoreDataProperties.h"

@implementation AAAActivityMO (CoreDataProperties)

+ (NSFetchRequest<AAAActivityMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Activity"];
}

@dynamic activityDescription;
@dynamic activityID;
@dynamic activityType;
@dynamic creationDate;
@dynamic creationTime;
@dynamic endDate;
@dynamic endTime;
@dynamic planedDate;
@dynamic planedTime;
@dynamic status;
@dynamic taluka;
@dynamic toOpportunity;

@end
