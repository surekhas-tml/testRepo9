//
//  ContactDetails.m
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "ContactDetails.h"
#import "AppDelegate.h"
#import "NSDate+eGuruDate.h"
#import "FinancierRequestViewController.h"
#import "FinanciersDBHelpers.h"
#import "FinancierFieldDBHelper.h"

@implementation ContactDetails 
{
    AppDelegate *appDelegate;
    AppDelegate *appdelegate;
    
    AutoCompleteUITextField * autoComplete_textField;
    
    NSMutableArray *mBillingArray;
    NSArray *talukaArray;
    NSArray *arrCurrentSearchTalukaData;
    NSMutableArray *sortedTalukaArray;
    NSMutableArray* stateArray;
    NSArray *sortedModelArr;
    NSMutableDictionary * talukakeyWithModelDict;
    EGTaluka *talukaModel;
    
    UIDatePicker *dobDatePicker;
    
    BOOL fetchTaluka;
    BOOL coApplicantExist;
    BOOL firstTabSelected;
    
    UITextField *activeField;
    
    NSString *stateCode;
    NSString *selectedFinancierString;
    EGRKWebserviceRepository *currentTalukaOperation;
}

- (void)loadUIFromXib {
    UIView *nib =[[[UINib nibWithNibName:@"ContactDetails" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];

    fetchTaluka = YES;
    coApplicantExist = NO;
    firstTabSelected = NO;
    [self hideOrShowCoApplicantsView:YES];
    
    _toggleSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFinancierValueChanged:) name:NOTIFICATION_FINANCIER_VALUE_CHANGED object:nil];
    
    [self setupFinancierTextField];
    [self setInitialDates];
    
    self.sectionType = FinancierContactsDetailsVw;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_EA_Contact_Details];
}

- (void)setupFinancierTextField {
    self.txtTaluka.autocompleteTableRowSelectedDelegate = self;
    self.txtTaluka.field = [[Field alloc] init];
}

- (void)hideKeyboard{
    [self endEditing:YES];
}

- (void)onFinancierValueChanged:(NSNotification *)notification {
    
    NSDictionary *dictUserInfo = [notification userInfo];
    selectedFinancierString    = [dictUserInfo objectForKey:@"financier_id"];
    
    if ([[dictUserInfo objectForKey:@"FinancierRemoved"] isEqualToString:@"YES"]) {
        [self hideOrShowCoApplicantsView:YES];
        self.toggleSwitch.userInteractionEnabled = false;
        [self checkIfMandatoryFieldsAreFilled];
    } else {
    
        if ([[dictUserInfo objectForKey:@"financier_id"] isEqualToString:@"1-4G25N97"]) {
            self.toggleSwitch.userInteractionEnabled = false;
            [self hideOrShowCoApplicantsView:NO];
        }
        else if([[dictUserInfo objectForKey:@"draftEntry"] isEqualToString:@"true"]){
            //will hvae to change here if chola mandlam is selected
            _toggleSwitch.userInteractionEnabled = true;
            [self hideOrShowCoApplicantsView:NO];
        }
        else {
            _toggleSwitch.userInteractionEnabled = true;            

//            if (firstTabSelected) {
////                 [_toggleSwitch setOn:NO];  // for tmf only
////                _toggleSwitch.userInteractionEnabled = true;
//                [self hideOrShowCoApplicantsView:YES];
//            }
//            else{

//            [self hideOrShowCoApplicantsView:NO];
//            }
            
        }
        [self checkIfMandatoryFieldsAreFilled];
    }
    
}

