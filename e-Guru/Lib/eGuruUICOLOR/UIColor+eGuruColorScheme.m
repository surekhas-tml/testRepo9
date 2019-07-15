//
//  UIColor+eGuruColorScheme.m
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UIColor+eGuruColorScheme.h"

@implementation UIColor (eGuruColorScheme)

+(UIColor *)navBarColor{
    return [UIColor colorWithR:28 G:115 B:184 A:1];
 
}
+(UIColor *)menuColor{
    return [UIColor colorWithR:70 G:88 B:102 A:1];
    
}
+(UIColor *)tableHeaderColor{
    return [UIColor colorWithR:23 G:106 B:171 A:1];
}
+(UIColor *)tableDarkRowColor{
    return [UIColor colorWithR:232 G:234 B:240 A:1];
}
+(UIColor *)tableLightRowColor{
    return [UIColor colorWithR:241 G:242 B:244 A:1];
}
+(UIColor *)tableTitleBarColor{
    return [UIColor colorWithR:216 G:223 B:230 A:1];
}
+(UIColor *)heddingTextColor{
    return [UIColor whiteColor];
}
+(UIColor *)successGreenColor{
    return [UIColor greenColor];
}
+(UIColor *)failuerRedColor{
    return [UIColor redColor];
}
+(UIColor *)C0Color{
    return [UIColor greenColor];
}
+(UIColor *)C1Color{
    return [UIColor yellowColor];
}
+(UIColor *)C1AColor{
    return [UIColor blueColor];
}
+(UIColor *)C2Color{
    return [UIColor cyanColor];
}
+(UIColor *)C3Color{
    return [UIColor redColor];
}
+(UIColor *)GTMEColor{
    return [UIColor purpleColor];
}

+(UIColor *)mandatoryFieldRedBorderColor{
    return [UIColor colorWithR:246 G:37 B:37 A:1];
}
+(UIColor *)nonmandatoryFieldRedBorderColor{
    return [UIColor colorWithR:197 G:197 B:201 A:1];
}

+(UIColor *)ChatBubbleYouColor{
    return [UIColor grayColor];
}
+(UIColor *)ChatBubbleMeColor{
    return [UIColor darkGrayColor];
}
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)buttonBackgroundBlueColor {
    return [UIColor colorWithR:30 G:118 B:181 A:1];
}
+ (UIColor *)buttonBackgroundGrayColor {
    return [UIColor colorWithR:188 G:184 B:185 A:1];
}
+ (UIColor *)buttonBorderColor {
    return [UIColor colorWithR:16 G:112 B:175 A:1];
}

+ (UIColor *)separatorColor {
    return [UIColor colorWithR:212 G:214 B:224 A:1];
}

+ (UIColor *)tableViewSeparatorColor {
    return [UIColor colorWithR:207 G:210 B:219 A:1];
}

+ (UIColor *)textFieldGreyBorder {
    return [UIColor colorWithR:197 G:197 B:201 A:1];
}

+ (UIColor *)textFieldLayerBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)searchTextFieldLayerBackgroundColor {
    return [UIColor colorWithR:216 G:223 B:229 A:1];
}

+ (UIColor *)searchTextFieldBackgroundViewColor {
    return [UIColor colorWithR:238 G:237 B:239 A:1];
}

+ (UIColor *)searchTextFieldBackgroundViewBorderColor {
    return [UIColor colorWithR:205 G:205 B:207 A:1];
}

+ (UIColor *)themePrimaryColor {
    return [UIColor colorWithR:34 G:115 B:181 A:1];
}

+ (UIColor *)themeDisabledColor {
    return [UIColor colorWithR:128 G:138 B:144 A:1];
}

+ (UIColor *)tableViewAlternateCellColor {
    return [UIColor colorWithR:237 G:239 B:243 A:1];
}

+ (UIColor *)slideViewSliderColor {
    return [UIColor colorWithR:160 G:210 B:224 A:1];
}

+ (UIColor *)mandatoryFieldStatusFilledColor {
    return [UIColor colorWithR:75 G:206 B:68 A:1];
}

+ (UIColor *)mandatoryFieldStatusEmptyColor {
    return [UIColor colorWithR:251 G:63 B:68 A:1];
}

+ (UIColor *)pplWiseReportCellBorderColor {
    return [UIColor colorWithR:166 G:174 B:179 A:1];
}

@end
