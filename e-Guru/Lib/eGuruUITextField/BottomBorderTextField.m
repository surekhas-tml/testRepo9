//
//  BottomBorderTextField.m
//  e-Guru
//
//  Created by MI iMac04 on 28/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "BottomBorderTextField.h"
#import "UIColor+eGuruColorScheme.h"

#define PADDING_X 0.0
#define PADDING_Y 5.0

@implementation BottomBorderTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

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
    [self addBottomBorder];
}

- (void)setLayerAndBorderProperties {
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)addBottomBorder {
    CGFloat x_coord = 0.0f;
    CGFloat y_coord = self.frame.size.height - 1;
    CGFloat width = self.frame.size.width;
    CGFloat height = 1.0f;
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(x_coord, y_coord, width, height)];
    [bottomBorder setBackgroundColor:[UIColor blackColor]];
    [self addSubview:bottomBorder];
}



#pragma mark - UITextField Overridden Methods

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

@end
