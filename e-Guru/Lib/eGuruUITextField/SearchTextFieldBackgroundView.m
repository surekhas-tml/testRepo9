//
//  SearchTextFieldBackgroundView.m
//  e-Guru
//
//  Created by Ashish Barve on 11/26/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchTextFieldBackgroundView.h"
#import "UIColor+eGuruColorScheme.h"

@implementation SearchTextFieldBackgroundView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor searchTextFieldBackgroundViewBorderColor].CGColor;
    [self setBackgroundColor:[UIColor searchTextFieldBackgroundViewColor]];
}

@end
