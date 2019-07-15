//
//  NFACompetitionDetails.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFACompetitionDetails.h"

@implementation NFACompetitionDetails

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.competitor = @"";
        self.model = @"";
        self.exShowroom = @"";
        self.discount = @"";
        self.landingPrice = @"";
    }
    return self;
}

@end
