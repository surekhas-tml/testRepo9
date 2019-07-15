//
//  NewNFARequestViewController.m
//  e-guru
//
//  Created by MI iMac04 on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NewNFARequestViewController.h"
#import "NFAUIHelper.h"
#import "NFASectionBaseView.h"
#import "PureLayout.h"
#import "DealerAndCustomerDetailsView.h"
#import "DealDetailsView.h"
#import "CompetitionDetailsView.h"
#import "TMLProposedLandingPriceView.h"
#import "DealerMarginAndRetentionView.h"
#import "SchemeDetailsView.h"
#import "FinancierDetailsView.h"
#import "NFARequestView.h"
#import "NFADetailViewController.h"
#import "AppRepo.h"
#import "NFACreationValidationHelper.h"

@interface NewNFARequestViewController () <NFASectionBaseViewDelegate> {
    NSMutableArray *tabButtonsArray;
    NSMutableArray *tabViewArray;
    UIAlertController *alertController;
    BOOL wasNFACreateSuccessAlertShown;
    BOOL wasNFAUpdateSuccessAlertShown;
    BOOL wasNFACreateUpdateErrorAlertShown;
    NSDictionary *cachedResponseDictionary;
    NSError *cachedError;
    NSString *cachedDefaultErrorMessage;
}

@end

@implementation NewNFARequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Form_NFA];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Following check are to solve the issue of AlertController being dismissed
    // if app is sent to background and PIN screen is shown
    if (wasNFACreateSuccessAlertShown && cachedResponseDictionary) {
        [self parseAndShowCreateNFASuccessMessage:cachedResponseDictionary];
    }
    else if (wasNFAUpdateSuccessAlertShown && cachedResponseDictionary) {
        [self parseAndShowUpdateNFASuccessMessage:cachedResponseDictionary];
    }
    else if (wasNFACreateUpdateErrorAlertShown && cachedError && cachedDefaultErrorMessage) {
        [self showNFACreateUpdateFailureMessage:cachedError defaultMessage:cachedDefaultErrorMessage];
    }
}

#pragma mark - UI Initialization

// This method initialized the required
// UI components for this screen
- (void)initUI {
    [self loadTabButtons];
    [self loadTabViews];
}

