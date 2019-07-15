//
//  ProspectViewController+CreateAccount.m
//  e-Guru
//
//  Created by Juili on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "ProspectViewController+CreateAccount.h"
#import "EGAccount.h"
#import "EGAddress.h"
#import "AAADraftAccountMO+CoreDataProperties.h"
#import "AAADraftContactMO+CoreDataProperties.h"
#import "AAAAddressMO+CoreDataClass.h"
#import "NSString+NSStringCategory.h"
#import "ReachabilityManager.h"

@implementation ProspectViewController (CreateAccount)

- (void)loadAccountView {
    //---------------PROSPECT_ACCOUNT---------------//
    NSLog(@"--->%@",PROSPECT_ACCOUNT);
    
    self.titleLabel.text = CREATEACCOUNT;
    self.titleImageView.image = [UIImage imageNamed:ACCOUNT];

    self.create_ContactView.hidden = TRUE;
    self.create_AccountView.hidden =FALSE;
    self.importContactButton.hidden = TRUE;
    self.createAccountButton.hidden = TRUE;
    
    [UtilityMethods clearAllTextFiledsInView:self.create_AccountView];
    
    if ([self.entryPoint isEqualToString:DRAFT]) {
        [self.saveToDraftsButton setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
        //[self hideOrShowAddressDetailsView:YES];
//        self.hideShowView_Buttton.tag = STATE_DISABLE;
//        [self hideShowView_ButttonClicked:self.hideShowView_Buttton];

        self.accountNameTextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.accountName"] length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.accountName"];
        
        self.siteTextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.site"] length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.site"];
        
        self.mainPhoneNumberTextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.contactNumber"] length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.contactNumber"];
        
        self.accPanNumTextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.accountPAN"] length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.accountPAN"];
        
        self.city_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.city"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.city"];
        
        self.state_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.name"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.name"];

        self.state.code = [self.draftAccount valueForKeyPath:@"toAccount.toAddress.toState.code"];

        self.district_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.district"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.district"];
        
        self.taluka_Textfield.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.toTaluka.talukaName"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.toTaluka.talukaName"];
        
        self.pincode_Textfield.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.pin"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.pin"];
        
        self.area_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.area"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.area"];
        
        self.panchayat_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.panchayat"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.panchayat"];
        
        self.addressLine_One_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.addressLine1"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.addressLine1"];
        
        self.addressLine_Two_TextField.text = [[self.draftAccount valueForKeyPath:@"toAccount.toAddress.addressLine2"]length] == 0 ? @"" : [self.draftAccount valueForKeyPath:@"toAccount.toAddress.addressLine2"];
        
        self.latitude = [[self.draftAccount valueForKeyPath:@"toAccount.latitude"] length] == 0 ? nil : [self.draftAccount valueForKeyPath:@"toAccount.latitude"];
        self.longitude = [[self.draftAccount valueForKeyPath:@"toAccount.longitude"] length] == 0 ? nil : [self.draftAccount valueForKeyPath:@"toAccount.longitude"];
        
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
        
        NSSet <AAAContactMO *> *contactSet = [self.draftAccount valueForKeyPath:@"toAccount.toContact"];
        AAAContactMO * contact = [[contactSet allObjects]firstObject];
        self.contactfirstnamelbl.text =  contact.firstName;
        self.contactlastnamelbl.text=contact.lastName;
        self.contactmobilenumberlbl.text=contact.contactNumber;
        self.contactSearchTextField.text=contact.contactNumber;
        self.searchedContactToBelinkedtoAccount = [[EGContact alloc]initWithObject:contact];
    }

	if(self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
		self.contactSearchTextField.enabled = NO;
	}
	
}

