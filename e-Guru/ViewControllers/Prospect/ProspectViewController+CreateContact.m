//
//  ProspectViewController+CreateContact.m
//  e-Guru
//
//  Created by Juili on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "ProspectViewController+CreateContact.h"
#import "AppDelegate.h"
#import "EGContact.h"
#import "EGAddress.h"

#import "AAADraftContactMO+CoreDataProperties.h"
#import "AAAContactMO+CoreDataClass.h"
#import "AAAAddressMO+CoreDataClass.h"
#import "AAATalukaMO+CoreDataClass.h"
#import "AAAStateMO+CoreDataClass.h"
#import "Constant.h"
#import "ReachabilityManager.h"
#import "DraftsViewController.h"
#import "NSString+NSStringCategory.h"
#import "EGDraftStatus.h"

@import Contacts;
@interface ProspectViewController(){
    
}
@end

@implementation ProspectViewController(CreateContact)


- (void)loadContactView {
    //--------------PROSPECT_CONTACT----------------//
    NSLog(@"--->%@",PROSPECT_CONTACT);
    
    self.titleLabel.text = CREATECONTACT;
    self.titleImageView.image = [UIImage imageNamed:CONTACT];
    self.create_ContactView.hidden = FALSE;
    self.create_AccountView.hidden = TRUE;
    self.importContactButton.hidden = FALSE;
    self.createAccountButton.hidden = FALSE;
    self.createAccountButton.hidden = TRUE;
    [UtilityMethods clearAllTextFiledsInView:self.create_ContactView];
    
    if ([self.entryPoint isEqualToString:DRAFT]) {
        
        [self.saveToDraftsButton setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
        //[self hideOrShowAddressDetailsView:YES];
//        self.hideShowView_Buttton.tag = STATE_DISABLE;
//        [self hideShowView_ButttonClicked:self.hideShowView_Buttton];

        self.firstNameTextField.text = [[self.draftContact valueForKeyPath:@"toContact.firstName"] length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.firstName"];
        
        self.LastNameTextField.text = [[self.draftContact valueForKeyPath:@"toContact.lastName"] length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.lastName"];
        
        self.emailTextField.text = [[self.draftContact valueForKeyPath:@"toContact.emailID"] length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.emailID"];
        
        self.mobileNumberTextField.text = [[self.draftContact valueForKeyPath:@"toContact.contactNumber"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.contactNumber"];
        
        self.panNumTextField.text = [[self.draftContact valueForKeyPath:@"toContact.panNumber"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.panNumber"];

        
        self.city_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.city"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.city"];
        
        self.state_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"];
        
        self.state = [[EGState alloc] init];
        self.state.code = [[self.draftContact valueForKeyPath:@"toContact.toAddress.toState.code"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toState.code"];
        self.state.name = [[self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toState.name"];
        
        self.district_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.district"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.district"];

        self.taluka_Textfield.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.toTaluka.talukaName"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.toTaluka.talukaName"];

        self.pincode_Textfield.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.pin"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.pin"];

        self.area_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.area"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.area"];

        self.panchayat_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.panchayat"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.panchayat"];

        self.addressLine_One_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.addressLine1"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.addressLine1"];

        self.addressLine_Two_TextField.text = [[self.draftContact valueForKeyPath:@"toContact.toAddress.addressLine2"]length] == 0 ? @"" : [self.draftContact valueForKeyPath:@"toContact.toAddress.addressLine2"];
        
        self.latitude = [[self.draftContact valueForKeyPath:@"toContact.latitude"] length] == 0 ? nil : [self.draftContact valueForKeyPath:@"toContact.latitude"];
        self.longitude = [[self.draftContact valueForKeyPath:@"toContact.longitude"] length] == 0 ? nil : [self.draftContact valueForKeyPath:@"toContact.longitude"];
        
        if (self.latitude && self.longitude) {
            [self.gpsSwitch setOn:true];
        }
        
        // Fix for: Address section seen collapsed in draf event if address section has values
        if ([self checkIfAnyAddressFieldHasValue]) {
            self.hideShowView_Buttton.tag = STATE_ENABLE;
            [self.addressDetailsView setHidden:false];
            [self.hideShowView_Buttton setImage:[UIImage imageNamed:@"minus_button"] forState:UIControlStateNormal];
        } else {
            self.hideShowView_Buttton.tag = STATE_DISABLE;
            [self.addressDetailsView setHidden:true];
            [self.hideShowView_Buttton setImage:[UIImage imageNamed:@"plus_button"] forState:UIControlStateNormal];
        }
    }
    else if (self.appEntryPoint == InvokeFromProductApp) {
        
        self.firstNameTextField.text = self.opportunityContact.firstName;
        self.LastNameTextField.text = self.opportunityContact.lastName;
        self.mobileNumberTextField.text = self.opportunityContact.contactNumber;
        self.emailTextField.text = self.opportunityContact.emailID;
    }
}

- (BOOL)validateContactFields:(NSString **)warningMessage_p
{
    if ([self.firstNameTextField.text isEqualToString:@""]) {
        *warningMessage_p = @"Please enter First Name";
        return NO;
    }
    else if ([self.LastNameTextField.text isEqualToString:@""]){
        *warningMessage_p = @"Please enter Last Name";
        return NO;
    }
    else if ([self.mobileNumberTextField.text isEqualToString:@""]){
        *warningMessage_p = @"Please enter Mobile Number";
        return NO;
    }
    else if (![UtilityMethods validateMobileNumber:self.mobileNumberTextField.text] && ([self.mobileNumberTextField.text length] < 10)){
        *warningMessage_p = @"Please enter valid Mobile Number";
        return NO;
    }
    else if ([UtilityMethods validateMobileNumber:self.mobileNumberTextField.text]) {
        NSString *str = [self.mobileNumberTextField.text substringToIndex:1];
        
        if ([str isEqualToString:@"0"] || [str isEqualToString:@"1"] || [str isEqualToString:@"2"] || [str isEqualToString:@"3"] || [str isEqualToString:@"4"] || [str isEqualToString:@"5"]) {
            *warningMessage_p = @"Please enter valid Mobile Number";
            return NO;
            
        } else if ([self.mobileNumberTextField.text isEqualToString:@"6666666666"] || [self.mobileNumberTextField.text isEqualToString:@"7777777777"] || [self.mobileNumberTextField.text isEqualToString:@"8888888888"] || [self.mobileNumberTextField.text isEqualToString:@"9999999999"]) {
            *warningMessage_p = @"Please enter valid Mobile Number";
            return NO;
        } else {
            return YES;
        }
    }
    
    else if(![self.emailTextField.text isEqualToString:@""] && ![UtilityMethods validateEmail:self.emailTextField.text]){
        *warningMessage_p = @"Please enter valid E-mail Id";
        return NO;

    }
    else if (![self.panNumTextField.text isEqualToString:@""] && ![UtilityMethods validatePanNumber:self.panNumTextField.text]){
        *warningMessage_p = @"Please enter valid Pan Number";
        return NO;

    }
    else {
         return [self validateAddress:warningMessage_p];
    }
}

- (BOOL)validateContactFieldsToEnableSubmitButton
{
    if (![self.firstNameTextField.text isEqualToString:@""] && ![self.LastNameTextField.text isEqualToString:@""] && ![self.mobileNumberTextField.text isEqualToString:@""]) {
        
        if (self.hideShowView_Buttton.tag) {
            
            // New validation for making address mandatory in contact creation
            if (![self.taluka_Textfield.text hasValue] || ![self.addressLine_One_TextField.text hasValue]) {
                return STATE_DISABLE;
            }
           
            if ([self.pincode_Textfield.text hasValue] && ![UtilityMethods validatePincode:self.pincode_Textfield.text]) {
                return STATE_DISABLE;
            }
            
            if (![self.taluka_Textfield.text isEqualToString:@""] ||![self.state_TextField.text isEqualToString:@""] ||![self.district_TextField.text isEqualToString:@""] ||![self.city_TextField.text isEqualToString:@""] ||![self.area_TextField.text isEqualToString:@""] ||![self.panchayat_TextField.text isEqualToString:@""] ||![self.addressLine_One_TextField.text isEqualToString:@""] ||![self.addressLine_Two_TextField.text isEqualToString:@""]) {
                
                if(![self.taluka_Textfield.text isEqualToString:@""] && ![self.addressLine_One_TextField.text isEqualToString:@""]){
                    return STATE_ENABLE;
                }else{
                    return STATE_DISABLE;
                }
            }
            else{
                return STATE_ENABLE;
            }
        }
        else{
            return STATE_ENABLE;
        }
    }
    else{
        return STATE_DISABLE;
    }
}

-(void)submitCreateContactRequest:(EGContact *)contact{
    
    if (self.invokedFrom == UpdateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
        
        [UtilityMethods alert_ShowMessage:MSG_INTERNET_NOT_AVAILBLE withTitle:APP_NAME andOKAction:nil];
    }
    else if (self.invokedFrom == Home && ![[ReachabilityManager sharedInstance] isInternetAvailable]){
        
//        [UtilityMethods alert_ShowMessage:MSG_INTERNET_NOT_AVAILBLE withTitle:APP_NAME andOKAction:nil];
        [self showContactDraftSaveConfirmation];
    }
    else{
        NSString *strConfirmationMessage;
        
        if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
            strConfirmationMessage = @"Continue to create contact in offline ?";
        } else {
            strConfirmationMessage = @"Do you want to Create Contact ?";
        }
        
        [UtilityMethods
         alert_showMessage:strConfirmationMessage
         withTitle:APP_NAME andOKAction:^{
             NSLog(@"This is a yes block");
             
             if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
                 if ([self.delegate respondsToSelector:@selector(contactSubmittedInOffline:)]) {
                     self.opportunityContact = [self makeContactModel];
                     [self.delegate contactSubmittedInOffline:self.opportunityContact];
                     [self.navigationController popViewControllerAnimated:true];
                 }
             } else {
                 [[EGRKWebserviceRepository sharedRepository]createContact:[self createContactPayload]
                                                           andSucessAction:^(NSDictionary *contact) {
                                                               if ([[contact allValues] count] > 0) {
                                                                   [self contactCreatedSuccessfully :contact Contact_id:[contact objectForKey:@"id"]];
                                                               }
                                                               else{
                                                                   [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                                                               }
                                                               [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewContact_Submit_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:GA_EA_Create_Contact_Successful];

                                                           } andFailuerAction:^(NSError *error) {
                                                               if (error.localizedRecoverySuggestion) {
                                                                   
                                                                   [ScreenshotCapture takeScreenshotOfView:self.view];
                                                                   AppDelegate *appdelegateObj = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                                                   appdelegateObj.screenNameForReportIssue = @"Prospect View";

                                                                   [UtilityMethods showErroMessageFromAPICall:error defaultMessage:CREATE_CONTACT_FAILED_MESSAGE];
                                                               }
                                                               else {
                                                                   [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                                                                       
                                                                   }];
                                                               }
                                                               [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewContact_Submit_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:GA_EA_Create_Contact_Failed];

                                                           }];
             }
         }
         andNoAction:^{
             NSLog(@"This is a no block");
         }];
    }
}

- (void) showContactDraftSaveConfirmation {
    NSString *message = @"You are currently Offline. Contact will be created automatically once we get the Internet Connection.";
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        if (self.draftContact && [self.draftContact.draftIDContact hasValue]) {
            [self updateContact:EGDraftStatusQueuedToSync];
        } else {
            [self saveContact:EGDraftStatusQueuedToSync];
        }
        
        // Go to home screen
        [[AppRepo sharedRepo] showHomeScreen];
    }];
}

- (EGContact *)makeContactModel {
	EGContact *egContact = [EGContact new];
	egContact.firstName = self.firstNameTextField.text;
	egContact.lastName = self.LastNameTextField.text;
	egContact.contactNumber = self.mobileNumberTextField.text;
	egContact.emailID = self.emailTextField.text.length >0 ? self.emailTextField.text :@"";
	egContact.panNumber = self.panNumTextField.text.length >0 ? self.panNumTextField.text :@"";
    egContact.latitude = self.latitude;
    egContact.longitude = self.longitude;
	EGAddress *address = [EGAddress new];
	
	EGState *state = [EGState new];
	state.code = (self.talukaObj.state.code.length >0 && self.talukaObj.state.code !=nil) ?self.talukaObj.state.code : @"";
	state.name = (self.talukaObj.state.name.length >0 && self.talukaObj.state.name !=nil) ?self.talukaObj.state.name : @"";
	address.state = state;
	
	address.district = self.district_TextField.text;
	address.city = self.city_TextField.text;
	
	EGTaluka *taluka = [EGTaluka new];
	taluka.talukaName = self.taluka_Textfield.text;
	address.taluka = taluka;
	
	address.area = self.area_TextField.text.length > 0 ? self.area_TextField.text : @"";
	address.tehsil = self.taluka_Textfield.text;
	address.pin = self.pincode_Textfield.text.length>0 ? self.pincode_Textfield.text : @"";
	address.addressLine1 = self.addressLine_One_TextField.text;
	address.addressLine2 = self.addressLine_Two_TextField.text.length>0 ? self.addressLine_Two_TextField.text : @"";
	
	egContact.toAddress = address;
	
	return egContact;
}

- (NSDictionary *)createContactPayload {
    return @{
             @"latitude": self.latitude? : @"",
             @"longitude" : self.longitude? : @"",
			 @"first_name": self.firstNameTextField.text,
			 @"last_name" : self.LastNameTextField.text,
			 @"mobile_number" : self.mobileNumberTextField.text,
			 @"email" : self.emailTextField.text.length >0 ? self.emailTextField.text :@"",
			 @"pan" : self.panNumTextField.text.length >0 ? self.panNumTextField.text :@"",
			 @"address" : @{
					 @"state" : @{
							 @"code":(self.state.code.length >0 && self.state.code !=nil) ?self.state.code : @"",
							 @"name":(self.state_TextField.text.length >0 && self.state_TextField.text !=nil) ?self.state_TextField.text : @""
							 },
					 @"district" : self.district_TextField.text,
					 @"city" : self.city_TextField.text,
					 @"taluka" : self.taluka_Textfield.text,
					 @"area" : self.area_TextField.text.length > 0 ? self.area_TextField.text : @"",
					 @"panchayat" : self.panchayat_TextField.text,
					 @"pincode" : self.pincode_Textfield.text.length>0 ? self.pincode_Textfield.text : @"",
					 @"address_line_1" : self.addressLine_One_TextField.text,
					 @"address_line_2" : self.addressLine_Two_TextField.text.length>0 ? self.addressLine_Two_TextField.text : @""
					 }
			 };
}

-(void)contactCreationFailedWithErrorMessage:(NSString *)errorMessage{
    
    [ScreenshotCapture takeScreenshotOfView:self.view];
    appdelegate.screenNameForReportIssue = @"Create Contact";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
//    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
	
}

-(void)contactCreatedSuccessfully:(id)contact Contact_id:(NSString *)contactid{
    if (self.invokedFrom == CreateOpportunity || self.invokedFrom == UpdateOpportunity) {
        
        //[UtilityMethods alert_ShowMessage:@"Contact Created Successfully." withTitle:self.opportunityContact.contactID andOKAction:^{
        // Send the created contact model to the invoker of this screen
        if ([self.delegate respondsToSelector:@selector(contactCreationSuccessfull:fromView:)]) {
            NSDictionary *responseDict = (NSDictionary *)contact;
            if (self.isReferral){
                EGContact *contactObject = [[EGContact alloc]init];
                contactObject.firstName = self.firstNameTextField.text;
                contactObject.lastName = self.LastNameTextField.text;
                contactObject.contactNumber = self.mobileNumberTextField.text;
                contactObject.contactID = [responseDict objectForKey:@"id"];
                [self.delegate referralContactCreationSuccessfull:contactObject fromView:SearchReferralResultFrom_OpportunityPage];
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[CreateOpportunityViewController class]]) {
                        [self.navigationController popToViewController:controller
                                                              animated:YES];
                        return;
                    }
                }
            }else{
                
                self.opportunityContact.firstName = self.firstNameTextField.text;
                self.opportunityContact.lastName = self.LastNameTextField.text;
                self.opportunityContact.contactNumber = self.mobileNumberTextField.text;
                
                self.opportunityContact.contactID = [responseDict objectForKey:@"id"];

                [self.delegate contactCreationSuccessfull:contact fromView:SearchResultFrom_Prospect];
                [self.navigationController popViewControllerAnimated:true];
                
            }
            
        }
        //}];
    }
    else {//self.invokedFrom = Home
        
        [UtilityMethods alert_showMessage:@"Contact Created Successfully. Do you want to create Opportunity ? " withTitle:contactid andOKAction:^{
            NSLog(@"%@",self.firstNameTextField.text);
            self.opportunityContact = [[EGContact alloc] init];
            self.opportunityContact.firstName = self.firstNameTextField.text;
            self.opportunityContact.lastName = self.LastNameTextField.text;
            self.opportunityContact.contactNumber = self.mobileNumberTextField.text;
            
            NSDictionary *responseDict = (NSDictionary *)contact;
            self.opportunityContact.contactID = [responseDict objectForKey:@"id"];
            [self userConfirmedForCreateOpportunityFlow:[responseDict objectForKey:@"id"]];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewContact_ContinuetoOpportunity_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];
            
        } andNoAction:^{
            
            [self clearAllTextFiledsInView:self.addressDetailsView];
            [UtilityMethods clearAllTextFiledsInView:self.create_ContactView];
            [self.submitButton setEnabled:false];
            [[AppRepo sharedRepo] showHomeScreen];
            [self disableOrEnableButton:self.createAccountButton withState:[self validateContactFieldsToEnableSubmitButton]];
        }];
        
        if([self.entryPoint  isEqual: DRAFT]){
            NSFetchRequest *fetchRequest = [AAADraftContactMO fetchRequest];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDContact == %@",  self.draftContact.draftIDContact]];
            
            AAADraftContactMO * draftContactInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
            
            [appdelegate.managedObjectContext deleteObject:draftContactInfo];
            
            [appdelegate saveContext];
        }
    }
}

