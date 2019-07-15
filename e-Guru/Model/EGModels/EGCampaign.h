//
//  EGCampaign.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAACampaignMO+CoreDataClass.h"
@class EGOpportunity;
@interface EGCampaign : NSObject

@property (nullable, nonatomic, copy) NSString *campaignID;
@property (nullable, nonatomic, copy) NSString *campaignName;
@property (nullable, nonatomic, copy) NSString *campaignDescription;
@property (nullable, nonatomic, retain) EGOpportunity *toOpportunity;

-(_Nullable instancetype)initWithObject:(AAACampaignMO * _Nullable)object;

@end
