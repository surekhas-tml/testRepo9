//
//  EGFinancier.m
//  e-Guru
//
//  Created by MI iMac04 on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGFinancier.h"

@implementation EGFinancier
@synthesize financierID;
@synthesize financierName;



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.financierID = @"";
        self.financierName = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancerMO *_Nullable)object{
    self = [super init];
    if (self) {
        self.financierID = object.financierID? : @"";
        self.financierName = object.financierName? : @"";
    }
    return self;
}

@end
