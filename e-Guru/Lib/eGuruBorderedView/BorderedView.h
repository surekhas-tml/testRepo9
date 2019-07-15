//
//  BorderedView.h
//  e-guru
//
//  Created by Ashish Barve on 9/25/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BorderedView : UIView

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
