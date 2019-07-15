//
//  SearchNFAViewController.m
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "SearchNFAViewController.h"

#define TITLE_Pending      @"Pending"
#define TITLE_Rejected      @"Rejected"
#define TITLE_Approved      @"Approved"
#define TITLE_Exp   @"Expired/Cancelled"

#define DEFAULT_DATE_RANGE_TEXT     @"This Month\'s"

@interface SearchNFAViewController ()<HHSlideViewDelegate>{
    AppDelegate *appdelegate;
    EGSearchNFAFilter *searchNFAFilter;
    NFASearchView *nfaSearchView;
}
@property (strong, nonatomic) NFAHHSlideView *slideView;
@property (strong, nonatomic) NSMutableArray *viewControllersArray;
@property (strong, nonatomic) NSMutableArray *viewControllersTitleArray;
@end
@implementation SearchNFAViewController
@synthesize nfaExpiredViewController,nfaPendingViewController,nfaRejectedViewController,nfaApprovedViewController,invokedFrom;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.view addSubview:self.slideView];
    [self configureView];
    [self searchViewConfiguration];
    if (self.invokedFrom != Home) {
        [self searchNFA:nil];
    }
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Search_NFA];

}
-(void)viewDidAppear:(BOOL)animated{
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)configureView{
    self.nameLbl.text = [NSString stringWithFormat:@"%@ %@ NFA", DEFAULT_DATE_RANGE_TEXT, [[self.viewControllersTitleArray objectAtIndex:0] capitalizedString]];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UtilityMethods navigationBarSetupForController:self];
    
    if (appdelegate.shouldRefreshNFASummaryView) {
        appdelegate.shouldRefreshNFASummaryView = NO;
        [self searchNFAForQuery];
    }
}

- (NFAHHSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[NFAHHSlideView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 114)];
        _slideView.delegate = self;
    }
    return _slideView;
}
- (NSMutableArray *)viewControllersArray {
    if (!_viewControllersArray) {
        _viewControllersArray = [[NSMutableArray alloc] init];

            [_viewControllersArray addObject:[self getViewControllerForTab:TabpendingNFA]];
        [_viewControllersArray addObject:[self getViewControllerForTab:TabApprovedNFA]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabRejectedNFA]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabExpiredNFA]];
    }
    return _viewControllersArray;
}


- (NSMutableArray *)viewControllersTitleArray {
    if (!_viewControllersTitleArray) {
        _viewControllersTitleArray = [[NSMutableArray alloc] init];
        [_viewControllersTitleArray addObject:TITLE_Pending];
        [_viewControllersTitleArray addObject:TITLE_Approved];
        [_viewControllersTitleArray addObject:TITLE_Rejected];
        [_viewControllersTitleArray addObject:TITLE_Exp];
    }
    return _viewControllersTitleArray;
}
- (NFACollectionViewContainerViewController *)nfaPendingViewController {
    if (!nfaPendingViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        nfaPendingViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFACollectionViewContainerViewController"];
        nfaPendingViewController.TabMode = TabpendingNFA;
        nfaPendingViewController.searchNFAViewController = self;
    }
    return nfaPendingViewController;
}
- (NFACollectionViewContainerViewController *)nfaExpiredViewController {
    if (!nfaExpiredViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        nfaExpiredViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFACollectionViewContainerViewController"];
        nfaExpiredViewController.TabMode = TabExpiredNFA;
        nfaExpiredViewController.searchNFAViewController = self;
    }
    return nfaExpiredViewController;
}
- (NFACollectionViewContainerViewController *)nfaRejectedViewController {
    if (!nfaRejectedViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        nfaRejectedViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFACollectionViewContainerViewController"];
        nfaRejectedViewController.TabMode = TabRejectedNFA;
        nfaRejectedViewController.searchNFAViewController = self;
    }
    return nfaRejectedViewController;
}
- (NFACollectionViewContainerViewController *)nfaApprovedViewController {
    if (!nfaApprovedViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        nfaApprovedViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFACollectionViewContainerViewController"];
        nfaApprovedViewController.TabMode = TabApprovedNFA;
        nfaApprovedViewController.searchNFAViewController = self;
    }
    return nfaApprovedViewController;
}
#pragma mark - Private Methods

- (UIViewController *)getViewControllerForTab:(NFATabName)tabName {
    NFACollectionViewContainerViewController *viewController;
    switch (tabName) {
        case TabpendingNFA:
            viewController = self.nfaPendingViewController;
            break;
        case TabApprovedNFA:
            viewController = self.nfaApprovedViewController;
            break;
        case TabRejectedNFA:
            viewController = self.nfaRejectedViewController;
            break;
        case TabExpiredNFA:
            viewController = self.nfaExpiredViewController;
            break;
           }
    return viewController;
}

#pragma mark - HHSlideViewDelegate Method

- (NSInteger)numberOfSlideItemsInSlideView:(HHSlideView *)slideView {
    return [self.viewControllersArray count];
}

- (NSArray *)namesOfSlideItemsInSlideView:(HHSlideView *)slideView {
    return self.viewControllersTitleArray;
}

- (NSArray *)childViewControllersInSlideView:(HHSlideView *)slideView {
    return self.viewControllersArray;
}

- (void)slideView:(HHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
    self.nameLbl.text = [NSString stringWithFormat:@"%@ %@ NFA", DEFAULT_DATE_RANGE_TEXT, [[self.viewControllersTitleArray objectAtIndex:index] capitalizedString]];
}

- (UIColor *)colorOfSliderInSlideView:(HHSlideView *)slideView {
    return [UIColor slideViewSliderColor];
}

- (UIColor *)colorOfSlideView:(HHSlideView *)slideView {
    return [UIColor tableHeaderColor];
}

