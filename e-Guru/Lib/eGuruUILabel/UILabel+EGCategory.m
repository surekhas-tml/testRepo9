//
//  UILabel+EGCategory.m
//  e-Guru
//
//  Created by Rajkishan on 18/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UILabel+EGCategory.h"
#import "NSString+NSStringCategory.h"

@implementation UILabel (EGCategory)

- (void)setTextWithPlaceholder:(NSString *)text {
    self.text = [text hasValue] ? text: @"-";
}

@end
