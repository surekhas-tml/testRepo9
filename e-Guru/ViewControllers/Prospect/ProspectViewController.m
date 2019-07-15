//
//  ProspectViewController.m
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocationManagerSingleton.h"
#import "EGRKWebserviceRepository.h"
#import "ProspectViewController.h"
#import "ProspectViewController+CreateContact.m"
#import "ProspectViewController+CreateAccount.m"
#import "EGPin.h"
#import "SearchResultsViewController.h"
#import "AsyncLocationManager.h"

#define DISTRICTS_KEY @"districts"
#define CITIES_KEY @"cities"
#define TALUKAS_KEY @"talukas"
#define PINCODES_KEY @"pincodes"

#import "PureLayout.h"
#define HEIGHT_WIDTHT 12.0f


@interface ProspectViewController() <LocationManagerSingletonDelegate,SearchResultsViewControllerDelegate> {
    
    SearchContactView * search_contact_View;
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *talukaTapRecognizer;

    AutoCompleteUITextField * autoComplete_textField;
    EGAccount * accountObjectLocal;
    EGContact *contactObjectLocal;
    EGAddress * addressObject;
    CNContactPickerViewController *contactPicker;
    CLLocation *myCurrentLocation;
    NSMutableArray *mStatesArray;  //new changes
    NSArray *talukaArray;
    NSArray *arrCurrentSearchTalukaData;
//    NSArray *sortedTalukaAray;   //new changes
    NSMutableArray *sortedTalukaArray;
    NSArray *sortedModelArr;     //new changes
    
    NSArray *pinArray;
    EGRKWebserviceRepository *currentTalukaOperation;
    MBProgressHUD *hud;
    BOOL fetchTaluka;
}
@property (strong,nonatomic) UIActivityIndicatorView *actIndicator;
//@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation ProspectViewController
@synthesize searchedContactToBelinkedtoAccount,actIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = [[EGState alloc] init];
   
    // Do not remove this instantiation
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    fetchTaluka = YES;
    
    [self addGestureRecogniserToView];
    [self addGestureToDropDownFields]; //new changes
    
    [self configureView];
    
    
//    [self.state_TextField setUserInteractionEnabled:YES];   //new changes
    [self.district_TextField setUserInteractionEnabled:NO];
    [self.city_TextField setUserInteractionEnabled:NO];
    self.pageScrollView.scrollEnabled=NO;
    
    if([self.entryPoint  isEqualToString: DRAFT]) {
//        self.addressDetailsView.hidden = TRUE;
//        self.hideShowView_Buttton.tag = STATE_ENABLE;
        [self disableOrEnableButton:self.submitButton withState:STATE_ENABLE];
//        self.gpsSwitch.hidden=YES;
//        self.pickFromGPSLabel.hidden=YES;
//        [self.hideShowView_Buttton setImage:[UIImage imageNamed:@"plus_button"] forState:UIControlStateNormal];
        [self.saveToDraftsButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
    }
    else  if([self.detailsObj  isEqual: PROSPECT_CONTACT] && [self.demo hasValue]) {
        self.mobileNumberTextField.text=self.demo;
    }
    else  if([self.detailsObj  isEqual: PROSPECT_ACCOUNT] && [self.demo hasValue]) {
        self.mainPhoneNumberTextField.text=self.demo;
        

    }
    
    [[AsyncLocationManager sharedInstance] startAsyncLocationFetch];
    [self addDropDownIconOnTalukaTextfiled];
}

//add dropdown icon on taluka textfiled
- (void)addDropDownIconOnTalukaTextfiled {
    UIImageView *icon = [[UIImageView alloc] init];
    [self.taluka_Textfield addSubview:icon];
    [icon setImage:[UIImage imageNamed:@"temp_blueTriangle"]];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [icon autoSetDimension:ALDimensionWidth toSize:HEIGHT_WIDTHT];
    [icon autoSetDimension:ALDimensionHeight toSize:HEIGHT_WIDTHT];
    [icon setBackgroundColor:[UIColor clearColor]];
    
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    addressObject = [[EGAddress alloc] init];
    accountObjectLocal = [[EGAccount alloc] init];
    contactObjectLocal = [[EGContact alloc] init];
    
//    self.addressDetailsView.hidden = TRUE;
//    self.hideShowView_Buttton.tag = STATE_DISABLE;
    
    // Do not hide the address view for Contact Prospect
//    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
//        self.addressDetailsView.hidden = false;
//        self.hideShowView_Buttton.hidden = true;
//        [self hideShowView_ButttonClicked:nil];
//    } else {
//        self.addressDetailsView.hidden = true;
//        self.hideShowView_Buttton.hidden = false;
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self makeRedbox_mandatoryFields];
}


- (void)configureView {

    /** Commented to show back button, report issue and home button
     when add contact/account is selected from create opty **/
//    if (self.invokedFrom != CreateOpportunity) {
        [UtilityMethods navigationBarSetupForController:self];
//    }
    self.pageScrollView.bounces = FALSE;
    
    //AddressArea
    [self clearAllTextFiledsInView:self.addressDetailsView];
    
    self.addressDetailsView.hidden = TRUE;
    self.hideShowView_Buttton.tag = STATE_DISABLE;
    [self.saveToDraftsButton  setTitle:SAVE_AS_DRAFT forState:UIControlStateNormal];
    
    for (AutoCompleteUITextField *autoField in [self.addressDetailsView subviews]) {
        if ([autoField isKindOfClass:[AutoCompleteUITextField class]]) {
            autoField.autocompleteTableRowSelectedDelegate = self;
        }
    }
    
    //Buttons Section
    [self disableOrEnableButton:self.createAccountButton withState:STATE_DISABLE];
    [self disableOrEnableButton:self.submitButton withState:STATE_DISABLE];
    [self disableOrEnableButton:self.saveToDraftsButton withState:STATE_DISABLE];

    //Contact And Account Section.
    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_CreateNewProspect_Contact];
        self.addressLabel.text = @"Contact Address";
        if (!contactPicker) {
            [self initialiseContactPicker];
        }
        [self loadContactView];
        
    }
    else if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]){
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_CreateNewProspect_Account];
        self.addressLabel.text = @"Account Address";
        [self loadAccountView];
    }
    
    // Tap Gesture to Pincode Textfield
    [self addTapGesturePincodeField];
    
