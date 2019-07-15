//
//  ContactAndAccountView.h
//  e-Guru
//
//  Created by Ashish Barve on 11/27/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreyBorderUITextField.h"
#import "BottomBorderTextField.h"

@interface ContactView : UIView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *contactNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchContactButton;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *mobileNumberTextField;

@end
