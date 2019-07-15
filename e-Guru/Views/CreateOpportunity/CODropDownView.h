//
//  CoDropDownView.h
//  e-Guru
//
//  Created by MI iMac04 on 25/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Field.h"
#import "DropDownTextField.h"

@interface CODropDownView : UIView

@property (nonatomic, strong) Field *field;
@property (nonatomic, strong) UILabel *fieldNameLabel;
@property (nonatomic, strong) DropDownTextField *textField;

@end