//    self.pickFromGPSLabel.hidden = false;
//    self.gpsSwitch.hidden = false;
    if (self.commentJson != nil) {
        self.firstNameTextField.text = self.commentJson[@"first_name"] ? self.commentJson[@"first_name"] : @"";
        self.LastNameTextField.text = self.commentJson[@"last_name"] ? self.commentJson[@"last_name"] : @"";
        self.mobileNumberTextField.text = self.commentJson[@"contact_no"] ? self.commentJson[@"contact_no"] : @"";
        
        [self disableOrEnableButton:self.submitButton withState:STATE_ENABLE];
        [self disableOrEnableButton:self.saveToDraftsButton withState:STATE_ENABLE];
    }
}

#pragma mark - Helper methods

-(void)validateSaveToDraft{
    BOOL state;
    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
        state = ([UtilityMethods isAnyTextFieldHasUpdated:self.create_ContactView]||[UtilityMethods isAnyTextFieldHasUpdated:self.addressDetailsView]) ? YES : NO;
    
    }
    else{
        state = ([UtilityMethods isAnyTextFieldHasUpdated:self.create_AccountView]||[UtilityMethods isAnyTextFieldHasUpdated:self.addressDetailsView]) ? YES : NO;
    }
        [self disableOrEnableButton:self.saveToDraftsButton withState:state];
}

-(void)validationForButtonState
{
    NSLog(@"Validating Text Fields .....");
    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT] ) {
        [self disableOrEnableButton:self.submitButton withState:[self validateContactFieldsToEnableSubmitButton]];
    }
    else{
        [self disableOrEnableButton:self.submitButton withState:[self validateAccountFieldsToEnableSubmitButton]];
    }
}

-(void)disableOrEnableButton:(UIButton *)button withState:(BOOL)buttonState
{
    button.enabled = buttonState;
    if (buttonState) {//Enable button
        [button setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
    }
    else{// Disable button
        [button setBackgroundColor:[UIColor buttonBackgroundGrayColor]];
    }
}

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.pageScrollView addGestureRecognizer:tapRecognizer];
}


-(BOOL)isTextFieldDataValid
{
    NSString * warningMessage = @"";
    BOOL isValid;
    //--Basic info validation--//
    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
        isValid = [self validateContactFields:&warningMessage];
    }
    else if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]){
        isValid = [self validateAccountFields:&warningMessage];
    }
    if (!isValid) {
        [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
            NSLog(@"This is a OK block");
        }];
    }
        return isValid;
}

- (BOOL)validateAddress:(NSString **)warningMessage_p
{
    //--Address validation--//
    if (self.hideShowView_Buttton.tag) {
        if ([self.addressLine_One_TextField.text isEqualToString:@""]) {
            *warningMessage_p = @"Please Enter Address Line One";
            return NO;
        }
    }
    if (![self.state_TextField.text isEqualToString:@""] || ![self.city_TextField.text isEqualToString:@""] ||![self.district_TextField.text isEqualToString:@""] ||![self.taluka_Textfield.text isEqualToString:@""] ||![self.addressLine_One_TextField.text isEqualToString:@""]) {
        if ([self.state_TextField.text isEqualToString:@""]){
            *warningMessage_p = @"Please select State";
            return NO;

        }
        else if ([self.district_TextField.text isEqualToString:@""]){
            *warningMessage_p = @"Please select District";
            return NO;

        }
        else if ([self.city_TextField.text isEqualToString:@""]){
            *warningMessage_p = @"Please select City";
            return NO;

        }
        else if ([self.taluka_Textfield.text isEqualToString:@""]){
            *warningMessage_p = @"Please select Taluka";
            return NO;

        }
        
//        else if ([self.pincode_Textfield.text isEqualToString:@""]){
//            *warningMessage_p = @"Please select Pincode";
//            return NO;
//            
//        }
        else if ([self.addressLine_One_TextField.text isEqualToString:@""]){
            *warningMessage_p = @"Please Enter Address Line One";
            return NO;
        }
    }
    return YES;
}

-(void)makeRedbox_mandatoryFields
{
    [UtilityMethods setRedBoxBorder:self.firstNameTextField];
    [UtilityMethods setRedBoxBorder:self.LastNameTextField];
    [UtilityMethods setRedBoxBorder:self.mobileNumberTextField];
	[UtilityMethods setRedBoxBorder:self.taluka_Textfield];
    [UtilityMethods setRedBoxBorder:self.addressLine_One_TextField];
    [UtilityMethods setRedBoxBorder:self.accountNameTextField];
    [UtilityMethods setRedBoxBorder:self.siteTextField];
    [UtilityMethods setRedBoxBorder:self.mainPhoneNumberTextField];
    
    // Make the Area text field Mandatory
//    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
//        [UtilityMethods setRedBoxBorder:self.area_TextField];
//    }
	
	if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
		//Not Mandatatory Field
	} else {
		[UtilityMethods setRedBoxBorder:self.contactSearchTextField];
	}
	
}

-(void)make_Mandatory_AddressFields{
    [UtilityMethods setRedBoxBorder:self.state_TextField];
    [UtilityMethods setRedBoxBorder:self.taluka_Textfield];
    [UtilityMethods setRedBoxBorder:self.addressLine_One_TextField];

}
-(void)make_NonMandatory_AddressFields
{
//    [UtilityMethods setGreyBoxBorder:self.state_TextField];
    [UtilityMethods setGreyBoxBorder:self.city_TextField];
    [UtilityMethods setGreyBoxBorder:self.district_TextField];
}

-(void)getAllAddressValuesInObject{
    addressObject.state.name = self.state_TextField.text;
    addressObject.city = self.city_TextField.text;
    addressObject.taluka.talukaName = self.taluka_Textfield.text;
    addressObject.district = self.district_TextField.text;
    addressObject.pin = self.pincode_Textfield.text;
    addressObject.addressLine1 = self.addressLine_One_TextField.text;
    addressObject.addressLine2 = self.addressLine_Two_TextField.text;
}
-(void)getAllContactValuesinObject{
    contactObjectLocal.firstName = self.firstNameTextField.text;
    contactObjectLocal.lastName = self.LastNameTextField.text;
    contactObjectLocal.contactNumber = self.mobileNumberTextField.text;
    contactObjectLocal.emailID = self.emailTextField.text;
    contactObjectLocal.panNumber = self.panNumTextField.text;
    contactObjectLocal.toAddress = addressObject;
}

