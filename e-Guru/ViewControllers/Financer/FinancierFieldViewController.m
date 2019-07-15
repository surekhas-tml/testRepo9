//
//  FinancierFieldViewController.m
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierFieldViewController.h"
#import "NSString+NSStringCategory.h"
#import "PPLwiseViewController.h"
#import "FinancierListViewController.h"
#import "MBProgressHUD.h"

#import "FinanciersDBHelpers.h"
#import "EventDBHelper.h"
#import "VCNumberDBHelper.h"
#import "FinancierFieldDBHelper.h"
#import "EGPagedArray.h"
#import "AsyncLocationManager.h"
#import "FinancierSearchCollectionViewCell.h"
#import "NSDate+eGuruDate.h"

#import "FinancierListDetails.h"
#import "FinancierOptyDetails.h"
#import "FinancierContactDetails.h"
#import "FinancierAccountDetails.h"
#import "Home_LandingPageViewController.h"
#import "FinancierFieldViewController+Validations.m"
#import <QuartzCore/QuartzCore.h>
#import "FinancierListDetailModel.h"


#define datePickerHeight 300

@interface FinancierFieldViewController (){
    
    AppDelegate *appdelegate;
    UILabel *lbl;
    
    BOOL multipleSelection;

    //need to chnge
    EGLob *selectedLOBObj;
    
    UITextField *activeField;
    
    NSMutableArray *financierListArray;
    NSMutableArray *arrayWithoutDuplicates;
    
    UIDatePicker *dobDatePicker;
    UIDatePicker *issueDatePicker;
    UIDatePicker *expiryDatePicker;
    UITapGestureRecognizer *tapRecognizer;
    
}

@property (nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) UIToolbar     *toolbar;
@property (nonatomic, strong) EGPagedArray  *fieldDetailsArray;

@end

@implementation FinancierFieldViewController

//@synthesize otpTextfield;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"financierOpty is%@", _financierOpportunity);
    
    if (!_financierOpportunity.isQuoteSubmittedToFinancier) {
      multipleSelection = NO;
    } else{
       multipleSelection = YES;
       [self fetchFinancierQuoteAPI];
    }
  
    _otpBlurrView.hidden = true;
    financierListArray      = [[NSMutableArray alloc] init];
    arrayWithoutDuplicates  = [[NSMutableArray alloc] init];
    
    [self setUpOTPTextfields];
    [self setInitialDates];
//    [self addGestureToDropDownFields];
//    [self addGestureRecogniserToView];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_FinancierField];
}