- (void)didSlideToButton:(UIButton *)slideToButton {
    self.nameLbl.text = [NSString stringWithFormat:@"%@ %@ NFA", DEFAULT_DATE_RANGE_TEXT, [[[slideToButton titleLabel] text] capitalizedString]];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNFA:(id)sender {
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_NewNFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

    
    CreateNFAViewController *createNFA = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNFA_View"];
    [self.navigationController pushViewController:createNFA animated:YES];
}

- (IBAction)searchNFA:(id)sender {
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Open_SearchNFAFilter_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    nfaSearchView.searchFilter = searchNFAFilter;
    [nfaSearchView.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:nfaSearchView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [nfaSearchView setHidden:!nfaSearchView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@"Search Open %@",self.nameLbl.text);
                    }];
}
-(void)searchNFAWithQueryParameters:(NSDictionary *) queryParams{
    NSLog(@"SearchNFA For RequestNumber %@",queryParams);

    [[EGRKWebserviceRepository sharedRepository]searchNFA:queryParams andSucessAction:^(EGPagination *nfa) {
        [self nfaSearchedSuccessfully:nfa];
    } andFailuerAction:^(NSError *error) {
        [self nfaSearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)nfaSearchFailedWithErrorMessage:(NSString *)errorMessage{
    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchNFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_NFASearch_Failed];
}
-(void)nfaSearchedSuccessfully:(EGPagination *)paginationObj{
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchNFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_NFASearch_Successful];

    EGPagedArray * nFAPagedArray = [EGPagedArray new];
    nFAPagedArray = [EGPagedArray mergeWithCopy:nFAPagedArray withPagination:paginationObj];
    if ([nFAPagedArray currentSize] > 0) {
        NFADetailViewController *nfaDetailViewController = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"NFADetail"];
        nfaDetailViewController.nfaModel = [nFAPagedArray objectAtIndex:0];
        [self.navigationController pushViewController:nfaDetailViewController animated:YES];

    }else{
        [self nfaSearchFailedWithErrorMessage:@"No Search Results Found"];
    }
}
-(void)searchNFAForQuery{
    [self.nameLbl setHidden:true];
    searchNFAFilter = nfaSearchView.searchFilter;
    if ([searchNFAFilter.nfa_request_number hasValue]) {
        [[NFAOperationsHelper new] searchNFAForFilter:searchNFAFilter withOffset:0 withSize:10 fromVC:self];
    }else{
        
        if (searchNFAFilter.status == PendingForSPMApproval || searchNFAFilter.status == PendingForRSMApproval || searchNFAFilter.status == PendingForRMApproval || searchNFAFilter.status == PendingForLOBHeadApproval || searchNFAFilter.status == PendingForMarketingHeadApproval || searchNFAFilter.status == Pending || searchNFAFilter.status == SubmittedByDealer) {
            [self.slideView buttonClicked:[[self.slideView buttonsArray] objectAtIndex:0]];
        }else if (searchNFAFilter.status == ApproveBySPM || searchNFAFilter.status == ApproveByRSM || searchNFAFilter.status == ApproveByRM || searchNFAFilter.status == ApproveByLOBHead || searchNFAFilter.status == ApproveByMarketingHead || searchNFAFilter.status == Approved){
            [self.slideView buttonClicked:[[self.slideView buttonsArray] objectAtIndex:1]];
        }else if (searchNFAFilter.status == RejectedBySPM || searchNFAFilter.status == RejectedByRSM || searchNFAFilter.status == RejectedByRM || searchNFAFilter.status == RejectedByLOBHead || searchNFAFilter.status == RejectedByMarketingHead || searchNFAFilter.status == Rejected){
            [self.slideView buttonClicked:[[self.slideView buttonsArray] objectAtIndex:2]];
        }else if (searchNFAFilter.status == CancelledByDSM || searchNFAFilter.status == CancelledByTSM || searchNFAFilter.status == CancelledByUser || searchNFAFilter.status == CancelledAsOptyClosedLost || searchNFAFilter.status == Cancelled || searchNFAFilter.status == Expired || searchNFAFilter.status == ExpiredOrCancelled) {
            [self.slideView buttonClicked:[[self.slideView buttonsArray] objectAtIndex:3]];
        }
        
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"searchNFAForQuery"
     object:self userInfo:@{@"filter": searchNFAFilter}];
    }
}

-(void)closeSearchDrawer{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"closeSearchDrawer"
     object:self userInfo:nil];
}
-(void)fieldsCleared{
    [self.nameLbl setHidden:false];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"fieldsCleared"
     object:self userInfo:nil];
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_NFA_Clear_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

}

// -------------------------------------------------------------------------
-(void)searchViewConfiguration{
    
    nfaSearchView = [[NFASearchView alloc]initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    nfaSearchView.delegate = self;
    [nfaSearchView setHidden:YES];
    [nfaSearchView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:nfaSearchView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:nfaSearchView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:nfaSearchView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:nfaSearchView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                         constant:0];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint]];
}

#pragma mark - CreateNFAViewControllerDelegate Methods

- (void)nfaUpdated:(EGNFA *)mNFAModel {
    
//    [self.nfaPendingViewController loadMore:self.nfaPendingViewController.nfaCollectionView.egPagedDataSource];
//    [self.nfaApprovedViewController loadMore:self.nfaApprovedViewController.nfaCollectionView.egPagedDataSource];
//    [self.nfaRejectedViewController loadMore:self.nfaRejectedViewController.nfaCollectionView.egPagedDataSource];
//    [self.nfaExpiredViewController loadMore:self.nfaExpiredViewController.nfaCollectionView.egPagedDataSource];
    
    [self searchNFAForQuery];
}

@end
