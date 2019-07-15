//
//  NFATypeDetails.m
//  e-guru
//
//  Created by Ashish Barve on 3/22/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFATypeDetailsModel.h"
#import "NSDate+eGuruDate.h"

@implementation NFATypeDetailsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nfaRequestDate = [NSDate getCurrentDateInFormat:dateFormatddMMyyyy];
        _spendCategory = @"Retail Related";
        _categorySubType = @"Additional Support - Retail";
        _spend = @"Additional Support - NFA";
    }
    return self;
}

@end