//OTP View Textfields
-(void)setUpOTPTextfields{
    
    [self SetTextFieldBorder:_txt1];
    [self SetTextFieldBorder:_txt2];
    [self SetTextFieldBorder:_txt3];
    [self SetTextFieldBorder:_txt4];
    [self SetTextFieldBorder:_txt5];
    [self SetTextFieldBorder:_txt6];
    
    [_txt1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt5 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txt6 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        NSLog(@"back button pressed");
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [self configureView];
    [self makeRedbox_mandatoryFields];
}

- (void)configureView {
    self.navigationController.title = FINANCER_Field_DETAIL;
    [UtilityMethods navigationBarSetupForController:self];
}


#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    //    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(gestureHandlerMethod:)];
    //    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(gestureHandlerMethodToDissmissOTPView:)];
    
    //    tapRecognizer.delegate = self;
    //    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer *)gesture{
    [activeField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
        return YES;
    }
    return NO;
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
        //validate dates
//        [issueDatePicker setMaximumDate:[NSDate date]];
//        if (issueDatePicker.date > expiryDatePicker.date) {
//            [expiryDatePicker setMinimumDate:issueDatePicker.date];
//            self.expiryTextField.text = @"";
//        }
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
        self.expiryTextField.text = @"";
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
    if (dobDatePicker != nil) {
        [dobDatePicker setMaximumDate:[NSDate date]];
        self.tappedView = dobDatePicker;
        return dobDatePicker;
    } else {
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate date] animated:YES];
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
        self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
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
    if (self.tappedView == dobDatePicker) {
        [self.dobTextField setText:[NSDate formatDate:[dobDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    } else if (self.tappedView == issueDatePicker){
        [self.issueTextField setText:[NSDate formatDate:[issueDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    } else if (self.tappedView == expiryDatePicker){
        [self.expiryTextField setText:[NSDate formatDate:[expiryDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
        [self validations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning");
}

#pragma mark: Button Events

- (IBAction)submitFinancierClicked:(id)sender {
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_InsertQuote_Submit_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:nil];
    // [self submitFinancierAPI];
    
    if ([self fieldInputValid]) {
        if ([self isTextFieldDataValid]) {
              [self sendOtpAPI];
        }
    }
    
}

- (IBAction)btnResendClicked:(id)sender {
    [self cleartextfield];
    [self sendOtpAPI];
}

- (IBAction)btnValidateClicked:(id)sender {
//    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_ValidateOTP withEventCategory:GA_CL_Financier withEventResponseDetails:nil];
    if ([self otpTextFieldValid]) {
        [self verifyOtpAPI];
    }
}

- (IBAction)btnCancelClicked:(id)sender {
    [self hidePopupView];
}

#pragma mark -  APICalls

- (void)fetchFinancierQuoteAPI {

    NSDictionary *dict = @{@"opty_id": self.financierOpportunity.optyID};
//    NSDictionary *dict = @{@"opty_id":@"1-ACZFZQU"};
    
    [[EGRKWebserviceRepository sharedRepository] fetchFinancier:dict
                                                   andSuccessAction:^(EGPagination *financierFieldObj) {
                                                       
                                                    [UtilityMethods hideProgressHUD];
                                                       
        
//                                                NSString  *offset = [dict objectForKey:@"offset"];
//                                                if ([offset integerValue] == 0) {
//                                        //            [self.pArray clearAllItems];
//                                                }
                                                [self loadResultInArray:financierFieldObj];
                                                
                                            } andFailuerAction:^(NSError *error) {
                                                [UtilityMethods hideProgressHUD];
                                            }];
}


- (void)loadResultInArray:(EGPagination *)paginationObj {

    _fieldDetailsArray  = [EGPagedArray mergeWithCopy:self.fieldDetailsArray withPagination:paginationObj];
    if ([_fieldDetailsArray count] == 0) {
        
    }else{
        self.financierListModel = [_fieldDetailsArray objectAtIndex:0];
//        [self bindPersonalFieldFromFetchQuoteModel:_financierListModel];
//        [self bindLoanDetailsFromFetchQuoteModel:_financierListModel];
    }
}

//- (void)bindPersonalFieldFromFetchQuoteModel:(FinancierListDetailModel *)fieldModelData {
////        FinancierContactDetails *contact = self.financierOpportunity.toFinancierContact;
//    
//        [self.titleDropDownField  setText:fieldModelData.title];
//        [self.genderDD setText:fieldModelData.gender];
//        [self.maritalDD setText:fieldModelData.partydetails_maritalstatus];
//        [self.addressDD setText:fieldModelData.address_type];
//        [self.dobTextField setText:fieldModelData.date_of_birth];
//        [self.fatherNameTF setText:fieldModelData.father_mother_spouse_name];
//        [self.areaTF setText:fieldModelData.area];
//        [self.religionDropDownField setText:fieldModelData.religion];
//}

- (void)bindLoanDetailsFromFetchQuoteModel:(FinancierListDetailModel *)fieldModelData {
    
    [self.accountTypeDropDownField  setText:fieldModelData.account_type];
    [self.onRoadPriceTF setText:fieldModelData.on_road_price_total_amt];
    [self.exShowroomTF setText:fieldModelData.ex_showroom_price];
    [self.vehicleClassTF setText:fieldModelData.vehicle_class];
    [self.vehicleColorDropDownField setText:fieldModelData.vehicle_color];
    [self.emmisionNormsDropDownField setText:fieldModelData.emission_norms];
    [self.customerCategoryDropDownField setText:fieldModelData.customer_category];
    [self.customerSubCategoryDDField setText:fieldModelData.customer_subcategory];
    [self.idDescTF setText:fieldModelData.id_description];
    [self.issueTextField setText:fieldModelData.id_issue_date];
    [self.expiryTextField setText:fieldModelData.id_expiry_date];
    [self.idTypeDD setText:fieldModelData.id_type];
    [self.address1TF setText:fieldModelData.address1];
    [self.address2TF setText:fieldModelData.address2];
    [self.loanDetailsTF setText:fieldModelData.loandetails_repayableinmonths];
    [self.repaymentModeTF setText:fieldModelData.repayment_mode];
    [self.panNoCompanyTF setText:fieldModelData.pan_no_company];
    [self.panNoIndividual setText:fieldModelData.pan_no_indiviual];
    [self.indicativeLoanTF setText:fieldModelData.inidcative_loan_amt];
    [self.loanTenorTF setText:fieldModelData.loan_tenor];
    [self.partyDetail setText:fieldModelData.partydetails_occupation];
    [self.partyAnualTF setText:fieldModelData.partydetails_annualincome];
    
}


- (void)fetchFinanciers {
    
    if ([self dataExistsForField:self.searchFinancierDropDownField]) {
        [self showDropDownForView:self.searchFinancierDropDownField];
        return;
    }
    [self searchFinancierAPI];
}

-(void)searchFinancierAPI{

    NSDictionary* dict = @{@"opty_id": _financierOpportunity.optyID};
    [[EGRKWebserviceRepository sharedRepository]searchFinancier:dict
                                                andSucessAction:^(id financier) {
                                                NSMutableArray* arrValue = [[NSMutableArray alloc] init];
                                                
                                                for (int i = 0; i< [[financier valueForKey:@"result"] count] ; i ++) {
                                                    NSArray* financierArray = [[financier valueForKey:@"result"] objectAtIndex:i];
                                                    
                                                  [arrValue addObject:financierArray];
                                                }
//                                                NSLog(@"arr val %@", arrValue);
                                                [self showFinancierDropDown:arrValue];

                                        } andFailureAction:^(NSError *error) {
//                                            NSLog(@"error");
                                        }];

}

-(void)sendOtpAPI{
    
    NSDictionary* dict = @{@"app_name": @"com.tatamotors.egurucrm", @"phone_number": _financierOpportunity.toFinancierContact.mobileno ? :@""};
    [[EGRKWebserviceRepository sharedRepository]sendOTP:dict
                                        andSucessAction:^(id otp) {
//                                            NSLog(@"Sucessfully");
                                            [UtilityMethods hideProgressHUD];
                                            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                                            self.hud.label.text = [otp valueForKey:@"msg"];
                                            [self.hud hideAnimated:YES afterDelay:1];

                                            _otpBlurrView.hidden = false;
                                            [self cleartextfield];
                                            [UIView transitionWithView:_otpBlurrView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                           
                                            } completion:NULL];

                                            
                                        } andFailureAction:^(NSError *error) {
                                            NSLog(@"error");
                                        }];
    
}

-(void)verifyOtpAPI{
    
    NSString *otpString =  [NSString stringWithFormat:@"%@%@%@%@%@%@", _txt1.text,_txt2.text,_txt3.text,_txt4.text,_txt5.text,_txt6.text];
   
    NSDictionary* dict = @{@"otp_number":otpString,@"phone_number":_financierOpportunity.toFinancierContact.mobileno,@"status":@"Registration OTP"};
    [[EGRKWebserviceRepository sharedRepository]verifyOTP:dict
                                        andSucessAction:^(id verifiedMsg) {
//                                            NSLog(@"Sucessfully");
                                            [self hidePopupView];
                                            [self verifiedOtpAlert:[verifiedMsg valueForKey:@"msg"]];
                                            
                                        } andFailureAction:^(NSError *error) {
//                                            NSLog(@"error");
                                            [self cleartextfield];
                                        }];
}

/*
- (void)bindValuesToInsertOptyModel {
    self.toFinancieBranch.financier_name = _searchFinancierDropDownField.text ;
    self.toFinancieBranch.financier_id = _toFinancieBranch.financier_id;
    
    //for checking purpose
    self.financierOpportunity.optyID = _titleDropDownField.text;
    
    self.insertQuoteModel.organization = _titleDropDownField.text;
    self.insertQuoteModel.title = _titleDropDownField.text;
    self.insertQuoteModel.father_mother_spouse_name = _fatherNameTF.text;
    self.insertQuoteModel.gender = _genderDD.text;
    self.insertQuoteModel.religion = _religionDropDownField.text;
    self.insertQuoteModel.address_type = _addressDD.text;
    self.insertQuoteModel.address1 = _address1TF.text;
    self.insertQuoteModel.address2 = _address2TF.text;
    self.insertQuoteModel.area = _areaTF.text;
    self.insertQuoteModel.date_of_birth = _dobTextField.text;
    self.insertQuoteModel.customer_category_subcategory = _customerSubCategoryDDField.text;
    self.insertQuoteModel.partydetails_maritalstatus = _maritalDD.text;
    self.insertQuoteModel.account_type = _accountTypeDropDownField.text;

    //financierContactModel
    self.insertQuoteModel.first_name        = _financierOpportunity.toFinancierContactDetails.firstName;
    self.insertQuoteModel.last_name         = _financierOpportunity.toFinancierContactDetails.lastName;
    self.insertQuoteModel.mobile_no         = _financierOpportunity.toFinancierContactDetails.mobileno;
    self.insertQuoteModel.city_town_village = _financierOpportunity.toFinancierContactDetails.citytownvillage;
    self.insertQuoteModel.state             = _financierOpportunity.toFinancierContactDetails.state;
    self.insertQuoteModel.district          = _financierOpportunity.toFinancierContactDetails.district;
    self.insertQuoteModel.pincode           = _financierOpportunity.toFinancierContactDetails.pincode;
    //financierAccountModel
    self.insertQuoteModel.account_name              = _financierOpportunity.toFinancierAccount.accountName;
    self.insertQuoteModel.account_site              = _financierOpportunity.toFinancierAccount.accountSite;
    self.insertQuoteModel.account_number            = _financierOpportunity.toFinancierAccount.accountNumber;
    self.insertQuoteModel.account_address1          = _financierOpportunity.toFinancierAccount.accountAddress1;
    self.insertQuoteModel.account_address2          = _financierOpportunity.toFinancierAccount.accountAddress2;
    self.insertQuoteModel.account_city_town_village = _financierOpportunity.toFinancierAccount.accountCityTownVillage;
    self.insertQuoteModel.account_state             = _financierOpportunity.toFinancierAccount.accountState;
    self.insertQuoteModel.account_district          = _financierOpportunity.toFinancierAccount.accountDistrict;
    self.insertQuoteModel.account_pincode           = _financierOpportunity.toFinancierAccount.accountPinCode;
    //financierOptyModel
    self.insertQuoteModel.opty_id                   = _financierOpportunity.toFinancierOpty.optyID;
    self.insertQuoteModel.opty_created_date         = _financierOpportunity.toFinancierOpty.optyCreatedDate;
    self.insertQuoteModel.lob                       = _financierOpportunity.toFinancierOpty.lob;
    self.insertQuoteModel.ppl                       = _financierOpportunity.toFinancierOpty.ppl;
    self.insertQuoteModel.pl                        = _financierOpportunity.toFinancierOpty.pl;
    self.insertQuoteModel.usage                     = _financierOpportunity.toFinancierOpty.usage;
    self.insertQuoteModel.intended_application      = _financierOpportunity.toFinancierOpty.intendedApplication;
    
    self.insertQuoteModel.ex_showroom_price              = _exShowroomTF.text;
    self.insertQuoteModel.on_road_price_total_amt        = _onRoadPriceTF.text;
    self.insertQuoteModel.pan_no_company                 = _panNoCompanyTF.text;
    self.insertQuoteModel.pan_no_indiviual               = _panNoIndividual.text;
    self.insertQuoteModel.id_type                        = _idTypeDD.text;
    self.insertQuoteModel.id_description                 = _idDescTF.text;
    self.insertQuoteModel.id_issue_date                  = _issueTextField.text;
    self.insertQuoteModel.id_expiry_date                 = _expiryTextField.text;
    self.insertQuoteModel.vehicle_class                  = _vehicleClassTF.text;
    self.insertQuoteModel.vehicle_color                  = _vehicleColorDropDownField.text;
    self.insertQuoteModel.emission_norms                 = _emmisionNormsDropDownField.text;
    self.insertQuoteModel.loandetails_repayable_in_months = _loanDetailsTF.text;
    self.insertQuoteModel.repayment_mode                 = _repaymentModeTF.text;
}
*/

- (NSDictionary *)bindValuesToInsertOptyModel {

    NSDictionary   *inputDictionary =  @{
                                       @"financier_branch_details":financierListArray,
                                       @"opty_details": @{
                                               @"organization": _titleDropDownField.text,
                                               @"title": _titleDropDownField.text,
                                               @"father_mother_spouse_name": _fatherNameTF.text,
                                               @"gender": _genderDD.text,
                                               @"first_name": _financierOpportunity.toFinancierContact.firstName,
                                               @"last_name": _financierOpportunity.toFinancierContact.lastName,
                                               @"mobile_no": _financierOpportunity.toFinancierContact.mobileno,
                                               @"religion": _religionDropDownField.text,
                                               @"address_type": _addressDD.text,
                                               @"address1": _address1TF.text,
                                               @"address2": _address2TF.text,
                                               @"area": _areaTF.text,
                                               @"city_town_village": _financierOpportunity.toFinancierContact.citytownvillage,
                                               @"state": _financierOpportunity.toFinancierContact.state,
                                               @"district": _financierOpportunity.toFinancierContact.district,
                                               @"pincode": _financierOpportunity.toFinancierContact.pincode,
                                               @"date_of_birth": _dobTextField.text,
//                                               @"customer_category_subcategory": _customerSubCategoryDDField.text,
                                               @"partydetails_maritalstatus": _maritalDD.text,
                                               @"intended_application": _financierOpportunity.toFinancierOpty.intendedApplication,
                                               @"account_type": _accountTypeDropDownField.text,
                                               @"account_name": _financierOpportunity.toFinancierAccount.accountName,
                                               @"account_site": _financierOpportunity.toFinancierAccount.accountSite,
                                               @"account_number": _financierOpportunity.toFinancierAccount.accountNumber,
                                               @"account_address1":_financierOpportunity.toFinancierAccount.accountAddress1,
                                               @"account_address2":_financierOpportunity.toFinancierAccount.accountAddress2,
                                               @"account_city_town_village": _financierOpportunity.toFinancierAccount.accountCityTownVillage,
                                               @"account_state":_financierOpportunity.toFinancierAccount.accountState,
                                               @"account_district":_financierOpportunity.toFinancierAccount.accountDistrict,
                                               @"account_pincode": _financierOpportunity.toFinancierAccount.accountPinCode,
                                               @"opty_id": _financierOpportunity.toFinancierOpty.optyID, //@"19038"
                                               @"opty_created_date": _financierOpportunity.toFinancierOpty.optyCreatedDate,
                                               @"ex_showroom_price": _exShowroomTF.text,
                                               @"on_road_price_total_amt": _onRoadPriceTF.text,
                                               @"pan_no_company": _panNoCompanyTF.text,
                                               @"pan_no_indiviual":_panNoIndividual.text,
                                               @"id_type": _idTypeDD.text,
                                               @"id_description": _idDescTF.text,
                                               @"id_issue_date": _issueTextField.text,
                                               @"id_expiry_date": _expiryTextField.text,
                                               @"lob": _financierOpportunity.toFinancierOpty.lob,
                                               @"ppl": _financierOpportunity.toFinancierOpty.ppl,
                                               @"pl": _financierOpportunity.toFinancierOpty.pl,
                                               @"usage": @"na",  //_financierOpportunity.toFinancierOpty.usage, //@"na", //
                                               @"vehicle_class": _vehicleClassTF.text,
                                               @"vehicle_color": _vehicleColorDropDownField.text,
                                               @"emission_norms": _emmisionNormsDropDownField.text,
                                               @"loandetails_repayable_in_months": _loanDetailsTF.text,
                                               @"repayment_mode": _repaymentModeTF.text,
                                               @"organization_code":@"1-PQG56",
                                               @"organization_code": _financierOpportunity.toFinancierOpty.organizationID,
                                               @"division_id":_financierOpportunity.toFinancierOpty.divID,
//                                               @"customer_category_subcategory":@"",
                                               @"customer_category":@"",
                                               @"customer_subcategory":@"",
                                               @"vc_number":@"5R7649764",
                                               @"product_id":@"1-PV56IUY",
                                               @"bu_id":@""
                                               }
                                       };
    return inputDictionary;
}

-(void)submitFinancierAPI{
    
        [[EGRKWebserviceRepository sharedRepository]createFinancier:[self bindValuesToInsertOptyModel]
                                                    andSucessAction:^(id response) {
//                                                        NSLog(@"submit FinancierAPI Sucessfull");
                                                        
                                                        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                                                        self.hud.label.text = [response valueForKey:@"msg"];
                                                        [self.hud hideAnimated:YES afterDelay:3];
                                                        
                                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
                                                        Home_LandingPageViewController *vc = (Home_LandingPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Home_LandingPage_View"];
                                                        [self.navigationController pushViewController:vc animated:YES];
                                                        
                                                        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_InsertQuote_Submit_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_InsertQuote_Successful];
                                                        
                                                    } andFailureAction:^(NSError *error) {
                                                        NSLog(@"error");
                                                       [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Financier_InsertQuote_Submit_Button_Click withEventCategory:GA_CL_Financier withEventResponseDetails:GA_EA_InsertQuote_Failed];
                                                    }];
     
}

//- (NSDictionary *)getRequestDictionaryFromInsertOpptyModel {
//    NSLog(@"%@",self.insertQuoteModel);
//    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] opportunityMapping] inverseMapping]
//                                                                                   objectClass:[EGOpportunity class]
//                                                                                   rootKeyPath:nil
//                                                                                        method:RKRequestMethodPOST];
//    
//    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
//    
//    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:@"" requestDescriptor:requestDescriptor error:nil];
//    return parametersDictionary;
//}

#pragma mark - UIControls
- (void)verifiedOtpAlert:(NSString *)msg{
    
    UIAlertController *alertMsg = [UIAlertController
                                   alertControllerWithTitle:nil
                                   message:[NSString stringWithFormat:@"%@, Do you want to submit the selected financier?", msg]
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *YesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    [self cleartextfield];
                                    [self submitFinancierAPI];
                                }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"No action")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertMsg addAction:YesAction];
    [alertMsg addAction:noAction];
    [self presentViewController:alertMsg animated:YES completion:nil];
    
}

-(void)hidePopupView {
    [self cleartextfield];
    _otpBlurrView.hidden = true;
    [UIView transitionWithView:_otpBlurrView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
    } completion:NULL];
}

-(void)cleartextfield{
    _txt1.text =@"";
    _txt2.text =@"";
    _txt3.text =@"";
    _txt4.text =@"";
    _txt5.text =@"";
    _txt6.text =@"";
}

- (EGPagedArray *)fieldDetailsArray {
    if (!_fieldDetailsArray) {
        _fieldDetailsArray = [[EGPagedArray alloc] init];
    }
    return _fieldDetailsArray;
}

- (DropDownTextField *)searchFinancierDropDownField {
    if(!_searchFinancierDropDownField.field){
        _searchFinancierDropDownField.field = [[Field alloc] init];
    }
    return _searchFinancierDropDownField;
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

- (DropDownTextField *)accountTypeDropDownField {
    if (!_accountTypeDropDownField.field) {
        _accountTypeDropDownField.field = [[Field alloc] init];
    }
    return _accountTypeDropDownField;
}

- (DropDownTextField *)vehicleColorDropDownField {
    if (!_vehicleColorDropDownField.field) {
        _vehicleColorDropDownField.field = [[Field alloc] init];
    }
    return _vehicleColorDropDownField;
}

- (DropDownTextField *)emmisionNormsDropDownField {
    if (!_emmisionNormsDropDownField.field) {
        _emmisionNormsDropDownField.field = [[Field alloc] init];
    }
    return _emmisionNormsDropDownField;
}

- (DropDownTextField *)customerCategoryDropDownField {
    if (!_customerCategoryDropDownField.field) {
        _customerCategoryDropDownField.field = [[Field alloc] init];
    }
    return _customerCategoryDropDownField;
}

- (DropDownTextField *)customerSubCategoryDDField {
    if (!_customerSubCategoryDDField.field) {
        _customerSubCategoryDDField.field = [[Field alloc] init];
    }
    return _customerSubCategoryDDField;
}

- (DropDownTextField *)idTypeDDField {
    if (!_idTypeDD.field) {
        _idTypeDD.field = [[Field alloc] init];
    }
    return _idTypeDD;
}


//#pragma mark -GestureToDropDownField
//- (void)addGestureToDropDownFields {
//    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
//    [tapGesture setNumberOfTapsRequired:1];
//    [tapGesture setNumberOfTouchesRequired:1];
//
//    [[self.titleDropDownField superview] addGestureRecognizer:tapGesture];
//    [[self.genderDD superview] addGestureRecognizer:tapGesture];
//    [[self.maritalDD superview] addGestureRecognizer:tapGesture];
//    [[self.addressDD superview] addGestureRecognizer:tapGesture];
//}

-(void)textFieldButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 11:
            [self fetchFinanciers];
            break;
        case 12:
                [self fetchTitle];
            break;
        case 13:
                [self fetchGender];
            break;
        case 14:
                [self fetchMaritalStatus];
            break;
        case 15:
                [self fetchAddressType];
            break;
        case 16:
                [self fetchReligion];
            break;
        case 17:
                [self fetchAccountType];
            break;
        case 18:
                [self fetchVehicleColor];
            break;
        case 19:
                [self fetchEmmission];
        case 20:
                [self fetchCustomerCategory];
        case 21:
                [self fetchCustomerSubCategory];
        case 22:

              [self fetchIDType];

        default:
            break;
    }
}

#pragma mark - Validations
- (BOOL)fieldInputValid{
    NSString * warningMessage;
    BOOL hasValidInput = true;

    if (![self.titleDropDownField.text hasValue] || ![self.genderDD.text hasValue] || ![self.maritalDD.text hasValue] || ![self.addressDD.text hasValue] || ![self.dobTextField.text hasValue] || ![self.fatherNameTF.text hasValue] || ![self.areaTF.text hasValue] || ![self.religionDropDownField.text hasValue] || ![self.accountTypeDropDownField.text hasValue] || ![self.onRoadPriceTF.text hasValue] || ![self.exShowroomTF.text hasValue] || ![self.vehicleClassTF.text hasValue] || ![self.vehicleColorDropDownField.text hasValue] || ![self.emmisionNormsDropDownField.text hasValue] || ![self.customerCategoryDropDownField.text hasValue] || ![self.customerSubCategoryDDField.text hasValue] || ![self.idDescTF.text hasValue] || ![self.issueTextField.text hasValue] || ![self.idTypeDD.text hasValue] || ![self.address1TF.text hasValue] || ![self.address2TF.text hasValue] || ![self.loanDetailsTF.text hasValue] || ![self.repaymentModeTF.text hasValue] || ![self.panNoCompanyTF.text hasValue] || ![self.panNoIndividual.text hasValue] || ![self.indicativeLoanTF.text hasValue] || ![self.loanTenorTF.text hasValue] || ![self.partyDetail.text hasValue] || ![self.partyAnualTF.text hasValue])
     {
         hasValidInput = false;
         warningMessage = @"Please Fill the Mandatory Fields";
         [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
         }];

     } else if (!financierListArray || !financierListArray.count){
         hasValidInput = false;
         warningMessage = @"Please Select Financier";
         [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
         }];
     }
    return hasValidInput;
}

- (BOOL)otpTextFieldValid{
    NSString * warningMessage = @"Please enter OTP";
    BOOL hasValidInput = true;
    
    if (![_txt1.text hasValue] || ![_txt2.text hasValue] || ![_txt3.text hasValue] || ![_txt4.text hasValue] || ![_txt5.text hasValue] || ![_txt6.text hasValue])
    {
        hasValidInput = false;
        [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
        }];
    }
    return hasValidInput;
}


-(BOOL)isTextFieldDataValid {
    NSString * warningMessage = @"";
    BOOL isValid;
    isValid = [self validateTextFields:&warningMessage];
    
    if (!isValid) {
        [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
//            NSLog(@"This is a isTextFieldDataValid block");
        }];
    }
    return isValid;
}