-(void)getAllAccountValuesinObject{
    accountObjectLocal.accountName = self.accountNameTextField.text;
    accountObjectLocal.siteName = self.siteTextField.text;
    accountObjectLocal.contactNumber = self.mainPhoneNumberTextField.text;
    if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
    }
    else{
        accountObjectLocal.toContact = [[NSMutableSet alloc] initWithArray:@[self.searchedContactToBelinkedtoAccount]];
    }
    accountObjectLocal.toAddress = addressObject;
}

//need to change here

-(void)clearAllTextFiledsInView:(UIView *)fromView
{
    if (fromView == self.addressDetailsView) {
        [self.pincode_Textfield setText:@""];
    }
    for (UIView *view in [fromView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (textField != self.state_TextField) {        // new changes
                textField.text = @"";
            } else if (textField != self.taluka_Textfield) {
                textField.text = @"";
            }
            
        }
    }
}

- (BOOL)checkIfAnyAddressFieldHasValue {
    
    if ([self.taluka_Textfield.text hasValue] || [self.state_TextField.text hasValue] ||
        [self.area_TextField.text hasValue] ||
        [self.panchayat_TextField.text hasValue] ||
        [self.pincode_Textfield.text hasValue] ||
        [self.addressLine_One_TextField.text hasValue] ||
        [self.addressLine_Two_TextField.text hasValue]) {
        return true;
    }
    
    return false;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:[CREATEOPTY stringByAppendingString:SEGUE]]) {
        CreateOpportunityViewController __weak *destinationVC = (CreateOpportunityViewController *)[segue destinationViewController];
        
        [self getAllAddressValuesInObject];
        [self getAllAccountValuesinObject];
        [self getAllContactValuesinObject];
        destinationVC.accountObject = accountObjectLocal;
        destinationVC.contactObject = contactObjectLocal;
        if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
            destinationVC.contactObject = [[EGContact alloc]init];
            destinationVC.opportunity.toContact = self.opportunityContact;
        }
        else{
            destinationVC.opportunity.toAccount = [[EGAccount alloc]init];
            destinationVC.opportunity.toAccount = self.opportunityAccount;
        }
    }
    
    else if ([segue.identifier isEqualToString:[SEARCHRESULT stringByAppendingString:SEGUE]]){
        SearchResultsViewController *searchResultVC = (SearchResultsViewController *)[[segue destinationViewController] topViewController];
        searchResultVC.detailsObj = [SEARCHRESULT stringByAppendingString:SEGUE];
    }
    
}
-(void)userConfirmedForCreateOpportunityFlow:(NSString *)strID{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle: [NSBundle mainBundle]];
    
    CreateOpportunityViewController *tempCreateOptyVC = (CreateOpportunityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create Opportunity_View"];
    tempCreateOptyVC.entryPoint = InvokeForCreateOpportunity;
    EGOpportunity *opportunity = [[EGOpportunity alloc] init];
    opportunity.toContact = [[EGContact alloc] init];
    if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
        opportunity.toContact = self.opportunityContact;
    }
    else{
        accountObjectLocal.accountID = strID;
        opportunity.toAccount = [[EGAccount alloc] init];
        opportunity.toAccount = accountObjectLocal;
        NSArray *contactArr = [opportunity.toAccount.toContact allObjects];
        opportunity.toContact = [contactArr objectAtIndex:0];
    }
    
//    [self.navigationController pushViewController:tempCreateOptyVC animated:YES];
    UINavigationController *navVC = [appdelegate.splitViewController.viewControllers firstObject];
    MasterViewController *master = [[navVC childViewControllers]lastObject];
    [master performSegueWithIdentifier:[CREATEOPTY stringByAppendingString:SEGUE] sender:opportunity];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

#pragma mark - contact picker delegate method

- (void) contactPicker:(CNContactPickerViewController *)picker
      didSelectContact:(CNContact *)contact {
    
    [self clearAllTextFiledsInView:self.addressDetailsView];
    [UtilityMethods clearAllTextFiledsInView:self.create_ContactView];

    [self getContactDetails:contact];
    [self validateSaveToDraft];
    [self validationForButtonState];

}
-(void)getContactDetails:(CNContact *)contactObject {
    
    NSString * fullName = [NSString stringWithFormat:@"%@ %@",contactObject.givenName,contactObject.familyName];
    NSLog(@"fullName :: %@",fullName);
    
    if (contactObject.givenName) {
        self.firstNameTextField.text = contactObject.givenName;// First Name
    }
    if (contactObject.familyName) {
        self.LastNameTextField.text = contactObject.familyName;// Last Name
    }

    NSString * phonenumberorginal = [NSString stringWithFormat:@"%@",contactObject.phoneNumbers ];
    NSString * phonenumberfiltered = [phonenumberorginal stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phonenumberorginal length])];
    
    if (phonenumberfiltered.length > 0 ) {
          self.mobileNumberTextField.text = [phonenumberfiltered substringFromIndex: [phonenumberfiltered length] - 10];
    }else{
          self.mobileNumberTextField.text = @"";
    }
  
 
    NSString * email = @"";
    for(CNLabeledValue * emaillabel in contactObject.emailAddresses) {
        email = emaillabel.value;
        if (email) {
            self.emailTextField.text = email;
            break;
        }}
    
    [self parseAddressWithContac:contactObject];// address fields
    
}

- (void)parseAddressWithContac: (CNContact *)contact
{
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        
        self.hideShowView_Buttton.tag = FALSE;
        [self hideShowView_ButttonClicked:self.hideShowView_Buttton];
        CNPostalAddress * address = [addresses firstObject];
        self.state_TextField.text = address.state;
        self.city_TextField.text = address.city;
        self.pincode_Textfield.text = address.postalCode;
        self.addressLine_One_TextField.text = address.street;
        addressObject.district = @"";
        addressObject.taluka.talukaName = @"";
        addressObject.addressLine2 = @"";
    }
    else{
        //AddressArea
        [self clearAllTextFiledsInView:self.addressDetailsView];
        }
}


//// Hide the taluka table

-(void)removeTalukaTableView{
    [self clearSelectedTalukadata];
    [self.taluka_Textfield hideDropDownFromView];
}

/// show the taluka table
-(void)showTalukaTableView{
    [self.taluka_Textfield showDropDownFromView];
}