// This method loads the bottom tab buttons in
// tabButtonsArray and bind actions to each of these buttons
- (void)loadTabButtons {
    
    // Select the first tab
    [self.dealerAndCustomerDetailsTab setTabSelected:true];
    
    if (!tabButtonsArray) {
        tabButtonsArray = [[NSMutableArray alloc] initWithObjects:
                           self.dealerAndCustomerDetailsTab,
                           self.dealDetailsTab,
                           self.competitionDetailsTab,
                           self.tmlProposedLandingPriceTab,
                           self.dealerMarginAndRetentionTab,
                           self.schemeDetailsTab,
                           self.financierDetailsTab,
                           self.nfaRequestTab,
                           nil];
    }
    
    // Bind Section Type to each tab
    self.dealerAndCustomerDetailsTab.sectionType = NFASectionDealerAndCustomerDetails;
    self.dealDetailsTab.sectionType = NFASectionDealDetails;
    self.competitionDetailsTab.sectionType = NFASectionCompetitionDetails;
    self.tmlProposedLandingPriceTab.sectionType = NFASectionTMLProposedLandingPrice;
    self.dealerMarginAndRetentionTab.sectionType = NFASectionDealerMarginAndRetention;
    self.schemeDetailsTab.sectionType = NFASectionSchemeDetails;
    self.financierDetailsTab.sectionType = NFASectionFinancierDetails;
    self.nfaRequestTab.sectionType = NFASectionNFARequest;
    
    // Bind Action to tab buttons
    [self.dealerAndCustomerDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.dealDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.competitionDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.tmlProposedLandingPriceTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.dealerMarginAndRetentionTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.schemeDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.financierDetailsTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.nfaRequestTab.button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set following fields completed
    [self.competitionDetailsTab setStatusOfMandatoryFields:true];
    [self.schemeDetailsTab setStatusOfMandatoryFields:true];
    [self.financierDetailsTab setStatusOfMandatoryFields:true];
    [self.nfaRequestTab setStatusOfMandatoryFields:true];
}

// This method load the views for given NFA Request Type
// and renders the first view in tabViewArray
- (void)loadTabViews {
    tabViewArray = [NFAUIHelper getNFASectionsWithData:self.nfaModel forNFARequestType:NFATypeAdditonalSupport forMode:NFAModeCreate];
    if (tabViewArray && [tabViewArray count] > 0) {
        [self toggleTabButton:((NFARequestTabsView *)[tabButtonsArray objectAtIndex:0]).button];
    }
}

#pragma mark - Private Methods

// This method selected the clicked buttons
// and deselects all other buttons in tabButtonsArray
- (void)toggleTabButton:(UIButton *)clickedButton {
    
    NFARequestTabsView *selectedTab = nil;
    
    for (NFARequestTabsView *tabView in tabButtonsArray) {
        if (tabView.button == clickedButton) {
            [tabView setTabSelected:true];
            selectedTab = tabView;
        }
        else {
            [tabView setTabSelected:false];
        }
    }
    
    if (selectedTab) {
        [self showViewForSelectedTab:selectedTab];
    }
}

// This method shows the view for selected tab
// and hides the view for remaining tabs
- (void)showViewForSelectedTab:(NFARequestTabsView *)tab {
    if (tabViewArray && [tabViewArray count] > 0) {
        
        for (NFASectionBaseView *tabView in tabViewArray) {
            if (tab.sectionType == tabView.sectionType) {
                [self showTab:tabView];
            }
            else {
                [self hideTab:tabView];
            }
            tabView.delegate = self;
            
            [tabView checkIfMandatoryFieldsAreFilled];
        }
    }
}

// This method decided how to show a given view
- (void)showTab:(id)sectionView {
    if ([sectionView isDescendantOfView:self.containerView]) {
        [sectionView setHidden:false];
    }
    else {
        [self.containerView addSubview:sectionView];
        [sectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    }
    [self.containerView bringSubviewToFront:sectionView];
    
    // Login to hide show Preview and Submit
    // buttons for NFA Request tab and others
    if ([sectionView getSectionType] == NFASectionNFARequest) {
        [self showLastTabButtons:true];
    }
    else {
        [self showLastTabButtons:false];
    }
    
    // Special condition to re-calculate field values in
    // NFA Request Tab
    if ([sectionView getSectionType] == NFASectionNFARequest) {
        [sectionView calculateNetSupportPreVehicle];
    }
}

- (void)hideTab:(NFASectionBaseView *)sectionView {
    if ([sectionView isDescendantOfView:self.containerView]) {
        [sectionView setHidden:true];
        [self.containerView sendSubviewToBack:sectionView];
    }
}

- (void)showLastTabButtons:(BOOL)show {
    if (show) {
        [self.submitButton setHidden:false];
        [self.previewButton setHidden:false];
        self.resetButtonRightMargin.constant = 278;
        [self.resetButton setHidden:true];
    }
    else {
        [self.submitButton setHidden:true];
        [self.previewButton setHidden:true];
        self.resetButtonRightMargin.constant = 8;
        [self.resetButton setHidden:false];
    }
}

- (void)resetActiveSectionFields {
    id sectionView = [[self.containerView subviews] lastObject];
    [sectionView resetFields];
}

- (BOOL)areMandatoryFieldsFilled {
    
    BOOL hasIncompleteMandatoryFields = false;
    NSString *mandatoryFieldsCompletionError = @"Please fill mandatory details in";
    
    NSInteger currentIndex = 1;
    for (NFARequestTabsView *tabButton in tabButtonsArray) {
        if (![tabButton getMandatoryFieldsFilledStatus]) {
            hasIncompleteMandatoryFields = true;
            mandatoryFieldsCompletionError = [mandatoryFieldsCompletionError stringByAppendingString:[NSString stringWithFormat:@" \"%@\",", tabButton.titleLabel.text]];
        }
        currentIndex ++;
    }
    
    if (hasIncompleteMandatoryFields) {
        [UtilityMethods alert_ShowMessage:[self formatMandatoryFieldsCompletionError:mandatoryFieldsCompletionError] withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    return !hasIncompleteMandatoryFields;
}

- (NSString *)formatMandatoryFieldsCompletionError:(NSString *) errorMessage {
    errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSRange lastComma = [errorMessage rangeOfString:@"," options:NSBackwardsSearch];
    
    // First replace the last comma with full stop
    if(lastComma.location != NSNotFound) {
        errorMessage = [errorMessage stringByReplacingCharactersInRange:lastComma
                                                             withString: @"."];
    }
    
    // Now replace the last comma with and
    lastComma = [errorMessage rangeOfString:@"," options:NSBackwardsSearch];
    if(lastComma.location != NSNotFound) {
        errorMessage = [errorMessage stringByReplacingCharactersInRange:lastComma
                                                             withString: @" and"];
    }
    
    return errorMessage;
}

- (NSDictionary *)getRequestDictionaryFromNFAModel {
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[[EGRKObjectMapping sharedMapping] getCreateNFAModelMapping] inverseMapping]
                                                                                   objectClass:[NFAAPIModel class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    NFAAPIModel *apiModel = [[NFAAPIModel alloc] initWithNFAModel:self.nfaModel];
    
    NSDictionary *parametersDictionary = [RKObjectParameterization parametersWithObject:apiModel requestDescriptor:requestDescriptor error:nil];
    
    [UtilityMethods removeNSNullValuesFromDictionary:&parametersDictionary];
    
    return parametersDictionary;
}

- (void)parseAndShowCreateNFASuccessMessage:(NSDictionary *)responseDict {
    
    if (responseDict && [responseDict objectForKey:@"nfa_number"]) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Create_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_Create_NFA_Successful];

        wasNFACreateSuccessAlertShown = true;
        cachedResponseDictionary = responseDict;
        
        NSString *nfaSuccessMessage = [NSString stringWithFormat:@"NFA Request No. %@ is created successfully and forwarded to TSM", [responseDict objectForKey:@"nfa_number"]];
        
        [UtilityMethods alert_ShowMessage:nfaSuccessMessage withTitle:APP_NAME andOKAction:^{
            wasNFACreateSuccessAlertShown = false;
            [[AppRepo sharedRepo] showHomeScreen];
        }];
    }
}

- (void)parseAndShowUpdateNFASuccessMessage:(NSDictionary *)responseDictionary {
    
    if (responseDictionary && [responseDictionary objectForKey:@"nfa_number"]) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Create_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_Update_NFA_Successful];

        wasNFAUpdateSuccessAlertShown = true;
        cachedResponseDictionary = responseDictionary;
        
        NSString *nfaRequestNumber = [responseDictionary objectForKey:@"nfa_number"];
        NSString *nfaSuccessMessage = [NSString stringWithFormat:@"NFA is updated successfully with new NFA Request No. %@", nfaRequestNumber];
        
        // New NFA request Number
        self.nfaModel.nfaRequestNumber = nfaRequestNumber;
        
        // New NFA ID
        if ([responseDictionary objectForKey:@"msm_rd_id"]) {
            self.nfaModel.nfaID = [responseDictionary objectForKey:@"msm_rd_id"];
        }
        
        [UtilityMethods alert_ShowMessage:nfaSuccessMessage withTitle:APP_NAME andOKAction:^{
            wasNFAUpdateSuccessAlertShown = false;
            
            if ([self.delegate respondsToSelector:@selector(nfaUpdated:)]) {
                [self.delegate nfaUpdated:self.nfaModel];
            }
            [self.navigationController popViewControllerAnimated:true];
        }];
    }
}

