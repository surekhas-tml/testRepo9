//
//  EGTaluka.m
//  e-Guru
//
//  Created by local admin on 11/28/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGTaluka.h"

@implementation EGTaluka
@synthesize state;
@synthesize district;
@synthesize city;
@synthesize talukaName;



- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(instancetype)initWithObject:(AAATalukaMO *)object{
    self = [super init];
    if (self) {
        self.state = [[EGState alloc]initWithObject:object.toState];
        self.district = object.district? : @"";
        self.city = object.city? : @"";
        self.talukaName = object.talukaName? : @"";
    }
    return self;
}
@end