#pragma mark - textFiled delegate methods
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];

   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",currentString];
    arrCurrentSearchTalukaData = [sortedTalukaArray filteredArrayUsingPredicate:predicate];

    if (textField == self.taluka_Textfield ){
        
        if (self.taluka_Textfield.text.length >= 2) {
            if (self.taluka_Textfield.field.mValues.count >=1 && arrCurrentSearchTalukaData.count>=1) {
                   [self showTalukaTableView];
                   [self.taluka_Textfield reloadDropdownList_ForTalukaString:currentString];
            }
            else{
                if (length >= 2) {
                    [self APIactivityTypeForTalukaTextField:textField WithString:currentString AndStateCode:_state.code]; //new
                    
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
    
    if (textField == self.mobileNumberTextField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    if (textField == self.pincode_Textfield) {
        return NO;
//        if (length > 6)
//            return NO;
//        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    if (textField == self.mainPhoneNumberTextField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    if (textField == self.contactSearchTextField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    [self validateContactFieldsToEnableSubmitButton];
    return YES;
}
    
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    activeField = textField;
    
    if (textField == self.mobileNumberTextField || textField == self.contactSearchTextField || textField == self.mainPhoneNumberTextField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else{
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    if (![self.state_TextField.text isEqualToString:@""] || ![self.city_TextField.text isEqualToString:@""] || ![self.district_TextField.text isEqualToString:@""] || ![self.taluka_Textfield.text isEqualToString:@""] || ![self.addressLine_One_TextField.text isEqualToString:@""]) {
        [self make_Mandatory_AddressFields];
    }
    
    if (textField == self.taluka_Textfield && fetchTaluka){
//    
//        if (self.taluka_Textfield.text.length >= 2) {
//            
//            [self APIactivityTypeForTalukaTextField:textField WithString:@"" AndStateCode:_state.code]; //new
//
//        }
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [self validationForButtonState];
    [self validateSaveToDraft];
    
    if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        if (autoComplete_textField.resultTableView) {
            [autoComplete_textField.resultTableView removeFromSuperview];
        }
    }
    if ([self.state_TextField.text isEqualToString:@""] && [self.city_TextField.text isEqualToString:@""] && [self.district_TextField.text isEqualToString:@""] && [self.taluka_Textfield.text isEqualToString:@""] && [self.addressLine_One_TextField.text isEqualToString:@""]) {
        [self make_NonMandatory_AddressFields];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.taluka_Textfield && !fetchTaluka){
        
        if ([sortedTalukaArray count]> 0) {
            
           // [self showPopOver:textField withDataArray:sortedTalukaArray andModelData:[NSMutableArray arrayWithArray:sortedModelArr]];
            // [self showAutoCompleteTableForFinancierField];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder;
    if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT] && nextTag == 5) {
        nextTag +=1;
    }
    else if(nextTag == 6 && ![self.addressDetailsView isHidden]){
        nextResponder = [self.addressDetailsView viewWithTag:nextTag];

    }else if (nextTag == 6){
        nextResponder = nil;
    }
    else{
        nextResponder = [textField.superview viewWithTag:nextTag];
    }
    if (nextTag == 11) {
        [textField resignFirstResponder];
    }
    else{
    // Try to find next responder
    if (nextResponder) {
        // Found next responder, so set it.

            [nextResponder becomeFirstResponder];
            [textField resignFirstResponder];

        
        if (textField == self.pincode_Textfield){
            [textField resignFirstResponder];
        }
        [nextResponder becomeFirstResponder];
    }
    }
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - button Clicked
- (IBAction)saveToDraftButtonClicked:(id)sender{
    if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]) {

        if ([self.saveToDraftsButton.titleLabel.text isEqualToString:@"  Update Draft"]){
            //account update draft
            [self updateAccountDraft: EGDraftStatusSavedAsDraft];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_UpdateDraft_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];
    }
        else{
            [self saveAccountdraft:EGDraftStatusSavedAsDraft];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_SaveDraft_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

        }
    }else{
        if ([self.saveToDraftsButton.titleLabel.text isEqualToString:@"  Update Draft"]){
            [self updateContact:EGDraftStatusSavedAsDraft];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewContact_UpdateDraft_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

        }
        else{
            [self saveContact:EGDraftStatusSavedAsDraft];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewContact_SaveDraft_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

        }
    }
}

- (IBAction)submitButtonClicked:(id)sender {

    if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]) {
        if ([self isTextFieldDataValid]) {
            [self getAllAddressValuesInObject];
            [self getAllAccountValuesinObject];
            [self submitCreateAccountRequest:accountObjectLocal];
        }
    }else{
        if ([self isTextFieldDataValid]) {
            [self getAllAddressValuesInObject];
            [self getAllContactValuesinObject];
            [self submitCreateContactRequest:contactObjectLocal];
        }
    }
}

- (IBAction)createAccountButtonClicked:(id)sender {

    [UtilityMethods
     alert_showMessage:@"Do you want to Create to Account ?"
     withTitle:APP_NAME andOKAction:^{
         self.detailsObj = PROSPECT_ACCOUNT;
         [self configureView];
     }
     andNoAction:^{
         NSLog(@"This is a no block");
     }];
}

- (IBAction)importFromContactButtonClicked:(id)sender {
    if (contactPicker) {
        [self presentViewController:contactPicker animated:YES completion:nil];
    }else{
        [self initialiseContactPicker];
        [self importFromContactButtonClicked:sender];
    }
}

-(void)initialiseContactPicker{
    contactPicker = [CNContactPickerViewController new];
    
    [contactPicker.navigationController.navigationBar setTintColor:[UIColor heddingTextColor]];;
    contactPicker.delegate = self;
    [contactPicker.view setFrame:CGRectMake(0, 0, 200, 400)];
    [contactPicker setModalPresentationStyle:UIModalPresentationPageSheet];
}

- (void)showFetchingLocationLoader {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = MSG_FETCHING_LOCATION;
}

- (void)hideFetchingLocationLoader {
    if (hud) {
        [hud hideAnimated:true];
    }
}

- (void)clearLatLongValues {
    self.latitude = nil;
    self.longitude = nil;
}

- (IBAction)addressFromGPS:(UISwitch *)switchState {
    
    
    if (switchState.isOn) {
        
//        if ([UtilityMethods isLocationCaptureEnabled]) {
//            [self showFetchingLocationLoader];
//            [self startUpdatingLocation];
//        } else {
//            [self.gpsSwitch setOn:false];
//            [UtilityMethods showLocationAccessDeniedAlert];
//        }
        
        self.latitude = [[AppRepo sharedRepo] getLoggedInUser].latitude;
        self.longitude = [[AppRepo sharedRepo] getLoggedInUser].longitude;
        
    } else {
        [self clearLatLongValues];
    }
    
    [self validateSaveToDraft];
}
    
- (IBAction)searchContactButtonClicked:(id)sender {
    //_searchContactButton.enabled = false;
    //to hide keyboard
    [self.view.window endEditing:YES];
    if (self.contactSearchTextField.text.length == 10 && [UtilityMethods validateMobileNumber:self.contactSearchTextField.text]){

        [self openSearchResultViewFor:nil fromVC:self];
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_SearchContact_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

    }else{
        //_searchContactButton.enabled = true;
    [UtilityMethods alert_ShowMessage:@"Please enter valid Main Phone Number" withTitle:APP_NAME andOKAction:nil];
    }
}



-(void)openSearchResultViewFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    SearchResultsViewController *searchResult = [[UIStoryboard storyboardWithName:@"Search_Result" bundle:nil] instantiateViewControllerWithIdentifier:@"searchResult"];
    searchResult.detailsObj = [SEARCHRESULT stringByAppendingString:SEGUE];
    searchResult.searchResultFrom = SearchResultFrom_Prospect;
    searchResult.delegate = self;
    searchResult.searchByValue = [EGsearchByValues new];
    searchResult.searchByValue.radioButtonSelected = RADIO_CONTACT_BUTTON;
    searchResult.searchByValue.stringToSearch = self.contactSearchTextField.text;

    searchResult.entryPoint = InvokeFromPROSPECTEdit;
    [senderVC.navigationController pushViewController:searchResult animated:YES];
}

- (void)contactCreationSuccessfull:(EGContact*)contact fromView:(SearchResultFromPage)searchResultFromPage{
    //_searchContactButton.enabled = true;
//    [self validationForButtonState];
    NSLog(@"CALLLL %@",contact.contactID);
    EGContact *createdContact;
    
    if (searchResultFromPage == SearchResultFrom_ManageOpportunity) {
        createdContact = contact;
        
        self.contactfirstnamelbl.text=createdContact.firstName;
        self.contactlastnamelbl.text=createdContact.lastName;
        self.contactmobilenumberlbl.text=createdContact.contactNumber;
        self.contactSearchTextField.text=createdContact.contactNumber;
        self.contactid=createdContact.contactID;
    }else if (searchResultFromPage == InvokeFromPROSPECTEdit || searchResultFromPage == SearchResultFrom_Prospect){
        self.searchedContactToBelinkedtoAccount = contact;
        self.contactfirstnamelbl.text=searchedContactToBelinkedtoAccount.firstName;
        self.contactlastnamelbl.text=searchedContactToBelinkedtoAccount.lastName;
        self.contactmobilenumberlbl.text=searchedContactToBelinkedtoAccount.contactNumber;
        self.contactSearchTextField.text=searchedContactToBelinkedtoAccount.contactNumber;
        _contactid=createdContact.contactID;
    }
    
    [self validationForButtonState];
}

- (void)accountCreationSuccessfull:(EGAccount*)account fromView:(SearchResultFromPage)searchResultFromPage{
    
    //EGAccount *createdAccount;
    
    if (searchResultFromPage == SearchResultFrom_ManageOpportunity) {
        account = account;
        
        self.contactfirstnamelbl.text=account.siteName;
    
        self.opportunityContact = [[EGContact alloc] init];
        self.opportunityContact.firstName = self.opportunityContact.firstName;
        self.opportunityContact.lastName = self.opportunityContact.lastName;
        self.opportunityContact.contactNumber = self.opportunityContact.contactNumber;
        self.opportunityContact.contactID = self.opportunityContact.contactID;
        
    }
    else{
        accountObjectLocal.contactID = account.contactID;
    }
}


- (IBAction)hideShowView_ButttonClicked:(id)sender {
    
    if ([sender tag]) {
        __block BOOL hideAddressBar = YES;
        for (UITextField *textField in [self.addressDetailsView subviews]) {
            if ([textField isKindOfClass:[UITextField class]] && textField.text.length > 0) {
                hideAddressBar = NO;
                break;
            }
        }
        [self hideOrShowAddressDetailsView:hideAddressBar];
        
    }
    else{
        
        talukaTapRecognizer.cancelsTouchesInView = NO;
        tapRecognizer.cancelsTouchesInView = NO;

        [self setupTalukaTextField];
        self.addressDetailsView.hidden = TRUE;
        
        self.hideShowView_Buttton.tag = STATE_DISABLE;
//        self.pickFromGPSLabel.hidden = [sender tag];
//        self.gpsSwitch.hidden = [sender tag];
        self.addressDetailsView.hidden = [sender tag];
        self.hideShowView_Buttton.tag = ![sender tag];
        [self.hideShowView_Buttton setImage:[UIImage imageNamed:@"minus_button"] forState:UIControlStateNormal];
        [UtilityMethods setRedBoxBorder:self.addressLine_One_TextField];
//        [UtilityMethods setRedBoxBorder:self.pincode_Textfield];
        [UtilityMethods setRedBoxBorder:self.taluka_Textfield];
        [UtilityMethods setRedBoxBorder:self.state_TextField];   //new
        [self validationForButtonState];
    }
}


-(void)hideOrShowAddressDetailsView:(BOOL)hideAddressBar{
    if (hideAddressBar) {
        [self.hideShowView_Buttton setImage:[UIImage imageNamed:@"plus_button"] forState:UIControlStateNormal];
        [UtilityMethods setGreyBoxBorder:self.addressLine_One_TextField];
        [self clearAllTextFiledsInView:self.addressDetailsView];
//        self.pickFromGPSLabel.hidden = hideAddressBar;
//        self.gpsSwitch.hidden = hideAddressBar;
        self.addressDetailsView.hidden = hideAddressBar;
        self.hideShowView_Buttton.tag = !hideAddressBar;
        
        if ([self.gpsSwitch isOn]) {
            [self.gpsSwitch setOn:FALSE];
        }
        [self validationForButtonState];
        
        if ([self.entryPoint isEqualToString:DRAFT]) {
            if (self.draftAccount.draftIDAccount || self.draftContact.draftIDContact) {
                [self.saveToDraftsButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
                
            }else{
                [self.saveToDraftsButton  setTitle:SAVE_AS_DRAFT forState:UIControlStateNormal];
            }
        }
        else{
            if ([self.currentDraftID hasValue]) {
                [self.saveToDraftsButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
                
            }else{
                [self.saveToDraftsButton  setTitle:SAVE_AS_DRAFT forState:UIControlStateNormal];
            }
        }
        
        [self disableOrEnableButton:self.saveToDraftsButton withState:STATE_ENABLE];
        
    }else{
        [UtilityMethods alert_showMessage:@"Filled Address data will be Lost ... Do you want to proceed ?" withTitle:APP_NAME andOKAction:^{
            [self hideOrShowAddressDetailsView:YES];
        } andNoAction:^{
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SearchCOntact delegate method
-(void)searchContactSelectedValue:(EGContact *)selectedContact withIndex:(NSInteger)rowIndex
{
    //_searchContactButton.enabled = true;
    [search_contact_View removeFromSuperview];
    searchedContactToBelinkedtoAccount = selectedContact;
    self.contactSearchTextField.text = selectedContact.firstName;
    NSMutableSet *contactSet = [[NSMutableSet alloc] initWithObjects:selectedContact, nil];
    accountObjectLocal.toContact = contactSet;
    [self gestureHandlerMethod:nil];
}

#pragma mark - gesture methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
        return YES;
    }

    
    if ([touch.view isDescendantOfView:search_contact_View]) {
        return NO;
    }
    
    if([touch.view isKindOfClass:[UIPickerView class]]){
        return NO;
    }
    
//    if ([touch.view isDescendantOfView:autoComplete_textField.resultTableView]) {
//        return NO;
//    }
    return YES;
}

-(void)gestureHandlerMethod:(id)sender{
    
    [activeField resignFirstResponder];
//    if (activeField != nil && [activeField isKindOfClass:[UITextField class]]) {
//        activeField.text = @"";
//    }
}

- (void)addTapGesturePincodeField {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture addTarget:self action:@selector(fieldTapped:)];
    [self.pincodeView addGestureRecognizer:tapGesture];
    [self.pincodeView setUserInteractionEnabled:true];
    [self.pincode_Textfield setEnabled:false];
}

- (void)fieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded) {
                if (CGRectContainsPoint(textField.frame, point)) {
                    if (textField == self.pincode_Textfield) {
                        [self.view endEditing:true];
                        [self addressAPICalls:textField];
                    }
                }
            }
        }
    }
}

