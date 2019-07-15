//
//  AAACampaignMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAACampaignMO+CoreDataProperties.h"

@implementation AAACampaignMO (CoreDataProperties)

+ (NSFetchRequest<AAACampaignMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Campaign"];
}

@dynamic campaignDescription;
@dynamic campaignID;
@dynamic campaignName;
@dynamic toOpportunity;

@end
