//
//  ManageOpportunityViewController.h
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "ManageOpportunityCollectionViewCell.h"
#import "Constant.h"
#import "OpportunityOperationsHelper.h"
#import "UserDetails.h"
#import "OpportunityDetailsViewController.h"
#import "EGRKWebserviceRepository.h"
#import "OpportunityOperationsHelper.h"
#import "LostOpportunityViewController.h"
#import "NewActivityViewController.h"
#import "PendingActivitiesListViewController.h"
#import "SearchOpportunityView.h"
#import "EGsearchByValues.h"
#import "EGPagedArray.h"
#import "EGPagedCollectionView.h"
#import "EGPagedTableView.h"
#import "EGPagedTableViewDataSource.h"
#import "EGSearchOptyFilter.h"
#import "DropDownViewController.h"
#import "LostOpportunityViewController.h"

@interface ManageOpportunityViewController : UIViewController<UISplitViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ManageOpportunityCollectionViewCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,EGPagedCollectionViewDelegate,EGPagedCollectionViewDataSourceCallback,DropDownViewControllerDelegate>{
    
    SearchOpportunityView *searchOpportunityView;
    PendingActivitiesListViewController *pendingactivityView;
   
    
    AppDelegate *appdelegate;
    UITextField *activeField;
    UITapGestureRecognizer *tapRecognizer;
    UIDatePicker *fromDatePicker;
    UIDatePicker *toDatePicker;
    NSArray *actionList;
    NSMutableArray *opportunityList;
    EGOpportunity *opportunityBeingActedUpon;
    EGPagedArray * opportunityPagedArray;
    EGPagedArray * financierOpportunityPagedArray;  //will use later may be
    NSMutableDictionary *lastWeekC0OptyQuery;
    EGSearchOptyFilter *searchOptyFilter;
   
    __weak IBOutlet NSLayoutConstraint *appliedFilterLeadinConstraint;

}
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;

@property (weak, nonatomic) IBOutlet UISegmentedControl *optySwitchDSM_DSE;
@property (weak, nonatomic) IBOutlet UIButton *searchDrawerButton;
@property (weak, nonatomic) IBOutlet UILabel *filterInformation;

@property (weak, nonatomic) IBOutlet UILabel *noresultfoundlbl;

@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (weak, nonatomic) IBOutlet UILabel *optywithsalessatgelbl;
@property (nonatomic, strong) EGOpportunity *opportunity;

@property (weak, nonatomic) IBOutlet UILabel *vcTitle;
@property (strong,nonatomic)NSString *parentVC;
@property (strong,nonatomic)EGsearchByValues * searchByValue;
@property (weak, nonatomic) IBOutlet EGPagedCollectionView *collectionView;
-(void)updateCollectionView;
- (IBAction)openSearchDrawer:(id)sender;
- (IBAction)segmentSwitch:(UISegmentedControl *)sender;
- (EGSearchOptyFilter *)lastWeekC0OptyQuery;
@end
