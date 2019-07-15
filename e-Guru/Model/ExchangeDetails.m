//
//  ExchangeDetails.m
//  e-guru
//
//  Created by Admin on 05/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "ExchangeDetails.h"

@implementation ExchangeDetails

@synthesize ppl_for_exchange;
@synthesize pl_for_exchange;
@synthesize registration_no;
@synthesize tml_src_chassisnumber;
@synthesize milage;
@synthesize age_of_vehicle;
@synthesize tml_ref_pl_id;
@synthesize tml_src_assset_id;
@synthesize interested_in_exchange;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ppl_for_exchange       = @"";
        self.pl_for_exchange        = @"";
        self.registration_no        = @"";
        self.tml_src_chassisnumber  = @"";
        self.milage                 = @"";
        self.age_of_vehicle         = @"";
        self.tml_ref_pl_id          = @"";
        self.tml_src_assset_id      = @"";
        self.interested_in_exchange = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAExchangeDetailsMO *_Nullable)object {
    self = [super init];
    if (self) {
        self.ppl_for_exchange       = object.ppl_for_exchange? : @"";
        self.pl_for_exchange        = object.pl_for_exchange? : @"";
        self.registration_no        = object.registration_no? : @"";
        self.tml_src_chassisnumber  = object.tml_src_chassisnumber? : @"";
        self.milage                 = object.milage? : @"";
        self.age_of_vehicle         = object.age_of_vehicle? : @"";
        self.tml_ref_pl_id          = object.tml_ref_pl_id? : @"";
        self.tml_src_assset_id      = object.tml_src_assset_id? : @"";
        self.interested_in_exchange = object.interested_in_exchange? : @"";
        
    }
    return self;
}



@end
