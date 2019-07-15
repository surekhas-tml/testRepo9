//
//  EGPl.m
//  e-Guru
//
//  Created by MI iMac04 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPl.h"

@implementation EGPl
@synthesize plId;
@synthesize plName;


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(instancetype)initWithObject:(NSString *)object{
    self = [super init];
    if (self) {
        self.plName = object;
    }
    return self;
}

@end
