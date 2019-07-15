//
//  MandatoryFieldsViewController.m
//  e-Guru
//
//  Created by MI iMac04 on 24/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ScreenshotCapture.h"
#import "MandatoryFieldsViewController.h"
#import "COTextFieldView.h"
#import "COSearchTextFieldView.h"
#import "COAutoCompleteTextFieldView.h"
#import "CODropDownView.h"
#import "ValidationUtility.h"
#import "PrimaryField.h"
#import "Field.h"
#import "Constant.h"
#import "SeparatorView.h"
#import "ContactView.h"
#import "AccountView.h"
#import "AutoCompleteUITextField.h"
#import "NSString+NSStringCategory.h"
#import "DropDownTextField.h"
#import "ProspectViewController.h"
#import "SearchResultViewController.h"
#import "EGReferralCustomer.h"
#import "EGContact.h"
#import "AAAContactMO+CoreDataClass.h"
#import "AAADraftContactMO+CoreDataProperties.h"
#import "AAAAccountMO+CoreDataClass.h"
#import "AAADraftAccountMO+CoreDataProperties.h"
#import "EGAccount.h"
#import "PureLayout.h"
#import "UserDetails.h"
#import "AppDelegate.h"
#import "EGMMGeography.h"
#import "EGVCNumber.h"
#import "EGTGM.h"
#import "AppRepo.h"
#import "SearchResultsViewController.h"
#import "AAALobInformation+CoreDataClass.h"
#import "AAALobInformation+CoreDataProperties.h"
#import "AAAVCNumberMO+CoreDataClass.h"
#import "AAAVCNumberMO+CoreDataProperties.h"
#import "AAACampaignMO+CoreDataClass.h"
#import "AAACampaignMO+CoreDataProperties.h"
#import "AAAReferralCustomerMO+CoreDataClass.h"
#import "AAAReferralCustomerMO+CoreDataProperties.h"
#import "AAAEventMO+CoreDataClass.h"
#import "AAAEventMO+CoreDataProperties.h"
#import "EGDraftStatus.h"
#import "VehicleApplicationDBHelper.h"
#import "MMGeographyDBHelpers.h"
#import "UsageCategoryDBHelper.h"
#import "CustomerTypeDBHelper.h"
#import "SourceOfContactDBHelpers.h"
#import "ReferalTypesDBHelper.h"
#import "EventDBHelper.h"
#import "ReachabilityManager.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "LocationManagerSingleton.h"

@interface MandatoryFieldsViewController () <ProspectViewControllerDelegate, SearchResultViewControllerDelegate,SearchResultsViewControllerDelegate, UIGestureRecognizerDelegate, AutoCompleteUITextFieldDelegate, LocationManagerSingletonDelegate> {
    BOOL createOpty;
    BOOL forceCreateOpty;
    NSDictionary *commentJson;
}

@property (nonatomic, strong) NSMutableArray *dynamicFieldsArray;
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) ContactView *contactView;
@property (nonatomic, strong) AccountView *accountView;
@property (nonatomic, strong) GreyBorderUITextField *referralCustomerTextField;
@property (nonatomic, strong) AutoCompleteUITextField *mmGeographyTextField;
@property (nonatomic, strong) AutoCompleteUITextField *eventTextField;
@property (nonatomic, strong) UIAlertController *cachedAlertController;
@property (nonatomic) MBProgressHUD *hud;
@property (nonatomic) EGReferralCustomer *selectedReferralCustomer;
@property (nonatomic) NSTimer *locationTimer;
@property (nonatomic, strong) UIAlertController *couldNotFetchLocationAlert;

@end

