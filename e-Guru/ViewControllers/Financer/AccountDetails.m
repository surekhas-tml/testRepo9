//
//  AccountDetails.m
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AccountDetails.h"
#import "FinancierRequestViewController.h"
#import "FinanciersDBHelpers.h"
#import "FinancierFieldDBHelper.h"

@implementation AccountDetails
{
    AppDelegate *appDelegate;
    AppDelegate *appdelegate;
    
    AutoCompleteUITextField * autoComplete_textField;
    NSMutableArray* accountTypeArray;
    NSMutableArray *mBillingArray;
    NSArray *talukaArray;
    NSArray *arrCurrentSearchTalukaData;
    NSMutableDictionary * talukakeyWithModelDict;
    NSMutableArray *sortedTalukaArray;
    NSMutableArray* stateArray;
    NSArray *sortedModelArr;
    
    UITextField *activeField;
    NSString *stateCode;
    BOOL fetchTaluka;
    BOOL isAccountDetailMandatory;
    EGRKWebserviceRepository *currentTalukaOperation;
}

- (void)loadUIFromXib {
    
    UIView *nib =[[[UINib nibWithNibName:@"AccountDetails" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    
    fetchTaluka = YES;
    [self setupFinancierTextField];
    
    _individualSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);

    self.sectionType = FinancierAccountDetailsVw;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_EA_Account_Details];
}

- (void)setupFinancierTextField {
    self.talukaTextField.autocompleteTableRowSelectedDelegate = self;
    self.talukaTextField.field = [[Field alloc] init];
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

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(FinancierInsertQuoteModel *)model andEntryPoint:(NSString *)entryPoint {
    
    [self bindDataToFieldsFromModel:model andEntryPoint:entryPoint];
    
    switch (mode) {
        case FinancierModeCreate:
            [self setUserInteractionEnabled:true];

            if ([model.account_name isEqualToString:@""] || ![model.account_name hasValue] ) {
                isAccountDetailMandatory = NO;
            } else{
                isAccountDetailMandatory = YES;
                [self markMandatoryFields];
            }
            break;
        case FinancierModeDisplay:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:false];
            break;
    }
}

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData andEntryPoint:(NSString *)entryPoint{

    if (!fieldModelData) {
        return;
    }
    self.financierInsertQuoteModel = fieldModelData;
    
    [self.accountNametextField      setText:fieldModelData.account_name];
    [self.accountSiteTextFieldField setText:fieldModelData.account_site];
    [self.accountNoTextField        setText:fieldModelData.account_number];
    [self.panNoCompanyTF            setText:fieldModelData.account_pan_no_company];
    [self.accountTypeDropDownField  setText:fieldModelData.account_type];
    [self.stateDropDown             setText:fieldModelData.account_state];
    [self.talukaTextField           setText:fieldModelData.account_tahsil_taluka];
    [self.districtTextField         setText:fieldModelData.account_district];
    [self.cityTextField             setText:fieldModelData.account_city_town_village];
    [self.pinCodeDropDown           setText:fieldModelData.account_pincode];
    [self.add1TextField             setText:fieldModelData.account_address1];
    [self.add2TextField             setText:fieldModelData.account_address2];
    
    if ([fieldModelData.cust_loan_type isEqualToString:@""] || fieldModelData.cust_loan_type == nil) {
        self.financierInsertQuoteModel.cust_loan_type = @"Individual";
        [self.individualSwitch setOn:NO];
    } else{
        self.financierInsertQuoteModel.cust_loan_type = fieldModelData.cust_loan_type != nil ? fieldModelData.cust_loan_type :@"";
        
        if ([self.financierInsertQuoteModel.cust_loan_type isEqualToString:@"Individual"]) {
            [self.individualSwitch setOn:NO];
        } else{
            [self.individualSwitch setOn:YES];
        }
        
    }
    
}

- (void)markMandatoryFields {

    if ([self.accountNametextField.text hasValue]){
        [UtilityMethods setRedBoxBorder:self.accountTypeDropDownField];
        [UtilityMethods setRedBoxBorder:self.accountNametextField];
        [UtilityMethods setRedBoxBorder:self.accountSiteTextFieldField];
        [UtilityMethods setRedBoxBorder:self.accountNoTextField];
        [UtilityMethods setRedBoxBorder:self.panNoCompanyTF];
        [UtilityMethods setRedBoxBorder:self.stateDropDown];
        [UtilityMethods setRedBoxBorder:self.talukaTextField];
        [UtilityMethods setRedBoxBorder:self.districtTextField];
        [UtilityMethods setRedBoxBorder:self.cityTextField];
        [UtilityMethods setRedBoxBorder:self.add1TextField];
    }
    
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
  
    if (isAccountDetailMandatory) {
        
        if ( [self.accountNametextField.text hasValue] &&
            [self.accountSiteTextFieldField.text hasValue] && [self.accountNoTextField.text hasValue] && [self.panNoCompanyTF.text hasValue] &&
            [self.accountTypeDropDownField.text hasValue] && [self.stateDropDown.text hasValue] && [self.talukaTextField.text hasValue] &&
            [self.districtTextField.text hasValue] && [self.cityTextField.text hasValue] && [self.add1TextField.text hasValue])
        {
            if ([self isTextFieldDataValid]) {
                mandatoryFieldsFilled = true;
            }
        } else {
            mandatoryFieldsFilled = false;
        }
    } else {
        if ([_individualSwitch isOn]) {
            [UtilityMethods alert_ShowMessage:@"If you are selecting corporate customer then please make sure account is already linked with opportunity.In case account is not linked then link the same from manage opportunity first." withTitle:APP_NAME andOKAction:^{
            }];
            mandatoryFieldsFilled = false;
        }
        else {
            mandatoryFieldsFilled = true;
        }
    }
   
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
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
    if ([self.panNoCompanyTF.text isEqualToString:@""] || ![UtilityMethods validatePanNumber:self.panNoCompanyTF.text]){
        *warningMessage_p = @"Please enter valid company Pan Number";
        return NO;
    }
    return YES;
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

#pragma mark-Button Events
-(void)textFieldButtonClicked:(id)sender {
    [activeField resignFirstResponder];
    
    switch ([sender tag]) {
        case 121:
            [self fetchAccountType:_accountTypeDropDownField];
            break;
        case 122:
            [self fetchAllStates:_stateDropDown];
            break;
        case 123:
            [self pincodeFieldBeingEditted];
            break;
            
        default:
            break;
    }
}

- (IBAction)toggleButtonClicked:(UISwitch *)sender {
    
    if ([sender isOn]) {
        _corporateLabel.textColor = [UIColor colorWithRed:27/255.0 green:113/255.0 blue:183/255.0 alpha:1.0];
        _individualLabel.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
        self.financierInsertQuoteModel.cust_loan_type = @"corporate";
        [self checkIfMandatoryFieldsAreFilled];
    } else {
        _corporateLabel.textColor  = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
        _individualLabel.textColor = [UIColor colorWithRed:27/255.0 green:113/255.0 blue:183/255.0 alpha:1.0];
        self.financierInsertQuoteModel.cust_loan_type = @"Individual";
        [self checkIfMandatoryFieldsAreFilled];
    }
}

#pragma mark- API Calls

- (void)fetchAllStates:(DropDownTextField *)textField {
    
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
                        //                        [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@ - %@" , tal.talukaName ,tal.district, tal.city , tal.state.code]];
                        [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]];
                        [talukakeyWithModelDict setObject:tal forKey:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]];
                    }
                    //Sorting in Ascending order to show popup
                    
                    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                    NSArray *sortedTaluka = [talArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    sortedTalukaArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                  
                    self.talukaTextField.field.mValues = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                    fetchTaluka = NO;
                    
                    if ([sortedTalukaArray count]> 0) {
                        [self  showAutoCompleteTableForTalukaField];
//                        [self showPopOverTaluka:textField withDataArray:sortedTalukaArray andModelData:[NSMutableArray arrayWithArray:talukaArray]];
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
    if (self.talukaTextField.text.length > 0 && self.stateDropDown.text.length > 0 ) {
        
        [self.pinCodeDropDown addSubview:[self actIndicatorForView:self.pinCodeDropDown]];
        [self.actIndicator stopAnimating];
        [self.actIndicator startAnimating];
        
        [[EGRKWebserviceRepository sharedRepository]getPinFromTalukaCityDistrictState:
                                     @{ @"state"     : @{@"state":self.stateDropDown.text ? : @"", @"code":stateCode ? :@""},
                                        @"district"  : self.districtTextField.text,
                                        @"city"      : self.cityTextField.text,
                                        @"taluka"    : self.talukaTextField.text
                                        }
                                      andSucessAction:^(id pin) {
                                          [self.actIndicator stopAnimating];
                                          [self pinCodeFetchedSuccessfullyWithDictionary:pin];
                                          
                                      } andFailuerAction:^(NSError *error) {
                                          [self pinCodeFetchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
                                      }];
    } else{
        if (self.talukaTextField.text.length > 0){
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
        [self showPopOver:self.pinCodeDropDown withDataArray:array andModelData:array];
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

- (void)fetchAccountType:(DropDownTextField *)textField {
    
    if (accountTypeArray && [accountTypeArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [accountTypeArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAccountType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                accountTypeArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [accountTypeArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];

                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray
{
    if (!array || [array count] < 1) {
        return;
    }
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView
{
//    activeField.text = selectedValue;
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if ([dropDownForView isEqual:self.accountTypeDropDownField]) {
        self.accountTypeDropDownField.text = selectedValue;
        self.financierInsertQuoteModel.account_type = self.accountTypeDropDownField.text;
        [self checkIfMandatoryFieldsAreFilled];
    
    }
    else if([dropDownForView isEqual:self.stateDropDown]){
        self.stateDropDown.text = selectedValue;
        stateCode = selectedObject;
        self.financierInsertQuoteModel.account_state = selectedValue;
        [self.talukaTextField setEnabled:true];
        [self clearSelectedTalukadata];
        [self checkIfMandatoryFieldsAreFilled];
    }
    /* may be not in use */
    else if([dropDownForView isEqual:self.talukaTextField]){
        EGTaluka *tal = (EGTaluka *)selectedObject;
        self.talukaTextField.text        = tal.talukaName;
        self.districtTextField.text      = tal.district;
        self.cityTextField.text          = tal.city;
        self.financierInsertQuoteModel.taluka = tal.talukaName;
        
        [self checkIfMandatoryFieldsAreFilled];
        [self.pinCodeButton setEnabled:true];
        
    }
    else if([dropDownForView isEqual:self.pinCodeDropDown]) {
        NSString *pins = selectedObject;
        self.pinCodeDropDown.text = pins;
        self.financierInsertQuoteModel.pincode = selectedValue;
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    activeField = textField;
    fetchTaluka = YES;
    if (textField == self.talukaTextField && !fetchTaluka){
        if ([sortedTalukaArray count]> 0) {
        }
    }
    if (textField == self.panNoCompanyTF) {
        self.panNoCompanyTF.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
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
    
    if (textField == self.talukaTextField ){
        
        if (self.talukaTextField.text.length >= 2) {
            if (self.talukaTextField.field.mValues.count >=1 && arrCurrentSearchTalukaData.count>=1) {
                [self showTalukaTableView];
                [self.talukaTextField reloadDropdownList_ForTalukaString:currentString];
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
    if (textField == self.panNoCompanyTF) {
        if (length > 10)
            return NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
//    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        if (autoComplete_textField.resultTableView) {
            [autoComplete_textField.resultTableView removeFromSuperview];
        }
    }
    
    if (textField == self.accountNametextField) {
        self.financierInsertQuoteModel.account_name = self.accountNametextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.accountSiteTextFieldField) {
        self.financierInsertQuoteModel.account_site = self.accountSiteTextFieldField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.accountNoTextField) {
        self.financierInsertQuoteModel.account_number = self.accountNoTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.panNoCompanyTF) {
        self.financierInsertQuoteModel.account_pan_no_company = self.panNoCompanyTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.talukaTextField) {
        self.financierInsertQuoteModel.account_tahsil_taluka = self.talukaTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.districtTextField) {
        self.financierInsertQuoteModel.account_district = self.districtTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.cityTextField) {
        self.financierInsertQuoteModel.account_city_town_village = self.cityTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.pinCodeDropDown) {
        self.financierInsertQuoteModel.account_pincode = self.pinCodeDropDown.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.add1TextField) {
        self.financierInsertQuoteModel.account_address1 = self.add1TextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.add2TextField) {
        self.financierInsertQuoteModel.account_address2 = self.add2TextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
//    else if (textField == self.stateDropDown) {
//        self.financierInsertQuoteModel.account_state = self.stateDropDown.text;
//        [self checkIfMandatoryFieldsAreFilled];
//    }
    
}


-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.talukaTextField) {
        // [self clearAllTextFiledsInView:self.addressDetailsView];
    }
    return YES;
}

-(void)clearSelectedTalukadata{
    self.talukaTextField.field.mValues = nil;
    self.talukaTextField.text = nil;
    self.districtTextField.text = nil;
    self.cityTextField.text = nil;
    [self.talukaTextField hideDropDownFromView];
}


//// Hide the taluka table

-(void)removeTalukaTableView{
    [self clearSelectedTalukadata];
    [self.talukaTextField hideDropDownFromView];
}

/// show the taluka table
-(void)showTalukaTableView{
    [self.talukaTextField showDropDownFromView];
}

#pragma mark - AutoCompleteUITextFieldDelegate Methods
- (void)selectedActionSender:(id)sender {
    [self endEditing:true];
    
    EGTaluka *taluka_object = [talukakeyWithModelDict objectForKey:self.talukaTextField.text];
    

    for (EGTaluka *tal in talukaArray) {
        
        if ([self.talukaTextField.text isEqualToString:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]])
        {
            NSLog(@"Equal data found ");
            NSLog(@"selected data  %@",[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]);
            self.talukaTextField.text = tal.talukaName;
            self.districtTextField.text = tal.district;
            self.cityTextField.text = tal.city;
        }
    if (taluka_object && (taluka_object.talukaName.length > 0)) {
        self.talukaTextField.text = taluka_object.talukaName;
        self.financierInsertQuoteModel.account_tahsil_taluka = self.talukaTextField.text;
        [self.pinCodeButton setEnabled:true];
    }
    
    if (taluka_object && (taluka_object.district.length > 0)) {
        self.districtTextField.text = taluka_object.district;
        self.financierInsertQuoteModel.account_district = self.districtTextField.text;
    }
    
    if (taluka_object && (taluka_object.city.length > 0)) {
        self.cityTextField.text = taluka_object.city;
        self.financierInsertQuoteModel.account_city_town_village = self.cityTextField.text;

    }
    
    [self checkIfMandatoryFieldsAreFilled];
    
}
}
#pragma mark - Private Methods

- (void)setupTalukaTextField {
    self.talukaTextField.autocompleteTableRowSelectedDelegate = self;
    self.talukaTextField.field = [[Field alloc] init];
}

- (void)getTalukaObjectForTalukaName:(NSString *)talukaName {

    NSLog(@"talukaName name:%@", talukaName);
    NSArray *listItems = [talukaName componentsSeparatedByString:@"-"];
    NSLog(@"listItems name:%@", listItems);
}

- (void)setTalukaValuesInTalukaField {
    [UtilityMethods RunOnBackgroundThread:^{
        [UtilityMethods RunOnOfflineDBThread:^{
            self.talukaTextField.field.mValues = [[sortedTalukaArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
            
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
        
        if (self.talukaTextField.field.mValues && [self.talukaTextField.field.mValues count] > 0) {
            CGRect aRect = CGRectMake(self.talukaTextField.frame.origin.x, self.talukaTextField.frame.origin.y , self.talukaTextField.frame.size.width*2, self.talukaTextField.frame.size.height);
           
            [self.talukaTextField loadTableViewForFinancierTalukaTextFiled:aRect
                                                                   onView:self
                                                                withArray:self.talukaTextField.field.mValues
                                                                    atTop:true];

            [self.talukaTextField.resultTableView reloadData];
            
        } else {
            [self setTalukaValuesInTalukaField];
        }
    }
}

@end
