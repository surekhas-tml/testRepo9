//
//  NFAHigherAuthority.m
//  e-guru
//
//  Created by Ashish Barve on 3/22/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAUserPositionModel.h"

@implementation NFAUserPositionModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _dealerCode = @"";
        _dealerName = @"";
        _positionID = @"";
        _positionName = @"";
        _dealerRegion = @"";
        _dealerState = @"";
        _lobName = @"";
    }
    
    return self;
}

@end
