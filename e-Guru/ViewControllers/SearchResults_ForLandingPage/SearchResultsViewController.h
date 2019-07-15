//
//  SearchResultsViewController.h
//  e-Guru
//
//  Created by MI iMac01 on 30/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedOptySearchResultViewCell.h"
#import "RelatedContactSearchResultViewCell.h"
#import "RelatedAccountSearchViewCell.h"
#import "EGsearchByValues.h"

#import "AppDelegate.h"
#import "EGPagedTableViewDataSource.h"
#import "EGPagedTableView.h"
#import "EGPagedArray.h"
#import "HHSlideView.h"
#import "ProspectViewController.h"

@protocol SearchResultsViewControllerDelegate<NSObject>

- (void)contactCreationSuccessfull:(EGContact*)contact fromView:(SearchResultFromPage)searchResultFromPage;
- (void)accountCreationSuccessfull:(EGAccount*)account fromView:(SearchResultFromPage)searchResultFromPage;

@optional
- (void)moveToNewContactCreation:(SearchResultFromPage)searchResultFromPage;

@end

@interface SearchResultsViewController : UIViewController<UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,EGPagedTableViewDelegate>
{
    AppDelegate *appdelegate;

}

@property (weak, nonatomic) id<SearchResultsViewControllerDelegate>delegate;
@property (assign, nonatomic) SearchResultFromPage searchResultFrom;
@property (strong,nonatomic)EGsearchByValues * searchByValue;
@property (strong,nonatomic)NSString * detailsObj;

@property (strong,nonatomic)NSString *firstName;
@property (strong,nonatomic)NSString *LastName;
@property (strong,nonatomic)  NSDictionary *commentJson;

@property (weak,nonatomic) IBOutlet UILabel * firstSectionLabel;
@property (weak,nonatomic) IBOutlet UILabel * secondSectionLabel;
@property (weak,nonatomic) IBOutlet UILabel * thirdSectionLabel;

//address view
@property (weak, nonatomic) IBOutlet UIView *addressDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *talukaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *panchayatLabel;
@property (weak, nonatomic) IBOutlet UILabel *pincodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBackButton;
@property (weak,nonatomic) UIViewController* senderVC;
@property (assign, nonatomic) InvokeForOperation entryPoint;
//first view - search by number
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *LastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ContactNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
//
@property (weak, nonatomic) IBOutlet UIView *contactSearchView;
@property (weak, nonatomic) IBOutlet UIView *accountSearchView;

@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *siteTextField;
@property (weak, nonatomic) IBOutlet UITextField *mainPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *panNumberTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchButtonTrailingSpaceConstraint;

//--//
@property (weak, nonatomic) IBOutlet EGPagedTableView *contactAccResultTableView;

@property (weak,nonatomic) IBOutlet UIView * titleBarForContact_secondView;
@property (weak,nonatomic) IBOutlet UIView * titleBarForAccount_secondView;

@property (weak,nonatomic) IBOutlet UIView * titleBarForContact_thirdView;
@property (weak,nonatomic) IBOutlet UIView * titleBarForAccount_thirdView;
@property (weak, nonatomic) IBOutlet UIView *titleBarForOpportunity;

//thirt Opty view
@property (strong, nonatomic) IBOutlet HHSlideView *slideView;
@property (weak, nonatomic) IBOutlet UIView *third_OpportunityView;

@property (weak, nonatomic) IBOutlet EGPagedTableView * relatedOpportunityResultTableView;
@property (weak, nonatomic) IBOutlet EGPagedTableView * relatedAccountContactTableView;
-(IBAction)searchButtonClicked:(id)sender;
@end