- (void)saveContact:(EGDraftStatus) draftStatus {
    
    
    if(!(self.firstNameTextField.text.length == 0) || !(self.LastNameTextField.text.length == 0) ||!(self.emailTextField.text.length == 0 || !(self.panNumTextField.text.length == 0) || !(self.mobileNumberTextField.text.length == 0)) || !(self.mainPhoneNumberTextField.text.length == 0) || !(self.addressLine_One_TextField.text.length == 0) || !(self.addressLine_Two_TextField.text.length == 0) || !(self.taluka_Textfield.text.length == 0) || !(self.state_TextField.text.length == 0) || !(self.city_TextField.text.length == 0) || !(self.area_TextField.text.length == 0) || !(self.pincode_Textfield.text.length == 0) || !(self.panchayat_TextField.text.length == 0) || !(self.district_TextField.text.length == 0) || !(self.area_TextField.text.length == 0))
    {
        AAADraftContactMO *draftContactInfo = [NSEntityDescription   insertNewObjectForEntityForName:E_DRAFTCONTACT inManagedObjectContext:appdelegate.managedObjectContext];
        draftContactInfo.draftIDContact = [UtilityMethods uuid]; ;
        draftContactInfo.userIDLink = [[AppRepo sharedRepo] getLoggedInUser].userName;
        draftContactInfo.status = draftStatus;
        
        AAAContactMO *contactInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_CONTACT inManagedObjectContext:appdelegate.managedObjectContext];
        
        contactInfo.firstName=self.firstNameTextField.text.length > 0 ? self.firstNameTextField.text : @"";
        contactInfo.lastName=self.LastNameTextField.text.length > 0 ? self.LastNameTextField.text : @"";
        contactInfo.emailID=self.emailTextField.text.length > 0 ? self.emailTextField.text : @"";
        contactInfo.contactNumber=self.mobileNumberTextField.text.length > 0 ? self.mobileNumberTextField.text : @"";
        contactInfo.panNumber=self.panNumTextField.text.length > 0 ? self.panNumTextField.text : @"";
        contactInfo.latitude = self.latitude? : @"";
        contactInfo.longitude = self.longitude? : @"";
        
        AAAAddressMO *addressInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_ADDRESS inManagedObjectContext:appdelegate.managedObjectContext];
        
        addressInfo.district =self.district_TextField.text.length > 0 ? self.district_TextField.text : @"";
        addressInfo.city = self.city_TextField.text.length > 0 ? self.city_TextField.text : @"";
        addressInfo.area = self.area_TextField.text.length > 0 ? self.area_TextField.text : @"";
        addressInfo.panchayat = self.panchayat_TextField.text.length > 0 ? self.panchayat_TextField.text : @"";
        addressInfo.pin = self.pincode_Textfield.text.length > 0 ? self.pincode_Textfield.text : @"";
        addressInfo.addressLine1 = self.addressLine_One_TextField.text.length > 0 ? self.addressLine_One_TextField.text : @"";
        addressInfo.addressLine2 = self.addressLine_Two_TextField.text.length > 0 ? self.addressLine_Two_TextField.text : @"";
        
        AAAStateMO *stateInfo=[NSEntityDescription   insertNewObjectForEntityForName:@"State" inManagedObjectContext:appdelegate.managedObjectContext];

        stateInfo.name = self.state_TextField.text.length > 0 ? self.state_TextField.text : @"";
        stateInfo.code = self.state.code.length > 0 ? self.state.code : @"";
        
        AAATalukaMO *talukaInfo=[NSEntityDescription   insertNewObjectForEntityForName:@"Taluka" inManagedObjectContext:appdelegate.managedObjectContext];
        
        talukaInfo.talukaName = self.taluka_Textfield.text.length > 0 ? self.taluka_Textfield.text : @"";
        
        addressInfo.toTaluka=talukaInfo;
        addressInfo.toState=stateInfo;
        contactInfo.toAddress = addressInfo;
        draftContactInfo.toContact = contactInfo;
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else{
            
            self.currentDraftID = draftContactInfo.draftIDContact;
            NSLog(@"%@ == %@",self.currentDraftID ,[[AppRepo sharedRepo] getLoggedInUser].userName);
            [self.saveToDraftsButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
            [self disableOrEnableButton:self.saveToDraftsButton withState:STATE_DISABLE];
            NSLog(@"contact save successfully");
            [UtilityMethods alert_ShowMessage:@"Contact saved as Draft successfully..." withTitle:APP_NAME andOKAction:nil];
        }
    }
    
    else{
        [UtilityMethods alert_ShowMessage:@"Please enter contact details to save it as Draft!!" withTitle:APP_NAME andOKAction:nil];
    
    }
}

