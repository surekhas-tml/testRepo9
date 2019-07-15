//
//  EGCampaign.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGCampaign.h"

@implementation EGCampaign
@synthesize campaignID;
@synthesize campaignName;
@synthesize campaignDescription;
@synthesize toOpportunity;



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.campaignID = @"";
        self.campaignName = @"";
        self.campaignDescription = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAACampaignMO *)object{
    self = [super init];
    if (self) {
        self.campaignID = object.campaignID? : @"";
        self.campaignName = object.campaignName? : @"";
        self.campaignDescription = object.campaignDescription? : @"";
    }
    return self;
}


@end
