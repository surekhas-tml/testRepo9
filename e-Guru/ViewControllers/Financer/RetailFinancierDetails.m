//
//  RetailFinancierDetails.m
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "RetailFinancierDetails.h"
#import "FinancierRequestViewController.h"
#import "FinanciersDBHelpers.h"
#import "FinancierFieldDBHelper.h"

@implementation RetailFinancierDetails
{
    AppDelegate *appDelegate;
    NSMutableArray *mBillingArray;
    UITextField *activeField;
}

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"RetailFinancierDetails" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self addGestureRecognizer:gestureRecognizer];

    self.sectionType = RetailFinancierDetailsVw;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_EA_Retail_Financier];
}

- (void)hideKeyboard{
    [self endEditing:YES];
}

- (FinancierInsertQuoteModel *)financierInsertQuoteModel {
    if (!_financierInsertQuoteModel) {
        _financierInsertQuoteModel = [[FinancierInsertQuoteModel alloc] init];
    }
    return _financierInsertQuoteModel;
}

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint{
    
    [self bindDataToFieldsFromModel:model andEntryPoint:entryPoint];
    switch (mode) {
        case FinancierModeCreate:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            break;
        case FinancierModeDisplay:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:false];
            break;
    }
}

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData andEntryPoint:(NSString *)entryPoint{
   self.financierInsertQuoteModel = fieldModelData;

    [self.customerCategoryDropDown    setText:fieldModelData.customer_category];
    [self.customerSubCategoryDropDown setText:fieldModelData.customer_category_subcategory];
    [self.repaymentModeTextField      setText:fieldModelData.repayment_mode];
    [self.indicativeLoanTextField     setText:fieldModelData.indicative_loan_amt];
    [self.loanRepaymentTextField      setText:fieldModelData.loandetails_repayable_in_months];
    [self.loanTenorTextField          setText:fieldModelData.loan_tenor];
    
    if (fieldModelData.ltv) {
        [self.ltvTextField setText: fieldModelData.ltv];
    } else{
        [self.ltvTextField setText: [self calculateLTV:fieldModelData.indicative_loan_amt]];
    }
    
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.customerCategoryDropDown];
    [UtilityMethods setRedBoxBorder:self.customerSubCategoryDropDown];
    [UtilityMethods setRedBoxBorder:self.repaymentModeTextField];
    [UtilityMethods setRedBoxBorder:self.indicativeLoanTextField];
//    [UtilityMethods setRedBoxBorder:self.loanRepaymentTextField];
    [UtilityMethods setRedBoxBorder:self.loanTenorTextField];
    [UtilityMethods setRedBoxBorder:self.ltvTextField];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.customerCategoryDropDown.text hasValue] &&
        [self.customerSubCategoryDropDown.text hasValue] &&
        [self.repaymentModeTextField.text hasValue] &&
        [self.indicativeLoanTextField.text hasValue] &&
//        [self.loanRepaymentTextField.text hasValue] &&
        [self.loanTenorTextField.text hasValue] &&
        [self.ltvTextField.text hasValue]) {
        
        if ([self isTextFieldDataValid]) {
            mandatoryFieldsFilled = true;
        }
    }
    
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

- (DropDownTextField *)customerCategoryDropDownField {
    if (!_customerCategoryDropDown.field) {
        _customerCategoryDropDown.field = [[Field alloc] init];
    }
    return _customerCategoryDropDown;
}

- (DropDownTextField *)customerSubCategoryDDField {
    if (!_customerSubCategoryDropDown.field) {
        _customerSubCategoryDropDown.field = [[Field alloc] init];
    }
    return _customerSubCategoryDropDown;
}

#pragma mark-Button Events
-(void)textFieldButtonClicked:(id)sender {
    [activeField resignFirstResponder];
    
    switch ([sender tag]) {
        case 101:
            [self fetchCustomerCategory:_customerCategoryDropDown];
            break;
        case 102:
            [self fetchCustomerSubCategory:_customerSubCategoryDropDown];
            break;
            
        default:
            break;
    }
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;

        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        
        if (textField ==self.customerCategoryDropDown) {
            self.customerCategoryDropDown.text = selectedValue;
            self.financierInsertQuoteModel.customer_category = self.customerCategoryDropDown.text;
            [self checkIfMandatoryFieldsAreFilled];
        } else if (textField ==self.customerSubCategoryDropDown){
            self.customerSubCategoryDropDown.text = selectedValue;
            self.financierInsertQuoteModel.customer_category_subcategory = self.customerSubCategoryDropDown.text;
            [self checkIfMandatoryFieldsAreFilled];
        }
    }
}

