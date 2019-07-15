//
//  COAutoCompleteTextFieldView.h
//  e-Guru
//
//  Created by Ashish Barve on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoCompleteUITextField.h"
#import "Field.h"

@interface COAutoCompleteTextFieldView : UIView

@property (nonatomic, strong) Field *field;
@property (nonatomic, strong) UILabel *fieldNameLabel;
@property (nonatomic, strong) AutoCompleteUITextField *textField;

@end
