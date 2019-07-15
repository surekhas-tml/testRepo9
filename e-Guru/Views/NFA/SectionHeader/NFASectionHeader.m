//
//  NFASectionHeader.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFASectionHeader.h"
#import "UIColor+eGuruColorScheme.h"

@implementation NFASectionHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setHeaderBackgroundColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setHeaderBackgroundColor];
    }
    return self;
}

- (void)setHeaderBackgroundColor {
    [self setBackgroundColor:[UIColor themePrimaryColor]];
}

@end
