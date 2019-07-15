//
//  OptionalFieldsViewController.h
//  e-Guru
//
//  Created by Ashish Barve on 11/30/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOpportunity.h"
#import "ChassisDetails.h"
#import "EGFinancierOpportunity.h"
#import "DropDownViewController.h"
#import "PrimaryField.h"
@class EGMMGeography;

@interface OptionalFieldsViewController : UIViewController <UITextFieldDelegate, DropDownViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *intrestExchangeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContsraintExchangeVw;

@property (nonatomic, strong) EGOpportunity          *opportunity;
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;
@property (nonatomic, strong) ExchangeDetails        *exchangeDetailsModel;  //new
@property (nonatomic, strong) ChassisDetails         *chassisDetails;  //new

@property (nonatomic, strong) PrimaryField *primaryField;
@property (nonatomic, assign) InvokeForOperation entryPoint;

@property (weak, nonatomic) IBOutlet UIButton *financierButton;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIView *exchangeVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exchangeViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet DropDownTextField      *brandDropdownField;
@property (weak, nonatomic) IBOutlet DropDownTextField      *plDropdownField;
@property (weak, nonatomic) IBOutlet UITextField            *registrationTextField;

@property (weak, nonatomic) IBOutlet DropDownTextField      *mileageDropdownField;
@property (weak, nonatomic) IBOutlet DropDownTextField      *ageofVehicleDropDownfield;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField  *chasisNoTextfield;

- (IBAction)textFieldButtonClicked:(id)sender;

@end