#pragma mark - Address Service Calls

-(void)pincodeFieldBeingEditted{
    if (self.taluka_Textfield.text.length > 0 && self.state_TextField.text.length > 0 ) {
        
        [self.pincode_Textfield addSubview:[self actIndicatorForView:self.pincode_Textfield]];
        [self.actIndicator stopAnimating];
        [self.actIndicator startAnimating];
        
        if ([self.entryPoint isEqualToString:DRAFT]) {
            
            NSDictionary * queryDictionary;
            if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
                queryDictionary =@{@"state": @{@"state":[[self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"],
                                               @"code":[[self.draftContact valueForKeyPath:@"toContact.toAddress.toState.code"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toState.code"]},
                                   @"district" : self.district_TextField.text,
                                   @"city" : self.city_TextField.text,
                                   @"taluka" : self.taluka_Textfield.text
                                   };
            }
            else if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]){
                queryDictionary = @{@"state": @{@"state":[[self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.name"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.name"],
                                                @"code":[[self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.code"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.code"]},
                                    @"district" : self.district_TextField.text,
                                    @"city" : self.city_TextField.text,
                                    @"taluka" : self.taluka_Textfield.text
                                    };
            }
            
            [[EGRKWebserviceRepository sharedRepository]getPinFromTalukaCityDistrictState:queryDictionary
                                                                          andSucessAction:^(id pin) {
                                                                              [self.actIndicator stopAnimating];
                                                                              [self pinCodeFetchedSuccessfullyWithDictionary:pin];
                                                                          } andFailuerAction:^(NSError *error) {
                                                                              [self pinCodeFetchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
                                                                          }];
            
        }else{
            [[EGRKWebserviceRepository sharedRepository]getPinFromTalukaCityDistrictState:
             @{@"state": @{@"state":self.state.name,@"code":self.state.code},
               @"district" : self.district_TextField.text,
               @"city" : self.city_TextField.text,
               @"taluka" : self.taluka_Textfield.text
               }
                                                                          andSucessAction:^(id pin) {
                                                                              [self.actIndicator stopAnimating];
                                                                              [self pinCodeFetchedSuccessfullyWithDictionary:pin];
                                                                          } andFailuerAction:^(NSError *error) {
                                                                              [self pinCodeFetchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
                                                                          }];
        }
        
    }
    else{
        if (self.taluka_Textfield.text.length > 0){
            [UtilityMethods alert_ShowMessage:@"Enter Taluka" withTitle:APP_NAME andOKAction:^{
                [self.pincode_Textfield resignFirstResponder];
            }];
        }else{
            [self.pincode_Textfield resignFirstResponder];
        }
    }
}


-(void)addressAPICalls:(UITextField *)textField{
    if (textField == self.pincode_Textfield) {
        [self pincodeFieldBeingEditted];
    }
}

-(void)talukaFetchedSuccessfullyWithDictionary:(NSDictionary *)responseObject{
    NSArray * arrayOfWithTalukas = [responseObject objectForKey:@"talukas"];
    [autoComplete_textField loadTableViewForTalukaTextFiled:autoComplete_textField.frame onView:self.addressDetailsView withArray:[arrayOfWithTalukas valueForKeyPath:@"name"]];
}

-(void)talukaFetchFailedWithErrorMessage:(NSString *)errorMessage{
    
    [ScreenshotCapture takeScreenshotOfView:self.view];
    appdelegate.screenNameForReportIssue = @"Prospect View: Taluka Fetch";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

//    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
}
-(void)pinCodeFetchedSuccessfullyWithDictionary:(NSDictionary *)responseObject{

    NSLog(@"response %@",responseObject);
    NSMutableArray *array =  [responseObject valueForKey:@"pincodes"];
    if ([array count] > 0) {
        [self showPopOver:self.pincode_Textfield withDataArray:array andModelData:array];
    }
    else{
        [UtilityMethods alert_ShowMessage:CouldnotFetchDataMessage withTitle:APP_NAME andOKAction:nil];

    }
    }

-(void)pinCodeFetchFailedWithErrorMessage:(NSString *)errorMessage{
    [ScreenshotCapture takeScreenshotOfView:self.view];
    appdelegate.screenNameForReportIssue = @"Prospect View: Pin Code Fetch";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
//    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
}

-(void)contactSearchedSucessfully:(id)responseData{
    NSArray *contactsArray = (NSArray *)responseData;
    search_contact_View = [[SearchContactView alloc] initWithFrame:CGRectMake(0, 0, 280, 400) andData:contactsArray];
    search_contact_View.delegate = self;
    search_contact_View.center = self.view.center;
    [self.view addSubview:search_contact_View];
    
}
-(void)contactSearchFailedWithErrorMessage:(NSString *)errorMessage{
    [ScreenshotCapture takeScreenshotOfView:self.view];
    appdelegate.screenNameForReportIssue = @"Prospect View: Contact Search";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
}


#pragma mark locationDelegate method
- (void)locationManagerSingletonDidUpdateLocation:(CLLocation *)location {
    
    [self hideFetchingLocationLoader];
    NSLog(@"lat : %f,long : %f",location.coordinate.latitude,location.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
}

- (void)locationManagerFailedToUpdateLocation:(NSError *)error {
    
    [self hideFetchingLocationLoader];
    NSLog(@"error:%@", error);
    [self.gpsSwitch setOn:false];
    
    
    [UtilityMethods alert_ShowMessage:[NSString stringWithFormat:LOCATION_FETCH_FAILED_MSG, APP_NAME] withTitle:APP_NAME andOKAction:^{
        
    }];
}

- (void)passAddressFromLocation:(EGAddress *)address
{
    NSLog(@"pin--%@",address.pin);
    if (address) {
        addressObject = address;
        
        if (![addressObject.pin isEqualToString:@""]) {
            [self APIactivityTypeForPINCODETextField:addressObject.pin];
        }
        
        self.state_TextField.text = addressObject.state.name;
        self.district_TextField.text = addressObject.district;
        self.city_TextField.text = addressObject.city;
        self.taluka_Textfield.text = addressObject.taluka.talukaName;
        self.pincode_Textfield.text = addressObject.pin;
        self.addressLine_One_TextField.text = addressObject.addressLine1;
        
        contactObjectLocal.toAddress = addressObject;
        accountObjectLocal.toAddress = addressObject;
        
        [self validateSaveToDraft];
        [self validationForButtonState];
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

- (DropDownTextField *)stateDropDownTextField {
    
    if (!_state_TextField.field) {
        _state_TextField.field = [[Field alloc] init];
    }
    return _state_TextField;
}


- (void)addGestureToDropDownFields {

    talukaTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [talukaTapRecognizer setNumberOfTapsRequired:1];
    [talukaTapRecognizer setNumberOfTouchesRequired:1];
    [[self.state_TextField superview] addGestureRecognizer:talukaTapRecognizer];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            DropDownTextField *textField = (DropDownTextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                
                if (textField == self.stateDropDownTextField) {
                    [self fetchAllStates];
                }
               
            }
        }
    }
    
}

-(void)clearSelectedTalukadata{
   // self.taluka_Textfield.field.mValues = nil;
//    self.taluka_Textfield.text = nil;
    self.district_TextField.text = nil;
    self.city_TextField.text = nil;
    [self.taluka_Textfield hideDropDownFromView];

}

- (void)fetchAllStates {
    self.taluka_Textfield.field.mValues = nil;
    self.taluka_Textfield.text = nil;
    [self clearSelectedTalukadata];
    [[EGRKWebserviceRepository sharedRepository] getStates:nil andSucessAction:^(NSArray *statesArray) {
        if (statesArray && [statesArray count] > 0) {
            [self showLOBDropDown:[statesArray mutableCopy]];
        }
    
    } andFailuerAction:^(NSError *error) {

    }];
    
}

- (void)showLOBDropDown:(NSMutableArray *)arrLOB {
    
    NSArray *nameResponseArray = [arrLOB valueForKey:@"name"];
    self.state_TextField.field.mValues = [nameResponseArray mutableCopy];
    self.state_TextField.field.mDataList = [arrLOB mutableCopy];
    [self showDropDownForView:self.state_TextField];
    
}

- (void)showDropDownForView:(DropDownTextField *)textField {
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}


- (BOOL)fieldInputValid:(UITextField *)currentTextField {
    BOOL hasValidInput = true;
    NSString *errorMessage;
    
    if (currentTextField == self.state_TextField && ![self.state_TextField.text hasValue]) {
        errorMessage = @"Please select States";
        hasValidInput = false;
    }
    if (!hasValidInput && errorMessage) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    
    return hasValidInput;
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
                    
                    for (EGTaluka *tal in talukaArray) {
//                        [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@ - %@" , tal.talukaName ,tal.district, tal.city , tal.state.code]];
                        [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]];
                    }
                    //Sorting in Ascending order to show popup
                    
                    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                    NSArray *sortedTaluka = [talArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    sortedTalukaArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                    self.taluka_Textfield.field.mValues = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedTaluka]];
                    fetchTaluka = NO;
                   
                    if ([sortedTalukaArray count]> 0) {
                        [self  showAutoCompleteTableForFinancierField];
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
            //        [UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
            //        }];
        }];
    
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.taluka_Textfield) {
        [self clearAllTextFiledsInView:self.addressDetailsView];
    }
    return YES;
}

-(void)APIactivityTypeForPINCODETextField:(NSString *)pinCodeFromGps{
    [[EGRKWebserviceRepository sharedRepository]getAllPIN:@{@"pincode" : pinCodeFromGps} andSucessAction:^(EGReversePincode* reversePinData) {
        
        self.pincode_Textfield.text =reversePinData.pincode;
        
    } andFailuerAction:^(NSError *error) {
        
    }];
}
- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] initWithWidth:TALUKA_DROP_DOWN_WIDTH];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField = (UITextField *)dropDownForView;
    if (activeField == self.taluka_Textfield) {
        [self clearAllTextFiledsInView:self.addressDetailsView];
    }
    if([dropDownForView isEqual:self.taluka_Textfield]){
        EGTaluka *tal = (EGTaluka *)selectedObject;
        self.taluka_Textfield.text = tal.talukaName;
        self.state_TextField.text=tal.state.name;
        self.state = tal.state;
        self.district_TextField.text=tal.district;
        self.city_TextField.text=tal.city;
//        self.taluka_Textfield.text=tal.talukaName;
        self.talukaObj = tal;
        
    }else if ([dropDownForView isEqual:self.pincode_Textfield]){
        
        NSString *pins = selectedObject;
        self.pincode_Textfield.text = pins;
        
        if ([self.detailsObj isEqualToString:PROSPECT_ACCOUNT]) {
            [self disableOrEnableButton:self.submitButton withState:[self validateAccountFieldsToEnableSubmitButton]];
        }
        else if ([self.detailsObj isEqualToString:PROSPECT_CONTACT]) {
            [self disableOrEnableButton:self.submitButton withState:[self validateContactFieldsToEnableSubmitButton]];
        }
    }
    else if ([dropDownForView isEqual:self.state_TextField]){
        _state = (EGState *)selectedObject;
        self.state_TextField.text = _state.name;
//        NSString *strCode = state.code;
        
    }
}