-(void)validations{
    //    if(self.fromDate.text.length > 0 ) {
    //        _fromdateimage.hidden=YES;
    //    } else {
    //        _fromdateimage.hidden=NO;
    //    }
    //    if(self.todate.text.length > 0 ) {
    //        _todateimage.hidden=YES;
    //    } else {
    //        _todateimage.hidden=NO;
    //    }
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrayWithoutDuplicates count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FinancierSearchCollectionViewCell *cell = (FinancierSearchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"financierSearchCell" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    cell.financierNameLabel.text = [[arrayWithoutDuplicates objectAtIndex:indexPath.row] valueForKey:@"financier_name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath %@", indexPath);
    [arrayWithoutDuplicates removeObjectAtIndex:indexPath.row];
    [financierListArray removeObjectAtIndex:indexPath.row];
    
    [_financierSearchCollectionView reloadData];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
//        if (![textField.text isEqualToString:selectedValue]) {
//            [self.vcDetailsArray clearAllItems];
//        }
        if (textField != self.searchFinancierDropDownField) {
            textField.text = selectedValue;
            textField.field.mSelectedValue = selectedValue;
        }
        else if (textField == self.searchFinancierDropDownField) {
            
            if (multipleSelection) {
                NSMutableDictionary *dictFinancier = [[NSMutableDictionary alloc] init];
                [dictFinancier setObject:[selectedObject objectForKey:@"finacnier_id"] forKey:@"financier_id"];
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_name"] forKey:@"financier_name"];
                [dictFinancier setObject:@"" forKey:@"branch_id"];
//                [dictFinancier setObject:[[[selectedObject objectForKey:@"branch_details"] valueForKey:@"branch_id"] objectAtIndex:0] forKey:@"branch_id"];
               
                //adding dictionary to array
                [financierListArray addObject:dictFinancier];
                
                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:financierListArray];
                arrayWithoutDuplicates = [orderedSet mutableCopy];
                
                [_financierSearchCollectionView reloadData];
            } else {
                //by removing array it only stores single object
                [financierListArray removeAllObjects];
                
//                textField.field.mSelectedValue = selectedValue;
//                textField.text = selectedValue;
                
                NSMutableDictionary *dictFinancier = [[NSMutableDictionary alloc] init];
                [dictFinancier setObject:[selectedObject objectForKey:@"finacnier_id"] forKey:@"financier_id"];
                [dictFinancier setObject:[selectedObject objectForKey:@"financier_name"] forKey:@"financier_name"];
                [dictFinancier setObject:@"" forKey:@"branch_id"];
               
                [financierListArray addObject:dictFinancier];
                
                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:financierListArray];
                arrayWithoutDuplicates = [orderedSet mutableCopy];
                
                [_financierSearchCollectionView reloadData];

            }
        }
    }
}

