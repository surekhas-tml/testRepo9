//
//  NFANextAuthorityModel.m
//  e-guru
//
//  Created by MI iMac04 on 24/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFANextAuthorityModel.h"

@implementation NFANextAuthorityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextAuthorityPosition = [NSString string];
        _nextAuthorityEmaiID = [NSString string];
        _nextAuthorityFirstName = [NSString string];
        _nextAuthorityLastName = [NSString string];
        _nextAuthority = [NSString string];
    }
    
    return self;
}

@end
