//
//  GreyBorderUITextField.m
//  e-Guru
//
//  Created by Ashish Barve on 11/15/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "GreyBorderUITextField.h"
#import "UIColor+eGuruColorScheme.h"
#import "Constant.h"

#define PADDING_X           8.0
#define PADDING_Y           5.0
#define RIGHT_VIEW_DIMEN    30.0f

@implementation GreyBorderUITextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customizeAppreance];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppreance];
    }
    return self;
}

- (void)customizeAppreance {
    [self setLayerAndBorderProperties];
    [self setFontToTextField];
}

- (void)setFontToTextField {
    [self setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
}

- (void)setLayerAndBorderProperties {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 0;
    self.layer.backgroundColor = [UIColor textFieldLayerBackgroundColor].CGColor;
}

#pragma mark - UITextField Overridden Methods

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    if ([self.rightView isKindOfClass:[UIButton class]]) {
        return CGRectMake(bounds.size.width - RIGHT_VIEW_DIMEN, (bounds.size.height / 2) - (RIGHT_VIEW_DIMEN / 2), RIGHT_VIEW_DIMEN, RIGHT_VIEW_DIMEN);
    }
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.rightView) {
        bounds.size.width = bounds.size.width - RIGHT_VIEW_DIMEN;
    }
    
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.rightView) {
        bounds.size.width = bounds.size.width - RIGHT_VIEW_DIMEN;
    }
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}


    
@end
