//
//  FinancierFieldViewController.h
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "DropDownTextField.h"
#import "DropDownViewController.h"
#import "EGOpportunity.h"
#import "EGFinancierOpportunity.h"
#import "FinancierInsertQuoteModel.h"
#import "FinancierBranchDetailsModel.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface FinancierFieldViewController : UIViewController<UIGestureRecognizerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet DropDownTextField *searchFinancierDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *titleDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *genderDD;
@property (weak, nonatomic) IBOutlet DropDownTextField *maritalDD;
@property (weak, nonatomic) IBOutlet DropDownTextField *addressDD;

@property (weak, nonatomic) IBOutlet DropDownTextField *religionDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *accountTypeDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *vehicleColorDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *emmisionNormsDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *customerCategoryDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *customerSubCategoryDDField;
@property (weak, nonatomic) IBOutlet DropDownTextField *idTypeDD;


@property (strong, nonatomic) IBOutlet UITextField *fatherNameTF;
@property (strong, nonatomic) IBOutlet UITextField *areaTF;
@property (strong, nonatomic) IBOutlet UITextField *onRoadPriceTF;
@property (strong, nonatomic) IBOutlet UITextField *exShowroomTF;
@property (strong, nonatomic) IBOutlet UITextField *vehicleClassTF;

@property (weak, nonatomic) IBOutlet UITextField *idDescTF;
@property (weak, nonatomic) IBOutlet UITextField *address1TF;
@property (weak, nonatomic) IBOutlet UITextField *address2TF;
@property (weak, nonatomic) IBOutlet UITextField *loanDetailsTF;
@property (weak, nonatomic) IBOutlet UITextField *repaymentModeTF;
@property (weak, nonatomic) IBOutlet UITextField *panNoCompanyTF;
@property (weak, nonatomic) IBOutlet UITextField *panNoIndividual;
@property (weak, nonatomic) IBOutlet UITextField *indicativeLoanTF;
@property (weak, nonatomic) IBOutlet UITextField *loanTenorTF;
@property (weak, nonatomic) IBOutlet UITextField *partyDetail;
@property (weak, nonatomic) IBOutlet UITextField *partyAnualTF;

@property (weak, nonatomic)  IBOutlet UITextField *dobTextField;
@property (weak, nonatomic)  IBOutlet UITextField *issueTextField;
@property (weak, nonatomic)  IBOutlet UITextField *expiryTextField;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;
@property (nonatomic, strong) FinancierListDetailModel *financierListModel;
@property (nonatomic, strong) FinancierInsertQuoteModel *insertQuoteModel;
@property (nonatomic, strong) FinancierBranchDetailsModel *toFinancieBranch;


@property (strong, nonatomic) IBOutlet UIView *otpBlurrView;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UITextField *txt5;
@property (weak, nonatomic) IBOutlet UITextField *txt6;


@property (weak, nonatomic) IBOutlet UICollectionView *financierSearchCollectionView;

@property (nonatomic, strong) UIDatePicker *tappedView;

- (IBAction)textFieldButtonClicked:(id)sender;

@end


