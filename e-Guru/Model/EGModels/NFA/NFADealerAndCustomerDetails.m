//
//  NFADealerAndCustomerDetails.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFADealerAndCustomerDetails.h"

@implementation NFADealerAndCustomerDetails

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.oppotunityID = @"";
        self.dealerCode = @"";
        self.dealerName = @"";
        self.accountName = @"";
        self.location = @"";
        self.mmIntendedApplication = @"";
        self.tmlFleetSize = @"";
        self.overAllFleetSize = @"";
        self.dealType = @"";
        self.customerName = @"";
        self.additionalCustomers = @"";
        self.customerComments = @"";
        self.vehicleRegistrationState = @"";
        self.customerNumber = @"";
        self.remark = @"";
    }
    return self;
}

@end
