//
//  CircularView.m
//  e-Guru
//
//  Created by Ashish Barve on 11/27/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "CircularView.h"
#import "UIColor+eGuruColorScheme.h"

@implementation CircularView

- (instancetype)init
{
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
        self.radius = self.frame.size.width / 2;
        [self customizeAppearance];
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius andColor:(UIColor *)color {
    
    self = [super init];
    if (self) {
        self.radius = radius;
        self.color = color;
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    
    if (!self.radius) {
        self.radius = 15.0f;
    }
    
    [self setLayerCornerRadius:self.radius];
    [self.layer setMasksToBounds:true];
    if (self.color) {
        [self.layer setBackgroundColor:self.color.CGColor];
    }
}

- (void)setLayerCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

@end
