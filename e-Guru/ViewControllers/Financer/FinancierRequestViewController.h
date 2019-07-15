//
//  FinancierRequestViewController.h
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAAFinancierOpportunityMO+CoreDataClass.h"
#import "BlueUIButton.h"
#import "FinancierTabsView.h"
#import "FinancierListDetailModel.h"
#import "EGFinancierOpportunity.h"
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "DropDownTextField.h"
#import "DropDownViewController.h"
#import "FinancierInsertQuoteModel.h"
#import "FinancierBranchDetailsModel.h"
#import "PersonalDetails.h"
#import "ContactDetails.h"
#import "AAADraftFinancierMO+CoreDataClass.h"

@protocol FinancierRequestViewControllerDelegate <NSObject>
@optional
- (void)nfaUpdated:(EGNFA *)mNFAModel;
@end


@interface FinancierRequestViewController : UIViewController<UIGestureRecognizerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate, UICollectionViewDelegateFlowLayout,AutoCompleteUITextFieldDelegate>
{
    AppDelegate *appdelegate;
}
@property (strong, nonatomic) NSString *entryPoint;     // new for draft feature
@property (strong,nonatomic)  NSString *currentDraftID; //new

@property (weak, nonatomic) IBOutlet UILabel *lobTextField;
@property (weak, nonatomic) IBOutlet UILabel *pplTextField;
@property (weak, nonatomic) IBOutlet UILabel *plTextField;
@property (weak, nonatomic) IBOutlet UILabel *vcTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *searchFinancierDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *searchTMFBranchDropDown;
@property (weak, nonatomic) IBOutlet AutoCompleteUITextField *searchTMFBDMDropDown;

@property (weak, nonatomic) IBOutlet UIView *financierTMFView;
@property (weak, nonatomic) IBOutlet UIView *financierBDMView;

@property (weak, nonatomic) IBOutlet FinancierTabsView *personalDetailsTab;
@property (weak, nonatomic) IBOutlet FinancierTabsView *contactDetailsTab;
@property (weak, nonatomic) IBOutlet FinancierTabsView *accountDetailsTab;
@property (weak, nonatomic) IBOutlet FinancierTabsView *vehicleDetailsTab;
@property (weak, nonatomic) IBOutlet FinancierTabsView *retailFinancierTab;

@property (nonatomic, strong) FinancierListDetailModel *financierListModel;
@property (nonatomic, strong) EGFinancierOpportunity   *financierOpportunity;
@property (nonatomic, strong) FinancierInsertQuoteModel *insertQuoteModel;
@property AAADraftFinancierMO *draftFinancier; //new property for draft feature

@property (weak, nonatomic) IBOutlet UIButton *agrementButton;
@property (weak, nonatomic) IBOutlet BlueUIButton *submitButton;
@property (weak, nonatomic) IBOutlet BlueUIButton *draftButton;  

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *otpBlurrView;

@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UITextField *txt5;
@property (weak, nonatomic) IBOutlet UITextField *txt6;

@property (nonatomic, strong) PersonalDetails *personalView;
@property (nonatomic, strong) ContactDetails  *contactView;

@property (weak, nonatomic) IBOutlet UICollectionView *financierSearchCollectionView;

@property (weak, nonatomic) id<FinancierRequestViewControllerDelegate> delegate;

//@property (weak, nonatomic) id<ContactViewDelegate> contactDelegate;

@property (weak, nonatomic) IBOutlet UIButton *helperButton;
- (IBAction)refreshButtonClicked:(id)sender;

- (IBAction)helperButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollvw;

@end