@implementation MandatoryFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.activityObj.stakeholderResponse != nil) {
        commentJson = [UtilityMethods getJSONFrom:self.activityObj.stakeholderResponse];
        NSLog(@"commentJson %@",commentJson);
    }
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self fetchFieldsListBasedOnSelectedLOB];
    [self bindTapToView:self.containerView];
    NSLog(@"%@",self.opportunity.optyID);
    // Set the seleted LOB, PPL and PL values
    [self bindLOBPPLPLData];
    
    if (self.entryPoint == InvokeForUpdateOpportunity) {
        [self adjustUIForUpdateOptyOperation];
    }
    else if (self.entryPoint == InvokeForDraftEdit || self.entryPoint == InvokeForCreateOpportunity || self.entryPoint == InvokeFromProductApp) {
        if (self.entryPoint == InvokeForDraftEdit) {
            [self adjustUIForEditDraftOperation];
        }
        createOpty = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInternetAvailable) name:NOTIFICATION_NETWORK_AVAILABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInternetNotAvailable) name:NOTIFICATION_NETWORK_NOT_AVAILABLE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_NETWORK_AVAILABLE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_NETWORK_NOT_AVAILABLE object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.cachedAlertController) {
        UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [window presentViewController:self.cachedAlertController animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self bindValuesToOpportunityModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)adjustUIForUpdateOptyOperation {
    [self.saveAsDraftButton setHidden:true];
}

- (void)adjustUIForEditDraftOperation {
    [self.saveAsDraftButton setTitle:@"Update Draft" forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
    
    if (!self.didSetupConstraints) {
        
        if (self.dynamicFieldsArray && [self.dynamicFieldsArray count] > 0) {
            [self renderFieldsFromList:self.dynamicFieldsArray];
        }
        self.didSetupConstraints = true;
    }
    
    [super updateViewConstraints];
}

- (PrimaryField *)primaryField {
    if (!_primaryField) {
        _primaryField = [[PrimaryField alloc] init];
        Field *lob = [[Field alloc] init];
        lob.mTitle = FIELD_LOB;
        lob.mSelectedValue = self.opportunity.toVCNumber.lob;
        _primaryField.mLOBField = lob;
        
        Field *ppl = [[Field alloc] init];
        ppl.mTitle = FIELD_PPL;
        ppl.mSelectedValue = self.opportunity.toVCNumber.ppl;
        _primaryField.mPPLField = ppl;
        
        Field *pl = [[Field alloc] init];
        pl.mTitle = FIELD_PL;
        pl.mSelectedValue = self.opportunity.toVCNumber.pl;
        _primaryField.mPLField = pl;
    }
    return _primaryField;
}

#pragma mark - Bind Values to UI

- (void)bindOpportunityModelDataToField:(Field *)field {
    if (!field || !self.opportunity) {
        return;
    }
    
    if ([field.mTitle isEqualToString:FIELD_VEHICLE_APPLICATION]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.vehicleApplication;
    }
    else if ([field.mTitle isEqualToString:FIELD_CUSTOMER_TYPE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.customerType;
    }
    else if ([field.mTitle isEqualToString:FIELD_SOURCE_OF_CONTACT]) {
        if (commentJson != nil) {
            if([self isValidReferralOptyData]){
                field.mSelectedValue = @"Referral";
            }else{
                
                NSString *type = [self getMappedSourceContact:commentJson[@"channel_type"]];
                field.mSelectedValue = type;
                
                if ([type isEqualToString:@"Body Builder Meet"] || [type isEqualToString:@"Financier Meet"]){
                    self.opportunity.reffralType = @"Influencer";
                }
            }
        }else{
            field.mSelectedValue = self.opportunity.sourceOfContact;
        }
    }
    else if ([field.mTitle isEqualToString:FIELD_QUANTITY]) {
        field.mSelectedValue = self.opportunity.quantity;
    }
    else if ([field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
        if (commentJson != nil && !self.isFromReferralOptyCreatioin) {
           
                NSString *type = commentJson[@"channel_type"];
            
                if ([[type lowercaseString] isEqualToString:@"key customer"] || [[type lowercaseString] isEqualToString:@"regular visits"]){
                    self.opportunity.toLOBInfo.mmGeography = commentJson[@"mmgeo"];
                    field.mSelectedValue = commentJson[@"mmgeo"];
                }
            
        }else{
            field.mSelectedValue = self.opportunity.toLOBInfo.mmGeography;
        }
    }
    else if ([field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.bodyType;
    }
    else if ([field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.totalFleetSize;
    }
    else if ([field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.tmlFleetSize;
    }
    else if ([field.mTitle isEqualToString:FIELD_REFERRAL_TYPE]) {
        field.mSelectedValue = self.opportunity.reffralType;
    }
    else if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
        if (commentJson!=nil){
            self.opportunity.toReferral.cellPhoneNumber = commentJson[@"contact_no"];
            field.mSelectedValue = self.opportunity.toReferral.cellPhoneNumber;
        }else{
            field.mSelectedValue = [NSString stringWithFormat:@"%@ %@", self.opportunity.toReferral.firstName, self.opportunity.toReferral.lastName];
        }
        self.selectedReferralCustomer = self.opportunity.toReferral;
    }
    else if ([field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.usageCategory;
    }
    else if ([field.mTitle isEqualToString:FIELD_EVENT]) {
        field.mSelectedValue = self.opportunity.eventName;
    }
    //    else if ([field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
    //        field.mSelectedValue = self.opportunity.potentialDropOff;
    //    }
}

-(BOOL)isValidReferralOptyData{
    
    if(!self.isFromReferralOptyCreatioin){
        return NO;
    }
    if(![[commentJson[@"channel_type"] lowercaseString] isEqualToString:@"key customer"]){
        return YES;
    }
    
    if(![[commentJson[@"channel_type"] lowercaseString] isEqualToString:@"regular visits"]){
        return YES;
    }
    
    if(![[commentJson[@"channel_type"] lowercaseString] isEqualToString:@"any other channel type"]){
        return YES;
    }
    
    return NO;
}

- (void)bindContactDataFromOpportunityModel {
    if (self.contactView && self.opportunity && self.opportunity.toContact) {
        EGContact *contact = self.opportunity.toContact;
        if ([contact.contactID hasValue]) {
            
            [self.contactView.contactNumberTextField setText:contact.contactNumber];
            [self.contactView.firstNameTextField setText:contact.firstName];
            [self.contactView.lastNameTextField setText:contact.lastName];
            [self.contactView.mobileNumberTextField setText:contact.contactNumber];
        }
        else{
            [self.contactView.contactNumberTextField setText:contact.contactNumber];
        }
    }
    //    else if (self.commentsString.length > 0 || ![self.commentsString isEqualToString:@""] || commentJson != nil) {
    //        [self.contactView.contactNumberTextField setText:commentJson[@"contact_no"]];
    //        [self.contactView.firstNameTextField setText:commentJson[@"first_name"]];
    //        [self.contactView.lastNameTextField setText:commentJson[@"last_name"]];
    //        [self.contactView.mobileNumberTextField setText:commentJson[@"contact_no"]];
    //    }
}



-(NSString *)getMappedSourceContact:(NSString *)type {
    
    NSDictionary* letterValues = @{
                                   @"financier executives" : @"Financier Meet",
                                   @"body builders"        : @"Body Builder Meet",
                                   @"key customer"         : @"Key Account customer"
                                   };
    
    return (letterValues[type.lowercaseString] != nil) ? letterValues[type.lowercaseString] : @"";
}


- (void)bindAccountDataFromOpportunityModel {
    
    if (![[ValidationUtility sharedInstance] isAccountMandatory:self.opportunity.toVCNumber.lob]) {
        return;
    }
    
    if (self.accountView && self.opportunity.toAccount) {
        EGAccount *account = self.opportunity.toAccount;
        if ([account.accountID hasValue]) {
            
            [self.accountView.accountNameTextField setText:account.accountName];
            [self.accountView.accountSiteTextField setText:account.siteName];
            [self.accountView.accountPhoneNumberTextField setText:account.contactNumber];
            [self.accountView.accountNumberTextField setText:account.contactNumber];
        }
        else{
            
            [self.accountView.accountNumberTextField setText:account.contactNumber];
        }
    }
}

- (void)bindLOBPPLPLData {
    if (self.opportunity) {
        
        [self.selectedLOBLabel setText:self.opportunity.toVCNumber.lob];
        [self.selectedPPLLabel setText:self.opportunity.toVCNumber.ppl];
        [self.selectedPLLabel setText:self.opportunity.toVCNumber.pl];
        [self.selectedVCNumLabel setText:self.opportunity.toVCNumber.vcNumber];
    }
}

#pragma mark - Private Methods

- (void)fetchFieldsListBasedOnSelectedLOB {
    
    self.dynamicFieldsArray = [[ValidationUtility sharedInstance] getMandatoryFields:self.primaryField];
    //NSLog(@"%lu",(unsigned long)[self.dynamicFieldsArray count]);
    //NSLog(@"%@",[self.dynamicFieldsArray description]);
    for (Field *field in self.dynamicFieldsArray) {
        //NSLog(@"%@",field.mTitle);
        [self bindOpportunityModelDataToField:field];
    }
    
    // For 2nd level dependent fields e.g. Event Field
    if ([[ValidationUtility sharedInstance] getConditionalMandatoryFields:self.dynamicFieldsArray]) {
        for (Field *field in self.dynamicFieldsArray) {
            [self bindOpportunityModelDataToField:field];
        }
    }
    
    // For 3rd level dependent fields e.g. Referral Customer Field
    if ([[ValidationUtility sharedInstance] getConditionalMandatoryFields:self.dynamicFieldsArray]) {
        for (Field *field in self.dynamicFieldsArray) {
            [self bindOpportunityModelDataToField:field];
        }
    }
}

- (void)renderFieldsFromList:(NSMutableArray *)fieldsList {
    
    UIView *fieldsParentView = self.containerView;
    
    if (fieldsList && [fieldsList count] > 0) {
        
        NSMutableArray *singleRowFieldsArray = [[NSMutableArray alloc] init];
        id previousRowFirstField = nil;
        id currentRowFirstField = nil;
        int currentFieldIndex = 0;
        
        for (Field *field in fieldsList) {
            
            id generatedCustomView = [self getViewCorrespondingToField:field];
            [fieldsParentView addSubview:generatedCustomView];
            
            if ((currentFieldIndex % NO_OF_COLUMNS) == 0) {
                
                [generatedCustomView autoSetDimension:ALDimensionHeight toSize:DYNAMIC_FIELD_VIEW_HEIGHT];
                currentRowFirstField = generatedCustomView;
                
                // Retrive previous row first field from singleRowFieldsArray
                if (singleRowFieldsArray && [singleRowFieldsArray count] > 0) {
                    previousRowFirstField = [singleRowFieldsArray objectAtIndex:0];
                }
                
                // Set first field constraints based on previous field exists
                // or not
                if (previousRowFirstField) {
                    [currentRowFirstField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousRowFirstField];
                    [currentRowFirstField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:previousRowFirstField];
                    [currentRowFirstField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousRowFirstField];
                }
                else {
                    [currentRowFirstField autoPinEdgeToSuperviewEdge:ALEdgeTop];
                }
                
                [singleRowFieldsArray removeAllObjects];
            }
            
            [singleRowFieldsArray addObject:generatedCustomView];
            
            if (([singleRowFieldsArray count] == NO_OF_COLUMNS) || (currentFieldIndex == ([fieldsList count] - 1))) {
                
                // Fill empty views in singleRowFieldsArray to balance view
                // placement. If singleRowFieldsArray has 1 fields then add till
                // the array count becomes equal to NO_OF_COLUMNS
                for (NSInteger index = [singleRowFieldsArray count]; index < NO_OF_COLUMNS ; index ++) {
                    UIView *emptyView = [[UIView alloc] init];
                    [fieldsParentView addSubview:emptyView];
                    [singleRowFieldsArray addObject:emptyView];
                }
                
                [singleRowFieldsArray autoMatchViewsDimension:ALDimensionWidth];
                [singleRowFieldsArray autoMatchViewsDimension:ALDimensionHeight];
                [singleRowFieldsArray autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:30.0 insetSpacing:false matchedSizes:YES];
            }
            
            currentFieldIndex++;
        }
        
        id lastRowView = [singleRowFieldsArray objectAtIndex:NO_OF_COLUMNS - 1];
        //if (self.entryPoint != InvokeForUpdateOpportunity) {
        [self addSeparatorBelowView:lastRowView];
        //}
    }
}

- (void)addSeparatorBelowView:(id)view {
    
    SeparatorView *separatorView = [[SeparatorView alloc] init];
    [self.containerView addSubview:separatorView];
    
    // Set Constraints
    [separatorView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [separatorView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [separatorView autoSetDimension:ALDimensionHeight toSize:SEPARATOR_HEIGHT];
    [separatorView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:20.0f];
    
    // Attach Contact and Account View
    [self addContactsViewBelowView:separatorView];
}

- (void)addContactsViewBelowView:(id)view {
    
    self.contactView = [[ContactView alloc] init];
    [self.containerView addSubview:self.contactView];
    
    // Set Constraints
    [self.contactView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.contactView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.contactView autoSetDimension:ALDimensionHeight toSize:DYNAMIC_CONTACT_ACCOUNT_VIEW_HEIGHT];
    [self.contactView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10.0f];
    self.contactView.contactNumberTextField.delegate = self;
    self.contactView.contactNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.contactView.addContactButton setImageEdgeInsets:UIEdgeInsetsZero];
    [self.contactView.searchContactButton setImageEdgeInsets:UIEdgeInsetsZero];
    
    //    if (self.entryPoint == InvokeForUpdateOpportunity) {
    //        self.contactView.addContactButton.enabled = false;
    //        self.contactView.searchContactButton.enabled = false;
    //        self.contactView.contactNumberTextField.enabled = NO;
    //    }
    //    else{
    // Bind Action to Contact View buttons
    [self.contactView.addContactButton addTarget:self action:@selector(addContactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contactView.searchContactButton addTarget:self action:@selector(addSearchContactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    
    // Bind Data from Opportunity Model if available
    [self bindContactDataFromOpportunityModel];
    
    // Check if account is mandatory for selected LOB
    if ([[ValidationUtility sharedInstance] isAccountMandatory:self.opportunity.toVCNumber.lob]) {
        [self addAccountViewBelow:self.contactView];
    }
}

- (void)addAccountViewBelow:(id)view {
    
    self.accountView = [[AccountView alloc] init];
    [self.containerView addSubview:self.accountView];
    
    // Set Constraints
    [self.accountView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.accountView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.accountView autoSetDimension:ALDimensionHeight toSize:DYNAMIC_CONTACT_ACCOUNT_VIEW_HEIGHT];
    [self.accountView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:20.0f];
    self.accountView.accountNumberTextField.delegate = self;
    self.accountView.accountNumberTextField.keyboardType = UIKeyboardTypeDefault;
    self.accountView.accountNameTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self.accountView.addAccountButton setImageEdgeInsets:UIEdgeInsetsZero];
    [self.accountView.searchAccountButton setImageEdgeInsets:UIEdgeInsetsZero];
    //    if (self.entryPoint == InvokeForUpdateOpportunity) {
    //        self.accountView.accountNameTextField.enabled = false;
    //        self.accountView.addAccountButton.enabled = false;
    //        self.accountView.searchAccountButton.enabled = false;
    //    }
    //    else{
    
    // Bind Action to Account View buttons
    [self.accountView.addAccountButton addTarget:self action:@selector(addAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.accountView.searchAccountButton addTarget:self action:@selector(addSearchAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    
    // Bind Data from Opportunity Model if available
    [self bindAccountDataFromOpportunityModel];
}

- (id)getViewCorrespondingToField:(Field *)field {
    
    id generatedField;
    
    switch (field.mFieldType) {
        case SingleSelectList:
            generatedField = [self createDropDownViewWithValues:field];
            break;
            
        case AutoCompleteText:
            generatedField = [self createAutoCompleteTextFieldViewWithValues:field];
            break;
            
        case Search:
            generatedField = [self createSearchTextFieldViewWithValues:field];
            break;
            
        default:
            generatedField = [self createTextFieldViewWithValues:field];
            break;
    }
    
    return generatedField;
}

- (COTextFieldView *)createTextFieldViewWithValues:(Field *)field {
    
    COTextFieldView *textView = [[COTextFieldView alloc] init];
    [textView.fieldNameLabel setText:field.mDisplayTitle];
    [textView setField:field];
    [textView.textField setPlaceholder:field.mDisplayTitle];
    [textView.textField setText:field.mSelectedValue];
    [textView.textField setField:field];
    [textView.textField setDelegate:self];
    [textView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    return textView;
}

- (COSearchTextFieldView *)createSearchTextFieldViewWithValues:(Field *)field {
    
    COSearchTextFieldView *textView = [[COSearchTextFieldView alloc] init];
    [textView.fieldNameLabel setText:field.mDisplayTitle];
    [textView setField:field];
    [textView.textField setPlaceholder:field.mDisplayTitle];
    [textView.textField setText:field.mSelectedValue];
    [textView.textField setField:field];
    [textView.textField setDelegate:self];
    [textView.searchButton addTarget:self action:@selector(textFieldSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return textView;
}

- (COAutoCompleteTextFieldView *)createAutoCompleteTextFieldViewWithValues:(Field *)field {
    
    COAutoCompleteTextFieldView *autoCompleteTextFieldView = [[COAutoCompleteTextFieldView alloc] init];
    [autoCompleteTextFieldView.fieldNameLabel setText:field.mDisplayTitle];
    [autoCompleteTextFieldView setField:field];
    [autoCompleteTextFieldView.textField setPlaceholder:field.mDisplayTitle];
    [autoCompleteTextFieldView.textField setText:field.mSelectedValue];
    [autoCompleteTextFieldView.textField setField:field];
    [autoCompleteTextFieldView.textField setDelegate:self];
    [autoCompleteTextFieldView.textField setEnabled:false];
    [self addTapGestureToView:autoCompleteTextFieldView];
    return autoCompleteTextFieldView;
}

- (CODropDownView *)createDropDownViewWithValues:(Field *)field {
    
    CODropDownView *dropDownView = [[CODropDownView alloc] init];
    [dropDownView.fieldNameLabel setText:field.mDisplayTitle];
    [dropDownView setField:field];
    [dropDownView.textField setPlaceholder:field.mDisplayTitle];
    [dropDownView.textField setText:field.mSelectedValue];
    [dropDownView.textField setField:field];
    [self addTapGestureToView:dropDownView];
    return dropDownView;
}

- (void)addTapGestureToView:(id)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture addTarget:self action:@selector(fieldTapped:)];
    [view addGestureRecognizer:tapGesture];
}

- (void)fieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded) {
                if (CGRectContainsPoint(textField.frame, point)) {
                    [self.view endEditing:true];
                    [self makeAPICallToFetchDataForField:(DropDownTextField *)textField];
                }
            }
        }
    }
}

- (void)showPopOver:(DropDownTextField *)textField {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

- (void)reloadDynamicFieldsView {
    
    if (commentJson != nil) {
        if ([commentJson[@"first_name"] hasValue]){
            self.opportunity.toReferral.firstName = commentJson[@"first_name"];
        }
        if ([commentJson[@"last_name"] hasValue]){
            self.opportunity.toReferral.lastName = commentJson[@"last_name"];
        }
        if ([commentJson[@"contact_no"] hasValue]){
            self.opportunity.toReferral.cellPhoneNumber = commentJson[@"contact_no"];
        }
    }
    
    Field *field = [self.dynamicFieldsArray lastObject];
    
    if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
        field.mSelectedValue = self.opportunity.toReferral.cellPhoneNumber;
    }
    
    //[self bindOpportunityModelDataToField:[self.dynamicFieldsArray lastObject]];
    [self.containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self renderFieldsFromList:self.dynamicFieldsArray];
}

- (void)makeAPICallToFetchDataForField:(DropDownTextField *)textField {
    
    if ([textField.field.mTitle isEqualToString:FIELD_VEHICLE_APPLICATION]) {
        [self getVehicleApplication:textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_CUSTOMER_TYPE]) {
        [self getCustomerType:textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_SOURCE_OF_CONTACT]) {
        [self getSourceOfContact:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
        [self getBodyType:textField viaAutoLoad:false];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
        [self getUsageCategory:textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_REFERRAL_TYPE]) {
        [self getReferralType:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
        [self getMMGeography:(AutoCompleteUITextField *)textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_EVENT]) {
        [self getEventList:(AutoCompleteUITextField *)textField];
    }
    //    else if ([textField.field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
    //        //[self getReferralType:textField];
    //
    //        textField.field.mValues = [[NSMutableArray alloc] initWithObjects:@"Customer ineligible for finance",
    //                                   @"Discount",
    //                                   @"Delivery TAT",
    //                                   @"Delay in tender",
    //                                   @"Financing issue",
    //                                   @"Invalid entry",
    //                                   @"Lost deal",
    //                                   @"Mileage concern",
    //                                   @"Ongoing negotiations",
    //                                   @"Product acceptance",
    //                                   @"Resale value",
    //                                   @"Requirement dropped",
    //                                   @"Service-related issues",
    //                                   @"Vehicle performance issue",
    //                                   @"Vehicle stock not available", nil];
    //        [self showPopOver:(DropDownTextField *)textField];
    //    }
}

- (void)navigateToProspectScreenFor:(NSString *)detailsObj Referal:(BOOL)isRefferal {
    UIStoryboard *prospectStoryBoard = [UIStoryboard storyboardWithName:@"CreateNewProspect" bundle:[NSBundle mainBundle]];
    ProspectViewController *prospectViewController = [prospectStoryBoard instantiateViewControllerWithIdentifier:@"Create New Prospect_View"];
    prospectViewController.detailsObj = detailsObj;
    if (self.entryPoint == InvokeForUpdateOpportunity) {
        prospectViewController.invokedFrom = UpdateOpportunity;
    }
    else{
        prospectViewController.invokedFrom = CreateOpportunity;
    }
    
    prospectViewController.delegate = self;
    
    if ([detailsObj isEqualToString:PROSPECT_CONTACT]) {
        if (!self.opportunity.toContact) {
            EGContact *contact = [[EGContact alloc] init];
            self.opportunity.toContact = contact;
        }
        if ([appdelegate.userName hasValue]) {
            prospectViewController.appEntryPoint = InvokeFromProductApp;
            prospectViewController.firstNameTextField.text = self.opportunity.toContact.firstName.length > 0 ? self.opportunity.toContact.firstName : @"";
            prospectViewController.LastNameTextField.text = self.opportunity.toContact.lastName.length > 0 ? self.opportunity.toContact.lastName : @"";
            prospectViewController.mobileNumberTextField.text = self.opportunity.toContact.contactNumber.length > 0 ? self.opportunity.toContact.contactNumber : @"";
            prospectViewController.emailTextField.text = self.opportunity.toContact.emailID.length > 0 ? self.opportunity.toContact.emailID : @"";
        }
        else if (isRefferal) {
            if (self.activityObj.stakeholderResponse != nil){
                prospectViewController.commentJson = commentJson;
            }
            prospectViewController.isReferral = isRefferal;
        }
        prospectViewController.opportunityContact = self.opportunity.toContact;
    }
    else if ([detailsObj isEqualToString:PROSPECT_ACCOUNT]) {
        if (!self.opportunity.toAccount) {
            EGAccount *account = [[EGAccount alloc] init];
            self.opportunity.toAccount = account;
        }
        prospectViewController.opportunityAccount = self.opportunity.toAccount;
    }
    
    [self.navigationController pushViewController:prospectViewController animated:true];
}

- (BOOL)validateDynamicFields {
    BOOL isValid = true;
    for (Field *currentField in self.dynamicFieldsArray) {
        if (![currentField.mSelectedValue hasValue]) {
            [self showValidationErrorMessage:currentField.mErrorMessage];
            isValid = false;
            break;
        }
        else if ([currentField.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE] ||
                 [currentField.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            NSString *errorMessage = [[ValidationUtility sharedInstance] validateFieldValue:currentField inList:self.dynamicFieldsArray];
            if (errorMessage) {
                [self showValidationErrorMessage:errorMessage];
                isValid = false;
                break;
            }
        }
        else if ([currentField.mTitle isEqualToString:FIELD_QUANTITY]){//Check Quantity is <=5000
            if ([currentField.mSelectedValue intValue] >= 5000) {
                [self showValidationErrorMessage:@"Qunatity should be less than 5000"];
                isValid = false;
                break;
            }
        }
    }
    return isValid;
}

- (BOOL)validateContactDetails {
    NSString *errorMessage = @"Please search/add contact details";
    
    if ([self.opportunity.toContact.firstName hasValue] &&
        [self.opportunity.toContact.lastName hasValue] &&
        [self.opportunity.toContact.contactNumber hasValue] &&
        (![[ReachabilityManager sharedInstance] isInternetAvailable] || [self.opportunity.toContact.contactID hasValue]))
    {
        return true;
    }
    else {
        if ([self.contactView.contactNumberTextField.text hasValue]) {
            if (![UtilityMethods validateMobileNumber:self.contactView.contactNumberTextField.text]) {
                errorMessage = @"Please enter valid number in Contact Search Field";
                [self showValidationErrorMessage:errorMessage];
                return false;
            }
        }
        [self showValidationErrorMessage:errorMessage];
        return false;
    }
}

- (BOOL)validateRefferalContactDetails {
    NSString *errorMessage = @"Please search/add referral contact details";
    
    if ([self.opportunity.toReferral.rowID hasValue])
    {
        return true;
    }
    else {
        [self showValidationErrorMessage:errorMessage];
        return false;
    }
}


- (BOOL)validateAccountDetails {
    if (![[ValidationUtility sharedInstance] isAccountMandatory:self.opportunity.toVCNumber.lob]) {
        return true;
    }
    
    NSString *errorMessage = @"Please search/add account details";
    if ([self.opportunity.toAccount.accountName hasValue] &&
        [self.opportunity.toAccount.siteName hasValue] &&
        [self.opportunity.toAccount.contactNumber hasValue]&&
        (![[ReachabilityManager sharedInstance] isInternetAvailable] || [self.opportunity.toAccount.accountID hasValue]))
    {
        return true;
    }
    else {
        if ([self.accountView.accountNumberTextField.text hasValue]) {
            if (![UtilityMethods validateMobileNumber:self.accountView.accountNumberTextField.text]) {
                errorMessage = @"Please enter valid number in Account Search Field";
                [self showValidationErrorMessage:errorMessage];
                return false;
            }
        }
        [self showValidationErrorMessage:errorMessage];
        return false;
    }
}

- (void)showValidationErrorMessage:(NSString *)message {
    if ([message hasValue]) {
        [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
            
        }];
    }
}

- (void)bindValuesToOpportunityModel {
    
    EGLOBInfo *lobInfo = [[EGLOBInfo alloc] init];
    EGReferralCustomer *referralCustomer = [[EGReferralCustomer alloc] init];
    
    // Dynamic Mandatory Fields
    for (Field *field in self.dynamicFieldsArray) {
        if ([field.mTitle isEqualToString:FIELD_VEHICLE_APPLICATION]) {
            lobInfo.vehicleApplication = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_CUSTOMER_TYPE]) {
            
            lobInfo.customerType = field.mSelectedValue;
            NSLog(@"%@",lobInfo.customerType);
        }
        else if ([field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
            lobInfo.mmGeography = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
            lobInfo.usageCategory = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
            lobInfo.bodyType = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE]) {
            lobInfo.totalFleetSize = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            lobInfo.tmlFleetSize = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_SOURCE_OF_CONTACT]) {
            self.opportunity.sourceOfContact = field.mSelectedValue;
            if (![self.opportunity.sourceOfContact isEqualToString:VALUE_REFERRAL] || ![self.opportunity.sourceOfContact isEqualToString:VALUE_BODY] || ![self.opportunity.sourceOfContact isEqualToString:VALUE_FINANCE] || ![self.opportunity.sourceOfContact isEqualToString:VALUE_MECHANIC]) {
                self.opportunity.reffralType = @"";
            }
            if (![self.opportunity.sourceOfContact isEqualToString:VALUE_EVENT]) {
                self.opportunity.eventName = @"";
                self.opportunity.eventID = @"";
            }
        }
        else if ([field.mTitle isEqualToString:FIELD_REFERRAL_TYPE]) {
            self.opportunity.reffralType = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_QUANTITY]) {
            self.opportunity.quantity = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
            if ([field.mSelectedValue hasValue] && self.selectedReferralCustomer) {
                referralCustomer = self.selectedReferralCustomer;
            } else {
                referralCustomer = self.opportunity.toReferral;
            }
        }
        else if ([field.mTitle isEqualToString:FIELD_REFERRAL_TYPE]) {
            self.opportunity.reffralType = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_EVENT]) {
            NSInteger index = [field.mValues indexOfObject:field.mSelectedValue];
            if (field.mDataList) {
                EGEvent *selectedEvent = [field.mDataList objectAtIndex:index];
                self.opportunity.eventID = selectedEvent.mEventID;
                self.opportunity.eventName = selectedEvent.mEventName;
            }
        }
        //        else if ([field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
        //            self.opportunity.potentialDropOff = field.mSelectedValue;
        //        }
        
        self.opportunity.toPotentialDropOff.app_name = GTME_APP;
    }
    
    self.opportunity.toLOBInfo = lobInfo;
    self.opportunity.toReferral = referralCustomer;
}

- (void)showFillOptionalFieldsConfirmation {
    NSString *confirmationMessage = [NSString stringWithFormat:@"%@ %@", OPPORTUNITY_SUCCESS_MESSAGE, OPTIONAL_FIELDS_CONFIRMATION_MESSAGE];
    
    //    [UtilityMethods alert_showMessage:confirmationMessage withTitle:APP_NAME andOKAction:^{
    //        [self navigateToOptionalFieldsScreen];
    //    } andNoAction:^{
    //        [[AppRepo sharedRepo] showHomeScreen];
    //    }];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:confirmationMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    self.cachedAlertController = nil;
                                    [self navigateToOptionalFieldsScreen];
                                }];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   self.cachedAlertController = nil;
                                   [[AppRepo sharedRepo] showHomeScreen];
                               }];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:alert animated:YES completion:nil];
    
    self.cachedAlertController = alert;
}

- (void)saveNewActivity {
    
}

- (void)showActivityCreatedAlert {
    NSString *message = DEFAULT_ACTIVITY_SUCCESS_MESSAGE;
    [UtilityMethods alert_showMessage:message withTitle:APP_NAME andOKAction:^{
        //TODO: redirect to activity screen
        UpdateActivityViewController *updateActivityVC = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
        updateActivityVC.opportunity = self.opportunity;
        updateActivityVC.entryPoint = CREATEOPTY;
        updateActivityVC.checkuser=@"My_Activity";
        [self.navigationController pushViewController:updateActivityVC animated:YES];
    } andNoAction:^{
        
    }];
}

- (void) showDraftSaveConfirmation
{
    NSString *message = @"You are currently Offline. Opportunity will be created automatically once we get the Internet Connection.";
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        if ([self.opportunity.draftID hasValue]) {
            [self updateOpportunityDraft:EGDraftStatusQueuedToSync];
        }
        else {
            [self createOpportunityDraft:EGDraftStatusQueuedToSync];
        }
        
        [[AppRepo sharedRepo] showHomeScreen];
        
        // Below code to break the flow of product app
        if (!appdelegate) {
            appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        appdelegate.userName = nil;
        appdelegate.productAppOpty = nil;
    }];
}

- (void)navigateToOptionalFieldsScreen {
    if ([self.delegate respondsToSelector:@selector(mandatoryFieldsScreenSubmitButtonClicked)]) {
        [self.delegate mandatoryFieldsScreenSubmitButtonClicked];
    }
}

- (void)showAutoCompleteTableForField:(AutoCompleteUITextField *)autoCompleteTextField {
    [autoCompleteTextField loadTableViewForTextFiled:[UtilityMethods getFrameForDynamicField:autoCompleteTextField] onView:self.containerView withArray:autoCompleteTextField.field.mValues];
}

- (void)autoLoadBodyType:(DropDownTextField *)textField {
    
    if (![textField.field.mTitle isEqualToString:FIELD_VEHICLE_APPLICATION]) {
        return;
    }
    
    if (textField.field.mSuccessors && [textField.field.mSuccessors count] > 0) {
        Field *field = [textField.field.mSuccessors objectAtIndex:0];
        DropDownTextField *bodyTypeTextField = [self getTextFieldCorrespondingToField:field ofType:field.mFieldType];
        if (bodyTypeTextField) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_FOR_API * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getBodyType:bodyTypeTextField viaAutoLoad:true];
            });
        }
    }
}

