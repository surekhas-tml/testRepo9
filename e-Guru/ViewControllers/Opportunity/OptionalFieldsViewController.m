//
//  OptionalFieldsViewController.m
//  e-Guru
//
//  Created by Ashish Barve on 11/30/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "FinancierRequestViewController.h"
#import "FinancierListViewController.h"

#import "OptionalFieldsViewController.h"
#import "PotentialDropOffViewController.h"

#import "COTextFieldView.h"
#import "COAutoCompleteTextFieldView.h"
#import "CODropDownView.h"
#import "COSearchTextFieldView.h"
#import "ValidationUtility.h"
#import "PrimaryField.h"
#import "Field.h"
#import "PureLayout.h"
#import "Constant.h"
#import "SeparatorView.h"
#import "LiveDealFieldsView.h"
#import "AccountView.h"
#import "AdditionalView.h"  //new
#import "NSString+NSStringCategory.h"
#import "ProspectViewController.h"
#import "SearchResultViewController.h"
#import "EGBroker.h"
#import "EGTGM.h"
#import "EGMMGeography.h"
#import "AutoCompleteUITextField.h"
#import "FinanciersDBHelpers.h"
#import "VehicleApplicationDBHelper.h"
#import "CompetitorDBHelpers.h"
#import "InfluencerDBHelpers.h"
#import "UsageCategoryDBHelper.h"
#import "MMGeographyDBHelpers.h"
#import "ReachabilityManager.h"
#import "VCNumberDBHelper.h"
#import "ExchangeFieldDBHelper.h" //new
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "ValidationUtility.h"

#define NO_OF_COLUMNS   4
#define LIVE_DEAL_VIEW_ON_HEIGHT 90
#define LIVE_DEAL_VIEW_OFF_HEIGHT 20
#define LIVE_DEAL_VIEW_ON_HEIGHT_NEW 140  //new use for if account not coming

#define CONTAINER_VIEW_HEIGHT_ON         400
#define CONTAINER_VIEW_HEIGHT_OFF        360
#define CONTAINER_VIEW_HEIGHT_WITHOUTACCOFF 200  //new
#define CONTAINER_VIEW_HEIGHT_WITHOUTACCON  260  //new
#define EXCHANGE_VIEW_BOTTOM_SPACE_OFF   400
#define EXCHANGE_VIEW_BOTTOM_SPACE_ON    300
#define LIVE_DEAL_YES       @"Y"
#define LIVE_DEAL_NO        @"N"
#define DSM_FLAG_YES       @"Y"
#define DSM_FLAG_NO        @"N"

#define MESSAGE_NO_RESULTS_FOUND    @"No results found"

@interface OptionalFieldsViewController () <ProspectViewControllerDelegate, SearchResultViewControllerDelegate, AutoCompleteUITextFieldDelegate, UIGestureRecognizerDelegate> {
	BOOL createOpty;
    BOOL liveDealToggleOn;
    BOOL isAccountExist;
    BOOL brokerSelected;
    EGPagedArray *opportunityPagedArray;
    BOOL isQuoteSubmittedToFinancier;
    
    AppDelegate *appDelegate;
    NSMutableArray* brandArray;
    NSMutableArray* plArray;
    NSMutableArray* mileageArray;
    NSMutableArray* ageOfvehicleArray;
}

@property (strong, nonatomic) FinancierRequestViewController * financierRequestVc;
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) NSMutableArray *dynamicFieldsArray;
@property (nonatomic, strong) NSMutableArray *liveDealFieldsArray;
@property (nonatomic, strong) NSMutableArray *stakeFieldsArray;
@property (nonatomic, strong) NSMutableArray *stakeFieldsRespoArray;

@property (nonatomic, strong) NSLayoutConstraint *liveDealViewHeightConstraint;

@property (nonatomic, strong) GreyBorderUITextField *brokerTextField;
@property (nonatomic, strong) GreyBorderUITextField *tgmTextField;
@property (nonatomic, strong) AutoCompleteUITextField *mmGeographyTextField;
@property (nonatomic, strong) AutoCompleteUITextField *financierTextField;
@property (nonatomic, strong) AccountView *accountView;
@property (nonatomic, strong) AdditionalView *additionalView;


@property (nonatomic, strong) UIView *liveDealView;
@property (nonatomic, strong) UIView *liveDealFieldsContainer;
@property (nonatomic, strong) UIView *stakeHolderView;

@property (nonatomic, strong) SeparatorView *liveDealSectionSeparator;
@property (nonatomic, strong) UISwitch *liveDealToggleSwitch;
@property (nonatomic, strong) UILabel *liveDealTextLabel;

@end

@implementation OptionalFieldsViewController

@synthesize financierOpportunity;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.opportunity.optyID);
    
    isAccountExist = YES;
//    brokerSelected = NO;
    
    [self markMandatoryExchangeDetailFields];
    _switchButton.transform = CGAffineTransformMakeScale(0.65, 0.65);
    
    if ([self.opportunity.interested_in_exchange isEqualToString:@"Y"]) {
        [self fillExchangeDetailsTextFieldsFromModel];
        [self hideOrShowExchangeView:NO];
    } else{
        [self fillExchangeDetailsTextFieldsFromModel];
        [self hideOrShowExchangeView:YES];
    }
    
    _registrationTextField.delegate = self;
    
    [self fetchFieldsListBasedOnSelectedLOB];
    [self bindTapToView:self.containerView];
    
    if (self.entryPoint == InvokeForUpdateOpportunity) {
        createOpty = NO;
    }
    else {
        createOpty = YES;
    }
    
    //To check whether its C1 or C1A
//    if ([self.opportunity.salesStageName containsString:C1]) {
//        self.financierButton.hidden = false;
//    }
    if ([self.opportunity.salesStageName containsString:@"C1 (Quote Tendered)"]) {
        _financierButton.hidden = false;
    } else {
        self.financierButton.hidden = true;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Adjust live deal view based on toggle state
    [self setLiveDealToggleState:self.opportunity.isLiveDeal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self bindValuesToOpportunityModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    
    if (!self.didSetupConstraints) {
        
        if (self.dynamicFieldsArray && [self.dynamicFieldsArray count] > 0) {
            [self renderFieldsFromList:self.dynamicFieldsArray inView:self.containerView];
        }
//        if (self.stakeFieldsArray && [self.stakeFieldsArray count] > 0) {
//            [self renderStakeHolderFields:self.stakeFieldsArray inView:self.containerView];
//        }

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
        
        if (self.opportunity.vhApplication) {
            Field *vehicleApplication = [[Field alloc] init];
            vehicleApplication.mTitle = FIELD_VEHICLE_APPLICATION;
            vehicleApplication.mSelectedValue = self.opportunity.vhApplication;
            _primaryField.mVehicleApplication = vehicleApplication;
        }
    }
    return _primaryField;
}

- (UILabel *)liveDealTextLabel {
    if (!_liveDealTextLabel) {
        _liveDealTextLabel = [[UILabel alloc] init];
        [_liveDealTextLabel setText:@"Live Deal"];
        [_liveDealTextLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:17.0f]];
        [_liveDealTextLabel setTextColor:[UIColor themePrimaryColor]];
    }
    return _liveDealTextLabel;
}

#pragma mark - Bind Values to UI

- (void)bindAccountDataFromOpportunityModel {
    
    if (self.accountView && self.opportunity.toAccount) {
        EGAccount *account = self.opportunity.toAccount;
        [self.accountView.accountNameTextField setText:account.accountName];
        [self.accountView.accountSiteTextField setText:account.siteName];
        [self.accountView.accountPhoneNumberTextField setText:account.contactNumber];
        [self.accountView.accountNumberTextField setText:account.contactNumber];
    }
}

- (void)bindLiveDealDataFromOpportunityModel {
    
    if (!self.opportunity.isLiveDeal) {
        return;
    }
    
    for (Field *field in self.liveDealFieldsArray) {
        if ([field.mTitle isEqualToString:FIELD_COMPETITOR]) {
            field.mSelectedValue = self.opportunity.competitor;
        }
        else if ([field.mTitle isEqualToString:FIELD_PRODUCT_CATEGORY]) {
            field.mSelectedValue = self.opportunity.productCatagory;
        }
        else if ([field.mTitle isEqualToString:FIELD_MODEL]) {
            field.mSelectedValue = self.opportunity.competitorModel;
        }
        else if ([field.mTitle isEqualToString:FIELD_DETAILED_REMARK]) {
            field.mSelectedValue = self.opportunity.competitorRemark;
        }
    }
}