- (void)showFinancierDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"financier_name"];
    self.searchFinancierDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.searchFinancierDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.searchFinancierDropDownField];
}
- (void)showTitleDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"title"];
    self.titleDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.titleDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.titleDropDownField];
}

- (void)showGenderDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"gender"];
    self.genderDD.field.mValues = [nameResponseArray mutableCopy];
    self.genderDD.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.genderDD];
}

- (void)showMaritalStatusDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"partydetails_maritalstatus"];
    self.maritalDD.field.mValues = [nameResponseArray mutableCopy];
    self.maritalDD.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.maritalDD];
}

- (void)showAddressTypeDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"address_type"];
    self.addressDD.field.mValues = [nameResponseArray mutableCopy];
    self.addressDD.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.addressDD];
}


- (void)showReligionDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"religion"];
    self.religionDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.religionDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.religionDropDownField];
}

- (void)showAccountTypeDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"account_type"];
    self.accountTypeDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.accountTypeDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.accountTypeDropDownField];
}

- (void)showVehicleColorDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"vehicle_color"];
    self.vehicleColorDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.vehicleColorDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.vehicleColorDropDownField];
}

- (void)showEmmisionDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"emission_norms"];
    self.emmisionNormsDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.emmisionNormsDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.emmisionNormsDropDownField];
}

