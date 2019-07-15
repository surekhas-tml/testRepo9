//
//  EGAddress.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGAddress.h"

@implementation EGAddress
@synthesize addressID;
@synthesize addressLine1;
@synthesize addressLine2;
@synthesize city;
@synthesize district;
@synthesize pin;
@synthesize state;
@synthesize taluka;
@synthesize toAccount;
@synthesize toContact;
@synthesize panchayat;
@synthesize area;

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithObject:(AAAAddressMO *)address
{
    self = [super init];
    if (self) {
        self.addressID = address.addressID? : @"";
        self.addressLine1 = address.addressLine1? : @"";
        self.addressLine2 = address.addressLine2? : @"";
        self.city = address.city? : @"";
        self.district = address.district? : @"";
        self.pin = address.pin? : @"";
        self.state = [[EGState alloc]initWithObject:address.toState];
        self.taluka = [[EGTaluka alloc]initWithObject:address.toTaluka];
        self.panchayat = address.panchayat? : @"";
        self.area = address.area? : @"";
    }
    return self;
}

//+ (EGAddress *)parseFromDictionary:(NSDictionary *)dictAddress {
//	NSDictionary *state = dictPayload[@"state"];
//	EGState *state = [EGState new];
//	state.name =
//}
@end