#pragma mark - Location

- (void)startUpdatingLocation {
    
    [[LocationManagerSingleton sharedLocationInstance] setDelegate:self];
    [[LocationManagerSingleton sharedLocationInstance] setDidFindLocation:false];
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] startUpdatingLocation];
}



//old
//- (void)showAutoCompleteTableForFinancierField {
//    [self showTalukaTableView];
//
//    if (sortedTalukaArray && [sortedTalukaArray count] > 0) {
//        
//        if (self.taluka_Textfield.field.mValues && [self.taluka_Textfield.field.mValues count] > 0) {
//            
//            [self.taluka_Textfield loadTableViewForTalukaTextFiled:self.taluka_Textfield.frame
//                                                        onView:self.view
//                                                     withArray:self.taluka_Textfield.field.mValues
//                                                         atTop:true];
//            
//            [self.taluka_Textfield.resultTableView reloadData];
//            
//        } else {
//            [self setTalukaValuesInTalukaField];
//        }
//
//    }
//}

// new Upendra dubey
- (void)showAutoCompleteTableForFinancierField {
    
    [self showTalukaTableView];

    if (sortedTalukaArray && [sortedTalukaArray count] > 0) {
        if (self.taluka_Textfield.field.mValues && [self.taluka_Textfield.field.mValues count] > 0) {
            CGRect aRect = CGRectMake(self.taluka_Textfield.frame.origin.x, self.taluka_Textfield.frame.origin.y, self.taluka_Textfield.frame.size.width*2, self.taluka_Textfield.frame.size.height);
           
            [self.taluka_Textfield loadTableViewForTalukaTextFiled:aRect
                                                            onView:self.view
                                                         withArray:self.taluka_Textfield.field.mValues
                                                             atTop:true
                                                            isFromBeatPlan:false];

            
            [self.taluka_Textfield.resultTableView reloadData];

        } else {
            [self setTalukaValuesInTalukaField];
            
        }
    }
}