- (void)showNFACreateUpdateFailureMessage:(NSError *)error defaultMessage:(NSString *)defaultMessage {
    
    wasNFACreateUpdateErrorAlertShown = true;
    cachedError = error;
    cachedDefaultErrorMessage = defaultMessage;
 
    if (error.localizedRecoverySuggestion) {
        
        [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
            id responseMessage = [jsonDictionary objectForKey:@"msg"];
            if ([responseMessage isKindOfClass:[NSString class]]) {
                [UtilityMethods alert_ShowMessage:[jsonDictionary objectForKey:@"msg"] withTitle:APP_NAME andOKAction:^{
                    
                    wasNFACreateUpdateErrorAlertShown = false;
                }];
            }
            else if([responseMessage isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDictionary = (NSDictionary *)responseMessage;
                id message = [responseDictionary objectForKey:@"Failed"];
                if (message && [message isKindOfClass:[NSString class]]) {
                    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
                        
                        wasNFACreateUpdateErrorAlertShown = false;
                    }];
                }
            }
            
        } failure:^(NSError * _Nullable error) {
            [UtilityMethods alert_ShowMessage:defaultMessage withTitle:APP_NAME andOKAction:^{
                
                wasNFACreateUpdateErrorAlertShown = false;
            }];
        }];
    }
    else {
        [UtilityMethods alert_ShowMessage:error.localizedDescription withTitle:APP_NAME andOKAction:^{
            if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
                [self.navigationController popViewControllerAnimated:NO];
                AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                appdelegate.shouldRefreshNFASummaryView = YES;
            }
            wasNFACreateUpdateErrorAlertShown = false;
        }];
    }
}
#pragma mark - IBAction