- (void)showCustomerCategoryDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"customer_category"];
    self.customerCategoryDropDownField.field.mValues = [nameResponseArray mutableCopy];
    self.customerCategoryDropDownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.customerCategoryDropDownField];
}

- (void)showCustomerSubCategoryDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"customer_category_subcategory"];
    self.customerSubCategoryDDField.field.mValues = [nameResponseArray mutableCopy];
    self.customerSubCategoryDDField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.customerSubCategoryDDField];
}

- (void)showIDTypeDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr valueForKey:@"id_type"];
    self.idTypeDD.field.mValues = [nameResponseArray mutableCopy];
    self.idTypeDD.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.idTypeDD];
}

- (void)showDropDownForView:(DropDownTextField *)textField {
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

#pragma mark - Database Calls

- (void)fetchTitle {
    
    if ([self dataExistsForField:self.titleDropDownField]) {
        [self showDropDownForView:self.titleDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchTitle] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showTitleDropDown:arr];
            }];
        }
    }];
}
- (void)fetchGender {
    if ([self dataExistsForField:self.genderDropDownField]) {
        [self showDropDownForView:self.genderDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchGender] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showGenderDropDown:arr];
            }];
        }
    }];
}

- (void)fetchMaritalStatus {
    if ([self dataExistsForField:self.maritalDropDownField]) {
        [self showDropDownForView:self.maritalDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchMarritalStatus] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showMaritalStatusDropDown:arr];
            }];
        }
    }];
}