#pragma mark - AutoCompleteUITextFieldDelegate Methods
//old
//- (void)selectedActionSender:(id)sender {
//    [self.view endEditing:true];
//
//   // NSLog(@"self.taluka_Textfield.text name:%@", self.taluka_Textfield.text);
//
//    ///// Showing the data on talika , district and city
//    NSArray *listItems = [self.taluka_Textfield.text componentsSeparatedByString:@" - "];
//    NSLog(@"listItems name:%@", listItems);
//
//
//    if (listItems.count > 0) {
//         self.taluka_Textfield.text = [listItems objectAtIndex:0];
//    }
//    if (listItems.count >=1) {
//        self.district_TextField.text = [listItems objectAtIndex:1];
//
//    }
//    if (listItems.count >=2) {
//       self.city_TextField.text = [listItems objectAtIndex:2];
//    }
//
//
////    self.taluka_Textfield.font   =   [UIFont systemFontOfSize:12.5f];
////    self.district_TextField.font =   [UIFont systemFontOfSize:12.5f];
////    self.city_TextField.font     =   [UIFont systemFontOfSize:12.5f];
////    self.city_TextField.textColor=  [[UIColor blackColor] colorWithAlphaComponent:1.0f];
////    self.district_TextField.textColor=  [[UIColor blackColor] colorWithAlphaComponent:1.0f];
////    self.taluka_Textfield.textColor=  [[UIColor blackColor] colorWithAlphaComponent:1.0f];
// //   self.taluka_Textfield.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0f];
//}

