//
//  ManageFianancierViewController.h
//  e-guru
//
//  Created by Admin on 21/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "Constant.h"
#import "UserDetails.h"

#import "EGRKWebserviceRepository.h"
#import "OpportunityOperationsHelper.h"

#import "EGPagedArray.h"
#import "EGPagedCollectionView.h"
#import "FinancierManageOptyCollectionViewCell.h"
#import "FinancierRequestViewController.h"

#import "SearchFinancierView.h"
#import "EGSearchFinancierOptyFilterModel.h"

@interface ManageFianancierViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,EGPagedCollectionViewDelegate,EGPagedCollectionViewDataSourceCallback,DropDownViewControllerDelegate>{
    
    AppDelegate                      *appdelegate;
    UITapGestureRecognizer           *tapRecognizer;
    EGPagedArray                     *opportunityPagedArray;
    NSMutableDictionary              *lastWeekC1OptyQuery;
    EGSearchFinancierOptyFilterModel *searchOptyFilter;
    SearchFinancierView              *searchFinancierView;

    BOOL isSearchManageOpty;
    BOOL isQuoteSubmittedToFinancier;
}
@property (assign, nonatomic) NSInteger selectedSegmentIndex;

@property (weak, nonatomic) IBOutlet UILabel * titleSalesStageLabel;

@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (nonatomic, strong) EGOpportunity *manageOpportunityModel;
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;

@property (weak, nonatomic) IBOutlet UISegmentedControl *financierOptySwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *retailFinancierTeamOptySwitch;

@property (weak, nonatomic) IBOutlet UILabel *noresultfoundlbl;

@property (strong,nonatomic)EGsearchByValues *searchByValue;
@property (strong, nonatomic) FinancierRequestViewController * financierRequestVc;

-(void)updateCollectionView;

@property (weak, nonatomic) IBOutlet EGPagedCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchDrawerButton;
- (IBAction)searchDrawerButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *helperButton;
- (IBAction)helperButtonClicked:(id)sender;

-(void)navigateToFinancierListView;
- (EGSearchFinancierOptyFilterModel *)searchFinancierOptyFilter;

@end
