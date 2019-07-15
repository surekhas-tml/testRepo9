//
//  EGMMGeography.m
//  e-Guru
//
//  Created by MI iMac04 on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGMMGeography.h"

@implementation EGMMGeography
@synthesize geographyName;
@synthesize lobName;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.geographyName = @"";
        self.lobName = @"";
    }
    return self;
}

-(_Nullable instancetype)initWithObject:(AAAMMGeographyMO * _Nullable)object{
    self = [super init];
    if (self) {
        self.lobName = object.lobName? : @"";
        self.geographyName = object.geographyName? : @"";
    }
    return self;
}

@end