//new Upendra Dubey
- (void)selectedActionSender:(id)sender {
    
    [self.view endEditing:true];
    
    NSLog(@"self.taluka_Textfield.text name:%@", self.taluka_Textfield.text);
    for (EGTaluka *tal in talukaArray) {

        if ([self.taluka_Textfield.text isEqualToString:[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]])
        {
            NSLog(@"Equal data found ");
            NSLog(@"selected data  %@",[NSString stringWithFormat:@"%@ - %@ - %@" , tal.talukaName ,tal.district, tal.city]);
            self.taluka_Textfield.text = tal.talukaName;
            self.district_TextField.text = tal.district;
            self.city_TextField.text = tal.city;
        }
    }
}

#pragma mark - Private Methods

- (void)setupTalukaTextField {
    self.taluka_Textfield.autocompleteTableRowSelectedDelegate = self;
    self.taluka_Textfield.field = [[Field alloc] init];
    
}
- (void)setTalukaValuesInTalukaField {
    [UtilityMethods RunOnBackgroundThread:^{
        [UtilityMethods RunOnOfflineDBThread:^{
             self.taluka_Textfield.field.mValues = [[sortedTalukaArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
            
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAutoCompleteTableForFinancierField];
            }];
        }];
    }];
}

- (void)getTalukaObjectForTalukaName:(NSString *)talukaName {
    
    NSLog(@"talukaName name:%@", talukaName);
    NSArray *listItems = [talukaName componentsSeparatedByString:@"-"];
    NSLog(@"listItems name:%@", listItems);
}


@end

