//
//  NFARequestModel.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFARequestModel.h"

@implementation NFARequestModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.netSupportPerVehicle = @"";
        self.totalSupportSought = @"";
    }
    return self;
}

@end
