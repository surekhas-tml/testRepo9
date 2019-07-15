//
//  EGState.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGState.h"

@implementation EGState

@synthesize code;
@synthesize name;

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithObject:(AAAStateMO *)state
{
    self = [super init];
    if (self) {
        self.code = state.code? : @"";
        self.name = state.name? : @"";
    }
    return self;
}

@end
