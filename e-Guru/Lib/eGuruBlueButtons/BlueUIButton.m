//
//  eGuruBlueButton.m
//  e-Guru
//
//  Created by MI iMac04 on 16/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "BlueUIButton.h"
#import "UIColor+eGuruColorScheme.h"

#define BUTTON_BACKGROUND_COLOR     [UIColor buttonBackgroundBlueColor]
#define BUTTON_BORDER_COLOR         [UIColor buttonBorderColor].CGColor

@implementation BlueUIButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addBorderAndRoundedCorners];
        [self setButtonBacgroundAndTextColor];
        [self setInsetsForImage];
    }
    return self;
}

- (void)addBorderAndRoundedCorners {
    //self.layer.borderColor = BUTTON_BORDER_COLOR;
    self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = true;
}

- (void)setButtonBacgroundAndTextColor {
    [self setBackgroundColor:BUTTON_BACKGROUND_COLOR];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setInsetsForImage {
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(8.0f, 0, 8.0f, 5.0f)];
}

@end
