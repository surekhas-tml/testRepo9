//
//  EGTaluka.m
//  e-Guru
//
//  Created by local admin on 11/28/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPin.h"

@implementation EGPin
@synthesize pincode;

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
        self.pincode = object;
    }
    return self;
}

@end