- (id)getTextFieldCorrespondingToField:(Field *)field ofType:(FieldType)fieldType {
    
    if (fieldType == SingleSelectList) {
        for (id view in [self.containerView subviews]) {
            if ([view isKindOfClass:[CODropDownView class]]) {
                CODropDownView *dropDownView = (CODropDownView *)view;
                if ([dropDownView.field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
                    return dropDownView.textField;
                }
            }
        }
    }
    return nil;
}


-(void)navigateToContactSearchForGivenNumber:(NSString *)contactNumber withtype:(NSString *)create_type{
    
    
    if (![contactNumber isEqualToString:@""]) {
        
        if ([create_type isEqualToString:ACCOUNTSEARCH_FROM_OPPORTUNITY]) {
            NSString *errorMessage = [UtilityMethods getErrorForInValidatePANOrPhoneNumber:contactNumber];
            if (errorMessage) {
                [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
                return;
            }
        }
        
        EGsearchByValues *searchBy_Value = [EGsearchByValues new];
        SearchResultsViewController * searchResultCVObj = [[UIStoryboard storyboardWithName:@"Search_Result" bundle:nil] instantiateViewControllerWithIdentifier:@"searchResult"];
        searchResultCVObj.delegate = self;
        
        searchBy_Value.stringToSearch = contactNumber;
        searchResultCVObj.searchResultFrom = SearchResultFrom_OpportunityPage;
        
        if ([create_type isEqualToString:CONTACTREFRRALSEARCH_FROM_OPPORTUNITY]){
            searchResultCVObj.searchResultFrom = SearchReferralResultFrom_OpportunityPage;
        }else{
            searchResultCVObj.searchResultFrom = SearchResultFrom_OpportunityPage;
        }
        
        if ([create_type isEqualToString:CONTACTSEARCH_FROM_OPPORTUNITY] || [create_type isEqualToString:CONTACTREFRRALSEARCH_FROM_OPPORTUNITY]) {
            searchBy_Value.radioButtonSelected = radioCantactButton;
        }
        else{
            searchBy_Value.radioButtonSelected = radioAccountButton;
            
        }
        searchResultCVObj.searchByValue = searchBy_Value;
        if ([appdelegate.userName hasValue]) {
            
            searchResultCVObj.entryPoint = InvokeFromProductApp;
            searchResultCVObj.firstName = self.opportunity.toContact.firstName;
            searchResultCVObj.LastName = self.opportunity.toContact.lastName;
        }
        [self.navigationController pushViewController:searchResultCVObj animated:YES];
    }
    else
    {
        if ([create_type isEqualToString:CONTACTSEARCH_FROM_OPPORTUNITY]) {
            [UtilityMethods alert_ShowMessage:@"Please Enter Number" withTitle:APP_NAME andOKAction:nil];
        }
        else {
            [UtilityMethods alert_ShowMessage:@"Please Enter Phone Number/PAN" withTitle:APP_NAME andOKAction:nil];
        }
        
    }
}

- (NSDictionary *)getRequestDictionaryFromOpportunityModel {
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] opportunityMapping] inverseMapping]
                                                                                   objectClass:[EGOpportunity class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:self.opportunity requestDescriptor:requestDescriptor error:nil];
    [parametersDictionary setValue:forceCreateOpty? @"Y" : @"N" forKey:@"force_create_opty"];
    
    if (self.entryPoint != InvokeForUpdateOpportunity) {
        [parametersDictionary setValue:self.opportunity.latitude? : @"" forKey:@"latitude"];
        [parametersDictionary setValue:self.opportunity.longitude? : @"" forKey:@"longitude"];
    }
    
    //Newly added for passing GTME activty ID while creating opportunity
    if (self.activityObj.stakeholderResponse != nil && self.activityObj.activityID != nil) {
        [parametersDictionary setValue:self.activityObj.activityID? : @"" forKey:@"activity_id"];
    }
    
    return parametersDictionary;
}

