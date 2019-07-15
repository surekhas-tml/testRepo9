//
//  NFAFinancierDetails.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAFinancierDetails.h"

@implementation NFAFinancierDetails

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.financier = @"";
        self.ltvField = @"";
        self.finSubvn = @"";
    }
    return self;
}


@end