- (void)bindOpportunityModelDataToField:(Field *)field {
    if (!field || !self.opportunity) {
        return;
    }
    
    if ([field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.mmGeography;
    }
    else if ([field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.bodyType;
    }
    else if ([field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.usageCategory;
    }
    else if ([field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.totalFleetSize;
    }
    else if ([field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
        field.mSelectedValue = self.opportunity.toLOBInfo.tmlFleetSize;
    }
    else if ([field.mTitle isEqualToString:FIELD_FINANCIER]) {
        field.mSelectedValue = self.opportunity.toFinancier.financierName;
    }
    else if ([field.mTitle isEqualToString:FIELD_CAMPAIGN]) {
        field.mSelectedValue = self.opportunity.toCampaign.campaignName;
    }
    else if ([field.mTitle isEqualToString:FIELD_INFLUENCER]) {
        field.mSelectedValue = self.opportunity.influencer;
    }
    else if ([field.mTitle isEqualToString:FIELD_TGM]) {
        field.mSelectedValue = self.opportunity.toTGM.accountName;
    }
    else if ([field.mTitle isEqualToString:FIELD_BROKER_NAME]) {
        field.mSelectedValue = self.opportunity.toBroker.accountName;
    }
    else if ([field.mTitle isEqualToString:FIELD_INTERVENTION_SUPPORT]){
       field.mSelectedValue = self.opportunity.toPotentialDropOff.intervention_support;
    }
    else if ([field.mTitle isEqualToString:FIELD_STAKEHOLDER]){
        field.mSelectedValue = self.opportunity.toPotentialDropOff.stakeholder_responsible;
    }
    else if ([field.mTitle isEqualToString:FIELD_STAKEHOLDER_RESPONSE]){
        field.mSelectedValue = self.opportunity.toPotentialDropOff.stakeholder_response;
    }
    else if ([field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
        field.mSelectedValue = self.opportunity.toPotentialDropOff.potential_drop_of_reason;
    }
}

-(void)bindValuesToChassisModel:(NSArray *)chassisDataArray {
    [UtilityMethods hideProgressHUD];
    self.chassisDetails = [[ChassisDetails alloc] init];
    
    NSArray *chassisDataArr = [chassisDataArray objectAtIndex:0];
    self.chassisDetails.tml_src_assset_id   = [chassisDataArr valueForKey:@"ROW_ID"];
    self.chassisDetails.CHASSIS_NUM_s       = [chassisDataArr valueForKey:@"CHASSIS_NUM_s"];
    self.chassisDetails.PPL_s               = [chassisDataArr valueForKey:@"PPL_s"];
    self.chassisDetails.PPL_ID_s            = [chassisDataArr valueForKey:@"PPL_ID_s"];
    self.chassisDetails.VC_ID_s             = [chassisDataArr valueForKey:@"VC_ID_s"];
    self.chassisDetails.CHA_STAT_s          = [chassisDataArr valueForKey:@"CHA_STAT_s"];
    self.chassisDetails.PL_s                = [chassisDataArr valueForKey:@"PL_s"];
    self.chassisDetails.tml_ref_pl_id       = [chassisDataArr valueForKey:@"PL_ID_s"];
    
    [self fillExchangeDetailsTextFiledsInModel];  //to update main model and local model with textfields
}

#pragma mark - Private Methods

- (void)bindTapToView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAutoCompleteTableView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setDelegate:self];
    [view addGestureRecognizer:tapGesture];
}

- (void)fetchFieldsListBasedOnSelectedLOB {
    self.dynamicFieldsArray = [[ValidationUtility sharedInstance] getOptionalFields:self.primaryField];
    
    for (Field *field in self.dynamicFieldsArray) {
        [self bindOpportunityModelDataToField:field];
    }
    
    if ([[ValidationUtility sharedInstance] getConditionalOptionalFields:self.dynamicFieldsArray]) {
        for (Field *field in self.dynamicFieldsArray) {
            [self bindOpportunityModelDataToField:field];
        }
    }
    
    // added newly
    self.stakeFieldsArray = [[ValidationUtility sharedInstance] getStakeHolderFields:self.primaryField];
    //self.stakeFieldsRespoArray = [[ValidationUtility sharedInstance] getStakeHolderFields:self.primaryField];
    
    for (Field *field in self.stakeFieldsArray) {
        [self bindOpportunityModelDataToField:field];
    }
}

- (void)renderFieldsFromList:(NSMutableArray *)fieldsList inView:(UIView *)parentView {
    
    if (parentView == self.containerView) {
        [self addLiveDealViewBelowView:nil];
    }
    
    UIView *fieldsParentView = parentView;
    
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
                    if (parentView == self.containerView) {
                        [currentRowFirstField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.liveDealSectionSeparator withOffset:10.0f];
                    }
                    else if (parentView == self.liveDealFieldsContainer) {
                        [currentRowFirstField autoPinEdgeToSuperviewEdge:ALEdgeTop];
                    }
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
        // Add separator
        if (parentView == self.containerView) {
            [self addSeparatorBelowView:lastRowView belowLiveDealView:false];
        }
      
    }
}

- (SeparatorView *)getSeparatorView {
    SeparatorView *separatorView = [[SeparatorView alloc] init];
    [self.containerView addSubview:separatorView];
    
    // Set Constraints
    [separatorView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [separatorView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [separatorView autoSetDimension:ALDimensionHeight toSize:SEPARATOR_HEIGHT];
    
    return separatorView;
}

- (void)addSeparatorBelowView:(id)view belowLiveDealView:(BOOL)belowLiveDealView {
    
    SeparatorView *separatorView = [self getSeparatorView];
    [separatorView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:20.0f];
    
    // Attach Live Deal View
//    if (!belowLiveDealView) {
//        [self addLiveDealViewBelowView:separatorView];
//    }
   // [self addAccountViewBelow:separatorView];
    //    self.exchangeViewBottomConstraint.constant = EXCHANGE_VIEW_BOTTOM_SPACE_OFF;  //new
    
    [self addStakeholderBelowFieldView:separatorView];
    
    
}

-(void)renderStakeHolderFields:(NSMutableArray *)fieldsList inView:(UIView *)parentView {

    
    UIView *fieldsParentView = parentView;
    
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
                    if (parentView == self.containerView) {
                        [currentRowFirstField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.liveDealSectionSeparator withOffset:10.0f];
                    }
                    else if (parentView == self.stakeHolderView) {
                        [currentRowFirstField autoPinEdgeToSuperviewEdge:ALEdgeTop];
                    }
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
        
//        SeparatorView *separatorView = [self getSeparatorView];
//        [separatorView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastRowView withOffset:20.0f];
//        
//        [self addAccountViewBelow:separatorView];

    }
    
}


- (void)addStakeholderBelowFieldView:(id)view {
    
    self.stakeHolderView = [[UIView alloc] init];
    [self.containerView addSubview:self.stakeHolderView];
  
    // Set Constraints
    [self.stakeHolderView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.stakeHolderView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.stakeHolderView autoSetDimension:ALDimensionHeight toSize:DYNAMIC_CONTACT_ACCOUNT_VIEW_HEIGHT];
    [self.stakeHolderView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10.0f];

    SeparatorView *separatorView = [self getSeparatorView];
    [separatorView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stakeHolderView withOffset:20.0f];
    [self addPotentialButton:view];
//    [self renderStakeHolderFields:self.stakeFieldsArray inView:self.stakeHolderView];
    
    
    [self addAccountViewBelow:separatorView];
    self.topContsraintExchangeVw.constant = 45;
}

-(void)addPotentialButton:(id)view {

    UIView *potentialView = [[UIView alloc] init];
    [self.containerView addSubview:potentialView];
    [potentialView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [potentialView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    if (view) {
        [potentialView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10.0f];
    }
    else {
        [potentialView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    [potentialView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    UIButton *potentialDrop = [UIButton buttonWithType:UIButtonTypeCustom];
    [potentialView addSubview:potentialDrop];
    [potentialDrop autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [potentialDrop autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.0f];
    
    [potentialDrop setTitle:@"Potential Drop Off" forState:UIControlStateNormal];
    [potentialDrop setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
//    potentialDrop.backgroundColor = [UIColor lightGrayColor];
    UIButton *potentialDropPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    [potentialView addSubview:potentialDropPlus];
    [potentialDropPlus autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:potentialDrop withOffset:15];
    [potentialDropPlus autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.0f];
//    [potentialDropPlus autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [potentialDropPlus setImage:[UIImage imageNamed:@"add_btn_icon"] forState:UIControlStateNormal];
    [potentialDropPlus.layer setCornerRadius:5.0];

    [potentialDropPlus addConstraint:[NSLayoutConstraint constraintWithItem:potentialDropPlus
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute: NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:45]];
    
    // Height constraint
    [potentialDropPlus addConstraint:[NSLayoutConstraint constraintWithItem:potentialDropPlus
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute: NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:30]];
    
    [potentialDropPlus addTarget:self action:@selector(potentialDropButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // CenterX constraint
//    [potentialDrop addConstraint:[NSLayoutConstraint constraintWithItem:self.view
//                                                          attribute:NSLayoutAttributeCenterX
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:potentialDropPlus
//                                                          attribute: NSLayoutAttributeCenterX
//                                                         multiplier:1
//                                                           constant:0]];
    potentialDropPlus.backgroundColor = [UIColor themePrimaryColor];
//    [potentialDrop autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:potentialDropPlus withOffset:15];

//    [potentialDrop setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
    
//    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addNewLocation"]];
//    [potentialDrop addSubview : image];
//    [image autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:potentialDrop withOffset:10.0f];
//    [image autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [potentialDrop setTitle:@"Potential Drop Off" forState:UIControlStateNormal];
//
//    [potentialDrop setBackgroundColor:[UIColor whiteColor]];
}
- (void)addLiveDealViewBelowView:(id)view {
    
    // Live Deal View
    self.liveDealView = [[UIView alloc] init];
    [self.containerView addSubview:self.liveDealView];
    
    // Set Constraints
    [self.liveDealView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.liveDealView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    if (view) {
        [self.liveDealView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10.0f];
    }
    else {
        [self.liveDealView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    self.liveDealViewHeightConstraint = [self.liveDealView autoSetDimension:ALDimensionHeight toSize:LIVE_DEAL_VIEW_ON_HEIGHT];
    
    // Live Deal Text Label
    [self.liveDealView addSubview:self.liveDealTextLabel];
    
    [self.liveDealTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.liveDealTextLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
    
    // Switch
    self.liveDealToggleSwitch = [[UISwitch alloc] init];
    [self.liveDealView addSubview:self.liveDealToggleSwitch];
    
    [self.liveDealToggleSwitch autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.liveDealTextLabel withOffset:10.0f];
    [self.liveDealToggleSwitch autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    // Add click to Live Deal switch
    [self.liveDealToggleSwitch addTarget:self action:@selector(liveDealSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    // Fields Container
    self.liveDealFieldsContainer = [[UIView alloc] init];
    [self.liveDealView addSubview:self.liveDealFieldsContainer];
    
    [self.liveDealFieldsContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.liveDealFieldsContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.liveDealToggleSwitch withOffset:5.0f];
    
    // Add Live Deal Fields
    [self addLiveDealFieldsInView:self.liveDealFieldsContainer liveDealView:self.liveDealView];
}

- (void)addLiveDealFieldsInView:(UIView *)fieldsContainerView liveDealView:(UIView *)liveDeal{
    
    // Check added to prevent loss of selected data when live deal view
    // is rerendered
    if (!self.liveDealFieldsArray || [self.liveDealFieldsArray count] == 0) {
        self.liveDealFieldsArray = [[ValidationUtility sharedInstance] getLiveDealFields];
    }
    
    [self bindLiveDealDataFromOpportunityModel];
    
    if (self.liveDealFieldsArray && [self.liveDealFieldsArray count] > 0) {
        [self renderFieldsFromList:self.liveDealFieldsArray inView:fieldsContainerView];
    }
    
    // Set the live deal toggle state
    [self setLiveDealToggleState:liveDealToggleOn];
    
    // Add Separator below live deal view
    self.liveDealSectionSeparator = [self getSeparatorView];
    [self.liveDealSectionSeparator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:liveDeal withOffset:20.0f];
    
    // Add Account View below separator
//    [self addAccountViewBelow:separator];
    
    if (!self.stakeFieldsArray || [self.stakeFieldsArray count] == 0) {
        self.stakeFieldsArray = [[ValidationUtility sharedInstance] getLiveDealFields];
    }
    
    [self bindLiveDealDataFromOpportunityModel];
    
    if (self.liveDealFieldsArray && [self.liveDealFieldsArray count] > 0) {
        [self renderFieldsFromList:self.liveDealFieldsArray inView:fieldsContainerView];
    }
    
    
    // Add Separator below live stake view
    self.liveDealSectionSeparator = [self getSeparatorView];
    [self.liveDealSectionSeparator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:liveDeal withOffset:20.0f];
}

- (void)setLiveDealToggleState:(BOOL)isLiveDeal {
    if (isLiveDeal) {
        [self.liveDealToggleSwitch setOn:true];
    }
    else {
        [self.liveDealToggleSwitch setOn:false];
    }
    [self liveDealSwitchToggled:self.liveDealToggleSwitch];
}

- (void)addAccountViewBelow:(id)view {
   
    if ([[ValidationUtility sharedInstance] isAccountMandatory:self.opportunity.toVCNumber.lob]) {
        isAccountExist = NO;

        self.containerViewHeightConstraint.constant = CONTAINER_VIEW_HEIGHT_WITHOUTACCON;
        return;
    }
    
    self.accountView = [[AccountView alloc] init];
    [self.containerView addSubview:self.accountView];
    
    // Set Constraints
    [self.accountView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.accountView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.accountView autoSetDimension:ALDimensionHeight toSize:DYNAMIC_CONTACT_ACCOUNT_VIEW_HEIGHT];
    [self.accountView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view];
    self.accountView.accountNumberTextField.delegate = self;
    self.accountView.accountNumberTextField.keyboardType = UIKeyboardTypeDefault;
    self.accountView.accountNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self.accountView.addAccountButton setImageEdgeInsets:UIEdgeInsetsZero];
    [self.accountView.searchAccountButton setImageEdgeInsets:UIEdgeInsetsZero];
//    if (self.entryPoint == InvokeForUpdateOpportunity) {
//        self.accountView.accountNumberTextField.enabled = false;
//        //        self.accountView.accountNameTextField.backgroundColor = [UIColor lightGrayColor];
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

- (void)addSearchAccountButtonClicked:(id)sender {
    if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
        [self navigateToContactSearchForGivenNumber:self.accountView.accountNumberTextField.text withtype:ACCOUNTSEARCH_FROM_OPPORTUNITY];
        
        self.entryPoint=InvokeForCreateOpportunity;
        
    } else {
        [UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
        }];
    }
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
        
        if ([create_type isEqualToString:CONTACTSEARCH_FROM_OPPORTUNITY]) {
            searchBy_Value.radioButtonSelected = radioCantactButton;
        }
        else{
            searchBy_Value.radioButtonSelected = radioAccountButton;
            
        }
        searchResultCVObj.searchByValue = searchBy_Value;
        if (self.entryPoint == InvokeFromProductApp) {
            
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
        
        case SingleLongSelectList:
            generatedField = [self createLongTextFieldViewWithValues:field];
            break;

        default:
            generatedField = [self createTextFieldViewWithValues:field];
            break;
    }
    
    return generatedField;
}

- (COTextFieldView *)createLongTextFieldViewWithValues:(Field *)field {
    
    COTextFieldView *textView = [[COTextFieldView alloc] init];
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width*2, textView.frame.size.height)];
    [textView.fieldNameLabel setText:field.mDisplayTitle];
    [textView setField:field];
    [textView.textField setPlaceholder:field.mDisplayTitle];
    [textView.textField setText:field.mSelectedValue];
    [textView.textField setField:field];
    [textView.textField setDelegate:self];
    if ([field.mTitle isEqualToString:FIELD_MODEL] || [field.mTitle isEqualToString:FIELD_DETAILED_REMARK] || [field.mTitle isEqualToString:FIELD_INTERVENTION_SUPPORT]) {
        [textView.textField setKeyboardType:UIKeyboardTypeDefault];
    }
    else {
        [textView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    if ([self isFieldMandatory:field]) {
        [self makeMandatoryFieldRed:textView.textField];
    }
    
    return textView;
}

- (COTextFieldView *)createTextFieldViewWithValues:(Field *)field {
    
    COTextFieldView *textView = [[COTextFieldView alloc] init];
    [textView.fieldNameLabel setText:field.mDisplayTitle];
    [textView setField:field];
    [textView.textField setPlaceholder:field.mDisplayTitle];
    [textView.textField setText:field.mSelectedValue];
    [textView.textField setField:field];
    [textView.textField setDelegate:self];
    if ([field.mTitle isEqualToString:FIELD_MODEL] || [field.mTitle isEqualToString:FIELD_DETAILED_REMARK] || [field.mTitle isEqualToString:FIELD_INTERVENTION_SUPPORT]) {
        [textView.textField setKeyboardType:UIKeyboardTypeDefault];
    }
    else {
        [textView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    if ([self isFieldMandatory:field]) {
        [self makeMandatoryFieldRed:textView.textField];
    }
    
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
    [autoCompleteTextFieldView.textField setAutocompleteTableRowSelectedDelegate:self];
    [autoCompleteTextFieldView.textField setEnabled:false];
    [self addTapGestureToView:autoCompleteTextFieldView];
    
    if ([self isFieldMandatory:field]) {
        [self makeMandatoryFieldRed:autoCompleteTextFieldView.textField];
    }
    
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
    
    if ([self isFieldMandatory:field]) {
        [self makeMandatoryFieldRed:dropDownView.textField];
    }
    
    return dropDownView;
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
    
    if ([self isFieldMandatory:field]) {
        [self makeMandatoryFieldRed:textView.textField];
    }
    
    return textView;
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

- (void)showPopOver:(UITextField *)textField {
    [self.view endEditing:true];
    
    GreyBorderUITextField *mTextField = (GreyBorderUITextField *)textField;
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:mTextField.field.mValues andModelData:mTextField.field.mDataList forView:textField withDelegate:self];
}

- (void)reloadDynamicFieldsView {
    [self.containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self renderFieldsFromList:self.dynamicFieldsArray inView:self.containerView];
}

- (void)reloadLiveDealFieldsView {
    [self.liveDealFieldsContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self renderFieldsFromList:self.liveDealFieldsArray inView:self.liveDealFieldsContainer];
}

- (void)makeAPICallToFetchDataForField:(DropDownTextField *)textField {
    
    if ([textField.field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
        [self getMMGeography:(AutoCompleteUITextField *)textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
        [self getBodyType:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
        [self getUsageCategory:textField forLOB:self.opportunity.toVCNumber.lob];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_FINANCIER]) {
        [self getFinancierList:(AutoCompleteUITextField *)textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_CAMPAIGN]) {
        [self getCampaignList:textField forPL:self.opportunity.toVCNumber.pl];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_INFLUENCER]) {
        [self getInfluencersList:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_COMPETITOR]) {
        [self getCompetitorList:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_PRODUCT_CATEGORY]) {
        [self getProductCategoryList:textField];
    }
    else if ([textField.field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
        //[self getReferralType:textField];
        
        textField.field.mValues = [[NSMutableArray alloc] initWithObjects:@"Customer ineligible for finance",
                                   @"Discount",
                                   @"Delivery TAT",
                                   @"Delay in tender",
                                   @"Financing issue",
                                   @"Invalid entry",
                                   //@"Lost deal",
                                   @"Mileage concern",
                                   @"Ongoing negotiations",
                                   @"Product acceptance",
                                   @"Resale value",
                                   @"Requirement dropped",
                                   @"Service-related issues",
                                   @"Vehicle performance issue",
                                   @"Vehicle stock not available", nil];
        
        textField.field.mDataList = [[NSMutableArray alloc] initWithObjects:@"Customer ineligible for finance",
                                   @"Discount",
                                   @"Delivery TAT",
                                   @"Delay in tender",
                                   @"Financing issue",
                                   @"Invalid entry",
                                   //@"Lost deal",
                                   @"Mileage concern",
                                   @"Ongoing negotiations",
                                   @"Product acceptance",
                                   @"Resale value",
                                   @"Requirement dropped",
                                   @"Service-related issues",
                                   @"Vehicle performance issue",
                                   @"Vehicle stock not available", nil];

        [self showPopOver:(DropDownTextField *)textField];
    }
}

- (BOOL)validateLiveDealFields {
    if (![self.liveDealToggleSwitch isOn]) {
        return true;
    }
    
    BOOL isValid = true;
    for (Field *currentField in self.liveDealFieldsArray) {
        if (![currentField.mSelectedValue hasValue]) {
            [self showValidationErrorMessage:currentField.mErrorMessage];
            isValid = false;
            break;
        }
    }
    return isValid;
}

- (BOOL)validateMandatoryFields {
    BOOL isValid = true;
    for (Field *currentField in self.dynamicFieldsArray) {
        if ([currentField.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE] ||
            [currentField.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            NSString *errorMessage = [[ValidationUtility sharedInstance] validateFieldValue:currentField inList:self.dynamicFieldsArray];
            if (errorMessage) {
                [self showValidationErrorMessage:errorMessage];
                isValid = false;
                break;
            }
        }
        
        if ([currentField.mTitle isEqualToString:FIELD_BROKER_NAME]) {
            if (!self.opportunity.toBroker || ![self.opportunity.toBroker.accountID hasValue]) {
                [self showValidationErrorMessage:currentField.mErrorMessage];
                isValid = false;
                break;
            }
        }
        
        if ([currentField.mTitle isEqualToString:FIELD_TGM]) {
            if (!self.opportunity.toTGM || ![self.opportunity.toTGM.accountID hasValue]) {
                [self showValidationErrorMessage:currentField.mErrorMessage];
                isValid = false;
                break;
            }
        }
    }
    return isValid;
}

- (BOOL)validateExchangeMandatoryFields {
    BOOL isValid = true;
//    for (Field *currentField in self.dynamicFieldsArray) {
//        if ([currentField.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE] ||
//            [currentField.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
//            NSString *errorMessage = [[ValidationUtility sharedInstance] validateFieldValue:currentField inList:self.dynamicFieldsArray];
//            if (errorMessage) {
//                [self showValidationErrorMessage:errorMessage];
//                isValid = false;
//                break;
//            }
//        }
//        
//    }
    return isValid;
}

- (BOOL)validateInfluencerDependentFields {
    BOOL isValid = true;
    
    
    return isValid;
}

- (void)showValidationErrorMessage:(NSString *)message {
    if ([message hasValue]) {
        [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
            
        }];
    }
}

- (void)bindValuesToOpportunityModel {
    
    // Dynamic Optional Fields
    for (Field *field in self.dynamicFieldsArray) {
        if ([field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
            self.opportunity.toLOBInfo.mmGeography = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_BODY_TYPE]) {
            self.opportunity.toLOBInfo.bodyType = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_USAGE_CATEGORY]) {
            self.opportunity.toLOBInfo.usageCategory = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE]) {
            self.opportunity.toLOBInfo.totalFleetSize = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            self.opportunity.toLOBInfo.tmlFleetSize = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_FINANCIER]) {
            self.opportunity.toFinancier.financierName = field.mSelectedValue;
            EGFinancier *mSelectedFinancierModel = [self getFinancierObjectForFinancierName:field.mSelectedValue];
            if (mSelectedFinancierModel) {
                self.opportunity.toFinancier.financierID = [mSelectedFinancierModel financierID];
            }
        }
        else if ([field.mTitle isEqualToString:FIELD_CAMPAIGN]) {
            self.opportunity.toCampaign.campaignName = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_INFLUENCER]) {
            self.opportunity.influencer = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_TGM]) {
            self.opportunity.toTGM.accountName = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_BROKER_NAME]) {
            self.opportunity.toBroker.accountName = field.mSelectedValue;
        }
    }
    
    for (Field *field in self.stakeFieldsArray) {

        self.opportunity.toPotentialDropOff.app_name = GTME_APP;

        if ([field.mTitle isEqualToString:FIELD_INTERVENTION_SUPPORT]) {
            self.opportunity.toPotentialDropOff.intervention_support = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_STAKEHOLDER]) {
            self.opportunity.toPotentialDropOff.stakeholder_responsible = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_STAKEHOLDER_RESPONSE]) {
            self.opportunity.toPotentialDropOff.stakeholder_response = field.mSelectedValue;
        }
        else if ([field.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
            self.opportunity.toPotentialDropOff.potential_drop_of_reason = field.mSelectedValue;
        }
    }
    
    if ([self.liveDealToggleSwitch isOn]) {
        self.opportunity.isLiveDeal = true;
        self.opportunity.liveDeal = LIVE_DEAL_YES;
        // Live Deal Fields
        for (Field *field in self.liveDealFieldsArray) {
            if ([field.mTitle isEqualToString:FIELD_COMPETITOR]) {
                self.opportunity.competitor = field.mSelectedValue;
            }
            else if ([field.mTitle isEqualToString:FIELD_PRODUCT_CATEGORY]) {
                self.opportunity.productCatagory = field.mSelectedValue;
            }
            else if ([field.mTitle isEqualToString:FIELD_MODEL]) {
                self.opportunity.competitorModel = field.mSelectedValue;
            }
            else if ([field.mTitle isEqualToString:FIELD_DETAILED_REMARK]) {
                self.opportunity.competitorRemark = field.mSelectedValue;
            }
        }
    }
    else {
        self.opportunity.isLiveDeal = false;
        self.opportunity.liveDeal = LIVE_DEAL_NO;
        // Live Deal Fields
        for (Field *field in self.liveDealFieldsArray) {
            if ([field.mTitle isEqualToString:FIELD_COMPETITOR]) {
                self.opportunity.competitor = @"";
            }
            else if ([field.mTitle isEqualToString:FIELD_PRODUCT_CATEGORY]) {
                self.opportunity.productCatagory = @"";
            }
            else if ([field.mTitle isEqualToString:FIELD_MODEL]) {
                self.opportunity.competitorModel = @"";
            }
            else if ([field.mTitle isEqualToString:FIELD_DETAILED_REMARK]) {
                self.opportunity.competitorRemark = @"";
            }
        }
    }
    
    if ([self.switchButton isOn]) {
//        self.exchangeDetailsModel = [[ExchangeDetails alloc] init];
        self.opportunity.toExchange = [[ExchangeDetails alloc] init];
        self.opportunity.toExchange.ppl_for_exchange       = self.brandDropdownField.text != nil ? self.brandDropdownField.text: @"";
        self.opportunity.toExchange.pl_for_exchange        = self.plDropdownField.text != nil ?self.plDropdownField.text : @"";
        self.opportunity.toExchange.registration_no        = self.registrationTextField.text != nil ? self.registrationTextField.text: @"";
        self.opportunity.toExchange.milage                 = self.mileageDropdownField.text != nil ? self.mileageDropdownField.text: @"";
        self.opportunity.toExchange.age_of_vehicle         = self.ageofVehicleDropDownfield.text != nil ?self.ageofVehicleDropDownfield.text : @"";
        self.opportunity.toExchange.tml_src_chassisnumber  = self.chasisNoTextfield.text != nil ? self.chasisNoTextfield.text: @"";
        self.opportunity.toExchange.tml_src_assset_id      = self.chassisDetails.tml_src_assset_id != nil ? self.chassisDetails.tml_src_assset_id: @"";
        self.opportunity.toExchange.tml_ref_pl_id          = self.chassisDetails.tml_ref_pl_id != nil ? self.chassisDetails.tml_ref_pl_id: @"";
        self.opportunity.toExchange.interested_in_exchange = @"Y";

    }
    else {
        self.opportunity.toExchange                        = [[ExchangeDetails alloc] init];
        self.opportunity.toExchange.ppl_for_exchange       = @"";
        self.opportunity.toExchange.pl_for_exchange        = @"";
        self.opportunity.toExchange.registration_no        = @"";
        self.opportunity.toExchange.milage                 = @"";
        self.opportunity.toExchange.age_of_vehicle         = @"";
        self.opportunity.toExchange.tml_src_chassisnumber  = @"";
        self.opportunity.toExchange.tml_src_assset_id      = @"";
        self.opportunity.toExchange.tml_ref_pl_id          = @"";
        self.opportunity.toExchange.interested_in_exchange = @"N";
    }

}

- (void)bindComponentModel:(id)selectedModel selectedValue:(NSString *)selectedValue toOpportunityForField:(Field *)selectedField {
    if ([selectedField.mTitle isEqualToString:FIELD_CAMPAIGN]) {
        EGCampaign *selectedCampaign = (EGCampaign *)selectedModel;
        self.opportunity.toCampaign = selectedCampaign;
    } else if ([selectedField.mTitle isEqualToString:FIELD_POTENTIAL_DROP_OFF]) {
        self.opportunity.toPotentialDropOff.potential_drop_of_reason = selectedModel;
    } 
}

- (BOOL)isFieldMandatory:(Field *)field {
    BOOL isMandatory = false;
    
    if ([field.mTitle isEqualToString:FIELD_COMPETITOR]) {
        isMandatory = true;
    }
    else if ([field.mTitle isEqualToString:FIELD_PRODUCT_CATEGORY]) {
        isMandatory = true;
    }
    else if ([field.mTitle isEqualToString:FIELD_MODEL]) {
        isMandatory = true;
    }
    else if ([field.mTitle isEqualToString:FIELD_DETAILED_REMARK]) {
        isMandatory = true;
    }
    else if ([field.mTitle isEqualToString:FIELD_BROKER_NAME]) {
        isMandatory = true;
    }
    else if ([field.mTitle isEqualToString:FIELD_TGM]) {
        isMandatory = true;
    }
    
    return isMandatory;
}

- (void)makeMandatoryFieldRed:(UITextField *)textField {
    
    [textField.layer setBorderColor:[UIColor mandatoryFieldRedBorderColor].CGColor];
}
//ExchangeDetails Mandatory Fields
- (void)markMandatoryExchangeDetailFields {
    [UtilityMethods setRedBoxBorder:self.brandDropdownField];
    [UtilityMethods setRedBoxBorder:self.plDropdownField];
    [UtilityMethods setRedBoxBorder:self.registrationTextField];
    [UtilityMethods setRedBoxBorder:self.mileageDropdownField];
    [UtilityMethods setRedBoxBorder:self.ageofVehicleDropDownfield];
    [UtilityMethods setRedBoxBorder:self.chasisNoTextfield];
}
////ExchangeDetails Mandatory Fields
- (BOOL)checkIfMandatoryExchangeDetailFields {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.brandDropdownField.text hasValue] &&
        [self.plDropdownField.text hasValue] &&
        [self.registrationTextField.text hasValue] &&
        [self.mileageDropdownField.text hasValue] &&
        [self.ageofVehicleDropDownfield.text hasValue] &&
        [self.chasisNoTextfield.text hasValue])
    {
            mandatoryFieldsFilled = true;
    }
    return mandatoryFieldsFilled;
}


- (void)showAutoCompleteTableForField:(AutoCompleteUITextField *)autoCompleteTextField {
    if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
        [self.mmGeographyTextField loadTableViewForTextFiled:[UtilityMethods getFrameForDynamicField:autoCompleteTextField] onView:self.containerView withArray:autoCompleteTextField.field.mValues];
    }
    else if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_FINANCIER]) {
        [self.financierTextField loadTableViewForTextFiled:[UtilityMethods getFrameForDynamicField:autoCompleteTextField] onView:self.containerView withArray:autoCompleteTextField.field.mValues];
    }
}

- (void)checkValueSelectedForInfluencer:(NSString *)influencerType {
   
    if ([influencerType isEqualToString:VALUE_BROKER]) {
        self.opportunity.toTGM = nil;
        brokerSelected = YES;
    }
    else if ([influencerType isEqualToString:VALUE_TGM]) {
        self.opportunity.toBroker = nil;
    }
    else {
        self.opportunity.toTGM = nil;
        self.opportunity.toBroker = nil;
    }
}

#pragma mark - UITextFieldDelegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    GreyBorderUITextField *autoCompleteTextField = (GreyBorderUITextField *)textField;
    
    if ([autoCompleteTextField.field.mDisplayTitle isEqualToString:@"Stakeholder"]) {
        return NO;
    }
    if ([autoCompleteTextField.field.mDisplayTitle isEqualToString:@"Stakeholder Response"]) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    GreyBorderUITextField *autoCompleteTextField = (GreyBorderUITextField *)textField;
    
    if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
        [self validateMandatoryFields];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        
        AutoCompleteUITextField *autoCompleteTextField = (AutoCompleteUITextField *)textField;
        
        if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_MM_GEOGRAPHY]) {
            self.mmGeographyTextField = autoCompleteTextField;
            if (!self.mmGeographyTextField.field.mValues || [self.mmGeographyTextField.field.mValues count] == 0) {
                [self.mmGeographyTextField resignFirstResponder];
                [self getMMGeography:autoCompleteTextField forLOB:self.opportunity.toVCNumber.lob];
            }
            else {
                [self showAutoCompleteTableForField:self.mmGeographyTextField];
            }
        }
        else if ([autoCompleteTextField.field.mTitle isEqualToString:FIELD_FINANCIER]) {
            self.financierTextField = autoCompleteTextField;
            if (!self.financierTextField.field.mValues || [self.financierTextField.field.mValues count] == 0) {
                [self.financierTextField resignFirstResponder];
                [self getFinancierList:autoCompleteTextField];
            }
            else {
                [self showAutoCompleteTableForField:self.financierTextField];
            }
        }
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
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
        mTextField.field.mSelectedValue = currentString;
        
        // Total Fleet Size and TML Fleet Size Field Validation
        if ([mTextField.field.mTitle isEqualToString:FIELD_TOTAL_FLEET_SIZE] ||
            [mTextField.field.mTitle isEqualToString:FIELD_TML_FLEET_SIZE]) {
            if (length > 10) {
                mTextField.field.mSelectedValue = textField.text;
                return NO;
            }
            return [UtilityMethods isCharacterSetOnlyNumber:string];
        }
        if ([mTextField.field.mTitle isEqualToString:FIELD_INTERVENTION_SUPPORT]) {
            mTextField.field.mSelectedValue = textField.text;
            return [UtilityMethods isCharacterSetOnlyAlphaNumeric:string] || [string isEqualToString:@" "];
        }
//        if ([mTextField.field.mTitle isEqualToString:FIELD_STAKEHOLDER]) {
//            mTextField.field.mSelectedValue = textField.text;
//            return NO;
//        }
//        if ([mTextField.field.mTitle isEqualToString:FIELD_STAKEHOLDER_RESPONSE]) {
//            mTextField.field.mSelectedValue = textField.text;
//            return NO;
//        }
    }
    else if ([textField isKindOfClass:[AutoCompleteUITextField class]]) {
        AutoCompleteUITextField *autocompleteTextField = (AutoCompleteUITextField *)textField;
        [autocompleteTextField reloadDropdownList_ForString:currentString];
       
        if (textField == _registrationTextField) {
            const char * _char = [textField.text cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            
            if (range.length==1 && string.length==0){
//                NSLog(@"backspace tapped");
                self.chasisNoTextfield.text  = @"";
                self.brandDropdownField.text = @"";
                self.plDropdownField.text    = @"";
            }
        }

    }
    
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog( @"text changed: %@",textField.text);
   
    if (textField == _registrationTextField) {
        [self getRegistrationDetail];
    }

    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog( @"text changed: %@",textField.text);
//    [self ProdcutDirectSetToCartAPICall];
//    return YES;
//}

#pragma mark - DropDownViewControllerDelegate Method

//- (void)didSelectValueFromDropDown:(NSString *)selectedValue forField:(id)dropDownForView {
//    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
//        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
//        textField.text = selectedValue;
//        textField.field.mSelectedValue = selectedValue;
//
//        // Reset Sucessor value if predecessor value changed
//        if ([textField.field.mSuccessors count] > 0) {
//            Field *sucessor = [textField.field.mSuccessors objectAtIndex:0];
//            sucessor.mSelectedValue = @"";
//            if ([[textField superview] superview] == self.liveDealFieldsContainer) {
//                [self reloadLiveDealFieldsView];
//            }
//            else {
//                [self reloadDynamicFieldsView];
//            }
//        }
//        
//        // Below code should not execute for live deal fields
//        if ([[textField superview] superview] != self.liveDealFieldsContainer) {
//            if ([[ValidationUtility sharedInstance] getConditionalOptionalFields:self.dynamicFieldsArray]) {
//                [self reloadDynamicFieldsView];
//            }
//        }
//        
//        // Campaign
//        if ([textField.field.mTitle isEqualToString:FIELD_CAMPAIGN]) {
//            // Bind Campaign data 
//        }
//    }
//}

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        
        // Reset Sucessor value if predecessor value changed
        if ([textField.field.mSuccessors count] > 0) {
            Field *sucessor = [textField.field.mSuccessors objectAtIndex:0];
            sucessor.mSelectedValue = @"";
            if ([[textField superview] superview] == self.liveDealFieldsContainer) {
                [self reloadLiveDealFieldsView];
            }
            else {
                [self reloadDynamicFieldsView];
            }
        }
        //to cear plExchnage textfield
        if (textField == self.brandDropdownField) {
            _plDropdownField.text = @"";
        }
        
        // Below code should not execute for live deal fields
        if ([[textField superview] superview] != self.liveDealFieldsContainer) {
            if ([[ValidationUtility sharedInstance] getConditionalOptionalFields:self.dynamicFieldsArray]) {
                [self reloadDynamicFieldsView];
            }
        }
        
        // Check for Influencer as Broker or TGM
        if ([textField.field.mTitle isEqualToString:FIELD_INFLUENCER]) {
            [self checkValueSelectedForInfluencer:textField.field.mSelectedValue];
        }
        
        [self bindComponentModel:selectedObject selectedValue:(NSString *)selectedValue toOpportunityForField:textField.field];
        
        if (textField == self.mileageDropdownField) {
            self.opportunity.toExchange.milage = self.mileageDropdownField.text;
            self.opportunity.milage = self.mileageDropdownField.text;
       
        }
        else if (textField == self.ageofVehicleDropDownfield) {
                self.opportunity.toExchange.age_of_vehicle = self.ageofVehicleDropDownfield.text;
                self.opportunity.age_of_vehicle = self.ageofVehicleDropDownfield.text;
        }
    }
}

#pragma mark - ProspectViewControllerDelegate Methods

- (void)accountCreationSuccessfull:(EGAccount *)account fromView:(SearchResultFromPage)searchResultFromPaget {
    EGAccount *createdAccount;
    if (searchResultFromPaget == SearchResultFrom_ManageOpportunity || searchResultFromPaget == SearchResultFrom_Prospect) {
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
    }
}
#pragma mark - SearchResultViewControllerDelegate Methods

- (void)didSelectResultFromSearchResultController:(id)selectedObject {
    
    if ([selectedObject isKindOfClass:[EGBroker class]] && self.brokerTextField) {
        EGBroker *brokerDetail = (EGBroker *)selectedObject;
        [self.brokerTextField setText:brokerDetail.accountName];
        self.brokerTextField.field.mSelectedValue = brokerDetail.accountName;
        self.opportunity.toBroker = brokerDetail;
    }
    else if ([selectedObject isKindOfClass:[EGTGM class]] && self.tgmTextField) {
        EGTGM *tgm = (EGTGM *)selectedObject;
        [self.tgmTextField setText:tgm.accountName];
        self.tgmTextField.field.mSelectedValue = tgm.accountName;
        self.opportunity.toTGM = tgm;
    }
}

#pragma mark - AutoCompleteUITextFieldDelegate Methods

- (void)selectedActionSender:(id)sender {
    NSLog(@"%@:",sender);
    [self.view endEditing:true];
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
    }
    else if (self.financierTextField && [self.financierTextField.resultTableView isDescendantOfView:self.containerView]) {
        [self.financierTextField.resultTableView removeFromSuperview];
    }
}
- (void)potentialDropButtonClicked:(id)sender {
    UIStoryboard *prospectStoryBoard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:[NSBundle mainBundle]];
    PotentialDropOffViewController *prospectViewController = [prospectStoryBoard instantiateViewControllerWithIdentifier:@"PotentialDropOffViewController"];
    prospectViewController.opportunity = self.opportunity;
    [self.navigationController pushViewController:prospectViewController animated:true];
}

- (void)liveDealSwitchToggled:(UISwitch *)sender {
    if (sender.isOn) {
        liveDealToggleOn = true;
        [self showLiveDealView];
    }
    else {
        liveDealToggleOn = false;
        [self hideLiveDealView];
    }
}

- (void)addAccountButtonClicked:(id)sender {
    
    UIStoryboard *prospectStoryBoard = [UIStoryboard storyboardWithName:@"CreateNewProspect" bundle:[NSBundle mainBundle]];
    ProspectViewController *prospectViewController = [prospectStoryBoard instantiateViewControllerWithIdentifier:@"Create New Prospect_View"];
    prospectViewController.detailsObj = PROSPECT_ACCOUNT;
    if (self.entryPoint == InvokeForUpdateOpportunity) {
        prospectViewController.invokedFrom = UpdateOpportunity;
    }
    else{
        prospectViewController.invokedFrom = CreateOpportunity;
    }
    prospectViewController.delegate = self;
    if (!self.opportunity.toAccount) {
        EGAccount *account = [[EGAccount alloc] init];
        self.opportunity.toAccount = account;
    }
    prospectViewController.opportunityAccount = self.opportunity.toAccount;
    [self.navigationController pushViewController:prospectViewController animated:true];
}


- (void)hideLiveDealView {
    
    if(!isAccountExist) {
        self.containerViewHeightConstraint.constant = CONTAINER_VIEW_HEIGHT_WITHOUTACCOFF; //for Main Container view Height
        self.exchangeViewBottomConstraint.constant  = EXCHANGE_VIEW_BOTTOM_SPACE_OFF;
        self.liveDealViewHeightConstraint.constant  = LIVE_DEAL_VIEW_OFF_HEIGHT;
        [self.liveDealFieldsContainer setHidden:true];
    }
    else {
        self.containerViewHeightConstraint.constant = CONTAINER_VIEW_HEIGHT_OFF; //for Main Container view Height
        self.exchangeViewBottomConstraint.constant  = EXCHANGE_VIEW_BOTTOM_SPACE_OFF;
        self.liveDealViewHeightConstraint.constant  = LIVE_DEAL_VIEW_OFF_HEIGHT;
        [self.liveDealFieldsContainer setHidden:true];
    }
  
}

- (void)showLiveDealView {
    
    if(!isAccountExist) {
        self.containerViewHeightConstraint.constant = CONTAINER_VIEW_HEIGHT_WITHOUTACCON; //for Main Container view Height
        self.exchangeViewBottomConstraint.constant  = EXCHANGE_VIEW_BOTTOM_SPACE_ON;  //for exchange view spacing
        self.liveDealViewHeightConstraint.constant  = LIVE_DEAL_VIEW_ON_HEIGHT;
        [self.liveDealFieldsContainer setHidden:false];
    }
    else {
        self.containerViewHeightConstraint.constant = CONTAINER_VIEW_HEIGHT_ON;  //for Main Container view Height
        self.exchangeViewBottomConstraint.constant  = EXCHANGE_VIEW_BOTTOM_SPACE_ON;  //for exchange view spacing
        self.liveDealViewHeightConstraint.constant  = LIVE_DEAL_VIEW_ON_HEIGHT;
        [self.liveDealFieldsContainer setHidden:false];
    }
}

#pragma mark- ButtonEvents
- (IBAction)submitButtonClicked:(id)sender {
    
    if ([self validateMandatoryFields]) {
        if ([self validateLiveDealFields]) {
            [self bindValuesToOpportunityModel];
           
            if ([_switchButton isOn]) {
                if ([self checkIfMandatoryExchangeDetailFields]) {
                    [self callUpdateOpportunityAPI];
                } else{
                    [UtilityMethods alert_ShowMessage:@"Please fill Exchange Details Fields" withTitle:APP_NAME andOKAction:^{
                    }];
                }
            } else{
                [self callUpdateOpportunityAPI];
            }
            
        }
    }
}


- (IBAction)financierButtonClicked:(id)sender {
    [UtilityMethods showProgressHUD:YES];
    NSDictionary *queryParams = @{@"sales_stage_name" : @[@"C1 (Quote Tendered)"],
                                  @"is_quote_submitted_to_financier" : @(_opportunity.is_quote_submitted_to_financier),
                                  @"opty_id": _opportunity.optyID,
                                  @"search_status" : [NSNumber numberWithInt:1]//TODO:remove hardcore
                                  };
    [self searchFinancierOptyWithParam:queryParams];
}

- (IBAction)switchButtonClicked:(id)sender {
    
    if ([sender isOn]) {
        self.opportunity.interested_in_exchange = @"Y";
        [self hideOrShowExchangeView:NO];
    } else {
        self.opportunity.interested_in_exchange = @"N";
        [self hideOrShowExchangeView:YES];
    }
    
}

-(void)hideOrShowExchangeView:(BOOL)hideView{
    
    if (hideView) {
        [_switchButton setOn:NO];
        [self clearAllModelDataInExchangeView];     //new function to clear all model data
        self.exchangeVw.hidden = hideView;
    }else{
        [_switchButton setOn:YES];
        self.exchangeVw.hidden = hideView;
        [self fillExchangeDetailsTextFiledsInModel];
    }
}

//first time use
-(void)fillExchangeDetailsTextFieldsFromModel {
//    self.brandDropdownField.text            = self.opportunity.toExchange.ppl_for_exchange;
//    self.plDropdownField.text               = self.opportunity.toExchange.pl_for_exchange;
//    self.registrationTextField.text         = self.opportunity.toExchange.registration_no;
//    self.mileageDropdownField.text          = self.opportunity.toExchange.milage;
//    self.ageofVehicleDropDownfield.text     = self.opportunity.toExchange.age_of_vehicle;
//    self.chasisNoTextfield.text             = self.opportunity.toExchange.tml_src_chassisnumber;
//    self.opportunity.tml_src_assset_id      = self.opportunity.toExchange.tml_src_assset_id;
//    self.opportunity.tml_ref_pl_id          = self.opportunity.toExchange.tml_ref_pl_id;
//    self.opportunity.interested_in_exchange = self.opportunity.toExchange.interested_in_exchange;

    self.brandDropdownField.text            = self.opportunity.ppl_for_exchange;
    self.plDropdownField.text               = self.opportunity.pl_for_exchange;
    self.registrationTextField.text         = self.opportunity.registration_no;
    self.mileageDropdownField.text          = self.opportunity.milage;
    self.ageofVehicleDropDownfield.text     = self.opportunity.age_of_vehicle;
    self.chasisNoTextfield.text             = self.opportunity.tml_src_chassisnumber;
    self.opportunity.tml_src_assset_id      = self.opportunity.tml_src_assset_id;
    self.opportunity.tml_ref_pl_id          = self.opportunity.tml_ref_pl_id;
    self.opportunity.interested_in_exchange = self.opportunity.interested_in_exchange;
}
//this function will be call when on switch
-(void)fillExchangeDetailsTextFiledsInModel {
    self.opportunity.toExchange.ppl_for_exchange       = self.brandDropdownField.text;
    self.opportunity.toExchange.pl_for_exchange        = self.plDropdownField.text;
    self.opportunity.toExchange.registration_no        = self.registrationTextField.text;
    self.opportunity.toExchange.milage                 = self.mileageDropdownField.text;
    self.opportunity.toExchange.age_of_vehicle         = self.ageofVehicleDropDownfield.text;
    self.opportunity.toExchange.tml_src_chassisnumber  = self.chasisNoTextfield.text;
    self.opportunity.toExchange.tml_src_assset_id      = self.opportunity.tml_src_assset_id;
    self.opportunity.toExchange.tml_ref_pl_id          = self.opportunity.tml_ref_pl_id;
    self.opportunity.toExchange.interested_in_exchange = self.opportunity.interested_in_exchange;
    
    //for maintaning state always
    self.opportunity.ppl_for_exchange = self.brandDropdownField.text;
    self.opportunity.pl_for_exchange =self.plDropdownField.text;
    self.opportunity.registration_no = self.registrationTextField.text;
    self.opportunity.milage = self.mileageDropdownField.text;
    self.opportunity.age_of_vehicle= self.ageofVehicleDropDownfield.text;
    self.opportunity.tml_src_chassisnumber= self.chasisNoTextfield.text;
    self.opportunity.tml_src_assset_id=self.opportunity.tml_src_assset_id;
    self.opportunity.tml_ref_pl_id=self.opportunity.tml_ref_pl_id;
    self.opportunity.interested_in_exchange=self.opportunity.interested_in_exchange;
}

/* to clear all fields in exchange details when toggle button off */
-(void)clearAllModelDataInExchangeView
{
    self.opportunity.toExchange.ppl_for_exchange       = @"";
    self.opportunity.toExchange.pl_for_exchange        = @"";
    self.opportunity.toExchange.registration_no        = @"";
    self.opportunity.toExchange.milage                 = @"";
    self.opportunity.toExchange.age_of_vehicle         = @"";
    self.opportunity.toExchange.tml_src_chassisnumber  = @"";
    self.opportunity.toExchange.tml_src_assset_id      = @"";
    self.opportunity.toExchange.tml_ref_pl_id          = @"";
    self.opportunity.toExchange.interested_in_exchange = @"";

//    self.opportunity.pl_for_exchange        = @"";
//    self.opportunity.registration_no        = @"";
//    self.opportunity.milage                 = @"";
//    self.opportunity.age_of_vehicle         = @"";
//    self.opportunity.tml_src_chassisnumber  = @"";
//    self.opportunity.tml_src_assset_id      = @"";
//    self.opportunity.tml_ref_pl_id          = @"";
//    self.opportunity.interested_in_exchange = @"";
}

#pragma mark - Api Calls
-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
    
    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination *oportunity){
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self financierOptySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [self financierOpptySearcheFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)financierOpptySearcheFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods hideProgressHUD];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"Pending Financier button clicked";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}

-(void)financierOptySearchedSuccessfully:(EGPagination *)paginationObj{
    [UtilityMethods hideProgressHUD];
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    
    if ([opportunityPagedArray count] == 0) {
        NSLog(@"opty of Financier search is:%@", opportunityPagedArray);
        //        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:@"Data Not Found"] withTitle:APP_NAME andOKAction:^{
        //        } andReportIssueAction:^{
        //        }];
        
    }else{
        if(nil != opportunityPagedArray) {

            self.financierOpportunity = [opportunityPagedArray objectAtIndex:0];
            if (!financierOpportunity.isQuoteSubmittedToFinancier) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                [self.navigationController pushViewController:_financierRequestVc animated:YES];
            } else {
                
                if (!financierOpportunity.is_eligible_for_insert_quote) {
                    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                    vc.opportunity = self.opportunity;
                    [self.navigationController pushViewController:vc animated:YES] ;
               
                } else {
                    if (financierOpportunity.isAnyCaseApproved) {
                        FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                        vc.opportunity = self.opportunity;
                        [self.navigationController pushViewController:vc animated:YES] ;
                        
                    } else {
                        if (financierOpportunity.is_first_case_rejected) {
                            //old logic now changed on 28January2019 as per android
//                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
//                            self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                            self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                            vc.opportunity = self.opportunity;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        } else{
                            if (financierOpportunity.isTimeBefore48Hours) {
                                FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                                vc.opportunity = self.opportunity;
                                [self.navigationController pushViewController:vc animated:YES] ;
                            } else{
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];
                                self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
                                self.financierRequestVc.financierOpportunity = self.financierOpportunity;
                                [self.navigationController pushViewController:_financierRequestVc animated:YES];
                                
                            }
                        }
                        
                    }
                }
            }

        }
    }
}