- (FinancierInsertQuoteModel *)financierInsertQuoteModel {
    if (!_financierInsertQuoteModel) {
        _financierInsertQuoteModel = [[FinancierInsertQuoteModel alloc] init];
    }
    return _financierInsertQuoteModel;
}

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint {
    
    [self bindDataToFieldsFromModel:model andEntryPoint:entryPoint];
    
    switch (mode) {
        case FinancierModeCreate: {
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            [_toggleSwitch setOn:NO];
            
            FinancierInsertQuoteModel * modelObj = model;
            if(modelObj.financier_name && ![modelObj.financier_name isEqualToString:@""]) {
                self.toggleSwitch.userInteractionEnabled = true;
            }
        }
            break;
       
        case FinancierModeDisplay:
            [self markMandatoryFields];
            [_toggleSwitch setOn:NO];
            self.toggleSwitch.userInteractionEnabled = false;

            if ([_txtCoApplicantfirstName.text hasValue]) {
                _coapplicantvw.userInteractionEnabled = false;
            } else{
                _coapplicantvw.userInteractionEnabled = true;
            }
            
            self.txtPanNo.userInteractionEnabled            =false;
            self.stateDropDown.userInteractionEnabled       =false;
            self.stateDropdownButton.userInteractionEnabled =false;
            self.txtTaluka.userInteractionEnabled           =false;
            self.txtDistrict.userInteractionEnabled         =false;
            self.txtCity.userInteractionEnabled             =false;
            self.txtAdd1.userInteractionEnabled             =false;
            self.txtAdd2.userInteractionEnabled             =false;
            self.txtArea.userInteractionEnabled             =false;
            self.pincodeDropdown.userInteractionEnabled     =false;
            
            break;
    }
}

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData andEntryPoint:(NSString *)entryPoint{
    self.financierInsertQuoteModel = fieldModelData;
    
    [self.txtFirstName  setText:fieldModelData.first_name];
    [self.txtLastName setText:fieldModelData.last_name];
    [self.txtMobileNo setText:fieldModelData.mobile_no];
    [self.txtPanNo setText:fieldModelData.pan_no_indiviual];
    [self.stateDropDown setText:fieldModelData.state];
    [self.txtTaluka setText:fieldModelData.taluka];
    [self.txtDistrict setText:fieldModelData.district];
    [self.txtCity setText:fieldModelData.city_town_village];
    [self.txtAdd1 setText:fieldModelData.address1];
    [self.txtAdd2 setText:fieldModelData.address2];
    [self.txtArea setText:fieldModelData.area];
    [self.pincodeDropdown setText:fieldModelData.pincode];
    
    [self.txtCoApplicantfirstName setText:fieldModelData.coapplicant_first_name];
    [self.txtCoApplicantLastName setText:fieldModelData.coapplicant_last_name];
    [self.txtCoApplicantMobileNo setText:fieldModelData.coapplicant_mobile_no];
    [self.txtCoApplicantPanNo setText:fieldModelData.coapplicant_pan_no_indiviual];
    [self.txtCoApplicantCity setText:fieldModelData.coapplicant_city_town_village];
    [self.txtCoApplicantAddress1 setText:fieldModelData.coapplicant_address1];
    [self.txtCoApplicantAddress2 setText:fieldModelData.coapplicant_address2];
    [self.txtCoApplicantPincode setText:fieldModelData.coapplicant_pincode];
    [self.dobTextField setText:fieldModelData.coapplicant_date_of_birth];
    
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.txtPanNo];
    [UtilityMethods setRedBoxBorder:self.stateDropDown];
    [UtilityMethods setRedBoxBorder:self.txtTaluka];
    [UtilityMethods setRedBoxBorder:self.txtDistrict];
    [UtilityMethods setRedBoxBorder:self.txtCity];
    [UtilityMethods setRedBoxBorder:self.txtAdd1];
    
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantfirstName];
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantLastName];
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantMobileNo];
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantPanNo];
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantCity];
    [UtilityMethods setRedBoxBorder:self.txtCoApplicantAddress1];
    [UtilityMethods setRedBoxBorder:self.dobTextField];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.txtPanNo.text hasValue] &&
        [self.stateDropDown.text hasValue] &&
        [self.txtTaluka.text hasValue] &&
        [self.txtDistrict.text hasValue] &&
        [self.txtCity.text hasValue] &&
        [self.txtAdd1.text hasValue])
      {
        if (coApplicantExist){
            if ([self.txtCoApplicantfirstName.text hasValue] &&
                [self.txtCoApplicantLastName.text hasValue] &&
                [self.txtMobileNo.text hasValue] &&
                [self.txtCoApplicantPanNo.text hasValue] &&
                [self.txtCoApplicantCity.text hasValue] &&
                [self.txtCoApplicantAddress1.text hasValue] &&
                [self.dobTextField.text hasValue])
            {
                if ([self isTextFieldDataValid]) {
                    mandatoryFieldsFilled = true;
                }
            } else{
                mandatoryFieldsFilled = false;
            }
            
        } else {
            if ([self isTextFieldDataValid]) {
                mandatoryFieldsFilled = true;
            }
        }
    }
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