- (void)tabButtonClicked:(UIButton *)sender {
    [self toggleTabButton:sender];
}

- (IBAction)resetButtonClicked:(id)sender {
    [self resetActiveSectionFields];
}

- (IBAction)previewButtonClicked:(id)sender {
    NFADetailViewController *nfaDetailViewController = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"NFADetail"];
    nfaDetailViewController.nfaModel = self.nfaModel;
    nfaDetailViewController.entryPoint = EntryPointPreview;
    [self.navigationController pushViewController:nfaDetailViewController animated:true];
}

- (IBAction)submitButtonClicked:(id)sender {
    if ([self areMandatoryFieldsFilled] && [NFACreationValidationHelper checkPositionValidityAndShowErroMessage:self.nfaModel]) {
        
        if (self.currentNFAMode == NFAModeUpdate) {
            [self callUpdateNFAAPI];
        }
        else {
            [self callCreateNFAAPI];
        }
    }
}

#pragma mark - NFASectionBaseViewDelegate Method

- (void)mandatoryFieldsFilled:(BOOL)fieldsFilled inView:(id)sectionView {
    
    NSArray *filteredArray = nil;
    
    if ([sectionView isKindOfClass:[DealerAndCustomerDetailsView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionDealerAndCustomerDetails]];
    }
    else if([sectionView isKindOfClass:[DealDetailsView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionDealDetails]];
    }
    else if([sectionView isKindOfClass:[CompetitionDetailsView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionCompetitionDetails]];
    }
    else if([sectionView isKindOfClass:[TMLProposedLandingPriceView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionTMLProposedLandingPrice]];
    }
    else if([sectionView isKindOfClass:[DealerMarginAndRetentionView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionDealerMarginAndRetention]];
    }
    else if([sectionView isKindOfClass:[SchemeDetailsView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionSchemeDetails]];
    }
    else if([sectionView isKindOfClass:[FinancierDetailsView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionFinancierDetails]];
    }
    else if([sectionView isKindOfClass:[NFARequestView class]]) {
        filteredArray = [tabButtonsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionType = %d", NFASectionNFARequest]];
    }
    
    if (filteredArray && [filteredArray count] > 0) {
        NFARequestTabsView *tabButton = [filteredArray objectAtIndex:0];
        [tabButton setStatusOfMandatoryFields:fieldsFilled];
    }
}

#pragma mark - API Calls

- (void)callCreateNFAAPI {
    
    [[EGRKWebserviceRepository sharedRepository] createNFA:[self getRequestDictionaryFromNFAModel]
                                          andSuccessAction:^(NSDictionary *responseDictionary) {
                                              
                                              [self parseAndShowCreateNFASuccessMessage:responseDictionary];
                                              
                                          } andFailuerAction:^(NSError *error) {
                                              [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Create_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_Create_NFA_Failed];

                                              [self showNFACreateUpdateFailureMessage:error defaultMessage:CREATE_NFA_FAILED_MESSAGE];
                                          }];
}

- (void)callUpdateNFAAPI {
    
    [[EGRKWebserviceRepository sharedRepository] updateNFA:[self getRequestDictionaryFromNFAModel] andSuccessAction:^(NSDictionary *responseDictionary) {
        if (responseDictionary && [responseDictionary objectForKey:@"nfa_number"]) {
            
            [self parseAndShowUpdateNFASuccessMessage:responseDictionary];
        }
        
    } andFailuerAction:^(NSError *error) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Create_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_Update_NFA_Failed];

        [self showNFACreateUpdateFailureMessage:error defaultMessage:UPDATE_NFA_FAILED_MESSAGE];
    }];
}

@end
