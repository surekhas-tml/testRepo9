//
//  ProspectViewController.h
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GreyBorderUITextField.h"
#import "SeparatorView.h"
#import "UtilityMethods.h"
#import "AutoCompleteUITextField.h"
#import "UIColor+eGuruColorScheme.h"
#import "SearchContactView.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "MasterViewController.h"
#import "CreateOpportunityViewController.h"
#import "EGContact.h"
#import "EGAccount.h"
#import "AAADraftContactMO+CoreDataClass.h"
#import "AAADraftAccountMO+CoreDataClass.h"
#import "EGRKWebserviceRepository.h"
#import "EGState.h"
#import "EGTaluka.h"
#import "EGPin.h"
#import "SearchResultsViewController.h"


@import ContactsUI;
@import Contacts;

@protocol ProspectViewControllerDelegate <NSObject>

@optional
- (void)contactSubmittedInOffline:(EGContact*) contact;
- (void)accountSubmittedInOffline:(EGAccount*) account;
- (void)contactCreationSuccessfull:(EGContact*)contact fromView:(SearchResultFromPage)searchResultFromPage;
- (void)accountCreationSuccessfull:(EGAccount*)account fromView:(SearchResultFromPage)searchResultFromPage;
- (void)referralContactCreationSuccessfull:(EGContact*)account fromView:(SearchResultFromPage)searchResultFromPage;
@end

@interface ProspectViewController : UIViewController<UISplitViewControllerDelegate,UITextFieldDelegate,SearchContactViewDelegate,CNContactPickerDelegate,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate,AutoCompleteUITextFieldDelegate,DropDownViewControllerDelegate,ProspectViewControllerDelegate>{
    AppDelegate *appdelegate;
     UITextField *activeField;

}

@property (nonatomic, weak) id<ProspectViewControllerDelegate> delegate;
@property (strong,nonatomic)NSArray *resultArray;

@property (strong,nonatomic)  EGTaluka *talukaObj;
@property (weak,nonatomic)    UIViewController* senderVC;
@property (strong,nonatomic)  NSString * entryPoint;
@property (strong,nonatomic)  NSString * contactid;
@property (strong,nonatomic)  NSString * demo;
@property (strong,nonatomic)  EGState *state;
@property (strong,nonatomic)  NSString * currentDraftID;
@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (strong, nonatomic) EGContact *opportunityContact;
@property (strong,nonatomic)  EGAddress *contactAddress;         //new line
@property (strong, nonatomic) EGAccount *opportunityAccount;
@property (assign, nonatomic) InvokeForOperation appEntryPoint;
@property (strong,nonatomic)  NSString *latitude;
@property (strong,nonatomic)  NSString *longitude;
@property (strong,nonatomic)  NSDictionary *commentJson;
@property (nonatomic, assign) BOOL isReferral;

@property AAADraftContactMO *draftContact;
@property AAADraftAccountMO *draftAccount;
@property (strong, nonatomic) EGContact *searchedContactToBelinkedtoAccount;

@property (weak,nonatomic) IBOutlet UIView * create_AccountView;
@property (weak,nonatomic) IBOutlet UIView * create_ContactView;
@property (weak,nonatomic) IBOutlet UIView * titleBarView;
@property (weak,nonatomic) IBOutlet UIView * addressDetailsView;
@property (weak,nonatomic) IBOutlet UIScrollView * pageScrollView;


//titleBar view
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UIButton * importContactButton;
@property (weak,nonatomic) IBOutlet UIImageView * titleImageView;

@property (weak,nonatomic) IBOutlet UITextField     * firstNameTextField;
@property (weak,nonatomic) IBOutlet UITextField     * LastNameTextField;
@property (weak,nonatomic) IBOutlet UITextField     * mobileNumberTextField;
@property (weak,nonatomic) IBOutlet UITextField     * emailTextField;
@property (weak,nonatomic) IBOutlet UITextField     * panNumTextField;
@property (weak,nonatomic) IBOutlet AutoCompleteUITextField *taluka_Textfield;

//create account basic details
@property (weak,nonatomic) IBOutlet UITextField * accountNameTextField;
@property (weak,nonatomic) IBOutlet UITextField * siteTextField;
@property (weak,nonatomic) IBOutlet UITextField * mainPhoneNumberTextField;
@property (weak,nonatomic) IBOutlet UITextField * contactSearchTextField;
@property (weak,nonatomic) IBOutlet UITextField * accPanNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchContactButton;

//address Title Bar
@property (weak, nonatomic) IBOutlet UIButton *hideShowView_Buttton;
@property (weak, nonatomic) IBOutlet UIView *addressTitleBar;
@property (weak,nonatomic) IBOutlet UISwitch * gpsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *pickFromGPSLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactlastnamelbl;
@property (weak, nonatomic) IBOutlet UILabel *contactmobilenumberlbl;
@property (weak, nonatomic) IBOutlet UILabel *contactfirstnamelbl;

//address fields
@property (weak,nonatomic) IBOutlet DropDownTextField * state_TextField;
@property (weak,nonatomic) IBOutlet AutoCompleteUITextField * district_TextField;
@property (weak,nonatomic) IBOutlet AutoCompleteUITextField * city_TextField;

@property (weak,nonatomic) IBOutlet UITextField * area_TextField;
@property (weak,nonatomic) IBOutlet AutoCompleteUITextField * panchayat_TextField;

@property (weak,nonatomic) IBOutlet UITextField * addressLine_One_TextField;
@property (weak,nonatomic) IBOutlet UITextField * addressLine_Two_TextField;
@property (weak, nonatomic) IBOutlet SeparatorView *seperatorLineOne;
@property (weak, nonatomic) IBOutlet SeparatorView *seperatorLineTwo;

//Constraints
@property (weak,nonatomic) IBOutlet UIButton * saveToDraftsButton;
@property (weak,nonatomic) IBOutlet UIButton * submitButton;
@property (weak,nonatomic) IBOutlet UIButton * createAccountButton;

- (IBAction)saveToDraftButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)createAccountButtonClicked:(id)sender;
- (IBAction)importFromContactButtonClicked:(id)sender;
- (IBAction)addressFromGPS:(UISwitch *)switchState;
- (IBAction)searchContactButtonClicked:(id)sender;
- (IBAction)hideShowView_ButttonClicked:(id)sender;
- (BOOL)checkIfAnyAddressFieldHasValue;

@property (strong,nonatomic)NSString * detailsObj;


@property (weak, nonatomic) IBOutlet UIView *pincodeView;
@property (weak, nonatomic) IBOutlet UITextField *pincode_Textfield;
-(void)hideOrShowAddressDetailsView:(BOOL)hideAddressBar;
-(BOOL)validateAddress:(NSString **)warningMessage_p;
-(void)disableOrEnableButton:(UIButton *)button withState:(BOOL)buttonState;
-(void)userConfirmedForCreateOpportunityFlow:(NSString *)strID;
-(void)clearAllTextFiledsInView:(UIView *)fromView;
@end
