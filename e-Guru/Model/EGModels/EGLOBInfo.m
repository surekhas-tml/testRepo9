//
//  EGLOBInfo.m
//  e-guru
//
//  Created by MI iMac04 on 19/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGLOBInfo.h"

@implementation EGLOBInfo

@synthesize customerType;
@synthesize vehicleApplication;
@synthesize bodyType;
@synthesize mmGeography;
@synthesize tmlFleetSize;
@synthesize totalFleetSize;
@synthesize usageCategory;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.customerType = @"";
        self.vehicleApplication = @"";
        self.bodyType = @"";
        self.mmGeography = @"";
        self.tmlFleetSize = @"";
        self.totalFleetSize = @"";
        self.usageCategory = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAALobInformation *)object {
    self = [super init];
    if (self) {
        self.customerType = object.customerType? : @"";
        self.vehicleApplication = object.vehicleApplication? : @"";
        self.bodyType = object.bodyType? : @"";
        self.mmGeography = object.mmGeography? : @"";
        self.tmlFleetSize = object.tmlFleetSize? : @"";
        self.totalFleetSize = object.totalFleetSize? : @"";
        self.usageCategory = object.usageCategory? : @"";
    }
    return self;
}

@end