- (void)fetchAddressType {
    
    if ([self dataExistsForField:self.addressDropDownField]) {
        [self showDropDownForView:self.addressDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAddressType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAddressTypeDropDown:arr];
            }];
        }
    }];
}


- (void)fetchReligion {
    
    if ([self dataExistsForField:self.religionDropDownField]) {
        [self showDropDownForView:self.religionDropDownField];
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
                [self showReligionDropDown:arr];
            }];
        }
    }];
}

- (void)fetchAccountType {
    
    if ([self dataExistsForField:self.accountTypeDropDownField]) {
        [self showDropDownForView:self.accountTypeDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAccountType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAccountTypeDropDown:arr];
            }];
        }
    }];
}

- (void)fetchVehicleColor {
    
    if ([self dataExistsForField:self.vehicleColorDropDownField]) {
        [self showDropDownForView:self.vehicleColorDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchVehicleColor] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showVehicleColorDropDown:arr];
            }];
        }
    }];
}

- (void)fetchEmmission {
    
    if ([self dataExistsForField:self.emmisionNormsDropDownField]) {
        [self showDropDownForView:self.emmisionNormsDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchEmmisionNorms] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showEmmisionDropDown:arr];
            }];
        }
    }];
}

- (void)fetchCustomerCategory {
    
    if ([self dataExistsForField:self.customerCategoryDropDownField]) {
        [self showDropDownForView:self.customerCategoryDropDownField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchCustomerCategory] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showCustomerCategoryDropDown:arr];
            }];
        }
    }];
}