- (void)showActivitySuccessMessageWithFollowUpDate:(NSString *)followUpDate Opty_id:(NSString *)optyid  {
    
    NSDate *date = [NSDate getNSDateFromString:followUpDate havingFormat:dateFormatddMMyyyyHHmmss];
    NSString * dateString = [date ToISTStringInFormat:activityListDateFormat];
    
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@", OPPORTUNITY_SUCCESS_MESSAGE, DEFAULT_ACTIVITY_SUCCESS_MESSAGE, dateString];
    
    //    [UtilityMethods alert_showMessage:message withTitle:optyid andOKAction:^{
    //
    //        UpdateActivityViewController *updateActivityVC = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
    //        updateActivityVC.opportunity = self.opportunity;
    //        updateActivityVC.activity = self.activity;
    //        updateActivityVC.entryPoint = CREATEOPTY;
    //        updateActivityVC.checkuser=@"My_Activity";
    //        [self.navigationController pushViewController:updateActivityVC animated:YES];
    //        [self navigateToOptionalFieldsScreen];
    //    } andNoAction:^{
    //        [self showFillOptionalFieldsConfirmation];
    //    }];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:optyid
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    UpdateActivityViewController *updateActivityVC = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
                                    updateActivityVC.opportunity = self.opportunity;
                                    updateActivityVC.activity = self.activity;
                                    updateActivityVC.entryPoint = CREATEOPTY;
                                    updateActivityVC.checkuser=@"My_Activity";
                                    [self.navigationController pushViewController:updateActivityVC animated:YES];
                                    [self navigateToOptionalFieldsScreen];
                                    
                                    // clear the cached alert controller
                                    self.cachedAlertController = nil;
                                }];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   // clear the cached alert controller
                                   self.cachedAlertController = nil;
                                   
                                   [self showFillOptionalFieldsConfirmation];
                               }];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:alert animated:YES completion:nil];
    
    self.cachedAlertController = alert;
}

- (void)checkForDuplicateOpportunity:(NSError *)error opportunityDuplicate:(void (^)(NSString *message))duplicate opportunityNotDuplicate:(void(^)())notDuplicate {
    
    [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
        
        long errorCode = [[jsonDictionary objectForKey:@"error_code"] longValue];
        id responseMessage = [jsonDictionary objectForKey:@"msg"];
        
        if (errorCode && errorCode == DUPLICATE_OPTY_ERROR_CODE) {
            
            if (responseMessage && [responseMessage isKindOfClass:[NSString class]]) {
                duplicate(responseMessage);
            }
            else {
                notDuplicate();
            }
        }
        else {
            notDuplicate();
        }
        
    } failure:^(NSError * _Nullable error) {
        notDuplicate();
    }];
}

- (void)showDuplicateOpportunityAlert:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                 message:[message stringByAppendingString:CREATE_DUPLICATE_OPTY_CONFIRMATION]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // Create Duplicate Opportunity Action
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.cachedAlertController = nil;
            forceCreateOpty = true;
            [self callCreateOpportunityAPI];
        }]];
        
        // Do Not Create Duplicate Opportunity
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.cachedAlertController = nil;
        }]];
        
        // Show the AlertViewController
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
        }];
        
        self.cachedAlertController = alertController;
    });
}

- (void)showFetchingLocationLoader {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    self.hud.label.text = MSG_FETCHING_LOCATION;
}

- (void)hideFetchingLocationLoader {
    if (self.hud) {
        [self.hud hideAnimated:true];
    }
}

- (void)clearLatLongValues {
    self.opportunity.latitude = nil;
    self.opportunity.longitude = nil;
}

- (void)createOpportunity {
    
    if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
        
        // Below code to break the flow of product app
        if (!appdelegate) {
            appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        appdelegate.userName = nil;
        appdelegate.productAppOpty = nil;
        
        [self callCreateOpportunityAPI];
        
    } else {
        [self showDraftSaveConfirmation];
    }
}

