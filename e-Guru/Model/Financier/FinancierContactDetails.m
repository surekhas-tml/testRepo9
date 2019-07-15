//
//  FinancierContactDetails.m
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierContactDetails.h"

@implementation FinancierContactDetails

@synthesize taluka;
@synthesize contact_id;
@synthesize date_of_birth;
@synthesize gender;

@synthesize pan_number_individual;
@synthesize address2;
@synthesize address1;
@synthesize occupation;
@synthesize state;
@synthesize firstName;
@synthesize lastName;
@synthesize district;
@synthesize area;
@synthesize title;
@synthesize pincode;
@synthesize mobileno;
@synthesize citytownvillage;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.relationship_type = @"";
        self.taluka = @"";
        self.contact_id= @"";
        self.date_of_birth = @"";
        self.gender = @"";
        
        self.pan_number_individual = @"";
        self.address2       = @"";
        self.address1        = @"";
        self.occupation        = @"";
        
        self.state           = @"";
        self.firstName       = @"";
        self.lastName        = @"";
        self.district        = @"";
        self.area            = @"";
        self.title           = @"";
        self.pincode         = @"";
        self.mobileno        = @"";
        self.citytownvillage = @"";
    }
    return self;
}


-(instancetype)initWithObject:(AAAFinancierContactMO *)object{
    self = [super init];
    if (self) {
        self.relationship_type = object.relationship_type ? : @"";
        self.taluka = object.pan_number_individual? : @"";
        self.contact_id= object.pan_number_individual? : @"";
        self.date_of_birth = object.pan_number_individual? : @"";
        self.gender = object.pan_number_individual? : @"";
        
        self.pan_number_individual  = object.pan_number_individual? : @"";
        self.address2               = object.address2? : @"";
        self.address1               = object.address1? : @"";
        self.occupation             = object.occupation? : @"";
        
        self.state           = object.state? : @"";
        self.firstName       = object.firstName? : @"";
        self.lastName        = object.lastName? : @"";
        self.district        = object.district? : @"";
        self.area            = object.area? : @"";
        self.title           = object.title? : @"";
        self.pincode         = object.pincode? : @"";
        self.mobileno        = object.mobileno? : @"";
        self.citytownvillage = object.citytownvillage? : @"";
        
    }
    return self;
}


@end