- (void)fetchCustomerSubCategory {
    if ([self dataExistsForField:self.customerSubCategoryDDField]) {
        [self showDropDownForView:self.customerSubCategoryDDField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchCustomerSubCategory] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showCustomerSubCategoryDropDown:arr];
            }];
        }
    }];
}

- (void)fetchIDType {
    
    if ([self dataExistsForField:self.idTypeDDField]) {
        [self showDropDownForView:self.idTypeDDField];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchIDType] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showIDTypeDropDown:arr];
            }];
        }
    }];
}

- (BOOL)dataExistsForField:(DropDownTextField *)textField {
    
    if (textField.field.mDataList &&
        [textField.field.mDataList count] > 0 &&
        textField.field.mValues &&
        [textField.field.mValues count] > 0) {
        return true;
    }
    return false;
}


#pragma mark - TextField Delegates

//For otp textfield position change
-(void)textFieldDidChange:(UITextField*)textField{
    
    NSString *text = textField.text;
    
    if (text.length >= 1) {
        
        switch (textField.tag) {
            case 1:
                [self.txt2 becomeFirstResponder];
                break;
            case 2:
                [self.txt3 becomeFirstResponder];
                break;
            case 3:
                [self.txt4 becomeFirstResponder];
                break;
            case 4:
                [self.txt5 becomeFirstResponder];
                break;
            case 5:
                [self.txt6 becomeFirstResponder];
                break;
                
            default:
                break;
        }
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
    
    textField.text = @"";
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.onRoadPriceTF) {
        if (length > 8)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.exShowroomTF) {
        if (length > 8)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.loanDetailsTF) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.indicativeLoanTF) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.loanTenorTF) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.partyAnualTF) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.txt1 || textField == self.txt2 || textField == self.txt3 || textField == self.txt4 || textField == self.txt5 || textField == self.txt6) {
        if (length > 1)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [textField resignFirstResponder];
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
    
//    if(textField != self.taluka && textField != self.mobileNumber && textField != self.lastName && textField != self.fromDate && textField != self.todate && textField != self.financierTextField){
//        [textField resignFirstResponder];
//    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [activeField resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}

-(void)makeRedbox_mandatoryFields
{
    [UtilityMethods setRedBoxBorder:self.searchFinancierDropDownField];
    [UtilityMethods setRedBoxBorder:self.titleDropDownField];
    [UtilityMethods setRedBoxBorder:self.genderDD];
    [UtilityMethods setRedBoxBorder:self.maritalDD];
    [UtilityMethods setRedBoxBorder:self.addressDD];
    [UtilityMethods setRedBoxBorder:self.dobTextField];
    [UtilityMethods setRedBoxBorder:self.fatherNameTF];
    [UtilityMethods setRedBoxBorder:self.areaTF];
    [UtilityMethods setRedBoxBorder:self.religionDropDownField];
    [UtilityMethods setRedBoxBorder:self.accountTypeDropDownField];
    [UtilityMethods setRedBoxBorder:self.onRoadPriceTF];
    [UtilityMethods setRedBoxBorder:self.exShowroomTF];
    [UtilityMethods setRedBoxBorder:self.vehicleClassTF];
    [UtilityMethods setRedBoxBorder:self.vehicleColorDropDownField];
    [UtilityMethods setRedBoxBorder:self.emmisionNormsDropDownField];
    [UtilityMethods setRedBoxBorder:self.customerCategoryDropDownField];
    [UtilityMethods setRedBoxBorder:self.customerSubCategoryDDField];
    [UtilityMethods setRedBoxBorder:self.idDescTF];
    [UtilityMethods setRedBoxBorder:self.issueTextField];
    [UtilityMethods setRedBoxBorder:self.idTypeDD];
    [UtilityMethods setRedBoxBorder:self.address1TF];
    [UtilityMethods setRedBoxBorder:self.address2TF];
    [UtilityMethods setRedBoxBorder:self.loanDetailsTF];
    [UtilityMethods setRedBoxBorder:self.repaymentModeTF];
    [UtilityMethods setRedBoxBorder:self.panNoCompanyTF];
    [UtilityMethods setRedBoxBorder:self.panNoIndividual];
    [UtilityMethods setRedBoxBorder:self.indicativeLoanTF];
    [UtilityMethods setRedBoxBorder:self.loanTenorTF];
    [UtilityMethods setRedBoxBorder:self.partyDetail];
    [UtilityMethods setRedBoxBorder:self.partyAnualTF];
}

-(void)SetTextFieldBorder :(UITextField *)textField{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    
}

@end