#pragma mark - UITextFieldDelegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField{
    GreyBorderUITextField *greyBorderTextField = (GreyBorderUITextField *)textField;
    
    if ([greyBorderTextField.field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
        [self validateDynamicFields];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        
        AutoCompleteUITextField *autoCompleteTextField = (AutoCompleteUITextField *)textField;
        autoCompleteTextField.autocompleteTableRowSelectedDelegate = self;
        
        if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
            self.mmGeographyTextField = autoCompleteTextField;
            if (!self.mmGeographyTextField.field.mValues || [self.mmGeographyTextField.field.mValues count] == 0) {
                [self.mmGeographyTextField resignFirstResponder];
                [self getMMGeography:autoCompleteTextField forLOB:self.opportunity.toVCNumber.lob];
            }
            else {
                [self showAutoCompleteTableForField:self.mmGeographyTextField];
            }
        } else if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_EVENT]) {
            self.eventTextField = autoCompleteTextField;
            if (!self.eventTextField.field.mValues || [self.eventTextField.field.mValues count] == 0) {
                [self.eventTextField resignFirstResponder];
                [self getEventList:autoCompleteTextField];
            }
            else {
                [self showAutoCompleteTableForField:self.eventTextField];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    // Contact Search Field Validation
    if (self.contactView.contactNumberTextField == textField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }
    
    // Account Search Field Validation
    if (self.accountView.accountNumberTextField == textField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyAlphaNumeric:string];
    }
    
    if ([textField isKindOfClass:[GreyBorderUITextField class]]) {
        
        GreyBorderUITextField *mTextField = (GreyBorderUITextField *)textField;
        
        if ([mTextField.field.mTitle isEqualToString:FIELD_BROKER_NAME] || [mTextField.field.mTitle isEqualToString:FIELD_TGM]) {
            return true;
        }
        
        // Set selected value in textfield
        mTextField.field.mSelectedValue = currentString;
        
        // Quantity, Total Fleet Size and TML Fleet Size Field Validation
        if ([mTextField.field.mTitle isEqualToString:FIELD_QUANTITY] ||
            [mTextField.field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE] ||
            [mTextField.field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            
            if ([mTextField.field.mTitle isEqualToString:FIELD_QUANTITY]) {
                if (length > 4) {
                    mTextField.field.mSelectedValue = textField.text;
                    return NO;
                }
                
                if ([currentString hasValue] && currentString.intValue == 0) {
                    return NO;
                }
            }
            else {
                if (length > 10) {
                    mTextField.field.mSelectedValue = textField.text;
                    return NO;
                }
            }
            
            return [UtilityMethods isCharacterSetOnlyNumber:string];
        } // Referral Customer Validation
        else if ([mTextField.field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
            
            if ([UtilityMethods isCharacterSetOnlyNumber:string] && ![string isEqualToString:@""]){
                if (length > 10)
                    return NO;
            }
            
            //return [UtilityMethods isCharacterSetOnlyNumber:string];
            
            mTextField.field.mSelectedValue = @"";
            return true;
        }
    }
    else if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        AutoCompleteUITextField *autocompleteTextField = (AutoCompleteUITextField *)textField;
        [autocompleteTextField reloadDropdownList_ForString:currentString];
    }
    [UtilityMethods isCharacterSetOnlyNumber:string];
    
    return true;
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        
        // Reset Sucessor value if predecessor value changed
        if ([textField.field.mSuccessors count] > 0) {
            Field *sucessor = [textField.field.mSuccessors objectAtIndex:0];
            sucessor.mSelectedValue = @"";
            [self reloadDynamicFieldsView];
        }
        
        // Check for conditional mandatory fields for selected
        // field value
        if ([[ValidationUtility sharedInstance] getConditionalMandatoryFields:self.dynamicFieldsArray]) {
            [self reloadDynamicFieldsView];
        }
        
        // Check auto loading for body type
        [self autoLoadBodyType:textField];
    }
}

#pragma mark - ProspectViewControllerDelegate Methods


- (void)contactSubmittedInOffline:(EGContact *)contact {
    self.opportunity.toContact = contact;
    [self displayContactInfo:contact];
}

- (void)contactCreationSuccessfull:(EGContact*)contact fromView:(SearchResultFromPage)searchResultFromPage{
    
    if (searchResultFromPage == SearchResultFrom_ManageOpportunity) {
        
        self.opportunity.toContact = contact;
        [self displayContactInfo:contact];
        
    } else if (searchResultFromPage == SearchReferralResultFrom_OpportunityPage){
        
        if (contact.firstName != nil) {
            self.opportunity.toReferral.firstName = contact.firstName;
        }
        
        if (contact.lastName != nil) {
            self.opportunity.toReferral.lastName = contact.lastName;
        }
        
        if (contact.contactNumber != nil) {
            self.opportunity.toReferral.cellPhoneNumber = contact.contactNumber;
        }
        
        if (contact.contactID != nil) {
            self.opportunity.toReferral.rowID = contact.contactID;
        }
        
        Field *field = [self.dynamicFieldsArray lastObject];
        
        if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
            field.mSelectedValue = self.opportunity.toReferral.firstName;
        }
        
        [self.containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self renderFieldsFromList:self.dynamicFieldsArray];
        
    } else {
        if (self.opportunity.toContact) {
            [self displayContactInfo:self.opportunity.toContact];
        }
    }
    
}

-(void)referralContactCreationSuccessfull:(EGContact *)contact fromView:(SearchResultFromPage)searchResultFromPage
{
    if (searchResultFromPage == SearchReferralResultFrom_OpportunityPage){
        
        if (contact.firstName != nil) {
            self.opportunity.toReferral.firstName = contact.firstName;
        }
        
        if (contact.lastName != nil) {
            self.opportunity.toReferral.lastName = contact.lastName;
        }
        
        if (contact.contactNumber != nil) {
            self.opportunity.toReferral.cellPhoneNumber = contact.contactNumber;
        }
        
        if (contact.contactID != nil) {
            self.opportunity.toReferral.rowID = contact.contactID;
        }
        
        Field *field = [self.dynamicFieldsArray lastObject];
        
        if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
            field.mSelectedValue = self.opportunity.toReferral.firstName;
        }
        
        [self.containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self renderFieldsFromList:self.dynamicFieldsArray];
    }
    
    
    //    if (searchResultFromPage == SearchReferralResultFrom_OpportunityPage){
    //
    //        if (contact.firstName != nil) {
    //            self.opportunity.toReferral.firstName = contact.firstName;
    //        }
    //
    //        if (contact.lastName != nil) {
    //            self.opportunity.toReferral.lastName = contact.lastName;
    //        }
    //
    //        if (contact.contactNumber != nil) {
    //            self.opportunity.toReferral.cellPhoneNumber = contact.contactNumber;
    //        }
    //
    //        Field *field = [self.dynamicFieldsArray lastObject];
    //
    //        if ([field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
    //            field.mSelectedValue = self.opportunity.toReferral.cellPhoneNumber;
    //        }
    //    }
    
}

- (void)moveToNewContactCreation:(SearchResultFromPage)searchResultFromPage{
    NSLog(@" @Mandatory: Contact cancel ");
    [UtilityMethods alert_ShowMessagewithCreate:@"No results found" withTitle:APP_NAME  andOKAction:^{
        
    } andCreateContactAction:^{
        //[self addContactButtonClicked:nil];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Create_New_Referral_Contact_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
        [self navigateToProspectScreenFor:PROSPECT_CONTACT Referal:YES];
    }];
}


- (void)displayContactInfo:(EGContact *)contact {
    if ([contact.firstName hasValue]) {
        [self.contactView.firstNameTextField setText:contact.firstName];
    }
    
    if ([contact.lastName hasValue]) {
        [self.contactView.lastNameTextField setText:contact.lastName];
    }
    
    if ([contact.contactNumber hasValue]) {
        [self.contactView.mobileNumberTextField setText:contact.contactNumber];
        [self.contactView.contactNumberTextField setText:contact.contactNumber];
    }
}

- (void)accountSubmittedInOffline:(EGAccount *)account {
    self.opportunity.toAccount = account;
    [self displayAccountInfo:account];
}

- (void)accountCreationSuccessfull:(EGAccount *)account fromView:(SearchResultFromPage)searchResultFromPage {
    
    EGAccount *createdAccount;
    if (searchResultFromPage == SearchResultFrom_ManageOpportunity || searchResultFromPage == SearchResultFrom_Prospect) {
        self.opportunity.toAccount = account;
        createdAccount = account;
    }else{
        if (self.opportunity.toAccount) {
            createdAccount  = self.opportunity.toAccount;
        }
    }
    
    [self displayAccountInfo:createdAccount];
}

- (void)displayAccountInfo:(EGAccount *)createdAccount {
    if ([createdAccount.accountName hasValue]) {
        [self.accountView.accountNameTextField setText:createdAccount.accountName];
    }
    
    if ([createdAccount.siteName hasValue]) {
        [self.accountView.accountSiteTextField setText:createdAccount.siteName];
    }
    
    if ([createdAccount.contactNumber hasValue]) {
        [self.accountView.accountPhoneNumberTextField setText:createdAccount.contactNumber];
        [self.accountView.accountNumberTextField setText:createdAccount.contactNumber];
    }
}

- (void)startLocationUpdate {
    [self showFetchingLocationLoader];
    [[LocationManagerSingleton sharedLocationInstance] setDelegate:self];
    [[LocationManagerSingleton sharedLocationInstance] setDidFindLocation:false];
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] requestLocation];
    [self startLocationTimer];
}

- (void)locationTimerExpired {
    NSLog(@"20 seconds over!!!");
    [self stopLocationTimer];
    [self hideFetchingLocationLoader];
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] stopUpdatingLocation];
    [self handleCouldNotFetchLocationDueToTimeout];
}

- (void)startLocationTimer {
    
    if (!self.locationTimer) {
        self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_FETCH_TIMEOUT target:self selector:@selector(locationTimerExpired) userInfo:nil repeats:false];
    }
}

- (void)stopLocationTimer {
    
    if (self.locationTimer && self.locationTimer.isValid) {
        [self.locationTimer invalidate];
    }
    
    self.locationTimer = nil;
}

- (void)handleCouldNotFetchLocationDueToTimeout {
    
    if (!self.couldNotFetchLocationAlert) {
        self.couldNotFetchLocationAlert = [UIAlertController alertControllerWithTitle:APP_NAME message:LOCATION_FETCH_FAILED_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCreateOpty = [UIAlertAction actionWithTitle:YES_ACTION_TITLE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.opportunity.latitude = @"0.0";
            self.opportunity.longitude = @"0.0";
            [self createOpportunity];
        }];
        
        UIAlertAction *actionSaveAsDraft = [UIAlertAction actionWithTitle:SAVE_DRAFT_ACTION_TITLE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.opportunity.latitude = @"0.0";
            self.opportunity.longitude = @"0.0";
            [self createOpportunityDraft:EGDraftStatusSavedAsDraft];
        }];
        
        UIAlertAction *actionUpdateDraft = [UIAlertAction actionWithTitle:UPDATE_DRAFT_ACTION_TITLE style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.opportunity.latitude = @"0.0";
            self.opportunity.longitude = @"0.0";
            [self updateOpportunityDraft:EGDraftStatusSavedAsDraft];
        }];
        
        if (self.opportunity.draftID.hasValue) {
            [self.couldNotFetchLocationAlert addAction:actionUpdateDraft];
        } else {
            [self.couldNotFetchLocationAlert addAction:actionSaveAsDraft];
        }
        [self.couldNotFetchLocationAlert addAction:actionCreateOpty];
    }
    
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:self.couldNotFetchLocationAlert animated:true completion:nil];
}