#pragma mark - DatePicker Methods
-(void)setInitialDates
{
    [self dobDatePicker];
}

-(UIDatePicker *)dobDatePicker{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    if (dobDatePicker != nil) {
        [dobDatePicker setMaximumDate:maxDate];
        self.tappedView = dobDatePicker;
        return dobDatePicker;
    } else {
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:maxDate animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        dobDatePicker = datePickerNew;
        
        self.tappedView = dobDatePicker;
        [self setToolbarForPicker:dobDatePicker andCancelButtonHidden:false];
        return dobDatePicker;
    }
}


-(void)setToolbarForPicker:(UIDatePicker *)datePicker andCancelButtonHidden:(BOOL)hideCancelButton{
    
    if (!self.toolbar) {
        self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    }
    
    [self.toolbar setBarTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(datePickerCancelButtonTapped)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:self
                                                                                   action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(datePickerDoneButtonTapped)];
    [doneButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 16;
    
    if (hideCancelButton) {
        [self.toolbar setItems:@[flexibleSpace, doneButton]];
    }
    else {
        [self.toolbar setItems:@[space, cancelButton, flexibleSpace, doneButton, space]];
    }
    
    if (_tappedView == dobDatePicker) {
        self.dobTextField.inputAccessoryView = self.toolbar;
    }
}

- (void)dobDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSString *dateString =[NSDate formatDate:[dobDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.dobTextField.text = dateString;
}

- (void)datePickerCancelButtonTapped {
    [self.toolbar removeFromSuperview];
    [dobDatePicker removeFromSuperview];
    
    self.dobTextField.inputAccessoryView = nil;
    [self.dobTextField resignFirstResponder];
}

- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
   
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (self.tappedView == dobDatePicker) {
        [self.dobTextField setText:[NSDate formatDate:[dobDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
        self.financierInsertQuoteModel.coapplicant_date_of_birth = self.dobTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

#pragma mark- Textfield Validations

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
    if ([self.txtPanNo.text isEqualToString:@""] || ![UtilityMethods validatePanNumber:self.txtPanNo.text]){
        *warningMessage_p = @"Please enter valid individual Pan Number";
        return NO;
    }
    if (coApplicantExist) {
        if ([self.txtCoApplicantPanNo.text hasValue] && ![UtilityMethods validatePanNumber:self.txtCoApplicantPanNo.text]) {
            *warningMessage_p = @"Please enter valid Co-Applicant Pan Number";
            return NO;
        } else if ([self.txtCoApplicantPanNo.text hasValue] && [UtilityMethods validatePanNumber:self.txtCoApplicantPanNo.text]) {
            if ([self.txtCoApplicantPanNo.text isEqualToString:self.txtPanNo.text]) {
                    *warningMessage_p = @"Co-Applicant Pan Number and Contact Pan number should be different";
                    return NO;
            }
        }
        
        if ([UtilityMethods validateMobileNumber:self.txtCoApplicantMobileNo.text]) {
            NSString *str = [self.txtCoApplicantMobileNo.text substringToIndex:1];

                if ([str isEqualToString:@"0"] || [str isEqualToString:@"1"] || [str isEqualToString:@"2"] || [str isEqualToString:@"3"] || [str isEqualToString:@"4"] || [str isEqualToString:@"5"]) {
                    *warningMessage_p = @"Please enter valid Co-Applicant Mobile Number";
                    return NO;
                }
                else if ([self.txtCoApplicantMobileNo.text isEqualToString:@"6666666666"] || [self.txtCoApplicantMobileNo.text isEqualToString:@"7777777777"] || [self.txtCoApplicantMobileNo.text isEqualToString:@"8888888888"] || [self.txtCoApplicantMobileNo.text isEqualToString:@"9999999999"]) {
                    *warningMessage_p = @"Please enter valid Co-Applicant Mobile Number";
                    return NO;
                }
        } else{
            *warningMessage_p = @"Please enter valid Co-Applicant Mobile Number";
            return NO;
        }
        
    }
    return YES;
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
//    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        if (autoComplete_textField.resultTableView) {
            [autoComplete_textField.resultTableView removeFromSuperview];
        }
    }
    
    if (textField == self.txtFirstName) {
        self.financierInsertQuoteModel.first_name = self.txtFirstName.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtLastName) {
        self.financierInsertQuoteModel.last_name = self.txtLastName.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtMobileNo) {
        self.financierInsertQuoteModel.mobile_no = self.txtMobileNo.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtPanNo) {
        self.financierInsertQuoteModel.pan_no_indiviual = self.txtPanNo.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    //may be not in use
    else if (textField == self.stateDropDown) {
        self.financierInsertQuoteModel.state = self.pincodeDropdown.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.pincodeDropdown) {
        self.financierInsertQuoteModel.pincode = self.pincodeDropdown.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtTaluka) {
        self.financierInsertQuoteModel.taluka = self.txtTaluka.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtDistrict) {
        self.financierInsertQuoteModel.district = self.txtDistrict.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtArea) {
        self.financierInsertQuoteModel.area = self.txtArea.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCity) {
        self.financierInsertQuoteModel.city_town_village = self.txtCity.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtAdd1) {
        self.financierInsertQuoteModel.address1 = self.txtAdd1.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtAdd2) {
        self.financierInsertQuoteModel.address2 = self.txtAdd2.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    
    //for coapplicants checkfor mandatory is remaining
    else if (textField == self.txtCoApplicantfirstName) {
        self.financierInsertQuoteModel.coapplicant_first_name = self.txtCoApplicantfirstName.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantLastName) {
        self.financierInsertQuoteModel.coapplicant_last_name = self.txtCoApplicantLastName.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantMobileNo) {
        self.financierInsertQuoteModel.coapplicant_mobile_no = self.txtCoApplicantMobileNo.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantPanNo) {
        self.financierInsertQuoteModel.coapplicant_pan_no_indiviual = self.txtCoApplicantPanNo.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantCity) {
        self.financierInsertQuoteModel.coapplicant_city_town_village = self.txtCoApplicantCity.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantAddress1) {
        self.financierInsertQuoteModel.coapplicant_address1 = self.txtCoApplicantAddress1.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantAddress2) {
        self.financierInsertQuoteModel.coapplicant_address2 = self.txtCoApplicantAddress2.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.txtCoApplicantPincode) {
        self.financierInsertQuoteModel.coapplicant_pincode = self.txtCoApplicantPincode.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.dobTextField) {
        self.financierInsertQuoteModel.coapplicant_date_of_birth = self.dobTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

-(UIActivityIndicatorView *)actIndicatorForView:(UIView *)view{
    if(self.actIndicator) {
        return self.actIndicator;
    }else{
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.actIndicator setHidesWhenStopped:YES];
        CGFloat halfButtonHeight = view.bounds.size.height / 2;
        CGFloat buttonWidth = view.bounds.size.width;
        self.actIndicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    }
    return self.actIndicator;
}

- (DropDownTextField *)_stateDropDown {
    if (!_stateDropDown.field) {
        _stateDropDown.field = [[Field alloc] init];
    }
    return _stateDropDown;
}

#pragma mark- Button Events
-(void)textFieldButtonClicked:(id)sender {
    [activeField resignFirstResponder];
    switch ([sender tag]) {
        case 11:
            [self fetchAllStates:_stateDropDown];
            break;
        case 12:
            [self pincodeFieldBeingEditted];
            break;
            
        default:
            break;
    }
}

- (IBAction)toggleButtonClicked:(UISwitch *)sender {
   
    if ([sender isOn]) {
        coApplicantExist = true;
        self.financierInsertQuoteModel.toggleMode = @"true";
        [self hideOrShowCoApplicantsView:NO];
    } else {
        coApplicantExist = false;
        [self hideOrShowCoApplicantsView:YES];
    }
}

-(void)hideOrShowCoApplicantsView:(BOOL)hideCoApplicants{
    
    if (hideCoApplicants) {
        [self checkIfMandatoryFieldsAreFilled];
        coApplicantExist = NO;
        [_toggleSwitch setOn:NO];
        self.financierInsertQuoteModel.toggleMode = @"false";   //inserting togglemode bolean value
        [self clearAllTextFiledsInView:self.coapplicantvw];     //new function to clear all Coapplicant model data
        self.coapplicantvw.hidden = hideCoApplicants;
    }else{
        [self checkIfMandatoryFieldsAreFilled];
        coApplicantExist = YES;
        [_toggleSwitch setOn:YES];
        [self fillAllCoApplicantTextFiledsInModel:self.coapplicantvw];
        self.coapplicantvw.hidden = hideCoApplicants;
    }
}

/* to clear all fields in coApplicants when toggle button off */
-(void)clearAllTextFiledsInView:(UIView *)fromView
{
    self.financierInsertQuoteModel.coapplicant_first_name        = @"";
    self.financierInsertQuoteModel.coapplicant_last_name         = @"";
    self.financierInsertQuoteModel.coapplicant_mobile_no         = @"";
    self.financierInsertQuoteModel.coapplicant_pan_no_indiviual  = @"";
    self.financierInsertQuoteModel.coapplicant_city_town_village = @"";
    self.financierInsertQuoteModel.coapplicant_address1          = @"";
    self.financierInsertQuoteModel.coapplicant_address2          = @"";
    self.financierInsertQuoteModel.coapplicant_pincode           = @"";
    self.financierInsertQuoteModel.coapplicant_date_of_birth     = @"";
}

-(void)fillAllCoApplicantTextFiledsInModel:(UIView *)fromView
{
    self.financierInsertQuoteModel.coapplicant_first_name        = self.txtCoApplicantfirstName.text;
    self.financierInsertQuoteModel.coapplicant_last_name         = self.txtCoApplicantLastName.text;
    self.financierInsertQuoteModel.coapplicant_mobile_no         = self.txtCoApplicantMobileNo.text;
    self.financierInsertQuoteModel.coapplicant_pan_no_indiviual  = self.txtCoApplicantPanNo.text;
    self.financierInsertQuoteModel.coapplicant_city_town_village = self.txtCoApplicantCity.text;
    self.financierInsertQuoteModel.coapplicant_address1          = self.txtCoApplicantAddress1.text;
    self.financierInsertQuoteModel.coapplicant_address2          = self.txtCoApplicantAddress2.text;
    self.financierInsertQuoteModel.coapplicant_pincode           = self.txtCoApplicantPincode.text;
    self.financierInsertQuoteModel.coapplicant_date_of_birth     = self.dobTextField.text;
}

#pragma mark- API Calls

-(void)clearSelectedTalukadata{
    self.txtTaluka.field.mValues = nil;
    self.txtTaluka.text = nil;
    self.txtDistrict.text = nil;
    self.txtCity.text = nil;
    [self.txtTaluka hideDropDownFromView];
}

- (void)fetchAllStates:(DropDownTextField *)textField {
    [self clearSelectedTalukadata];
    
    [[EGRKWebserviceRepository sharedRepository] getStates:nil andSucessAction:^(NSArray *statesArray) {
        if (statesArray && [statesArray count] > 0) {
           [self showPopOver:textField withDataArray:[statesArray valueForKey:@"name"] andModelData:[statesArray valueForKey:@"code"]];
        }
        
    } andFailuerAction:^(NSError *error) {
        
    }];
}

-(void)APIactivityTypeForTalukaTextField:(UITextField *)textField WithString:(NSString *)string AndStateCode:(NSString *)strCode{
    
    NSLog(@"taluka pass %lu",(unsigned long)string.length);
    
    if (string.length ==3) {
        fetchTaluka = YES;
        
        [textField addSubview:[self actIndicatorForView:textField]];
        //    [textField setClearButtonMode:UITextFieldViewModeUnlessEditing];
        currentTalukaOperation = [EGRKWebserviceRepository sharedRepository];
        
        [self.actIndicator stopAnimating];
        [self.actIndicator startAnimating];
        [currentTalukaOperation getAllTaluka:@{@"taluka":string,@"state":@{@"code":strCode}} andSucessAction:^(id contact , EGRKWebserviceRepository *sender) {
            
            if ([sender isEqual:currentTalukaOperation]) {
                [self.actIndicator stopAnimating];
                
                if ([[[contact allValues] firstObject] count] > 0) {
                    NSMutableArray *talArray = [NSMutableArray array];
                    talukaArray = [NSArray arrayWithArray:[[contact allValues] firstObject]];
                    
                    //Sorting of model data in terms of taluka name
                    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"talukaName" ascending:true];
                    sortedModelArr = [[talukaArray sortedArrayUsingDescriptors:@[sortDesc]] mutableCopy];

                    talukakeyWithModelDict = [[NSMutableDictionary alloc] init];

                    for (EGTaluka *tal in talukaArray) {
                        [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]];
                        [talukakeyWithModelDict setObject:tal forKey:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]];
                    }
                    //add key as talarray object string and value as soredmodelarr object model
                    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                    NSArray *sortedTaluka = [talArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    sortedTalukaArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                    
                    self.txtTaluka.field.mValues = [[NSMutableArray alloc] init];
                    self.txtTaluka.field.mValues =[[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                    fetchTaluka = NO;
                    if ([sortedTalukaArray count]> 0) {
                        [self  showAutoCompleteTableForTalukaField];
                    }else{
                        [self removeTalukaTableView];
                        [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                    }
                } else {
                    [self removeTalukaTableView];
                    [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                }
            }
            
        } andFailuerAction:^(NSError *error) {
            [self removeTalukaTableView];
            [self.actIndicator stopAnimating];
        }];
        
    }
}

-(void)pincodeFieldBeingEditted{
    
    if (self.txtTaluka.text.length > 0 && self.stateDropDown.text.length > 0 ) {
        [self.pincodeDropdown addSubview:[self actIndicatorForView:self.pincodeDropdown]];
        [self.actIndicator stopAnimating];
        [self.actIndicator startAnimating];
        
        [[EGRKWebserviceRepository sharedRepository]getPinFromTalukaCityDistrictState:
                            @{ @"state"     : @{@"state":self.stateDropDown.text ? : @"", @"code":stateCode ? :@""},
                               @"district"  : self.txtDistrict.text,
                               @"city"      : self.txtCity.text,
                               @"taluka"    : self.txtTaluka.text
                               }
                                andSucessAction:^(id pin) {
                                  [self.actIndicator stopAnimating];
                                  [self pinCodeFetchedSuccessfullyWithDictionary:pin];
                                    
                              } andFailuerAction:^(NSError *error) {
                                  [self pinCodeFetchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
                              }];
    } else{
        if (self.txtTaluka.text.length > 0){
            [UtilityMethods alert_ShowMessage:@"Enter Taluka" withTitle:APP_NAME andOKAction:^{
//                [self.pinc resignFirstResponder];
            }];
        }else{
//            [self.pincode_Textfield resignFirstResponder];
        }
    }
}

-(void)pinCodeFetchedSuccessfullyWithDictionary:(NSDictionary *)responseObject{
    NSLog(@"response %@",responseObject);
    NSMutableArray *array =  [responseObject valueForKey:@"pincodes"];
    if ([array count] > 0) {
        [self showPopOver:self.pincodeDropdown withDataArray:array andModelData:array];
    }
    else{
        [UtilityMethods alert_ShowMessage:CouldnotFetchDataMessage withTitle:APP_NAME andOKAction:nil];
        
    }
}

-(void)pinCodeFetchFailedWithErrorMessage:(NSString *)errorMessage{
//    [ScreenshotCapture takeScreenshotOfView:self.view];
    appdelegate.screenNameForReportIssue = @"ContactDetails View: Pin Code Fetch";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
//    activeField.text = selectedValue;
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if([dropDownForView isEqual:self.stateDropDown]){
        self.stateDropDown.text = selectedValue;
        stateCode = selectedObject;
        self.financierInsertQuoteModel.state = selectedValue;
        [self.txtTaluka setEnabled:true];
        [self clearSelectedTalukadata];
        [self checkIfMandatoryFieldsAreFilled];  //new 20feb
        
    }
    //  may not be in use
    else if([dropDownForView isEqual:self.txtTaluka]){
        
        EGTaluka *tal = (EGTaluka *)selectedObject;
        self.txtTaluka.text        = tal.talukaName;
        self.txtDistrict.text      = tal.district;
        self.txtCity.text          = tal.city;
        self.financierInsertQuoteModel.taluka = tal.talukaName;
        [self.pinCodeButton setEnabled:true];
        [self checkIfMandatoryFieldsAreFilled];
    
    }
    else if([dropDownForView isEqual:self.pincodeDropdown]) {
        NSString *pins = selectedObject;
        self.pincodeDropdown.text = pins;
        self.financierInsertQuoteModel.pincode = selectedValue;
    }
    
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray
{
    if (!array || [array count] < 1) {
        return;
    }
    
    DropDownViewController *dropDown;
    if (textField == self.txtTaluka) {
        dropDown = [[DropDownViewController alloc]initWithWidth:TALUKA_DROP_DOWN_WIDTH];
    }else{
        dropDown = [[DropDownViewController alloc] init];
    }
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)showPopOverTaluka:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {

    if (!array || [array count] < 1) {
        return;
    }
    DropDownViewController *dropDown = [[DropDownViewController alloc] initWithWidth:TALUKA_DROP_DOWN_WIDTH];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    
    if (textField == self.dobTextField ) {
        textField.inputView = [self dobDatePicker];
    }
    if (textField == self.txtPanNo) {
        self.txtPanNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    } else if (textField == self.txtCoApplicantPanNo) {
        self.txtCoApplicantPanNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    activeField = textField;
    fetchTaluka = YES;
    if (textField == self.txtTaluka && !fetchTaluka){
        if ([sortedTalukaArray count]> 0) {
            
        }
    } else if (textField == self.dobTextField) {
        [self setToolbarForPicker:dobDatePicker andCancelButtonHidden:false];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - textFiled delegate methods

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];

    if (length > 0) {
        NSDictionary *userInfo = @{@"Value_Changed": @"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",currentString];
    arrCurrentSearchTalukaData = [sortedTalukaArray filteredArrayUsingPredicate:predicate];
    
    if (textField == self.txtTaluka){
        
        if (self.txtTaluka.text.length >= 2) {
            if (self.txtTaluka.field.mValues.count >=1 && arrCurrentSearchTalukaData.count>=1) {
                [self showTalukaTableView];
                [self.txtTaluka reloadDropdownList_ForTalukaString:currentString];
            }
            else{
                if (length >= 2) {
                    [self APIactivityTypeForTalukaTextField:textField WithString:currentString AndStateCode: stateCode]; //new
                    
                    if ( arrCurrentSearchTalukaData.count ==0 && fetchTaluka == 0  ) {
                        [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                        [self removeTalukaTableView];
                    }
                }
            }
        }
        if (length ==0) {
            [self removeTalukaTableView];
        }
    }
    /* pan no not more than 10 */
    if (textField == self.txtPanNo) {
        if (length > 10)
            return NO;
    }

    if (textField == self.txtCoApplicantPanNo) {
        if (length > 10)
            return NO;
    }
    
    if (textField == self.txtCoApplicantMobileNo) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.txtCoApplicantPincode) {
        if (length > 6)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    //    [self validateContactFieldsToEnableSubmitButton];  //later has to use this method to enable buttonSubmit
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.txtTaluka) {
    }
    return YES;
}

//// Hide the taluka table
-(void)removeTalukaTableView{
    [self clearSelectedTalukadata];
    [self.txtTaluka hideDropDownFromView];
}

/// show the taluka table
-(void)showTalukaTableView{
    [self.txtTaluka showDropDownFromView];
}

#pragma mark - AutoCompleteUITextFieldDelegate Methods
- (void)selectedActionSender:(id)sender {
    [self endEditing:true];
    
    EGTaluka *taluka_object = [talukakeyWithModelDict objectForKey:self.txtTaluka.text];
    
    if (taluka_object && (taluka_object.talukaName.length > 0)) {
        self.txtTaluka.text = taluka_object.talukaName;
        self.financierInsertQuoteModel.taluka = self.txtTaluka.text;
        [self.pinCodeButton setEnabled:true];
    }
    
    if (taluka_object && (taluka_object.district.length > 0)) {
        self.txtDistrict.text = taluka_object.district;
        self.financierInsertQuoteModel.district = self.txtDistrict.text;  //new
    }
    
    if (taluka_object && (taluka_object.city.length > 0)) {
        self.txtCity.text = taluka_object.city;
        self.financierInsertQuoteModel.city_town_village = self.txtCity.text;  //new

    }
    [self checkIfMandatoryFieldsAreFilled];
    
   /* NSArray *listItems = [self.txtTaluka.text componentsSeparatedByString:@" - "];
    NSLog(@"listItems name:%@", listItems);
    
    if (listItems.count > 0) {
        self.txtTaluka.text = [listItems objectAtIndex:0];
        
        [self.pinCodeButton setEnabled:true];
    }
    if (listItems.count >=1) {
        self.txtDistrict.text = [listItems objectAtIndex:1];
        self.financierInsertQuoteModel.district = self.txtDistrict.text;  //new
        
    }
    if (listItems.count >=2) {
        self.txtCity.text = [listItems objectAtIndex:2];
        self.financierInsertQuoteModel.city_town_village = self.txtCity.text;  //new
    }*/
 }

#pragma mark - Private Methods

- (void)setupTalukaTextField {
    self.txtTaluka.autocompleteTableRowSelectedDelegate = self;
    self.txtTaluka.field = [[Field alloc] init];
}

- (void)getTalukaObjectForTalukaName:(NSString *)talukaName {

    NSLog(@"talukaName name:%@", talukaName);
    NSArray *listItems = [talukaName componentsSeparatedByString:@"-"];
    NSLog(@"listItems name:%@", listItems);
}

- (void)setTalukaValuesInTalukaField {
    [UtilityMethods RunOnBackgroundThread:^{
        [UtilityMethods RunOnOfflineDBThread:^{
            self.txtTaluka.field.mValues = [[sortedTalukaArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
            
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAutoCompleteTableForTalukaField];
            }];
        }];
    }];
}


- (void)showAutoCompleteTableForTalukaField {
    [self showTalukaTableView];

    if (sortedTalukaArray && [sortedTalukaArray count] > 0) {
    
        if (self.txtTaluka.field.mValues && [self.txtTaluka.field.mValues count] > 0) {
            CGRect aRect = CGRectMake(self.txtTaluka.frame.origin.x, self.txtTaluka.frame.origin.y , self.txtTaluka.frame.size.width*2, self.txtTaluka.frame.size.height);
            NSLog(@"%@", NSStringFromCGRect(self.superview.frame));
            
            [self.txtTaluka loadTableViewForFinancierTalukaTextFiled:aRect
                                                        onView:self
                                                     withArray:self.txtTaluka.field.mValues
                                                         atTop:true];
            [self.txtTaluka.resultTableView reloadData];
            
        } else {
            [self setTalukaValuesInTalukaField];
        }
    }
}

@end
