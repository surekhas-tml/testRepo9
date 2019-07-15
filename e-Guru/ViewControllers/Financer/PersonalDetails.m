//
//  PersonalDetails.m
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "PersonalDetails.h"
#import "NSDate+eGuruDate.h"
#import "FinancierRequestViewController.h"
#import "FinanciersDBHelpers.h"
#import "FinancierFieldDBHelper.h"

@implementation PersonalDetails
{
    AppDelegate *appDelegate;
    NSMutableArray *mBillingArray;
   
    UITapGestureRecognizer *tapRecognizer;
    BOOL makeExpiryDateMandatory;
    UIDatePicker *dobDatePicker;
    UIDatePicker *issueDatePicker;
    UIDatePicker *expiryDatePicker;
    UITextField *activeField;
}

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"PersonalDetails" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [self addSubview:nib];
//    [self addGestureRecogniserToView];
    makeExpiryDateMandatory = false;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self addGestureRecognizer:gestureRecognizer];
    
    self.sectionType = FinancierPersonalDetailsVw;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self setInitialDates];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_EA_Personal_Details];
}

- (void)hideKeyboard
{
    [self endEditing:YES];
}

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint {
    
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

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData andEntryPoint:(NSString *)entryPoint {
    self.financierInsertQuoteModel = fieldModelData;
    
//    if ([entryPoint isEqualToString:DRAFT]) {
//    } else{
        [self.titleDropDownField  setText:fieldModelData.title];
        [self.genderDD setText:fieldModelData.gender];
        [self.maritalDD setText:fieldModelData.partydetails_maritalstatus];
        [self.addressDD setText:fieldModelData.address_type];
        [self.religionDropDownField setText:fieldModelData.religion];
        [self.relationTypeDropDownField setText:fieldModelData.relation_type];
        [self.fatherNameTF setText:fieldModelData.father_mother_spouse_name];
        [self.idTypeDD setText:fieldModelData.id_type];
        [self.idDescTF setText:fieldModelData.id_description];
        [self.dobTextField setText:fieldModelData.date_of_birth];
        [self.issueTextField setText:fieldModelData.id_issue_date];
        [self.expiryTextField setText:fieldModelData.id_expiry_date];
        [self.fin_OccupationTF setText:fieldModelData.fin_occupation];
        [self.occupationTF setText:fieldModelData.fin_occupation_in_years];
        [self.partyAnualTF setText:fieldModelData.partydetails_annualincome];
//    }
}

- (FinancierInsertQuoteModel *)financierInsertQuoteModel {
    if (!_financierInsertQuoteModel) {
        _financierInsertQuoteModel = [[FinancierInsertQuoteModel alloc] init];
    }
    return _financierInsertQuoteModel;
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.titleDropDownField];
    [UtilityMethods setRedBoxBorder:self.genderDD];
    [UtilityMethods setRedBoxBorder:self.maritalDD];
    [UtilityMethods setRedBoxBorder:self.addressDD];
    [UtilityMethods setRedBoxBorder:self.religionDropDownField];
    [UtilityMethods setRedBoxBorder:self.relationTypeDropDownField];
    [UtilityMethods setRedBoxBorder:self.fatherNameTF];
    [UtilityMethods setRedBoxBorder:self.dobTextField];
    [UtilityMethods setRedBoxBorder:self.issueTextField];
    
    if ([_idTypeDD.text isEqualToString:@"Passport"] || [_idTypeDD.text isEqualToString:@"Driving Licence"]) {
        [UtilityMethods setRedBoxBorder:self.expiryTextField];
    }
    
    [UtilityMethods setRedBoxBorder:self.idTypeDD];
    [UtilityMethods setRedBoxBorder:self.idDescTF];
    [UtilityMethods setRedBoxBorder:self.fin_OccupationTF];
    [UtilityMethods setRedBoxBorder:self.occupationTF];
    [UtilityMethods setRedBoxBorder:self.partyAnualTF];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.titleDropDownField.text hasValue] &&
        [self.genderDD.text hasValue] &&
        [self.maritalDD.text hasValue] &&
        [self.addressDD.text hasValue] &&
        [self.religionDropDownField.text hasValue] &&
        [self.relationTypeDropDownField.text hasValue] &&
        [self.fatherNameTF.text hasValue] &&
        [self.dobTextField.text hasValue] &&
        [self.issueTextField.text hasValue] &&
        [self.idTypeDD.text hasValue] &&
        [self.idDescTF.text hasValue]  &&
        [self.fin_OccupationTF.text hasValue] &&
        [self.occupationTF.text hasValue] &&
        [self.partyAnualTF.text hasValue])
      {
          
        if (makeExpiryDateMandatory == true) {
            if ([self.expiryTextField.text hasValue]){
              mandatoryFieldsFilled = true;
            } else{
              mandatoryFieldsFilled = false;
            }
            
        } else{
           mandatoryFieldsFilled = true;
        }
        
    }
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

