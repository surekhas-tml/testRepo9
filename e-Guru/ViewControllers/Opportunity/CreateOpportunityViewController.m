//
//  CreateOpportunityViewController.m
//  e-Guru
//
//  Created by Ashish Barve on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "CreateOpportunityViewController.h"
#import "EGOpportunity.h"
#import "NSString+NSStringCategory.h"
#import "UserDetails.h"
#import "AAADraftMO+CoreDataProperties.h"
#import "EGVCNumber.h"
#import "EGFinancier.h"
#import "EGMMGeography.h"
#import "EGReferralCustomer.h"
#import "EGTGM.h"


#define PRODUCT_SELECTION_TAB   0
#define MANDATORY_FIELDS_TAB    1
#define OPTIONAL_FIELDS_TAB     2
#define FINANCER_TAB            3

@interface CreateOpportunityViewController ()

@property (nonatomic, strong) ProductSelectionViewController   *productSelectionViewController;
@property (nonatomic, strong) MandatoryFieldsViewController    *mandatoryFieldsViewController;
@property (nonatomic, strong) OptionalFieldsViewController     *optionalFieldsViewController;
@property (nonatomic, strong) FinancierFieldViewController     *financeViewController;

@end

@implementation CreateOpportunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CALL CreateOpportunityViewController");
    // Following instruction disables constraint log messages 
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    [self configureView];
    
    // The sequence of below instruction is important
    [self generateOpportunityModelFromCoreData]; // 1
    
    if (self.entryPoint == InvokeForUpdateOpportunity){
        self.title = @"Update Opportunity";
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Update_Opportunity];

    }else if (self.entryPoint == InvokeForDraftEdit){
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Update];
        self.title = @"Update Draft";
    }
    
    if (self.entryPoint == InvokeForUpdateOpportunity || self.entryPoint == InvokeForDraftEdit) {  // 2
        [self selectTabWithIndex:PRODUCT_SELECTION_TAB];
        [self selectTabWithIndex:MANDATORY_FIELDS_TAB];
    }
    else {
        [self selectTabWithIndex:PRODUCT_SELECTION_TAB];
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Create_Opportunity];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EGOpportunity *)opportunity {
    if (!_opportunity) {
        _opportunity = [[EGOpportunity alloc] init];
    }
    return _opportunity;
}

#pragma mark - Private Methods

- (void)selectTabWithIndex:(NSInteger)index {
    [self adjustTabAppearanceForSelectedIndex:index];
    
    switch (index) {
        case PRODUCT_SELECTION_TAB:
            [self selectProductSelectionTab];
            break;
        
        case MANDATORY_FIELDS_TAB:
            [self selectMandatoryFieldsTab];
            break;
            
        case OPTIONAL_FIELDS_TAB:
            [self selectOptionalFieldsTab];
            break;
       
        default:
            break;
    }
}

- (void)adjustTabAppearanceForSelectedIndex:(NSInteger)index {
    if (index == PRODUCT_SELECTION_TAB) {
        [self setSelectedColorsForView:self.productSelectionTabNumber andButton:self.productSelectionTabButton];
    }
    else if (index == MANDATORY_FIELDS_TAB) {
        [self setSelectedColorsForView:self.mandatoryFieldsTabNumber andButton:self.mandatoryFieldsTabButton];
        if (self.entryPoint == InvokeForUpdateOpportunity) {
            [self.optionalFieldsTabButton setEnabled:true];
        }
    }
    else if (index == OPTIONAL_FIELDS_TAB) {
        [self setSelectedColorsForView:self.optionalFieldsTabNumber andButton:self.optionalFieldsTabButton];
        if (self.entryPoint != InvokeForUpdateOpportunity) {
            [self.productSelectionTabButton setEnabled:false];
            [self.mandatoryFieldsTabButton setEnabled:false];
        }
    }
    else if (index == FINANCER_TAB){
        [self setSelectedColorsForView:self.financeFieldTabNumber andButton:self.financeFieldTabButton];
//        if (self.entryPoint != InvokeForUpdateOpportunity) {
//
//        }
    }
    
    if (index != PRODUCT_SELECTION_TAB) {
        [self setDeselectedColorsForView:self.productSelectionTabNumber andButton:self.productSelectionTabButton];
    }
    
    if (index != MANDATORY_FIELDS_TAB) {
        [self setDeselectedColorsForView:self.mandatoryFieldsTabNumber andButton:self.mandatoryFieldsTabButton];
    }
    
    if (index != OPTIONAL_FIELDS_TAB) {
        [self setDeselectedColorsForView:self.optionalFieldsTabNumber andButton:self.optionalFieldsTabButton];
    }
    if (index != FINANCER_TAB) {
        [self setDeselectedColorsForView:self.financeFieldTabNumber andButton:self.financeFieldTabButton];
    }
}

