//
//  ReferralCustomer.m
//  e-Guru
//
//  Created by Ashish Barve on 12/4/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGReferralCustomer.h"

@implementation EGReferralCustomer
@synthesize firstName;
@synthesize lastName;
@synthesize rowID;
@synthesize cellPhoneNumber;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstName = @"";
        self.lastName = @"";
        self.rowID = @"";
        self.cellPhoneNumber = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAReferralCustomerMO *_Nullable)object{
    self = [super init];
    if (self) {
        self.firstName = object.refferalFirstName? : @"";
        self.lastName = object.refferalLastName? : @"";
        self.rowID = object.refferalrowID? : @"";
        self.cellPhoneNumber = object.refferalCellPhoneNumber? : @"";

    }
    return self;
}

@end
