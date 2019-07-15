//
//  FinancierOptyDetails.m
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierOptyDetails.h"

@implementation FinancierOptyDetails

@synthesize organization_name;
@synthesize bu_id;
@synthesize date_of_birth;
@synthesize bdm_mobile_no;
@synthesize pan_number_company;
@synthesize ex_showroom_price;
@synthesize bdm_name;
@synthesize on_road_price_total_amt;
@synthesize customer_type;
@synthesize cust_loan_type; //new
@synthesize gender;
@synthesize financier_status;

@synthesize lob;
@synthesize ppl;
@synthesize usage;
@synthesize financierName;
@synthesize optyID;
@synthesize pl;
@synthesize optyCreatedDate;
@synthesize intendedApplication;
@synthesize productID;
@synthesize vcNumber;
@synthesize channelType;
@synthesize bodyType;
@synthesize quantity;
@synthesize organizationID;
@synthesize divID;
@synthesize sales_stage_name;
@synthesize search_status;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.organization_name       = @"";
        self.bu_id                   = @"";
        self.date_of_birth           = @"";
        self.bdm_mobile_no           = @"";
        self.pan_number_company      = @"";
        self.ex_showroom_price       = @"";
        self.bdm_name                = @"";
        self.on_road_price_total_amt = @"";
        self.customer_type           = @"";
        self.gender                  = @"";
        self.financier_status        = @"";
        
        self.lob                 = @"";
        self.cust_loan_type      = @"";
        self.ppl                 = @"";
        self.usage               = @"";
        self.financierName       = @"";
        self.optyID              = @"";
        self.pl                  = @"";
        self.optyCreatedDate     = @"";
        self.intendedApplication = @"";
        self.productID           = @"";
        self.vcNumber            = @"";
        self.channelType         = @"";
        self.bodyType            = @"";
        self.quantity            = @"";
        self.organizationID      = @"";
        self.divID               = @"";
        self.sales_stage_name    = @"";
        self.search_status       = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancierOptyDetailsMO *)object{
    self = [super init];
    if (self) {
        self.organization_name       = object.organization_name? : @"";
        self.bu_id                   = object.bu_id? : @"";
        self.date_of_birth           = object.date_of_birth? : @"";
        self.bdm_mobile_no           = object.bdm_mobile_no? : @"";
        self.pan_number_company      = object.pan_number_company? : @"";
        self.ex_showroom_price       = object.ex_showroom_price? : @"";
        self.bdm_name                = object.bdm_name? : @"";
        self.on_road_price_total_amt = object.on_road_price_total_amt? : @"";
        self.customer_type           = object.customer_type? : @"";
        self.gender                  = object.gender? : @"";
        self.financier_status        = object.financier_status? : @"";
        self.cust_loan_type          = object.cust_loan_type ? : @"";
        
        self.lob                     = object.lob? : @"";
        self.ppl                     = object.ppl? : @"";
        self.usage                   = object.usage? : @"";
        self.financierName           = object.financierName? : @"";
        self.optyID                  = object.optyID? : @"";
        self.pl                      = object.pl? : @"";
        self.optyCreatedDate         = object.optyCreatedDate? : @"";
        self.intendedApplication     = object.intendedApplication? : @"";
        self.productID               = object.productID? : @"";
        self.vcNumber                = object.vcNumber? : @"";
        self.channelType             = object.channelType? : @"";
        self.bodyType                = object.bodyType? : @"";
        self.quantity                = object.quantity? : @"";
        self.organizationID          = object.organizationID? : @"";
        self.divID                   = object.divID? : @"";
    }
    return self;
}


@end