- (void)textFieldSearchButtonClicked:(id)sender {
    if ([[sender superview] isKindOfClass:[GreyBorderUITextField class]]) {
        GreyBorderUITextField *textField = (GreyBorderUITextField *)[sender superview];
        
        if (![textField.text hasValue]) {
            if ([textField.field.mTitle isEqualToString:FIELD_TGM]) {
                [self showValidationErrorMessage:@"Please enter TGM Name"];
            }
            else if ([textField.field.mTitle isEqualToString:FIELD_BROKER_NAME]) {
                [self showValidationErrorMessage:@"Please enter Broker Name"];
            }
            else {
                NSString *errorMessage = textField.field.mErrorMessage;
                [self showValidationErrorMessage:errorMessage];
            }
        }
        else {
            [self.view endEditing:true];
            if ([textField.field.mTitle isEqualToString:FIELD_TGM]) {
                self.tgmTextField = textField;
                [self getTGMList:textField];
            }
            else if ([textField.field.mTitle isEqualToString:FIELD_BROKER_NAME]) {
                self.brokerTextField = textField;
                [self getBrokerList:textField];
            }
        }
    }
}

-(void)textFieldButtonClicked:(id)sender {
//    [activeField resignFirstResponder];
    
    switch ([sender tag]) {
//        case 11:
//            [self fetchBrand:_brandDropdownField];
//            break;
//        case 12:
//            if (![_brandDropdownField.text hasValue]) {
//                [UtilityMethods alert_ShowMessage:@"Please select Brand" withTitle:APP_NAME andOKAction:^{
//                }];
//            } else {
//                [self fetchPLExchange:_plDropdownField];
//            }
//            break;
        case 13:
            [self fetchMileage:_mileageDropdownField];
            break;
        case 14:
            [self fetchAgeOfVehicle:_ageofVehicleDropDownfield];
            break;
            
        default:
            break;
    }
}
//
- (DropDownTextField *)brandDropdownField {
    if (!_brandDropdownField.field) {
        _brandDropdownField.field = [[Field alloc] init];
    }
    return _brandDropdownField;
}

