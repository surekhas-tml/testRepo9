//
//  ContactDetails.h
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierSectionView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "AutoCompleteUITextField.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

//@protocol ContactViewDelegate <NSObject>
//
//-(void)contactDetailDelegate:(NSString *)str;
//@end

@interface ContactDetails : FinancierSectionView<UITextFieldDelegate, DropDownViewControllerDelegate,AutoCompleteUITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtPanNo;
@property (weak, nonatomic) IBOutlet DropDownTextField *stateDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *pincodeDropdown;
@property (weak, nonatomic) IBOutlet AutoCompleteUITextField *txtTaluka;

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtDistrict;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtArea;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCity;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtAdd1;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtAdd2;

@property (weak, nonatomic) IBOutlet UIButton *stateDropdownButton;
@property (weak, nonatomic) IBOutlet UIButton *pinCodeButton;

@property (nonatomic, strong) UIDatePicker *tappedView;
@property (nonatomic, strong) UIToolbar    *toolbar;

@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UIView *coapplicantvw;

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantfirstName;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantLastName;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantMobileNo;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantPanNo;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantCity;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantAddress1;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantAddress2;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *txtCoApplicantPincode;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;

@property (strong,nonatomic)    UIActivityIndicatorView *actIndicator;
@property (strong, nonatomic) FinancierInsertQuoteModel *financierInsertQuoteModel;
- (IBAction)textFieldButtonClicked:(id)sender;

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData;

//@property (weak, nonatomic) id<ContactViewDelegate>contactDelegate;

@end