#pragma mark - DatePicker Methods
-(void)setInitialDates
{
    [self dobDatePicker];
    [self issueDatePicker];
    [self expiryDatePicker];
}

-(UIDatePicker *)issueDatePicker{
    if (issueDatePicker != nil) {
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//        [offsetComponents setDay:-1];
//        NSDate *maxdate = [gregorian dateByAddingComponents:offsetComponents toDate:issueDatePicker.date options:0];
        
        [issueDatePicker setMaximumDate:[NSDate date]];
        self.tappedView = issueDatePicker;
        return issueDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate date] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        
        issueDatePicker = datePickerNew;
        self.tappedView = issueDatePicker;
        [self setToolbarForPicker:issueDatePicker andCancelButtonHidden:false];
        return issueDatePicker;
    }
}

-(UIDatePicker *)expiryDatePicker{
    if (expiryDatePicker != nil) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        NSDate *maxdate = [gregorian dateByAddingComponents:offsetComponents toDate:issueDatePicker.date options:0];
        
        [expiryDatePicker setMinimumDate:maxdate];
//        [expiryDatePicker setMinimumDate:issueDatePicker.date];
        self.tappedView = expiryDatePicker;
        return expiryDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        
        expiryDatePicker = datePickerNew;
        [expiryDatePicker setMinimumDate:issueDatePicker.date];
        self.tappedView = expiryDatePicker;
        [self setToolbarForPicker:expiryDatePicker andCancelButtonHidden:false];
        return expiryDatePicker;
    }
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
        //      [datePickerNew addTarget:self action:@selector(onFromDatePickerValueChanged:)     forControlEvents:UIControlEventValueChanged];
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
    } else if (_tappedView == issueDatePicker){
        self.issueTextField.inputAccessoryView = self.toolbar;
    } else if ( _tappedView == expiryDatePicker){
        self.expiryTextField.inputAccessoryView = self.toolbar;
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
    [issueDatePicker removeFromSuperview];
    [expiryDatePicker removeFromSuperview];
    
    self.dobTextField.inputAccessoryView = nil;
    self.issueTextField.inputAccessoryView = nil;
    self.expiryTextField.inputAccessoryView = nil;
    
    [self.dobTextField resignFirstResponder];
    [self.issueTextField resignFirstResponder];
    [self.expiryTextField resignFirstResponder];
}

- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (self.tappedView == dobDatePicker) {
        [self.dobTextField setText:[NSDate formatDate:[dobDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
         self.financierInsertQuoteModel.date_of_birth = self.dobTextField.text;
        
    } else if (self.tappedView == issueDatePicker){
        [self.issueTextField setText:[NSDate formatDate:[issueDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
        self.financierInsertQuoteModel.id_issue_date = self.issueTextField.text;
        [self.expiryTextField setText:@""];
        self.financierInsertQuoteModel.id_expiry_date = @"";
        
    } else if (self.tappedView == expiryDatePicker){
        [self.expiryTextField setText:[NSDate formatDate:[expiryDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
        self.financierInsertQuoteModel.id_expiry_date = self.expiryTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    [self checkIfMandatoryFieldsAreFilled];
}

#pragma mark- Button Events
-(void)textFieldButtonClicked:(id)sender {
    [activeField resignFirstResponder];
//    NSDictionary *userInfo = @{@"ValueChanged": @YES};
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];

    switch ([sender tag]) {
        case 11:
            [self fetchTitle:_titleDropDownField];
            break;
        case 12:
            if (![_titleDropDownField.text hasValue]) {
                [UtilityMethods alert_ShowMessage:@"Please select Title" withTitle:APP_NAME andOKAction:^{
                }];
            } else {
                [self fetchGender:_genderDD];
            }
    
            break;
        case 13:
            [self fetchMaritalStatus:_maritalDD];
            break;
        case 14:
            [self fetchAddressType:_addressDD];
            break;
        case 15:
            [self fetchReligion:_religionDropDownField];
            break;
        case 16:
            [self fetchIDType:_idTypeDD];
            break;
        case 17:
            [self fetchRelationType:_relationTypeDropDownField];
            break;
        
        default:
            break;
    }
}

- (DropDownTextField *)titleDropDownField {
    if (!_titleDropDownField.field) {
        _titleDropDownField.field = [[Field alloc] init];
    }
    return _titleDropDownField;
}

- (DropDownTextField *)genderDropDownField {
    if (!_genderDD.field) {
        _genderDD.field = [[Field alloc] init];
    }
    return _genderDD;
}

- (DropDownTextField *)maritalDropDownField {
    if (!_maritalDD.field) {
        _maritalDD.field = [[Field alloc] init];
    }
    return _maritalDD;
}

- (DropDownTextField *)addressDropDownField {
    if (!_addressDD.field) {
        _addressDD.field = [[Field alloc] init];
    }
    return _addressDD;
}
- (DropDownTextField *)religionDropDownField {
    if (!_religionDropDownField.field) {
        _religionDropDownField.field = [[Field alloc] init];
    }
    return _religionDropDownField;
}

- (DropDownTextField *)relationTypeDropDownField {
    if (!_relationTypeDropDownField.field) {
        _relationTypeDropDownField.field = [[Field alloc] init];
    }
    return _relationTypeDropDownField;
}

- (DropDownTextField *)idTypeDDField {
    if (!_idTypeDD.field) {
        _idTypeDD.field = [[Field alloc] init];
    }
    return _idTypeDD;
}

#pragma mark - Database Calls

- (void)fetchTitle:(DropDownTextField *)textField {
    
    if (titleArray && [titleArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [titleArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchTitle] mutableCopy];
        //&& arr.count > 0
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                titleArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [titleArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];

                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
//        else{
//            [UtilityMethods hideProgressHUD];
//            [UtilityMethods alert_ShowMessage:@"No Data Found" withTitle:APP_NAME andOKAction:^{
//            }];
//        }
        
    }];
}

- (void)fetchGender:(DropDownTextField *)textField {
    if (genderArray && [genderArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [genderArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        if ([_titleDropDownField.text isEqualToString:@"Miss."] || [_titleDropDownField.text isEqualToString:@"Mrs."]) {
            [arrSorted removeObjectAtIndex: 1];
        } else if([_titleDropDownField.text isEqualToString:@"Mr."]) {
            [arrSorted removeObjectAtIndex: 0];
        }
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchGender] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                genderArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [genderArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                if ([_titleDropDownField.text isEqualToString:@"Miss."] || [_titleDropDownField.text isEqualToString:@"Mrs."]) {
                    [arrSorted removeObjectAtIndex: 1];
                } else if([_titleDropDownField.text isEqualToString:@"Mr."]) {
                    [arrSorted removeObjectAtIndex: 0];
                }
                
                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

- (void)fetchMaritalStatus:(DropDownTextField *)textField {
    if (maritalArray && [maritalArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [maritalArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchMarritalStatus] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                maritalArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [maritalArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

- (void)fetchAddressType:(DropDownTextField *)textField {
    if (addresArray && [addresArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [addresArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAddressType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                addresArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [addresArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
 
                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}


- (void)fetchReligion:(DropDownTextField *)textField {
    if (religionArray && [religionArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [religionArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];

        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchReligion] mutableCopy];
        //        VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
        //        NSMutableArray *arr = [[vcNumberDBHelper fetchAllLOB] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                religionArray = [arr mutableCopy];
               
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [religionArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

-(void)fetchRelationType:(DropDownTextField *)textField {
    if (relationTypeArray && [relationTypeArray count] > 0) {
        [self showPopOver:textField withDataArray:relationTypeArray andModelData:relationTypeArray];
        return;
    }
    NSArray * arr ;
    arr = [NSMutableArray arrayWithObjects: @"Father", @"Mother", @"Spouse",@"Others", nil];
    [UtilityMethods hideProgressHUD];
    relationTypeArray = [arr mutableCopy];
    [self showPopOver:textField withDataArray:relationTypeArray andModelData:relationTypeArray];
}

- (void)fetchIDType:(DropDownTextField *)textField {
    if (idTypeArray && [idTypeArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [idTypeArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchIDType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                idTypeArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [idTypeArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
            }];
        }
    }];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray
{
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;

        if (textField ==self.titleDropDownField) {
            _genderDD.text = @"";
            self.titleDropDownField.text = selectedValue;
            self.financierInsertQuoteModel.title = self.titleDropDownField.text;
            [self checkIfMandatoryFieldsAreFilled];
            
        } else if (textField ==self.genderDD){
            self.genderDD.text = selectedValue;
            self.financierInsertQuoteModel.gender = self.genderDD.text;
            [self checkIfMandatoryFieldsAreFilled];
        } else if (textField ==self.maritalDD){
            self.maritalDD.text = selectedValue;
            self.financierInsertQuoteModel.partydetails_maritalstatus = self.maritalDD.text;
            [self checkIfMandatoryFieldsAreFilled];
        }else if (textField ==self.addressDD){
            self.addressDD.text = selectedValue;
            self.financierInsertQuoteModel.address_type = self.addressDD.text;
            [self checkIfMandatoryFieldsAreFilled];
        }else if (textField ==self.religionDropDownField){
            self.religionDropDownField.text = selectedValue;
            self.financierInsertQuoteModel.religion = self.religionDropDownField.text;
            [self checkIfMandatoryFieldsAreFilled];
        } else if (textField ==self.relationTypeDropDownField){
            self.relationTypeDropDownField.text = selectedValue;
            self.financierInsertQuoteModel.relation_type = self.relationTypeDropDownField.text;
            [self checkIfMandatoryFieldsAreFilled];
        }
        else if (textField ==self.idTypeDD){
            
            if ([selectedValue isEqualToString:@"Driving Licence"] || [selectedValue isEqualToString:@"Passport"]) {
                [UtilityMethods setRedBoxBorder:self.expiryTextField];
                makeExpiryDateMandatory = true;
            }
            else{
                [UtilityMethods setGreyBoxBorder:self.expiryTextField];
                makeExpiryDateMandatory = false;
            }
            
            self.idTypeDD.text = selectedValue;
            self.financierInsertQuoteModel.id_type = self.idTypeDD.text;
            
            [self.expiryTextField setText:@""];
            [self.issueTextField setText:@""];
            self.financierInsertQuoteModel.id_issue_date = @"";
            self.financierInsertQuoteModel.id_expiry_date = @"";
            
            [self checkIfMandatoryFieldsAreFilled];
        }
    }
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.dobTextField) {
        self.financierInsertQuoteModel.date_of_birth = self.dobTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    } else if (textField == self.fatherNameTF) {
        self.financierInsertQuoteModel.father_mother_spouse_name = self.fatherNameTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    } else if (textField == self.idDescTF) {
        self.financierInsertQuoteModel.id_description = self.idDescTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    } else if (textField == self.issueTextField) {
        self.financierInsertQuoteModel.id_issue_date = self.issueTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.expiryTextField) {
        self.financierInsertQuoteModel.id_expiry_date = self.expiryTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.fin_OccupationTF) {
        self.financierInsertQuoteModel.fin_occupation = self.fin_OccupationTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    }else if (textField == self.occupationTF) {
        self.financierInsertQuoteModel.fin_occupation_in_years = self.occupationTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    } else if (textField == self.partyAnualTF) {
        self.financierInsertQuoteModel.partydetails_annualincome = self.partyAnualTF.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    
    if (textField == self.issueTextField) {
        textField.inputView = [self issueDatePicker];
    } else if (textField == self.expiryTextField){
        textField.inputView = [self expiryDatePicker];
    } else if (textField == self.dobTextField ) {
        textField.inputView = [self dobDatePicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.dobTextField) {
        // Toolbar
        [self setToolbarForPicker:dobDatePicker andCancelButtonHidden:false];
    } else if(textField == self.issueTextField){
        [self setToolbarForPicker:issueDatePicker andCancelButtonHidden:false];
    } else if(textField == self.expiryTextField){
        [self setToolbarForPicker:expiryDatePicker andCancelButtonHidden:false];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [activeField resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];

    if (length > 0) {
        NSDictionary *userInfo = @{@"Value_Changed": @"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    }
    
    if (textField == self.occupationTF) {
        if (length > 2)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    
    } else if (textField == self.partyAnualTF) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    return YES;
}

@end