- (void)updateContact:(EGDraftStatus) draftStatus {
    NSLog(@"%@ == %@",self.currentDraftID ,[[AppRepo sharedRepo] getLoggedInUser].userName);
    NSFetchRequest *fetchRequest = [AAADraftContactMO fetchRequest];
    if ([self.entryPoint isEqualToString:DRAFT]) {
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDContact == %@ && SELF.userIDLink == %@",  self.draftContact.draftIDContact ,[[AppRepo sharedRepo] getLoggedInUser].userName]];
    }
    else{
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDContact == %@ && SELF.userIDLink == %@",  self.currentDraftID ,[[AppRepo sharedRepo] getLoggedInUser].userName]];
    }
    
    AAADraftContactMO * draftContactInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    // update the draft status
    draftContactInfo.status = draftStatus;
    
    [draftContactInfo setValue: self.firstNameTextField.text.length > 0 ? self.firstNameTextField.text : @"" forKeyPath:@"toContact.firstName"];
    [draftContactInfo setValue: self.LastNameTextField.text.length > 0 ? self.LastNameTextField.text : @"" forKeyPath:@"toContact.lastName"];
    [draftContactInfo setValue: self.emailTextField.text.length > 0 ? self.emailTextField.text : @"" forKeyPath:@"toContact.emailID"];
     [draftContactInfo setValue: self.mobileNumberTextField.text.length > 0 ? self.mobileNumberTextField.text : @"" forKeyPath:@"toContact.contactNumber"];
    [draftContactInfo setValue: self.panNumTextField.text.length > 0 ? self.panNumTextField.text : @"" forKeyPath:@"toContact.panNumber"];
    [draftContactInfo setValue: self.taluka_Textfield.text.length > 0 ? self.taluka_Textfield.text : @"" forKeyPath:@"toContact.toAddress.toTaluka.talukaName"];
    [draftContactInfo setValue: self.state_TextField.text.length > 0 ? self.state_TextField.text : @"" forKeyPath:@"toContact.toAddress.toState.name"];
    [draftContactInfo setValue: self.district_TextField.text.length > 0 ? self.district_TextField.text : @"" forKeyPath:@"toContact.toAddress.district"];
    [draftContactInfo setValue: self.city_TextField.text.length > 0 ? self.city_TextField.text : @"" forKeyPath:@"toContact.toAddress.city"];
    [draftContactInfo setValue: self.area_TextField.text.length > 0 ? self.area_TextField.text : @"" forKeyPath:@"toContact.toAddress.area"];
    [draftContactInfo setValue: self.panchayat_TextField.text.length > 0 ? self.panchayat_TextField.text : @"" forKeyPath:@"toContact.toAddress.panchayat"];
    [draftContactInfo setValue: self.pincode_Textfield.text.length > 0 ? self.pincode_Textfield.text : @"" forKeyPath:@"toContact.toAddress.pin"];
    [draftContactInfo setValue: self.addressLine_One_TextField.text.length > 0 ? self.addressLine_One_TextField.text : @"" forKeyPath:@"toContact.toAddress.addressLine1"];
    [draftContactInfo setValue: self.addressLine_Two_TextField.text.length > 0 ? self.addressLine_Two_TextField.text : @"" forKeyPath:@"toContact.toAddress.addressLine2"];
    
    [draftContactInfo setValue:self.latitude? : @"" forKeyPath:@"toContact.latitude"];
    [draftContactInfo setValue:self.latitude? : @"" forKeyPath:@"toContact.longitude"];

    NSError *error = nil;
    // Save the object to persistent store
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        
        if ([self.entryPoint isEqualToString:DRAFT]) {
        
            [UtilityMethods alert_ShowMessage:@"Draft updated successfully!!" withTitle:APP_NAME andOKAction:^{
                [self.navigationController popViewControllerAnimated:true];
            }];
        }
        else{
            [UtilityMethods alert_ShowMessage:@"Draft updated successfully!!" withTitle:APP_NAME andOKAction:^{
                [[AppRepo sharedRepo] showHomeScreen];
            }];
        }
    }
    

    
}

@end
