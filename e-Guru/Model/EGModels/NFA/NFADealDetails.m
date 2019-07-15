//
//  NFADealDetails.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFADealDetails.h"

@implementation NFADealDetails

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.lob = @"";
        self.ppl = @"";
        self.model = @"";
        self.dealSize = @"";
        self.billing = @"";
        self.vc = @"";
        self.productDescription = @"";
    }
    return self;
}


@end