#pragma mark - SearchResultViewControllerDelegate Methods

- (void)didSelectResultFromSearchResultController:(id)selectedObject {
    self.selectedReferralCustomer = (EGReferralCustomer *)selectedObject;
    
    if (self.referralCustomerTextField) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.selectedReferralCustomer.firstName, self.selectedReferralCustomer.lastName];
        self.referralCustomerTextField.text = fullName;
        self.referralCustomerTextField.field.mSelectedValue = fullName;
    }
}

#pragma mark - AutoCompleteUITextFieldDelegate Methods
- (void)selectedActionSender:(id)sender {
    [self.view endEditing:true];
}

#pragma mark - LocationManagerSingletonDelegate Methods
- (void)locationManagerSingletonDidUpdateLocation:(CLLocation *)location {
    [self stopLocationTimer];
    [self hideFetchingLocationLoader];
    self.opportunity.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.opportunity.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] stopUpdatingLocation];
    [self createOpportunity];
}

- (void)locationManagerFailedToUpdateLocation:(NSError *)error {
    [self stopLocationTimer];
    [self hideFetchingLocationLoader];
    [self clearLatLongValues];
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] stopUpdatingLocation];
    [self handleCouldNotFetchLocationDueToTimeout];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.containerView) {
        return true;
    }
    return false;
}

#pragma mark - IBActions

- (void)removeAutoCompleteTableView:(UITapGestureRecognizer *)gesture {
    if (self.mmGeographyTextField && [self.mmGeographyTextField.resultTableView isDescendantOfView:self.containerView]) {
        [self.mmGeographyTextField.resultTableView removeFromSuperview];
    } else if (self.eventTextField && [self.eventTextField.resultTableView isDescendantOfView:self.containerView]) {
        [self.eventTextField.resultTableView removeFromSuperview];
    }
}

-(void)callvalidateOtherContactData{
    
    if ([self validateContactDetails]) {
        if ([self validateAccountDetails]) {
            [self bindValuesToOpportunityModel];
            if (self.entryPoint == InvokeForUpdateOpportunity) {
                [self callUpdateOpportunityAPI];
            }
            else {
                self.opportunity.latitude = [[AppRepo sharedRepo] getLoggedInUser].latitude;
                self.opportunity.longitude = [[AppRepo sharedRepo] getLoggedInUser].longitude;
                [self createOpportunity];
            }
        }
    }
}


- (IBAction)submitButtonClicked:(id)sender {
    if ([self validateDynamicFields]) {
        
        //Check is referral fields are enabled or not
        BOOL isReferralData = NO;
        for (Field *field in self.dynamicFieldsArray) {
            if ([field.mTitle caseInsensitiveCompare:FIELD_SOURCE_OF_CONTACT] == NSOrderedSame) {
                if ([field.mSelectedValue caseInsensitiveCompare:VALUE_REFERRAL] == NSOrderedSame || [field.mSelectedValue caseInsensitiveCompare:VALUE_BODY] == NSOrderedSame || [field.mSelectedValue caseInsensitiveCompare:VALUE_MECHANIC] == NSOrderedSame || [field.mSelectedValue caseInsensitiveCompare:VALUE_FINANCE] == NSOrderedSame) {
                    
                    isReferralData = YES;
                }
            }
            NSLog(@"%@",field.mTitle);
            NSLog(@"%@",field.mSelectedValue);
            
            if ([field.mTitle caseInsensitiveCompare:FIELD_REFERRAL_TYPE] == NSOrderedSame){
                if ([field.mSelectedValue caseInsensitiveCompare:INFLUENCER] != NSOrderedSame || [field.mSelectedValue caseInsensitiveCompare:EXISTING_CUST] != NSOrderedSame){
                    isReferralData = NO;
                }
            }
            
        }
        
        if (isReferralData) {
            if([self validateRefferalContactDetails]){
                [self callvalidateOtherContactData];
            }
        }else{
            [self callvalidateOtherContactData];
        }
    }
}

- (void)addContactButtonClicked:(id)sender {
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Create_New_Contact_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
    [self navigateToProspectScreenFor:PROSPECT_CONTACT Referal:NO];
}

- (void)addSearchContactButtonClicked:(id)sender {
    if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Search_Contact_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
        
        [self navigateToContactSearchForGivenNumber:self.contactView.contactNumberTextField.text withtype:CONTACTSEARCH_FROM_OPPORTUNITY];
    } else {
        [UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
            
        }];
    }
}

- (void)addAccountButtonClicked:(id)sender {
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Create_New_Account_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
    
    [self navigateToProspectScreenFor:PROSPECT_ACCOUNT Referal:NO];
}


- (void)addSearchAccountButtonClicked:(id)sender {
    if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Search_Account_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
        
        [self navigateToContactSearchForGivenNumber:self.accountView.accountNumberTextField.text withtype:ACCOUNTSEARCH_FROM_OPPORTUNITY];
        //        if(self.entryPoint==InvokeForUpdateOpportunity){
        //            self.entryPoint=InvokeForUpdateOpportunity;
        //
        //        }else{
        //        self.entryPoint=InvokeForCreateOpportunity;
        //        }
    } else {
        [UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
        }];
    }
}

-(BOOL)validateSearchBar:(GreyBorderUITextField *)textfield
{
    NSString * errorMessage = @"";
    BOOL flag = TRUE;
    if([textfield.text isEqualToString:@""]){
        errorMessage = @"Please enter valid Referral Customer Cell No.";
        flag = FALSE;
    }
    //    else if([textfield.text length] < 10){
    //        errorMessage = @"Please enter valid mobile number";
    //        flag = FALSE;
    //    }
    
    if (![errorMessage isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    }
    return flag;
    
}

- (void)textFieldSearchButtonClicked:(id)sender {
    if ([[sender superview] isKindOfClass:[GreyBorderUITextField class]]) {
        GreyBorderUITextField *textField = (GreyBorderUITextField *)[sender superview];
        
        if ([textField.field.mTitle isEqualToString:FIELD_REFERRAL_CUSTOMER]) {
            
            if (![self validateSearchBar:textField]){
                return ;
            }
            
            self.referralCustomerTextField = textField;
            //[self getReferralCustomerList:textField];
            
            
            if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
                
                [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Search_Contact_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
                
                [self navigateToContactSearchForGivenNumber:self.referralCustomerTextField.text withtype:CONTACTREFRRALSEARCH_FROM_OPPORTUNITY];
            } else {
                [UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
                    
                }];
            }
        }
    }
}

- (IBAction)saveOptyDraft:(id)sender {
    
    if ([self validateContactDetails]) {
        if ([self.opportunity.draftID hasValue]) {
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_UpdateDraft_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
            
            [self updateOpportunityDraft:EGDraftStatusSavedAsDraft];
        }
        else {
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_SaveDraft_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
            
            [self createOpportunityDraft:EGDraftStatusSavedAsDraft];
        }
    }
}

