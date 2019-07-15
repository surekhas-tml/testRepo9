//
//  AccountView.h
//  e-Guru
//
//  Created by MI iMac04 on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomBorderTextField.h"
#import "GreyBorderUITextField.h"

@interface AccountView : UIView
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *accountNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *addAccountButton;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *accountSiteTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *accountPhoneNumberTextField;

@end
