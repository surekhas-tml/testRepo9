//
//  EGPotentialDropOff.m
//  e-guru
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGPotentialDropOff.h"

@implementation EGPotentialDropOff

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.potential_drop_of_reason = @"";
        self.intervention_support = @"";
        self.stakeholder_responsible = @"";
        self.stakeholder_response = @"";
        self.app_name = @"";
    }
    return self;
}

@end