- (void)fetchCustomerCategory:(DropDownTextField *)textField {
    
    if (customerCategoryArray && [customerCategoryArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [customerCategoryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchCustomerCategory] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                customerCategoryArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [customerCategoryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];

                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];

            }];
        }
    }];
}

- (void)fetchCustomerSubCategory:(DropDownTextField *)textField {
    
    if (customerSubCategoryArray && [customerSubCategoryArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [customerSubCategoryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchCustomerSubCategory] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                customerSubCategoryArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [customerSubCategoryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];

                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray
{
    DropDownViewController *dropDown;
    dropDown = [[DropDownViewController alloc]initWithWidth:CUSTOMER_CATEGORY_DROP_DOWN_WIDTH];
    
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

-(BOOL)isTextFieldDataValid {
    NSString * warningMessage = @"";
    BOOL isValid;
    isValid = [self validateTextFields:&warningMessage];
    
    if (!isValid) {
        [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
        }];
    }
    return isValid;
}

- (BOOL)validateTextFields:(NSString **)warningMessage_p
{
//    if (!([self.indicativeLoanTextField.text length] < 9) || !([self.indicativeLoanTextField.text length] > 4)) {
//        *warningMessage_p = @"Please enter valid Indicative Loan amount";
//        return NO;
//    }

    if ([self.indicativeLoanTextField.text intValue]  > [self.financierInsertQuoteModel.ex_showroom_price intValue]) {
        *warningMessage_p = @"Loan Price cannot be more than ExShowroom Price";
        return NO;
    }
//    else if ([self.financierInsertQuoteModel.on_road_price_total_amt intValue] <= [self.indicativeLoanTextField.text intValue]) {
//        *warningMessage_p = @"Loan Price should be less than or equal to OnRoad Price";
//        return NO;
//    }
    else if ([self.loanTenorTextField.text hasValue] && ([self.loanTenorTextField.text intValue] > 84 || ([self.loanTenorTextField.text intValue] < 1))) {
        *warningMessage_p = @"Loan Tenor cannot be 0 or more than 84 months";
        return NO;
    }

    return YES;
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
//    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (textField == self.customerCategoryDropDown) {
        self.financierInsertQuoteModel.customer_category = self.customerCategoryDropDown.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.customerSubCategoryDropDown) {
        self.financierInsertQuoteModel.customer_category_subcategory = self.customerSubCategoryDropDown.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.repaymentModeTextField) {
        self.financierInsertQuoteModel.repayment_mode = self.repaymentModeTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.indicativeLoanTextField) {
        self.financierInsertQuoteModel.indicative_loan_amt = self.indicativeLoanTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
        [self isTextFieldDataValid];
//        activeField = self.indicativeLoanTextField;
    }
    else if (textField == self.loanTenorTextField) {
        
        if (![self.loanTenorTextField.text hasValue]) {
            [UtilityMethods alert_ShowMessage:@"Please Enter Loan Tenor amount" withTitle:APP_NAME andOKAction:^{
            }];
//            activeField = self.loanTenorTextField;
        } else{
            self.financierInsertQuoteModel.loan_tenor = self.loanTenorTextField.text;
            [self checkIfMandatoryFieldsAreFilled];
        }
       
    }else if (textField == self.ltvTextField) {
        self.financierInsertQuoteModel.ltv = self.ltvTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (length > 0) {
        NSDictionary *userInfo = @{@"Value_Changed": @"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    }
    
    if (textField == self.indicativeLoanTextField) {
        [self.ltvTextField setText:[self calculateLTV:currentString]];
        self.financierInsertQuoteModel.ltv = self.ltvTextField.text;
        
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    else if (textField == self.loanTenorTextField) {
        if (length > 2)
            return NO;
        if ([currentString intValue] > 84) {
            return NO;
//            [UtilityMethods alert_ShowMessage:@"Loan Tenor cannot be 0 or more than 84 months" withTitle:APP_NAME andOKAction:^{
//            }];
        }
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    return YES;
}

-(NSString *)calculateLTV:(NSString *)indicativeAmount{
  
    NSString* strLTV;
    float exShowRoom     = self.financierInsertQuoteModel.ex_showroom_price.intValue;
    float indicativeLoan = indicativeAmount.intValue;
    
    if (!exShowRoom || !indicativeLoan) {
        
    } else if((exShowRoom != 0) || (indicativeLoan != 0)){
        float ltvValue =  indicativeLoan/ exShowRoom ;
        strLTV = [self roundingLTVPercentage:ltvValue * 100];
    }
    
    return strLTV;
}

-(NSString *)roundingLTVPercentage:(float)ltvFloat{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:ltvFloat]];
    return numberString;
}

@end