- (BOOL)validateAccountFields:(NSString **)warningMessage_p
{
    if ([self.accountNameTextField.text isEqualToString:@""]) {
        *warningMessage_p = @"Please enter Account Name";
        return NO;
    }
    else if ([self.siteTextField.text isEqualToString:@""]){
        *warningMessage_p = @"Please enter Site";
        return NO;

    }
    else if ([self.mainPhoneNumberTextField.text isEqualToString:@""]){
        *warningMessage_p = @"Please enter Main Phone Number";
        return NO;

    }
    else if (self.contactSearchTextField.isEnabled && [self.contactSearchTextField.text isEqualToString:@""]) {
        *warningMessage_p = @"Please enter contact Number";
        return NO;
    }
    else if (![self.mainPhoneNumberTextField.text isEqualToString:@""] && ![UtilityMethods validateMobileNumber:self.mainPhoneNumberTextField.text]){
        *warningMessage_p = @"Please enter valid Main Phone Number";
        return NO;

    }
    else if ([UtilityMethods validateMobileNumber:self.mainPhoneNumberTextField.text]) {
        NSString *str = [self.mainPhoneNumberTextField.text substringToIndex:1];
        
        if ([str isEqualToString:@"0"] || [str isEqualToString:@"1"] || [str isEqualToString:@"2"] || [str isEqualToString:@"3"] || [str isEqualToString:@"4"] || [str isEqualToString:@"5"]) {
            *warningMessage_p = @"Please enter valid Mobile Number";
            return NO;
            
        } else if ([self.mainPhoneNumberTextField.text isEqualToString:@"6666666666"] || [self.mainPhoneNumberTextField.text isEqualToString:@"7777777777"] || [self.mainPhoneNumberTextField.text isEqualToString:@"8888888888"] || [self.mainPhoneNumberTextField.text isEqualToString:@"9999999999"]) {
            *warningMessage_p = @"Please enter valid Mobile Number";
            return NO;
        } else {
            return YES;
        }
    }
    
    else if (![self.accPanNumTextField.text isEqualToString:@""] && ![UtilityMethods validatePanNumber:self.accPanNumTextField.text]){
        *warningMessage_p = @"Please enter valid Pan Number";
        return NO;
        
    }
    else {
        return [self validateAddress:warningMessage_p];
    }
}


