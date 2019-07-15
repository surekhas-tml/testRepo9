//
//  AAACampaignMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAACampaignMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAACampaignMO (CoreDataProperties)

+ (NSFetchRequest<AAACampaignMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *campaignDescription;
@property (nullable, nonatomic, copy) NSString *campaignID;
@property (nullable, nonatomic, copy) NSString *campaignName;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
