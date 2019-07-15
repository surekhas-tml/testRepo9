//
//  EGCustomerDetailModel.m
//  e-guru
//
//  Created by Apple on 08/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGCustomerDetailModel.h"

@implementation EGCustomerDetailModel

- (id)init{
    if(self == [super init]){
        self.name = @"";
        self.accountName = @"";
        self.contactNumber = @"";
        self.lob = @"";
        self.application = @"";
        self.status = @"";
        self.customer_id = @"";
    }
    return self;
}
@end