- (BOOL)validateAccountFieldsToEnableSubmitButton
{
	if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
		if (![self.accountNameTextField.text isEqualToString:@""] && ![self.siteTextField.text isEqualToString:@""] && ![self.mainPhoneNumberTextField.text isEqualToString:@""]) {
			if (self.hideShowView_Buttton.tag) {
                
                if ([self.pincode_Textfield.text hasValue] && ![UtilityMethods validatePincode:self.pincode_Textfield.text]) {
                    return STATE_DISABLE;
                }
                
                if (![self.taluka_Textfield.text isEqualToString:@""] ||![self.state_TextField.text isEqualToString:@""] ||![self.district_TextField.text isEqualToString:@""] ||![self.city_TextField.text isEqualToString:@""] ||![self.area_TextField.text isEqualToString:@""] ||![self.panchayat_TextField.text isEqualToString:@""]||![self.addressLine_One_TextField.text isEqualToString:@""] ||![self.addressLine_Two_TextField.text isEqualToString:@""]) {
                    
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
	} else {

        if (![self.accountNameTextField.text isEqualToString:@""] && ![self.siteTextField.text isEqualToString:@""] && ![self.mainPhoneNumberTextField.text isEqualToString:@""] && [self.searchedContactToBelinkedtoAccount.contactID length] != 0) {
			if (self.hideShowView_Buttton.tag) {
                
                if ([self.pincode_Textfield.text hasValue] && ![UtilityMethods validatePincode:self.pincode_Textfield.text]) {
                    return STATE_DISABLE;
                }
                
                if (![self.taluka_Textfield.text isEqualToString:@""] ||![self.state_TextField.text isEqualToString:@""] ||![self.district_TextField.text isEqualToString:@""] ||![self.city_TextField.text isEqualToString:@""] ||![self.area_TextField.text isEqualToString:@""] ||![self.panchayat_TextField.text isEqualToString:@""]||![self.addressLine_One_TextField.text isEqualToString:@""] ||![self.addressLine_Two_TextField.text isEqualToString:@""]) {
                    
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
}

-(void)submitCreateAccountRequest:(EGAccount __weak*)accountObjectLocal {
    
    if (self.invokedFrom == UpdateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
        
        [UtilityMethods alert_ShowMessage:MSG_INTERNET_NOT_AVAILBLE withTitle:APP_NAME andOKAction:nil];
    }
    else if (self.invokedFrom == Home && ![[ReachabilityManager sharedInstance] isInternetAvailable]){
        
        //[UtilityMethods alert_ShowMessage:MSG_INTERNET_NOT_AVAILBLE withTitle:APP_NAME andOKAction:nil];
        [self showDraftSaveConfirmation];
    }
    else{
        NSString *strConfirmationMessage;
        
        if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
            strConfirmationMessage = @"Continue to create account in offline ?";
        } else {
            strConfirmationMessage = @"Do you want to Create Account ?";
        }
        [UtilityMethods
         alert_showMessage:strConfirmationMessage
         withTitle:APP_NAME andOKAction:^{
             NSLog(@"This is a yes block");
             if (self.invokedFrom == CreateOpportunity && ![[ReachabilityManager sharedInstance] isInternetAvailable]) {
                 if ([self.delegate respondsToSelector:@selector(accountSubmittedInOffline:)]) {
                     self.opportunityAccount = [self makeAccountModel];
                     [self.delegate accountSubmittedInOffline:self.opportunityAccount];
                     [self.navigationController popViewControllerAnimated:true];
                 }
             } else {
                 
                 [[EGRKWebserviceRepository sharedRepository]createAccount:[self accountCreationPayload:accountObjectLocal]
                                                           andSucessAction:^(NSDictionary *account) {
                                                               if ([[account allValues] count] > 0) {
                                                                   [self accountCreatedSuccessfully:account Account_id:[account objectForKey:@"id"]];
                                                               } else{
                                                                   [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                                                               }
                                                               [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_Submit_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:GA_EA_Create_Account_Successful];
                                                               
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
                                                               
                                                               [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_Submit_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:GA_EA_Create_Account_Failed];
                                                               
                                                           }];
             }
         }
         andNoAction:^{
             NSLog(@"This is a no block");
         }];
    }
}

- (void) showDraftSaveConfirmation
{
    NSString *message = @"You are currently Offline. Account will be created automatically once we get the Internet Connection.";
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        if (self.draftAccount && [self.draftAccount.draftIDAccount hasValue]) {
            [self updateAccountDraft:EGDraftStatusQueuedToSync];
        } else {
            [self saveAccountdraft:EGDraftStatusQueuedToSync];
        }
        
        // Go to home screen
        [[AppRepo sharedRepo] showHomeScreen];
    }];
}

- (NSDictionary *)accountCreationPayload:(EGAccount *)accountObjectLocal {
	
	
	EGContact *selectedContact = self.searchedContactToBelinkedtoAccount;
    NSString *selectedContactID = selectedContact.contactID;
	if (accountObjectLocal.toContact && [accountObjectLocal.toContact count] > 0) {
		for (EGContact *contact in accountObjectLocal.toContact) {
			selectedContact = contact;
			selectedContactID = contact.contactID;
			break;
		}
	}
	
	NSDictionary *requestDictionary;
	if ([self.addressLine_One_TextField.text hasValue]) {
        requestDictionary = @{
                              @"latitude": self.latitude? : @"",
                              @"longitude" : self.longitude? : @"",
							  @"account_name": self.accountNameTextField.text,
							  @"site_name" : self.siteTextField.text,
							  @"main_phone_number" : self.mainPhoneNumberTextField.text,
                              @"PAN_number" : self.accPanNumTextField.text,
							  @"primary_contact" : @{
									  @"contact_id" : selectedContactID
									  },
							  @"address" : @{
									  @"country": @"India",
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
	else {
        requestDictionary = @{
                              @"latitude": self.latitude? : @"",
                              @"longitude" : self.longitude? : @"",
							  @"account_name": self.accountNameTextField.text,
							  @"site_name" : self.siteTextField.text,
							  @"main_phone_number" : self.mainPhoneNumberTextField.text,
                              @"PAN_number" : self.accPanNumTextField.text,
							  @"address" : @{},
							  @"primary_contact" : @{
									  @"contact_id" : selectedContactID
                                    }
							  };
	}
	
	return requestDictionary;
}


- (EGAccount *)makeAccountModel {
	EGAccount *accountModel = [EGAccount new];
	accountModel.accountName = self.accountNameTextField.text;
	accountModel.siteName = self.siteTextField.text;
	accountModel.contactNumber = self.mainPhoneNumberTextField.text;
    accountModel.mPAN = self.accPanNumTextField.text;
	
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
	
	accountModel.toAddress = address;
	return accountModel;
}



-(void)accountCreationFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
	
}

-(void)accountCreatedSuccessfully:(id)account Account_id:(NSString *)accountid{
    if (self.invokedFrom == CreateOpportunity || self.invokedFrom == UpdateOpportunity) {
        NSDictionary *responseDict = (NSDictionary *)account;
        //[UtilityMethods alert_ShowMessage:@"Account Created Successfully." withTitle:[responseDict objectForKey:@"id"] andOKAction:^{
            // Send the created contact model to the invoker of this screen
            if ([self.delegate respondsToSelector:@selector(accountCreationSuccessfull:fromView:)]) {
                self.opportunityAccount = [[EGAccount alloc] init];
                self.opportunityAccount.accountName = self.accountNameTextField.text;
                self.opportunityAccount.siteName = self.siteTextField.text;
                self.opportunityAccount.contactNumber = self.mainPhoneNumberTextField.text;
                self.opportunityAccount.mPAN = self.accPanNumTextField.text;
                
                self.opportunityAccount.accountID = [responseDict objectForKey:@"id"];
            
                [self.delegate accountCreationSuccessfull:self.opportunityAccount fromView:SearchResultFrom_Prospect];
                
                [self.navigationController popViewControllerAnimated:true];
            }
        //}];
    }
    else {
       
        
        [UtilityMethods alert_showMessage:@"Account Created Sucsessfully. Do you want to create Opportunity ? " withTitle:accountid andOKAction:^{
            [self userConfirmedForCreateOpportunityFlow:[account objectForKey:@"id"]];
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewAccount_ContinuetoOpportunity_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

        } andNoAction:^{
            [[AppRepo sharedRepo] showHomeScreen];
            [self clearAllTextFiledsInView:self.addressDetailsView];
            [UtilityMethods clearAllTextFiledsInView:self.create_AccountView];
        }];
        
        
        if([self.entryPoint  isEqualToString: DRAFT]){
            
            NSFetchRequest *fetchRequest=[AAADraftAccountMO  fetchRequest];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDAccount == %@",  self.draftAccount.draftIDAccount]];
            
            AAADraftAccountMO * draftAccountInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
            
            [appdelegate.managedObjectContext deleteObject:draftAccountInfo];
            
            [appdelegate saveContext];
        }
        
    }

}


- (void)saveAccountdraft:(EGDraftStatus) draftStatus {
  
    if(!(self.firstNameTextField.text.length == 0) || !(self.LastNameTextField.text.length == 0) ||!(self.emailTextField.text.length == 0 || !(self.panNumTextField.text.length == 0) || !(self.mobileNumberTextField.text.length == 0)) || !(self.mainPhoneNumberTextField.text.length == 0) || !(self.addressLine_One_TextField.text.length == 0) || !(self.addressLine_Two_TextField.text.length == 0) || !(self.taluka_Textfield.text.length == 0) || !(self.state_TextField.text.length == 0) || !(self.city_TextField.text.length == 0) || !(self.area_TextField.text.length == 0) || !(self.pincode_Textfield.text.length == 0) || !(self.panchayat_TextField.text.length == 0) || !(self.district_TextField.text.length == 0) || !(self.area_TextField.text.length == 0) || !(self.accountNameTextField.text.length == 0) || !(self.siteTextField.text.length == 0))
    {
        
        AAADraftAccountMO *draftAccountInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_DRAFTACC inManagedObjectContext:appdelegate.managedObjectContext];
        draftAccountInfo.draftIDAccount = [UtilityMethods uuid];
        draftAccountInfo.userIDLink = [[AppRepo sharedRepo] getLoggedInUser].userName;
        draftAccountInfo.status = draftStatus;
    
        AAAAccountMO *accountInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_ACCOUNT inManagedObjectContext:appdelegate.managedObjectContext];
        accountInfo.site = self.siteTextField.text.length > 0 ? self.siteTextField.text : @"";
        accountInfo.contactNumber = self.mainPhoneNumberTextField.text.length > 0 ? self.mainPhoneNumberTextField.text : @"";
        accountInfo.accountName = self.accountNameTextField.text.length > 0 ? self.accountNameTextField.text : @"";
        accountInfo.accountPAN = self.accPanNumTextField.text.length > 0 ? self.accPanNumTextField.text : @"";
        accountInfo.latitude =  self.latitude? : @"";
        accountInfo.longitude = self.longitude? : @"";
    
        if (self.searchedContactToBelinkedtoAccount != nil) {
            AAAContactMO *contactInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_CONTACT inManagedObjectContext:appdelegate.managedObjectContext];
            contactInfo.firstName = self.searchedContactToBelinkedtoAccount.firstName.length > 0 ? self.searchedContactToBelinkedtoAccount.firstName : @"";
            contactInfo.lastName = self.searchedContactToBelinkedtoAccount.lastName.length > 0 ? self.searchedContactToBelinkedtoAccount.lastName : @"";
            contactInfo.emailID = self.searchedContactToBelinkedtoAccount.emailID.length > 0 ? self.searchedContactToBelinkedtoAccount.emailID : @"";
            contactInfo.contactNumber = self.searchedContactToBelinkedtoAccount.contactNumber.length > 0 ? self.searchedContactToBelinkedtoAccount.contactNumber : @"";
            contactInfo.panNumber = self.searchedContactToBelinkedtoAccount.panNumber.length > 0 ? self.searchedContactToBelinkedtoAccount.panNumber : @"";
            contactInfo.contactID = self.searchedContactToBelinkedtoAccount.contactID.length > 0 ? self.searchedContactToBelinkedtoAccount.contactID : @"";

            contactInfo.toAddress.city = self.searchedContactToBelinkedtoAccount.toAddress.city.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.city : @"";
            contactInfo.toAddress.district = self.searchedContactToBelinkedtoAccount.toAddress.district.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.district : @"";
            contactInfo.toAddress.pin = self.searchedContactToBelinkedtoAccount.toAddress.pin.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.pin : @"";
            contactInfo.toAddress.toState.name = self.searchedContactToBelinkedtoAccount.toAddress.state.name.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.state.name : @"";
            contactInfo.toAddress.toState.code = self.searchedContactToBelinkedtoAccount.toAddress.state.code.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.state.code : @"";
            contactInfo.toAddress.area = self.searchedContactToBelinkedtoAccount.toAddress.area.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.area : @"";
            contactInfo.toAddress.addressLine2 = self.searchedContactToBelinkedtoAccount.toAddress.addressLine2.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.addressLine2 : @"";
            contactInfo.toAddress.addressLine1 = self.searchedContactToBelinkedtoAccount.toAddress.addressLine1.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.addressLine1 : @"";
            contactInfo.toAddress.panchayat = self.searchedContactToBelinkedtoAccount.toAddress.panchayat.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.panchayat : @"";
            
            NSMutableSet *contactSets = [NSMutableSet setWithObjects:contactInfo, nil];
            accountInfo.toContact = contactSets;
        }else{
            accountInfo.toContact = nil;
        }
        
    
    AAAAddressMO *addressInfo = [NSEntityDescription   insertNewObjectForEntityForName:@"Address" inManagedObjectContext:appdelegate.managedObjectContext];
    
    AAAStateMO *stateInfo=[NSEntityDescription   insertNewObjectForEntityForName:@"State" inManagedObjectContext:appdelegate.managedObjectContext];
    stateInfo.name = self.state_TextField.text.length > 0 ? self.state_TextField.text : @"";
    stateInfo.code = self.state.code.length > 0 ? self.state.code : @"";
        
    AAATalukaMO *talukaInfo=[NSEntityDescription   insertNewObjectForEntityForName:@"Taluka" inManagedObjectContext:appdelegate.managedObjectContext];
        
    talukaInfo.talukaName = self.taluka_Textfield.text.length > 0 ? self.taluka_Textfield.text : @"";
    addressInfo.toTaluka = talukaInfo;
    addressInfo.toState = stateInfo;
    addressInfo.district = self.district_TextField.text.length > 0 ? self.district_TextField.text : @"";
    addressInfo.city = self.city_TextField.text.length > 0 ? self.city_TextField.text : @"";
    addressInfo.area = self.area_TextField.text.length > 0 ? self.area_TextField.text : @"";
    addressInfo.panchayat = self.panchayat_TextField.text.length > 0 ? self.panchayat_TextField.text : @"";
    addressInfo.pin = self.pincode_Textfield.text.length > 0 ? self.pincode_Textfield.text : @"";
    addressInfo.addressLine1 = self.addressLine_One_TextField.text.length > 0 ? self.addressLine_One_TextField.text : @"";
    addressInfo.addressLine2 = self.addressLine_Two_TextField.text.length > 0 ? self.addressLine_Two_TextField.text : @"";
    accountInfo.toAddress = addressInfo;
        
    draftAccountInfo.toAccount = accountInfo;
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        self.currentDraftID = draftAccountInfo.draftIDAccount;
        [self.saveToDraftsButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
        [self disableOrEnableButton:self.saveToDraftsButton withState:STATE_DISABLE];
    [UtilityMethods alert_ShowMessage:@"Account saved as Draft successfully..." withTitle:APP_NAME andOKAction:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else{
        [UtilityMethods alert_ShowMessage:@"Please enter contact details to save it as Draft!!" withTitle:APP_NAME andOKAction:nil];
        
    }

}

- (void)updateAccountDraft:(EGDraftStatus) draftStatus {
    NSFetchRequest *fetchRequest = [AAADraftAccountMO fetchRequest];
    if ([self.entryPoint isEqualToString:DRAFT]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDAccount == %@",  self.draftAccount.draftIDAccount]];
    }
    else{
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftIDAccount == %@",  self.currentDraftID]];
    }
    

    AAADraftAccountMO * draftAccountInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    // update the draft status
    draftAccountInfo.status = draftStatus;
    
    [draftAccountInfo setValue: self.siteTextField.text forKeyPath:@"toAccount.site"];
    [draftAccountInfo setValue: self.mainPhoneNumberTextField.text forKeyPath:@"toAccount.contactNumber"];
    [draftAccountInfo setValue: self.accountNameTextField.text forKeyPath:@"toAccount.accountName"];
    [draftAccountInfo setValue: self.accPanNumTextField.text forKeyPath:@"toAccount.accountPAN"];
    [draftAccountInfo setValue:self.latitude? : @"" forKeyPath:@"toAccount.latitude"];
    [draftAccountInfo setValue:self.longitude? : @"" forKeyPath:@"toAccount.longitude"];
    
//    if (self.searchedContactToBelinkedtoAccount == nil) {
//        self.searchedContactToBelinkedtoAccount = [[EGContact alloc]init];
//        self.searchedContactToBelinkedtoAccount = (EGContact *)draftAccountInfo;
//    }
   
    AAAAddressMO *address = draftAccountInfo.toAccount.toAddress;
     AAAStateMO *state = draftAccountInfo.toAccount.toAddress.toState;
    AAATalukaMO *taluka = draftAccountInfo.toAccount.toAddress.toTaluka;
    
    if (self.searchedContactToBelinkedtoAccount != nil) {
        AAAContactMO *contactInfo=[NSEntityDescription   insertNewObjectForEntityForName:E_CONTACT inManagedObjectContext:appdelegate.managedObjectContext];
        contactInfo.firstName = self.searchedContactToBelinkedtoAccount.firstName.length > 0 ? self.searchedContactToBelinkedtoAccount.firstName : @"";
        contactInfo.lastName = self.searchedContactToBelinkedtoAccount.lastName.length > 0 ? self.searchedContactToBelinkedtoAccount.lastName : @"";
        contactInfo.emailID = self.searchedContactToBelinkedtoAccount.emailID.length > 0 ? self.searchedContactToBelinkedtoAccount.emailID : @"";
        contactInfo.contactNumber = self.searchedContactToBelinkedtoAccount.contactNumber.length > 0 ? self.searchedContactToBelinkedtoAccount.contactNumber : @"";
        contactInfo.panNumber = self.searchedContactToBelinkedtoAccount.panNumber.length > 0 ? self.searchedContactToBelinkedtoAccount.panNumber : @"";
        contactInfo.contactID = self.searchedContactToBelinkedtoAccount.contactID.length > 0 ? self.searchedContactToBelinkedtoAccount.contactID : @"";
        
        contactInfo.toAddress.city = self.searchedContactToBelinkedtoAccount.toAddress.city.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.city : @"";
        contactInfo.toAddress.district = self.searchedContactToBelinkedtoAccount.toAddress.district.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.district : @"";
        contactInfo.toAddress.pin = self.searchedContactToBelinkedtoAccount.toAddress.pin.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.pin : @"";
        contactInfo.toAddress.area = self.searchedContactToBelinkedtoAccount.toAddress.area.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.area : @"";
        contactInfo.toAddress.addressLine2 = self.searchedContactToBelinkedtoAccount.toAddress.addressLine2.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.addressLine2 : @"";
        contactInfo.toAddress.addressLine1 = self.searchedContactToBelinkedtoAccount.toAddress.addressLine1.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.addressLine1 : @"";
        contactInfo.toAddress.panchayat = self.searchedContactToBelinkedtoAccount.toAddress.panchayat.length > 0 ? self.searchedContactToBelinkedtoAccount.toAddress.panchayat : @"";
        
        NSMutableSet *contactSets = [NSMutableSet setWithObjects:contactInfo, nil];
        draftAccountInfo.toAccount.toContact = contactSets;
    }else{
        draftAccountInfo.toAccount.toContact = nil;
    }

    [taluka setValue: self.taluka_Textfield.text forKey:@"talukaName"];
    [state setValue: self.state_TextField.text forKey:@"name"];
    [state setValue: self.state.code forKey:@"code"];
    [address setValue: self.district_TextField.text forKey:@"district"];
    [address setValue: self.city_TextField.text forKey:@"city"];
    [address setValue: self.area_TextField.text forKey:@"area"];
    [address setValue: self.panchayat_TextField.text forKey:@"panchayat"];
    [address setValue: self.pincode_Textfield.text forKey:@"pin"];
    [address setValue: self.addressLine_One_TextField.text forKey:@"addressLine1"];
    [address setValue: self.addressLine_Two_TextField.text forKey:@"addressLine2"];

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
