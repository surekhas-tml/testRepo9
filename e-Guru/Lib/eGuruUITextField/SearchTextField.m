//
//  SearchTextField.m
//  e-Guru
//
//  Created by MI iMac04 on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchTextField.h"
#import "UIColor+eGuruColorScheme.h"

#define PADDING_X 8.0
#define PADDING_Y 5.0

@implementation SearchTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    [self setLayerAndBorderProperties];
    [self setFontToTextField];
    [self addSearchIcon];
}

- (void)setLayerAndBorderProperties {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 0;
    self.backgroundColor = [UIColor textFieldLayerBackgroundColor];
}

- (void)addSearchIcon {
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grey_search_icon"]];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = searchIcon;
}

- (void)setFontToTextField {
    [self setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
}

#pragma mark - UITextField Overridden Methods

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.size.width - 25, (bounds.size.height / 2) - 10, 20, 20);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

@end
