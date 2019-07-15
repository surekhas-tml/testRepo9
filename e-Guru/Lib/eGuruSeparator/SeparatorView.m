//
//  SeparatorView.m
//  e-Guru
//
//  Created by Ashish Barve on 11/15/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SeparatorView.h"
#import "UIColor+eGuruColorScheme.h"

@implementation SeparatorView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    self.backgroundColor = [UIColor separatorColor];
}

@end