- (DropDownTextField *)plDropdownField {
    if (!_plDropdownField.field) {
        _plDropdownField.field = [[Field alloc] init];
    }
    return _plDropdownField;
}

- (DropDownTextField *)mileageDropdownField {
    if (!_mileageDropdownField.field) {
        _mileageDropdownField.field = [[Field alloc] init];
    }
    return _mileageDropdownField;
}

- (DropDownTextField *)ageofVehicleDropDownfield {
    if (!_ageofVehicleDropDownfield.field) {
        _ageofVehicleDropDownfield.field = [[Field alloc] init];
    }
    return _ageofVehicleDropDownfield;
}

#pragma mark - Database Calls

- (void)fetchBrand:(DropDownTextField *)textField {
    
    if (brandArray && [brandArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [brandArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];

        [self showBrandDropDown:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        ExchangeFieldDBHelper *dbHelper = [ExchangeFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchBrand] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                brandArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [brandArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showBrandDropDown:arrSorted];
            }];
        }        
    }];
}

- (void)fetchPLExchange:(DropDownTextField *)textField {
    
    if (plArray && [plArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [plArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
//        [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
        [self showPLDropDown:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        ExchangeFieldDBHelper *dbHelper = [ExchangeFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchPLForExchange] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                plArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [plArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
//                [self showPopOver:textField withDataArray:arrSorted andModelData:arrSorted];
                [self showPLDropDown:arrSorted];
            }];
        }
    }];
}

