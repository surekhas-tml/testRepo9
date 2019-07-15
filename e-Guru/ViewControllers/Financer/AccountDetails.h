//
//  AccountDetails.h
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancierSectionView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "AutoCompleteUITextField.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface AccountDetails : FinancierSectionView<UITextFieldDelegate,AutoCompleteUITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *accountNametextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *accountSiteTextFieldField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *accountNoTextField;
@property (weak, nonatomic) IBOutlet UITextField             *panNoCompanyTF;
@property (weak, nonatomic) IBOutlet DropDownTextField       *accountTypeDropDownField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *districtTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *cityTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField       *pinCodeDropDown;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *add1TextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField   *add2TextField;
@property (weak, nonatomic) IBOutlet DropDownTextField       *stateDropDown;
@property (weak, nonatomic) IBOutlet AutoCompleteUITextField *talukaTextField;

@property (strong, nonatomic) FinancierInsertQuoteModel   *financierInsertQuoteModel;

@property (strong,nonatomic)    UIActivityIndicatorView *actIndicator;
@property (weak, nonatomic) IBOutlet UIButton *pinCodeButton;

@property (weak, nonatomic) IBOutlet UILabel  *individualLabel;
@property (weak, nonatomic) IBOutlet UILabel  *corporateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *individualSwitch; //new

- (IBAction)textFieldButtonClicked:(id)sender;

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData;

@end