- (void)setSelectedColorsForView:(UIView *)view andButton:(UIButton *)button {
    [view setBackgroundColor:[UIColor themePrimaryColor]];
    [button setEnabled:true];
    [button setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
}

- (void)setDeselectedColorsForView:(UIView *)view andButton:(UIButton *)button {
    [view setBackgroundColor:[UIColor themeDisabledColor]];
    [button setTitleColor:[UIColor themeDisabledColor] forState:UIControlStateNormal];
}

- (void)selectProductSelectionTab {
    [self removeViewController:self.mandatoryFieldsViewController];
    [self removeViewController:self.optionalFieldsViewController];
    [self removeViewController:self.financeViewController];
    [self addProductSelectionViewController];
}

- (void)selectMandatoryFieldsTab {
    [self removeViewController:self.optionalFieldsViewController];
    [self addMandatoryFieldsViewController];
}

- (void)selectOptionalFieldsTab {
    [self removeViewController:self.mandatoryFieldsViewController];
    [self addOptionalFieldsViewController];
}

- (void)addProductSelectionViewController {
    if (![self.productSelectionViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:[NSBundle mainBundle]];
        self.productSelectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProductSelectionViewController"];
        [self.productSelectionViewController setDelegate:self];
        [self.productSelectionViewController setOpportunity:self.opportunity];
        [self.productSelectionViewController setEntryPoint:self.entryPoint];
        [self addChildViewController:self.productSelectionViewController];
        [self.containerView addSubview:self.productSelectionViewController.view];
        [self.productSelectionViewController.view setFrame:self.containerView.bounds];
        [self.productSelectionViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.productSelectionViewController.view];
    }
}

- (void)addMandatoryFieldsViewController {
    if (![self.mandatoryFieldsViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:[NSBundle mainBundle]];
        self.mandatoryFieldsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MandatoryFieldsViewController"];
        [self.mandatoryFieldsViewController setDelegate:self];
        [self.mandatoryFieldsViewController setOpportunity:self.opportunity];
        [self.mandatoryFieldsViewController setEntryPoint:self.entryPoint];
        [self.mandatoryFieldsViewController setActivityObj:self.activityObj];
        //[self.mandatoryFieldsViewController setCommentsString:self.commentsString];
        
        [self.mandatoryFieldsViewController setIsFromReferralOptyCreatioin:self.isFromReferralOptyCreatioin];
        [self addChildViewController:self.mandatoryFieldsViewController];
        [self.containerView addSubview:self.mandatoryFieldsViewController.view];
        [self.mandatoryFieldsViewController.view setFrame:self.containerView.bounds];
        [self.mandatoryFieldsViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.mandatoryFieldsViewController.view];
    }
}

- (void)addOptionalFieldsViewController {
    if (![self.optionalFieldsViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:[NSBundle mainBundle]];
        self.optionalFieldsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionalFieldsViewController"];
        [self.optionalFieldsViewController setOpportunity:self.opportunity];
        [self.optionalFieldsViewController setEntryPoint:self.entryPoint];
        [self addChildViewController:self.optionalFieldsViewController];
        [self.containerView addSubview:self.optionalFieldsViewController.view];
        [self.optionalFieldsViewController.view setFrame:self.containerView.bounds];
        [self.optionalFieldsViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.optionalFieldsViewController.view];
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    if (viewController) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}

- (void)generateOpportunityModelFromCoreData {
    if (self.entryPoint != InvokeForDraftEdit || !self.opportunityDraft) {
        return;
    }
//    self.opportunity = [[EGOpportunity alloc] init];
    self.opportunity = [[EGOpportunity alloc]initWithObject:self.opportunityDraft.toOpportunity];
    self.opportunity.draftID = self.opportunityDraft.draftID;
}

#pragma mark - ProductSelectionViewControllerDelegate Methods

- (void)productSelectionScreenNextButtonClicked {
    [self selectTabWithIndex:MANDATORY_FIELDS_TAB];
}

- (void)opportunityModelChanged:(EGOpportunity *)newOpportuityModel {
    
    if ([self.opportunity.optyID hasValue] && self.entryPoint == InvokeForUpdateOpportunity) {
        newOpportuityModel.optyID = self.opportunity.optyID;
        self.opportunity = newOpportuityModel;
        
    }else{
        self.opportunity = newOpportuityModel;
    }
}

#pragma mark - MandatoryFieldsViewControllerDelegate Methods

- (void)mandatoryFieldsScreenSubmitButtonClicked {
    [self selectTabWithIndex:OPTIONAL_FIELDS_TAB];
}

#pragma mark - IBActions

- (IBAction)productSelectionTabClicked:(id)sender {
    [self selectTabWithIndex:PRODUCT_SELECTION_TAB];
}

- (IBAction)mandatoryFieldsTabClicked:(id)sender {
    [self selectTabWithIndex:MANDATORY_FIELDS_TAB];
}

- (IBAction)optionalFieldsTabClicked:(id)sender {
    [self selectTabWithIndex:OPTIONAL_FIELDS_TAB];
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

@end
