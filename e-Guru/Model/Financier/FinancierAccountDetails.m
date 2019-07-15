//
//  FinancierAccountDetails.m
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierAccountDetails.h"

@implementation FinancierAccountDetails

@synthesize account_id;
@synthesize pan_number_company;
@synthesize accountAddress1;
@synthesize accountAddress2;
@synthesize accountState;
@synthesize account_taluka;
@synthesize accountDistrict;
@synthesize accountPinCode;
@synthesize accountNumber;
@synthesize accountName;
@synthesize accountSite;
@synthesize accountType;
@synthesize accountCityTownVillage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.account_id             = @"";
        self.pan_number_company     = @"";
        self.accountAddress1        = @"";
        self.accountAddress2        = @"";
        self.accountState           = @"";
        self.account_taluka         = @"";
        self.accountDistrict        = @"";
        self.accountPinCode         = @"";
        self.accountNumber          = @"";
        self.accountName            = @"";
        self.accountSite            = @"";
        self.accountType            = @"";
        self.accountCityTownVillage = @"";
        
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancierAccountDetailMO * _Nullable)object{
    self = [super init];
    if (self) {
        self.account_id             = object.account_id ?        : @"";
        self.pan_number_company     = object.pan_number_company ?        : @"";
        self.accountAddress1        = object.accountAddress1 ?        : @"";
        self.accountAddress2        = object.accountAddress2 ?        : @"";
        self.accountState           = object.accountState ?           : @"";
        self.account_taluka         = object.account_taluka ?         : @"";
        self.accountDistrict        = object.accountDistrict ?        : @"";
        self.accountPinCode         = object.accountPinCode ?         : @"";
        self.accountNumber          = object.accountNumber ?          : @"";
        self.accountName            = object.accountName ?            : @"";
        self.accountSite            = object.accountSite ?            : @"";
        self.accountType            = object.accountType ?            : @"";
        self.accountCityTownVillage = object.accountCityTownVillage ? : @"";
    }
    return self;
}

@end