- (void)createOpportunityDraft:(EGDraftStatus) draftStatus {
    
    [self bindValuesToOpportunityModel];
    
    NSLog(@"DB Path:%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    AAADraftMO *draftOptyInfo = [NSEntityDescription insertNewObjectForEntityForName:E_DRAFT inManagedObjectContext:appdelegate.managedObjectContext];
    draftOptyInfo.draftID = [UtilityMethods uuid];
    draftOptyInfo.userIDLink = [[AppRepo sharedRepo] getLoggedInUser].userName;
    
    draftOptyInfo.status = draftStatus;
    
    // Bind Opportunity Data
    AAAOpportunityMO *optyInfo = [NSEntityDescription insertNewObjectForEntityForName:E_OPPORTUNITY
                                                               inManagedObjectContext:appdelegate.managedObjectContext];
    [self bindOpportunityModelToCoreDataModel:optyInfo];
    
    draftOptyInfo.toOpportunity = optyInfo;
    
    NSError *error = nil;
    [appdelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else {
        [UtilityMethods alert_ShowMessage:@"Opportunity saved as Draft successfully." withTitle:APP_NAME andOKAction:nil];
        self.opportunity.draftID = draftOptyInfo.draftID;
        [self adjustUIForEditDraftOperation];
    }
}

- (void)updateOpportunityDraft:(EGDraftStatus)draftStatus {
    
    [self bindValuesToOpportunityModel];
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    NSFetchRequest *fetchRequest = [AAADraftMO fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"draftID == %@",self.opportunity.draftID];
    fetchRequest.predicate = predicate;
    AAADraftMO *draftOptyInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    draftOptyInfo.status = draftStatus;
    
    [self bindOpportunityModelToCoreDataModel:draftOptyInfo.toOpportunity];
    
    NSError *error = nil;
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else {
        [UtilityMethods alert_ShowMessage:@"Draft updated successfully." withTitle:APP_NAME andOKAction:^{
            if (self.entryPoint == InvokeForUpdateOpportunity){
                [self.navigationController popViewControllerAnimated:YES];
                
                // Below code to break the flow of product app
                if (!appdelegate) {
                    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                }
                appdelegate.userName = nil;
                appdelegate.productAppOpty = nil;
                
            }
        }];
    }
}

- (void)bindOpportunityModelToCoreDataModel:(AAAOpportunityMO *)optyInfo {
    
    NSLog(@"%@",self.opportunity.quantity);
    optyInfo.quantity = self.opportunity.quantity;
    optyInfo.sourceOfContact = self.opportunity.sourceOfContact;
    optyInfo.fromContext = self.opportunity.fromContext;
    optyInfo.idLocal = self.opportunity.idLocal;
    optyInfo.prospectType = self.opportunity.prospectType;
    optyInfo.leadAssignedName = self.opportunity.leadAssignedName;
    optyInfo.leadAssignedPhoneNumber = self.opportunity.leadAssignedPhoneNumber;
    optyInfo.leadAssignedPositionID = self.opportunity.leadAssignedPositionID;
    optyInfo.leadAssignedPosition = self.opportunity.leadAssignedPosition;
    optyInfo.license = self.opportunity.license;
    optyInfo.lostMake = self.opportunity.lostMake;
    optyInfo.lostReson = self.opportunity.lostReson;
    optyInfo.lostModel = self.opportunity.lostModel;
    optyInfo.opportunityCreatedDate = self.opportunity.opportunityCreatedDate;
    optyInfo.opportunityName = self.opportunity.opportunityName;
    optyInfo.rev_productID = self.opportunity.rev_productID;
    optyInfo.salesStageName = self.opportunity.salesStageName;
    optyInfo.saleStageUpdatedDate = self.opportunity.saleStageUpdatedDate;
    optyInfo.reffralType = self.opportunity.reffralType;
    optyInfo.competitor = self.opportunity.competitor;
    optyInfo.productCatagory = self.opportunity.productCatagory;
    optyInfo.competitorModel = self.opportunity.competitorModel;
    optyInfo.competitorRemark = self.opportunity.competitorRemark;
    optyInfo.influencer = self.opportunity.influencer;
    optyInfo.businessUnit = self.opportunity.businessUnit;
    optyInfo.opportunityStatus = self.opportunity.opportunityStatus;
    optyInfo.latitude = self.opportunity.latitude? : @"";
    optyInfo.longitude = self.opportunity.longitude? : @"";
    
    // Bind Contact Data
    EGContact *opportunityContact = self.opportunity.toContact;
    
    if (opportunityContact) {
        AAAContactMO *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Contact"
                                                                  inManagedObjectContext:appdelegate.managedObjectContext];
        contactInfo.contactNumber = opportunityContact.contactNumber;
        contactInfo.firstName = opportunityContact.firstName;
        contactInfo.lastName = opportunityContact.lastName;
        contactInfo.contactID = opportunityContact.contactID;
        contactInfo.latitude = opportunityContact.latitude;
        contactInfo.longitude = opportunityContact.longitude;
        optyInfo.toContact = contactInfo;
    }
    
    // Bind Account Data
    EGAccount *opportunityAccount = self.opportunity.toAccount;
    
    if (opportunityAccount) {
        AAAAccountMO *accountInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                                  inManagedObjectContext:appdelegate.managedObjectContext];
        accountInfo.contactNumber = opportunityAccount.contactNumber;
        accountInfo.accountName = opportunityAccount.accountName;
        accountInfo.site = opportunityAccount.siteName;
        accountInfo.accountID = opportunityAccount.accountID;
        optyInfo.toAccount = accountInfo;
    }
    
    // Bind LOB Info
    EGLOBInfo *lobInfo = self.opportunity.toLOBInfo;
    if (lobInfo) {
        AAALobInformation *lobInformation = [NSEntityDescription insertNewObjectForEntityForName:@"LobInformation" inManagedObjectContext:appdelegate.managedObjectContext];
        lobInformation.customerType = self.opportunity.toLOBInfo.customerType;
        lobInformation.vehicleApplication = self.opportunity.toLOBInfo.vehicleApplication;
        lobInformation.bodyType = self.opportunity.toLOBInfo.bodyType;
        lobInformation.mmGeography = self.opportunity.toLOBInfo.mmGeography;
        lobInformation.tmlFleetSize = self.opportunity.toLOBInfo.tmlFleetSize;
        lobInformation.totalFleetSize = self.opportunity.toLOBInfo.totalFleetSize;
        lobInformation.usageCategory = self.opportunity.toLOBInfo.usageCategory;
        optyInfo.toLobInfo = lobInformation;
    }
    
    // VC Details
    EGVCNumber *vcDetails = self.opportunity.toVCNumber;
    if (vcDetails) {
        AAAVCNumberMO *vcNumber = [NSEntityDescription insertNewObjectForEntityForName:@"VCNumber" inManagedObjectContext:appdelegate.managedObjectContext];
        vcNumber.ppl = self.opportunity.toVCNumber.ppl;
        vcNumber.lob = self.opportunity.toVCNumber.lob;
        vcNumber.pl = self.opportunity.toVCNumber.pl;
        vcNumber.vcNumber = self.opportunity.toVCNumber.vcNumber;
        vcNumber.productID = self.opportunity.toVCNumber.productID;
        vcNumber.productDescription = self.opportunity.toVCNumber.productDescription;
        vcNumber.productName = self.opportunity.toVCNumber.productName;
        vcNumber.productName1 = self.opportunity.toVCNumber.productName1;
        optyInfo.toVC = vcNumber;
    }
    
    // Campaign Details
    EGCampaign *campaignDetails = self.opportunity.toCampaign;
    if (campaignDetails) {
        AAACampaignMO *campaign = [NSEntityDescription insertNewObjectForEntityForName:@"Campaign" inManagedObjectContext:appdelegate.managedObjectContext];
        campaign.campaignID = campaignDetails.campaignID;
        optyInfo.toCampaign = campaign;
    }
    
    // Referral Customer
    EGReferralCustomer *referralCustomer = self.opportunity.toReferral;
    if (referralCustomer) {
        AAAReferralCustomerMO *referralCustomerObj = [NSEntityDescription insertNewObjectForEntityForName:@"ReferralCustomer" inManagedObjectContext:appdelegate.managedObjectContext];
        referralCustomerObj.refferalrowID = self.opportunity.toReferral.rowID;
        referralCustomerObj.refferalFirstName = self.opportunity.toReferral.firstName;
        referralCustomerObj.refferalLastName = self.opportunity.toReferral.lastName;
        referralCustomerObj.refferalCellPhoneNumber = self.opportunity.toReferral.cellPhoneNumber;
        optyInfo.toRefferal = referralCustomerObj;
    }
    
    // Event
    AAAEventMO *eventObj = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:appdelegate.managedObjectContext];
    eventObj.eventName = self.opportunity.eventName;
    eventObj.eventID = self.opportunity.eventID;
    optyInfo.toEvent = eventObj;
}

- (void)bindTapToView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAutoCompleteTableView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setDelegate:self];
    [view addGestureRecognizer:tapGesture];
}

#pragma mark - API Calls

- (void)getVehicleApplication:(DropDownTextField *)textField forLOB:(NSString *)lobName {
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            VehicleApplicationDBHelper *vehicleAppDBHelper = [VehicleApplicationDBHelper new];
            NSMutableArray * vhApplicationArray  = [[vehicleAppDBHelper fetchAllVehicleApplication:lobName] mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showVehicleAppDropDown:vhApplicationArray fortextField:textField];
            }];
        }];
        
    } else {
        NSDictionary *requestDictionary = @{@"lob" : lobName};
        [[EGRKWebserviceRepository sharedRepository] getVehicleApplication:requestDictionary andSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                [self showVehicleAppDropDown:[responseArray mutableCopy] fortextField:textField];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

- (void)showVehicleAppDropDown:(NSMutableArray *)arrVehicleApps fortextField:(DropDownTextField *)textField {
    textField.field.mValues = [arrVehicleApps mutableCopy];
    textField.field.mDataList = [arrVehicleApps mutableCopy];
    [self showPopOver:(DropDownTextField *)textField];
}


- (void)getCustomerType:(DropDownTextField *)textField forLOB:(NSString *)lobName {
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            CustomerTypeDBHelper *customerType = [CustomerTypeDBHelper new];
            NSMutableArray * customerTyperray = [[customerType fetchCustomerTypesFromLob:lobName] mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopUpOver:customerTyperray fortextField:textField];
            }];
        }];
        
    } else {
        NSDictionary *requestDictionary = @{@"lob" : lobName};
        [[EGRKWebserviceRepository sharedRepository] getCustomerType:requestDictionary andSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                textField.field.mValues = [responseArray mutableCopy];
                textField.field.mDataList = [responseArray mutableCopy];
                [self showPopOver:(DropDownTextField *)textField];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

- (void)getSourceOfContact:(DropDownTextField *)textField {
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            SourceOfContactDBHelpers *sourceOfContactDBHelpers = [SourceOfContactDBHelpers new];
            NSMutableArray *sourceOfContactArray = [[sourceOfContactDBHelpers fetchSourceOfContactFromLob] mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopUpOver:sourceOfContactArray fortextField:textField];
            }];
            
        }];
        
    } else {
        [[EGRKWebserviceRepository sharedRepository] getSourceOfContactSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                textField.field.mValues = [responseArray mutableCopy];
                textField.field.mDataList = [responseArray mutableCopy];
                [self showPopOver:(DropDownTextField *)textField];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

- (void)getMMGeography:(AutoCompleteUITextField *)textField forLOB:(NSString *)lobName {
    
    [textField setEnabled:true];
    self.mmGeographyTextField = textField;
    
    if (createOpty) {
        [UtilityMethods showProgressHUD:YES];
        [UtilityMethods RunOnBackgroundThread:^{
            [UtilityMethods RunOnOfflineDBThread:^{
                MMGeographyDBHelpers *mmGeoDBHelper = [MMGeographyDBHelpers new];
                textField.field.mValues = [[[mmGeoDBHelper fetchAllMMGeoGraphyFromLob:lobName] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
                [UtilityMethods RunOnMainThread:^{
                    [UtilityMethods hideProgressHUD];
                    if (self.mmGeographyTextField) {
                        [self.mmGeographyTextField becomeFirstResponder];
                    }
                }];
            }];
        }];
    } else {
        NSDictionary *requestDictionary = @{@"lob" : lobName,
                                            @"name" : @""};
        [[EGRKWebserviceRepository sharedRepository] getMMGeography:requestDictionary andSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                textField.field.mValues = [[responseArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
                if (self.mmGeographyTextField) {
                    [self.mmGeographyTextField becomeFirstResponder];
                }
            }
            else {
                [textField setEnabled:false];
            }
        } andFailuerAction:^(NSError *error) {
            [textField setEnabled:false];
        }];
    }
}

- (void)getBodyType:(DropDownTextField *)textField viaAutoLoad:(BOOL)isAutoLoad {
    
    Field *vehicleApplicationField = [textField.field.mPredecessors objectAtIndex:0];
    if (!vehicleApplicationField || ![vehicleApplicationField.mSelectedValue hasValue]) {
        [UtilityMethods alert_ShowMessage:vehicleApplicationField.mErrorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    else {
        
        if (createOpty) {
            
            [UtilityMethods RunOnOfflineDBThread:^{
                VehicleApplicationDBHelper *vehicleAppDBHelper = [VehicleApplicationDBHelper new];
                NSMutableArray *defaultBodyTypeArray = [[vehicleAppDBHelper fetchDefaultBodyType:vehicleApplicationField.mSelectedValue forLOB:self.opportunity.toVCNumber.lob] mutableCopy];
                NSMutableArray *bodyTypeArray = [[vehicleAppDBHelper fetchAllBodyType:vehicleApplicationField.mSelectedValue forLOB:self.opportunity.toVCNumber.lob] mutableCopy];
                if ([defaultBodyTypeArray count] > 0 && ![[defaultBodyTypeArray firstObject] isEqualToString:@""]) {
                    [bodyTypeArray addObjectsFromArray:defaultBodyTypeArray];
                }
                
                if (isAutoLoad) {
                    textField.field.mValues = defaultBodyTypeArray;
                    textField.field.mDataList = defaultBodyTypeArray;
                    textField.field.mSelectedValue = [textField.field.mValues objectAtIndex:0];
                    textField.text = [textField.field.mValues objectAtIndex:0];
                }
                else {
                    [UtilityMethods RunOnMainThread:^{
                        [self showPopUpOver:bodyTypeArray fortextField:textField];
                    }];
                }
            }];
            
            
        } else {
            NSDictionary *requestDictionary = @{@"vehicle_application" : vehicleApplicationField.mSelectedValue,
                                                @"lob" : self.opportunity.toVCNumber.lob};
            [[EGRKWebserviceRepository sharedRepository] getBodyType:requestDictionary andSuccessAction:^(NSArray *responseArray) {
                if (responseArray && [responseArray count] > 0) {
                    textField.field.mValues = [responseArray mutableCopy];
                    textField.field.mDataList = [responseArray mutableCopy];
                    if (isAutoLoad) {
                        textField.field.mSelectedValue = [textField.field.mValues objectAtIndex:0];
                        textField.text = [textField.field.mValues objectAtIndex:0];
                    }
                    else {
                        [self showPopOver:(DropDownTextField *)textField];
                    }
                }
                else {
                    [UtilityMethods resetDynamicField:textField];
                }
            } andFailuerAction:^(NSError *error) {
                [UtilityMethods resetDynamicField:textField];
            }];
        }
        
        
    }
}

- (void)showPopUpOver:(NSMutableArray *)arrValues fortextField:(DropDownTextField *)textField {
    textField.field.mValues = arrValues;
    textField.field.mDataList = arrValues;
    [self showPopOver:(DropDownTextField *)textField];
}


- (void)getReferralCustomerList:(GreyBorderUITextField *)textField {
    
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    
    // Set Phone Number
    if ([UtilityMethods isCharacterSetOnlyNumber:textField.text]) {
        [requestDictionary setValue:textField.text forKey:@"cellphnumber"];
    } else {
        
        NSArray *nameComponentsArray = [textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // Set First Name
        if (nameComponentsArray && [nameComponentsArray count] > 0) {
            [requestDictionary setValue:[nameComponentsArray firstObject] forKey:@"FirstName"];
            
            // Set Last Name
            if (nameComponentsArray && [nameComponentsArray count] > 1) {
                [requestDictionary setValue:[nameComponentsArray lastObject] forKey:@"LastName"];
            }
        }
    }
    
    [[EGRKWebserviceRepository sharedRepository] getReferralCustomer:requestDictionary andSuccessAction:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            [self.view endEditing:true];
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] init];
            
            [searchResultViewController showWithData:responseArray fromViewController:self];
        }
        else {
            [UtilityMethods alert_ShowMessagewithCreate:@"No results found" withTitle:APP_NAME  andOKAction:^{
                
            } andCreateContactAction:^{
                //[self addContactButtonClicked:nil];
                [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Create_New_Referral_Contact_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];
                [self navigateToProspectScreenFor:PROSPECT_CONTACT Referal:YES];
            }];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
}

- (void)getUsageCategory:(DropDownTextField *)textField forLOB:(NSString *)lobName {
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            UsageCategoryDBHelper *usageCategoryDBHelper = [UsageCategoryDBHelper new];
            NSMutableArray *usageCategoryArray = [[usageCategoryDBHelper fetchAllUsageCategoriesFromLob:lobName] mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopUpOver:usageCategoryArray fortextField:textField];
            }];
        }];
        
    } else {
        NSDictionary *requestDictionary = @{@"lob" : lobName};
        [[EGRKWebserviceRepository sharedRepository] getUsageCategory:requestDictionary andSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                [self showPopUpOver:[responseArray mutableCopy] fortextField:textField];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}


- (void)getReferralType:(DropDownTextField *)textField {
    NSDictionary *requestDictionary = @{
                                        @"referral_name" : @"Referral"
                                        };
    
    if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
            ReferalTypesDBHelper *referalTypeDBHelper = [ReferalTypesDBHelper new];
            textField.field.mValues = [[referalTypeDBHelper fetchReferalTypes] mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopOver:textField];
            }];
        }];
        
        
    } else {
        [[EGRKWebserviceRepository sharedRepository] getReferralType:requestDictionary
                                                    andSuccessAction:^(NSArray *responseArray) {
                                                        if (responseArray && [responseArray count] > 0) {
                                                            textField.field.mValues = [responseArray mutableCopy];
                                                            [self showPopOver:(DropDownTextField *)textField];
                                                        }
                                                    } andFailuerAction:^(NSError *error) {
                                                        
                                                        [ScreenshotCapture takeScreenshotOfView:self.view];
                                                        appdelegate.screenNameForReportIssue = @"Create Opty: Mandatory Fields";
                                                        [UtilityMethods showErroMessageFromAPICall:error defaultMessage:CREATE_OPPORTUNITY_FAILED_MESSAGE];
                                                    }];
    }
}

