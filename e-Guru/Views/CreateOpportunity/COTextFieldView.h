//
//  CustomTextView.h
//  e-Guru
//
//  Created by MI iMac04 on 24/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Field.h"
#import "GreyBorderUITextField.h"

@interface COTextFieldView : UIView

@property (nonatomic, strong) Field *field;
@property (nonatomic, strong) UILabel *fieldNameLabel;
@property (nonatomic, strong) GreyBorderUITextField *textField;

@end
