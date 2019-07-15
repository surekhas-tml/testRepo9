//
//  Home_LandingPageViewController.h
//  e-Guru
//
//  Created by MI iMac01 on 29/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserDetails.h"
#import "EGsearchByValues.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "UIColor+eGuruColorScheme.h"
#import "SearchResultsViewController.h"
#import "DetailViewController.h"
#import "ManageOpportunityViewController.h"
#import "ProspectViewController.h"
#import "CreateOpportunityViewController.h"
#import "DashboardViewController.h"
#import "WeekCalendarViewController.h"
#import "SearchNFAViewController.h"
#define MYPAGEBUTTON 10
#define MYOPPORTUNITYBUTTON 11
#define CALENDERBUTTON 12
#define DASHBOARDBUTTON 13
#define DRAFTBUTTON 14
#define CONTACTBUTTON 15
#define NFABUTTON 16
#define FINANCERBUTTON 101

@interface Home_LandingPageViewController : UIViewController<UISplitViewControllerDelegate,UITextFieldDelegate>
{
    AppDelegate *appdelegate;
}
@property (weak, nonatomic) IBOutlet UIView         *dseOptionsView;
@property (weak, nonatomic) IBOutlet UIView         *dsmOptionsView;
@property (strong, nonatomic) IBOutlet UILabel      *LogedinUser;
@property (weak, nonatomic) IBOutlet UITextField    *searchTextField;
@property (strong,nonatomic)NSString                * contactnumber;
@property (strong,nonatomic)NSString                * accountnumber;
@property (strong, nonatomic) IBOutlet UILabel *basedonrolelabel;

@property (strong,nonatomic)NSString * entrypoint;
@property (strong,nonatomic)NSString * number;
@property (strong, nonatomic) IBOutlet UIButton *buttonbasedonrole;

@property (weak, nonatomic) IBOutlet UIButton *createNewButton;
@property (weak, nonatomic) IBOutlet UIButton *radioOptyButton;
@property (weak, nonatomic) IBOutlet UIButton *radioContactButton;
@property (weak, nonatomic) IBOutlet UIButton *radioAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIButton *myPageButton;
@property (weak, nonatomic) IBOutlet UIButton *myOpportunityButton;
@property (weak, nonatomic) IBOutlet UIButton *calenderButton;
@property (weak, nonatomic) IBOutlet UIButton *dashboardButton;
@property (weak, nonatomic) IBOutlet UIButton *draftButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
- (IBAction)searchButtonClick:(id)sender;

- (IBAction)cirularButtonClicked:(id)sender;

- (IBAction)radioButtonClicked:(id)sender;
-(IBAction)createNewButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchFieldsRightMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchButtonRightMarginConstraint;
@end
