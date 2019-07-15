//
//  EGPpl.m
//  e-Guru
//
//  Created by MI iMac04 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPpl.h"

@implementation EGPpl
@synthesize pplId;
@synthesize pplName;

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
        self.pplName = object;
    }
    return self;
}
@end