- (void)callCreateOpportunityAPI {
    [[EGRKWebserviceRepository sharedRepository] createOpportunity:[self getRequestDictionaryFromOpportunityModel]
                                                  andSuccessAction:^(NSDictionary *responseDictionary) {
                                                      forceCreateOpty = false;
                                                      [self deleteDraftOnSucessfulCreationOfOpty];
                                                      [self callCreateActivityAPIForOpportunity:[responseDictionary objectForKey:@"id"]];
                                                      
                                                      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Submit_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Create_Opportunity_Successful];
                                                  }
                                                  andFailuerAction:^(NSError *error) {
                                                      forceCreateOpty = false;
                                                      if (error.localizedRecoverySuggestion) {
                                                          
                                                          [ScreenshotCapture takeScreenshotOfView:self.view];
                                                          appdelegate.screenNameForReportIssue = @"Create Opty: Mandatory Fields";
                                                          
                                                          /**
                                                           ** Checking for duplicate opportunity error
                                                           **/
                                                          
                                                          [self checkForDuplicateOpportunity:error opportunityDuplicate:^(NSString *message) {
                                                              [self showDuplicateOpportunityAlert:message];
                                                          } opportunityNotDuplicate:^{
                                                              [UtilityMethods showErroMessageFromAPICall:error defaultMessage:CREATE_OPPORTUNITY_FAILED_MESSAGE];
                                                          }];
                                                          
                                                      }
                                                      else {
                                                          [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                              
                                                          }];
                                                      }
                                                      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateOpportunity_Submit_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Create_Opportunity_Failed];
                                                      
                                                  }];
}

- (void)deleteDraftOnSucessfulCreationOfOpty{
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    if ([self.opportunity.draftID hasValue]) {
        
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Draft"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftID == %@",  self.opportunity.draftID]];
        AAADraftContactMO * draftContactInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
        if (draftContactInfo) {
            [appdelegate.managedObjectContext deleteObject:draftContactInfo];
            [appdelegate saveContext];
        }
    }
    
}

- (void)callUpdateOpportunityAPI {
    
    [[EGRKWebserviceRepository sharedRepository] updateOpportunity:[self getRequestDictionaryFromOpportunityModel] andSuccessAction:^(id activity){
        [UtilityMethods alert_ShowMessage:@"Opportunity updated successfully." withTitle:APP_NAME andOKAction:^(void){
            if (self.entryPoint == InvokeForUpdateOpportunity){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_UpdateOpportunity_Submit_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Update_Opportunity_Successful];
        
    }andFailuerAction:^(NSError *error) {
        
        [ScreenshotCapture takeScreenshotOfView:self.view];
        appdelegate.screenNameForReportIssue = @"Update Opty: Mandatory Fields";
        
        if (error.localizedRecoverySuggestion) {
            [UtilityMethods showErroMessageFromAPICall:error defaultMessage:UPDATE_OPPORTUNITY_FAILED_MESSAGE];
        }
        else {
            [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                
            }];
        }
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_UpdateOpportunity_Submit_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Update_Opportunity_Failed];
        
    }];
}

- (void)callCreateActivityAPIForOpportunity:(NSString *)opportunityID {
    
    NSString *completeDateTime = [NSDate getNextDayDate:2 inFormat:dateFormatMMddyyyyHHmmss];
    NSLog(@"%@",completeDateTime);
    NSDate *date = [NSDate getNSDateFromString:completeDateTime havingFormat:dateFormatMMddyyyyHHmmss];
    completeDateTime = [date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];
    
    NSString *completeDateTimeUTC = [date ToUTCStringInFormat:dateFormatyyyyMMddTHHmmssZ];
    NSString *followUpDate = [NSDate getNextDayDate:2 inFormat:dateFormatddMMyyyyHHmmss];
    NSLog(@"followUpDate:- %@",followUpDate);
    
    self.activity = [[EGActivity alloc] init];
    self.opportunity.optyID = opportunityID;
    self.opportunity.toLastDoneActivity.status = @"Open";
    self.activity.status = @"Open";
    self.activity.activityType = @"Follow-Up";
    [self.activity setPlanedDate:completeDateTimeUTC];
    self.activity.activityDescription = @""; // DEFAULT_ACTIVITY_MESSAGE
    NSDictionary *inputDictionary = @{
                                      @"opty": @{
                                              @"opportunity_id" : opportunityID
                                              },
                                      @"status": @"Open",
                                      @"type": @"Follow-Up",
                                      @"start_date": [self.activity planedDateTimeInFormat:dateFormatMMddyyyyHHmmss],
                                      @"comments" : @"",
                                      @"contact_id" : self.opportunity.toContact.contactID
                                      };
    
    [[EGRKWebserviceRepository sharedRepository]createActivity:inputDictionary
                                               andSucessAction:^(id activity) {
                                                   self.activity.activityID = [[activity allValues] firstObject];
                                                   [self showActivitySuccessMessageWithFollowUpDate:followUpDate Opty_id:self.opportunity.optyID];
                                               } andFailuerAction:^(NSError *error) {
                                                   [self showFillOptionalFieldsConfirmation];
                                               }];
}

- (void)getEventList:(AutoCompleteUITextField *)textField {
    
    if ([self.opportunity.salesStageName localizedStandardContainsString:@"c2"] || [self.opportunity.salesStageName localizedStandardContainsString:@"c2"]) {
        [UtilityMethods showAlertWithMessage:UPDATE_EVENT_NOT_ALLOWED(self.opportunity.salesStageName) andTitle:APP_NAME onViewController:self];
        return;
    }
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    self.eventTextField = textField;
    if (createOpty) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        // Delay added since without delay the above loader was not seen
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [UtilityMethods RunOnOfflineDBThread:^{
                EventDBHelper *eventDBHelper = [EventDBHelper new];
                // Fetching event list and then sorting it alphabetically
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mEventName" ascending:true];
                NSMutableArray *eventsArray = [[[eventDBHelper fetchAllEvents] sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                
                if (eventsArray && [eventsArray count] > 0) {
                    textField.field.mDataList = [eventsArray mutableCopy];
                    textField.field.mValues = [eventsArray valueForKey:@"mEventName"];
                    [UtilityMethods RunOnMainThread:^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        if (self.eventTextField) {
                            [self.eventTextField setEnabled:true];
                            [self.eventTextField becomeFirstResponder];
                        }
                    }];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [UtilityMethods alert_ShowMessage:@"No events found" withTitle:APP_NAME andOKAction:^{
                        
                    }];
                }
                
            }];
        });
        
    } else {
        
        [[EGRKWebserviceRepository sharedRepository] getEventListSuccessAction:^(NSArray *responseArray) {
            if (responseArray && [responseArray count] > 0) {
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mEventName" ascending:true];
                NSArray *sortedResponseArray = [responseArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                textField.field.mValues = [sortedResponseArray valueForKey:@"mEventName"];
                textField.field.mDataList = [sortedResponseArray mutableCopy];
                if (self.eventTextField) {
                    [self.eventTextField setEnabled:true];
                    [self.eventTextField becomeFirstResponder];
                }
            }
        } andFailureAction:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Internet Availablity Callbacks
- (void)onInternetAvailable {
    
}

- (void)onInternetNotAvailable {
    
}


@end