- (void)fetchMileage:(DropDownTextField *)textField {
    
    if (mileageArray && [mileageArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [mileageArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showMileageDropDown:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        ExchangeFieldDBHelper *dbHelper = [ExchangeFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchMileage] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                mileageArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [mileageArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showMileageDropDown:arrSorted];
            }];
        }
    }];
}

- (void)fetchAgeOfVehicle:(DropDownTextField *)textField {
    
    if (ageOfvehicleArray && [ageOfvehicleArray count] > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedArr = [ageOfvehicleArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
        
        [self showAgeOfVehicleDropDown:arrSorted];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        ExchangeFieldDBHelper *dbHelper = [ExchangeFieldDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAgeOfVehicle] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                ageOfvehicleArray = [arr mutableCopy];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                NSArray *sortedArr = [ageOfvehicleArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                NSMutableArray *arrSorted = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:sortedArr]];
                
                [self showAgeOfVehicleDropDown:arrSorted];
            }];
        }
    }];
}

- (void)showBrandDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr copy];
    self.brandDropdownField.field.mValues = [nameResponseArray mutableCopy];
    self.brandDropdownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.brandDropdownField];
}

- (void)showPLDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr copy];
    self.plDropdownField.field.mValues = [nameResponseArray mutableCopy];
    self.plDropdownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.plDropdownField];
}

