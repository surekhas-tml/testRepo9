//
//  BorderedView.m
//  e-guru
//
//  Created by Ashish Barve on 9/25/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "BorderedView.h"

@implementation BorderedView

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

@end
