//
//  EGTGM.m
//  e-Guru
//
//  Created by MI iMac04 on 05/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGTGM.h"

@implementation EGTGM
@synthesize accountID;
@synthesize accountName;
@synthesize mainPhoneNumber;



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accountID = @"";
        self.accountName = @"";
        self.mainPhoneNumber = @"";
    }
    return self;
}

-(_Nullable instancetype)initWithObject:(AAATGMMO *_Nullable)object{
    self = [super init];
    if (self) {
        self.accountID = object.accountID? : @"";
        self.accountName = object.accountName? : @"";
        self.mainPhoneNumber = object.mainPhoneNumber? : @"";
    }
    return self;
}


@end