- (void)showMileageDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr copy];
    self.mileageDropdownField.field.mValues = [nameResponseArray mutableCopy];
    self.mileageDropdownField.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.mileageDropdownField];
}

- (void)showAgeOfVehicleDropDown:(NSMutableArray *)arr {
    NSArray *nameResponseArray = [arr copy];
    self.ageofVehicleDropDownfield.field.mValues = [nameResponseArray mutableCopy];
    self.ageofVehicleDropDownfield.field.mDataList = [arr mutableCopy];
    [self showDropDownForView:self.ageofVehicleDropDownfield];
}

//used for exchange drop downs
- (void)showDropDownForView:(DropDownTextField *)textField {
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    
    if (textField.field.mValues == nil || textField.field.mValues.count == 0) {
        [UtilityMethods alert_ShowMessage:@"No Data Found" withTitle:APP_NAME andOKAction:^{
        }];
    }
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray
{
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - API Calls
- (void)getMMGeography:(AutoCompleteUITextField *)textField forLOB:(NSString *)lobName {
    
    [textField setEnabled:true];
    self.mmGeographyTextField = textField;
    
    NSDictionary *requestDictionary = @{@"lob" : lobName,
                                        @"name" : @""};
	
	if (createOpty) {
		[UtilityMethods showProgressHUD:YES];
		[UtilityMethods RunOnBackgroundThread:^{
			MMGeographyDBHelpers *mmGeoDBHelper = [MMGeographyDBHelpers new];
			textField.field.mValues = [[[mmGeoDBHelper fetchAllMMGeoGraphyFromLob:lobName] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
			[UtilityMethods RunOnMainThread:^{
				[UtilityMethods hideProgressHUD];
				if (self.mmGeographyTextField) {
					[self.mmGeographyTextField becomeFirstResponder];
				}
			}];
		}];
	} else {
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

- (void)getBodyType:(DropDownTextField *)textField {
    
    if (!self.primaryField.mVehicleApplication || !self.primaryField.mVehicleApplication.mSelectedValue) {
        return;
    }
	
	NSString *vehicleApplication = self.opportunity.toLOBInfo.vehicleApplication;

	if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
		VehicleApplicationDBHelper *vehicleAppDBHelper = [VehicleApplicationDBHelper new];
            NSMutableArray *defaultBodyTypeArray = [[vehicleAppDBHelper fetchDefaultBodyType:vehicleApplication forLOB:self.opportunity.toVCNumber.lob] mutableCopy];
            NSMutableArray *bodyTypeArray = [[vehicleAppDBHelper fetchAllBodyType:vehicleApplication forLOB:self.opportunity.toVCNumber.lob] mutableCopy];
            if ([defaultBodyTypeArray count] > 0 && ![[defaultBodyTypeArray firstObject] isEqualToString:@""]) {
                [bodyTypeArray addObjectsFromArray:defaultBodyTypeArray];
            }
            textField.field.mValues = bodyTypeArray;
            [UtilityMethods RunOnMainThread:^{
                [self showPopOver:(DropDownTextField *)textField];
            }];
        }];
	} else {
		NSDictionary *requestDictionary = @{@"vehicle_application" : vehicleApplication,
                                            @"lob" : self.opportunity.toVCNumber.lob};
		[[EGRKWebserviceRepository sharedRepository] getBodyType:requestDictionary andSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				textField.field.mValues = [responseArray mutableCopy];
				[self showPopOver:(DropDownTextField *)textField];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)getUsageCategory:(DropDownTextField *)textField forLOB:(NSString *)lobName {
	
	if (createOpty) {
        [UtilityMethods RunOnOfflineDBThread:^{
		UsageCategoryDBHelper *usageCategoryDBHelper = [UsageCategoryDBHelper new];
            NSMutableArray *usageCategoryArray = [[usageCategoryDBHelper fetchAllUsageCategoriesFromLob:lobName] mutableCopy];
        [UtilityMethods RunOnMainThread:^{
        textField.field.mValues = usageCategoryArray;
		[self showPopOver:(DropDownTextField *)textField];
            }];
        }];
	} else {
		NSDictionary *requestDictionary = @{@"lob" : lobName};
		[[EGRKWebserviceRepository sharedRepository] getUsageCategory:requestDictionary andSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				textField.field.mValues = [responseArray mutableCopy];
				[self showPopOver:(DropDownTextField *)textField];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)getFinancierList:(AutoCompleteUITextField *)textField {
    
    [textField setEnabled:true];
    self.financierTextField = textField;
    if (textField.field.mDataList && textField.field.mValues && [textField.field.mValues count] > 0) {
        if (self.financierTextField) {
            [self.financierTextField becomeFirstResponder];
            return;
        }
    }
    
	if (createOpty) {
		[UtilityMethods showProgressHUD:YES];
		[UtilityMethods RunOnBackgroundThread:^{
            [UtilityMethods RunOnOfflineDBThread:^{
                FinanciersDBHelpers *financierDBHelper = [FinanciersDBHelpers new];
                textField.field.mDataList = [[financierDBHelper fetchAllFinanciers] mutableCopy];
                textField.field.mValues = [[[[financierDBHelper fetchAllFinanciers] valueForKey:@"financierName"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
                
                [UtilityMethods RunOnMainThread:^{
                    [UtilityMethods hideProgressHUD];
                    if (self.financierTextField) {
                        [self.financierTextField becomeFirstResponder];
                    }
                }];
            }];
		}];
	} else {
        
        [UtilityMethods showProgressHUD:true];
		[[EGRKWebserviceRepository sharedRepository] getFinancierList:nil andSuccessAction:^(NSArray *responseArray) {
            
            [UtilityMethods hideProgressHUD];
            
            if (responseArray && [responseArray count] > 0) {
                textField.field.mDataList = [responseArray mutableCopy];
                textField.field.mValues = [[[responseArray valueForKey:@"financierName"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
                if (self.financierTextField) {
                    [self.financierTextField becomeFirstResponder];
                }
            }
            else {
                [textField setEnabled:false];
            }
            
        } andFailuerAction:^(NSError *error) {
			[UtilityMethods hideProgressHUD];
            [textField setEnabled:false];
		}];
	}
}
//getRegistrationDetail
- (void)getRegistrationDetail {
    _chasisNoTextfield.text = @"";
//    [textField setEnabled:true];
    NSDictionary *requestDictionary = @{@"REG_NO"          : _registrationTextField.text
//                                        @"pl_for_exchange" : _plDropdownField.text
                                        };
    
    [[EGRKWebserviceRepository sharedRepository] getRegistrationDetails:requestDictionary andSuccessAction:^(NSArray *responseArray) {
     [UtilityMethods hideProgressHUD];
            if (responseArray && [responseArray count] > 0) {
                [UtilityMethods hideProgressHUD];
//                self.chasisNoTextfield.text = [[responseArray valueForKey:@"CHASSIS_NUM_s"] objectAtIndex:0];
//                self.chasisNoTextfield.text  = [responseArray valueForKey:@"CHASSIS_NUM_s"] != nil ?[responseArray valueForKey:@"CHASSIS_NUM_s"] :[[responseArray valueForKey:@"CHASSIS_NUM_s"] objectAtIndex:0];
                
                self.chasisNoTextfield.text  = [[responseArray valueForKey:@"CHASSIS_NUM_s"] objectAtIndex:0];
                self.brandDropdownField.text = [[responseArray valueForKey:@"PPL_s"] objectAtIndex:0];
                self.plDropdownField.text    = [[responseArray valueForKey:@"PL_s"] objectAtIndex:0];
                [self bindValuesToChassisModel:responseArray];
            }        
        
        } andFailuerAction:^(NSError *error) {
            [UtilityMethods hideProgressHUD]; //error.localozedrecovery, [error localized]
            if (error.localizedRecoverySuggestion) {
                [UtilityMethods showErroMessageFromAPICall:error defaultMessage:error.localizedDescription];
                [UtilityMethods hideProgressHUD];
            }
            else {
                [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
                }];
                [UtilityMethods hideProgressHUD];
            }
            [UtilityMethods hideProgressHUD];

        }];
    
}

- (void)getCampaignList:(DropDownTextField *)textField forPL:(NSString *)plName {
    
    if (textField.field.mDataList && textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
    NSDictionary *requestDictionary = @{@"plname" : plName};
    
    [[EGRKWebserviceRepository sharedRepository] get_Campaign_List:requestDictionary withblock:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            NSMutableArray * array = [NSMutableArray new];
            for(EGCampaign * obj in responseArray) {
                [array addObject:obj.campaignName];
            }
            textField.field.mValues = array;
            textField.field.mDataList = [responseArray mutableCopy];
            [self showPopOver:(DropDownTextField *)textField];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
    
//    [[EGRKWebserviceRepository sharedRepository] getCampaignList:requestDictionary andSuccessAction:^(NSArray *responseArray) {
//        if (responseArray && [responseArray count] > 0) {
//            textField.field.mDataList = [responseArray mutableCopy];
//            textField.field.mValues = [responseArray valueForKey:@"campaignName"];
//            [self showPopOver:(DropDownTextField *)textField];
//        }
//    } andFailuerAction:^(NSError *error) {
//        
//    }];
}

- (void)getInfluencersList:(DropDownTextField *)textField{
    
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
	if (createOpty) {
		[UtilityMethods showProgressHUD:YES];
		[UtilityMethods RunOnBackgroundThread:^{
            [UtilityMethods RunOnOfflineDBThread:^{
                InfluencerDBHelpers *influencerDBHelpers = [InfluencerDBHelpers new];
                textField.field.mValues = [[influencerDBHelpers fetchInfluencerTypes] mutableCopy];
                [UtilityMethods RunOnMainThread:^{
                    [UtilityMethods hideProgressHUD];
                    [self showPopOver:(DropDownTextField *)textField];
                }];
            }];
		}];
	} else {
		[[EGRKWebserviceRepository sharedRepository] getInfluencersListSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				textField.field.mValues = [responseArray mutableCopy];
				[self showPopOver:(DropDownTextField *)textField];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
}

- (void)getCompetitorList:(DropDownTextField *)textField {
	
    if (textField.field.mValues && [textField.field.mValues count] > 0) {
        [self showPopOver:(DropDownTextField *)textField];
        return;
    }
    
	if (createOpty) {
		[UtilityMethods showProgressHUD:YES];
		[UtilityMethods RunOnBackgroundThread:^{
            [UtilityMethods RunOnOfflineDBThread:^{
                CompetitorDBHelpers *compititorsDBHelpers = [CompetitorDBHelpers new];
                textField.field.mValues = [[compititorsDBHelpers fetchAllCompetitors] mutableCopy];
                [UtilityMethods RunOnMainThread:^{
                    [UtilityMethods hideProgressHUD];
                    [self showPopOver:(DropDownTextField *)textField];
                }];
            }];
		}];
	} else {
		[[EGRKWebserviceRepository sharedRepository] getCompetitorListSuccessAction:^(NSArray *responseArray) {
			if (responseArray && [responseArray count] > 0) {
				textField.field.mValues = [responseArray mutableCopy];
				[self showPopOver:(DropDownTextField *)textField];
			}
		} andFailuerAction:^(NSError *error) {
			
		}];
	}
	
}

- (void)getProductCategoryList:(DropDownTextField *)textField {
    
    Field *competitorField = [textField.field.mPredecessors objectAtIndex:0];
    if (competitorField.mSelectedValue) {
        
        if (textField.field.mValues && [textField.field.mValues count] > 0) {
            [self showPopOver:(DropDownTextField *)textField];
            return;
        }
        
        if(createOpty) {
            
            [UtilityMethods RunOnOfflineDBThread:^{
                    VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
                    NSMutableArray *pplArray = [[vcNumberDBHelper fetchAllPPLFromLob:self.opportunity.toVCNumber.lob] mutableCopy];
                    NSArray *nameResponseArray = [pplArray valueForKey:@"pplName"];
                if (nameResponseArray != nil) {
                    [UtilityMethods RunOnMainThread:^{
                        textField.field.mValues = [nameResponseArray mutableCopy];
                        [self showPopOver:(DropDownTextField *)textField];
                    }];
                }
                }];
            
        } else {
            NSDictionary *requestDict = @{@"lob_name": self.opportunity.toVCNumber.lob};
            [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
                if (responseArray && [responseArray count] > 0) {
                    NSArray *nameResponseArray = [responseArray valueForKey:@"pplName"];
                    textField.field.mValues = [nameResponseArray mutableCopy];
                    textField.field.mDataList = [responseArray mutableCopy];
                    [self showPopOver:textField];
                }
            } andFailuerAction:^(NSError *error) {
                
            }];
        }
        
    }
    else {
        [UtilityMethods alert_ShowMessage:competitorField.mErrorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
}

- (void)getTGMList:(GreyBorderUITextField *)textField {
    
    NSDictionary *requestDictionary = @{@"number" : @"",
                                        @"name" : textField.text};
    
    [[EGRKWebserviceRepository sharedRepository] getTGMList:requestDictionary andSuccessAction:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            textField.field.mDataList = [responseArray mutableCopy];
            textField.field.mValues = [responseArray valueForKey:@"accountName"];
            [self.view endEditing:true];
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] init];
            [searchResultViewController showWithData:responseArray fromViewController:self];
        }
        else {
            [UtilityMethods alert_ShowMessage:MESSAGE_NO_RESULTS_FOUND withTitle:APP_NAME andOKAction:^{
                
            }];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
}

- (void)getBrokerList:(GreyBorderUITextField *)textField {
    
    NSDictionary *requestDictionary = @{@"name" : textField.text,
                                        @"phone" : @"",
                                        @"buid" : @""};
    
    [[EGRKWebserviceRepository sharedRepository] getBrokerDetails:requestDictionary andSuccessAction:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            textField.field.mDataList = [responseArray mutableCopy];
            textField.field.mValues = [responseArray valueForKey:@"accountName"];
            [self.view endEditing:true];
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] init];
            [searchResultViewController showWithData:responseArray fromViewController:self];
        }
        else {
            [UtilityMethods alert_ShowMessage:MESSAGE_NO_RESULTS_FOUND withTitle:APP_NAME andOKAction:^{
                
            }];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
}

- (void)callUpdateOpportunityAPI {

//    NSLog(@"Input Parrameter:- %@",[self getRequestDictionaryFromOpportunityModel]);
    [[EGRKWebserviceRepository sharedRepository] updateOpportunity:[self getRequestDictionaryFromOpportunityModel] andSuccessAction:^(id activity){
        [UtilityMethods alert_ShowMessage:@"Opportunity updated successfully." withTitle:APP_NAME andOKAction:^(void){
            if (self.entryPoint != InvokeForUpdateOpportunity) {
                [[AppRepo sharedRepo] showHomeScreen];
            }else if (self.entryPoint == InvokeForUpdateOpportunity){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } andFailuerAction:^(NSError *error) {
        
        [ScreenshotCapture takeScreenshotOfView:self.view];
        AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appdelegate.screenNameForReportIssue = @"Optional Fields";

        [UtilityMethods showErroMessageFromAPICall:error defaultMessage:UPDATE_OPPORTUNITY_FAILED_MESSAGE];
    }];
}

- (NSDictionary *)getRequestDictionaryFromOpportunityModel {
    NSLog(@"%@",self.opportunity.optyID);
    NSLog(@"%@",self.opportunity.toLOBInfo.mmGeography);
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] opportunityMapping] inverseMapping]
                                                                                   objectClass:[EGOpportunity class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:self.opportunity requestDescriptor:requestDescriptor error:nil];
    return parametersDictionary;
}

- (EGFinancier *)getFinancierObjectForFinancierName:(NSString *)financierName {
    if (self.financierTextField.field.mDataList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"financierName == %@", financierName];
        NSArray *filteredArray = [self.financierTextField.field.mDataList filteredArrayUsingPredicate:predicate];
        if (filteredArray && [filteredArray count] > 0) {
            return [filteredArray objectAtIndex:0];
        }
    }
    
    return nil;
}

@end
