//
//  DashboardViewController.m
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "HHSlideView.h"
#import "ActivityViewController.h"
#import "PPLwiseViewController.h"
#import "MMGEOwiseViewController.h"
#import "MMAPPwiseViewController.h"
#import "MISalesViewController.h"
#import "ActualVsTargetViewController.h"
#import "DSEwiseViewController.h"
#define TITLE_ACTIVITY      @"Activity"
#define TITLE_PPL_WISE      @"PPLwise Pipeline"
#define TITLE_MM_GEO_WISE   @"MM GEOwise Pipeline"
#define TITLE_MM_APP_WISE   @"MM APPwise Pipeline"
#define TITLE_MI_SALES      @"MIS Sales"
#define TITLE_DSE_WISE      @"DSEwise Pipeline"
#define TITLE_TARGET_ACTUAL      @"My Goal"

typedef enum {
    
    TabTargetVsActual,
    TabActivity,
    TabPPLwise,
    TabMMGEOwise,
    TabMMAppwise,
    TabMISales,
    TabDSEwise,
    
}TabName;

@interface DashboardViewController () <HHSlideViewDelegate>

@property (strong, nonatomic) HHSlideView *slideView;
@property (strong, nonatomic) NSMutableArray *viewControllersArray;
@property (strong, nonatomic) NSMutableArray *viewControllersTitleArray;

@property (nonatomic, strong) ActivityViewController *activityViewController;
@property (nonatomic, strong) PPLwiseViewController *pplwiseViewController;
@property (nonatomic, strong) MMGEOwiseViewController *mmgeowiseViewController;
@property (nonatomic, strong) MMAPPwiseViewController *mmappwiseViewController;
@property (nonatomic, strong) MISalesViewController *miSalesViewController;
@property (nonatomic, strong) ActualVsTargetViewController *actualVsTargetViewController;
@property (nonatomic, strong) DSEwiseViewController *dsewiseViewController;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.dashboardNavigationController = self.navigationController;
    [UtilityMethods navigationBarSetupForController:self];
    [self.view addSubview:self.slideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HHSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[HHSlideView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _slideView.delegate = self;
    }
    return _slideView;
}
-(void) viewWillAppear:(BOOL)animated{
    
    [UtilityMethods navigationBarSetupForController:self];
}
-(void)viewDidAppear:(BOOL)animated{
    
    ActivityViewController *VC = [self.viewControllersArray firstObject];
    if ([VC isKindOfClass:[ActivityViewController class]]) {
        if (VC.activityList.count > 0) {
            [VC.activityList clearAllItems];
            [VC.tableView reloadData];
        }
    }
}
- (NSMutableArray *)viewControllersArray {
    if (!_viewControllersArray) {
        _viewControllersArray = [[NSMutableArray alloc] init];
        if([[AppRepo sharedRepo] isDSMUser])
        {
            [_viewControllersArray addObject:[self getViewControllerForTab:TabDSEwise]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabActivity]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabPPLwise]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMISales]];
        }
        else{
             [_viewControllersArray addObject:[self getViewControllerForTab:TabTargetVsActual]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabActivity]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabPPLwise]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMMGEOwise]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMMAppwise]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMISales]];
            
        }
    }
    return _viewControllersArray;
}


- (NSMutableArray *)viewControllersTitleArray {
    if (!_viewControllersTitleArray) {
        _viewControllersTitleArray = [[NSMutableArray alloc] init];
        if([[AppRepo sharedRepo] isDSMUser])
        {
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_DSEWise];
            [_viewControllersTitleArray addObject:TITLE_DSE_WISE];
            [_viewControllersTitleArray addObject:TITLE_ACTIVITY];
            [_viewControllersTitleArray addObject:TITLE_PPL_WISE];
            [_viewControllersTitleArray addObject:TITLE_MI_SALES];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_DSEWise];

        }
        else{
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_Activity];
            [_viewControllersTitleArray addObject:TITLE_TARGET_ACTUAL];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_Activity];
            [_viewControllersTitleArray addObject:TITLE_ACTIVITY];
            [_viewControllersTitleArray addObject:TITLE_PPL_WISE];
            [_viewControllersTitleArray addObject:TITLE_MM_GEO_WISE];
            [_viewControllersTitleArray addObject:TITLE_MM_APP_WISE];
            [_viewControllersTitleArray addObject:TITLE_MI_SALES];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_TargetVSActual];

        }
    }
    return _viewControllersTitleArray;
}

#pragma mark - Private Methods

- (UIViewController *)getViewControllerForTab:(TabName)tabName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;
    
    switch (tabName) {
        case TabActivity:
            
            storyboard = [UIStoryboard storyboardWithName:@"Activity" bundle:[NSBundle mainBundle]];
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"Activity_View"];
            ((ActivityViewController *)viewController).invokedFrom = Dashboard;
            ((ActivityViewController *)viewController).dashboardViewController = self;
            break;
            
        case TabPPLwise:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"PPLwiseViewController"];
            break;
        case TabMMGEOwise:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MMGEOwiseViewController"];
            break;
        case TabMMAppwise:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MMAPPwiseViewController"];
            break;
        case TabMISales:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MISalesViewController"];
            break;
        case TabDSEwise:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"DSEwiseViewController"];
            break;
        case TabTargetVsActual:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"ActualVsTargetViewController"];
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
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        switch (index) {
            case TabDSEwise:
                NSLog(@"M dse");
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_DSEWise];
                break;
                
            case TabActivity:
                NSLog(@"m activity");
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_Activity];
                break;
            case TabPPLwise:
                NSLog(@"m ppl");
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_PPLWisePipeline];
                break;
            case TabMISales:
                NSLog(@"m mis");
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_MisSales];
                break;
            
        }

    }
    else{
        switch (index) {
            case TabActivity:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_Activity];
                NSLog(@"activity");
            }
                break;
                
            case TabPPLwise:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_PPLWisePipeline];
                NSLog(@"ppl wise");
            }
                break;
            case TabMMGEOwise:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_MMGeoWisePipeline];
                NSLog(@"mm geo wise");
            }
                break;
            case TabMMAppwise:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_MMAppWisePipeline];
                NSLog(@"mm app wise");
            }
                break;
            case TabMISales:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_MisSales];
                NSLog(@"mis sale");
            }
                break;
            case TabTargetVsActual:{
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_TargetVSActual];
            NSLog(@"TargetVSActual");
            }
            break;
    }
    }
}

- (UIColor *)colorOfSliderInSlideView:(HHSlideView *)slideView {
    return [UIColor slideViewSliderColor];
}

- (UIColor *)colorOfSlideView:(HHSlideView *)slideView {
    return [UIColor tableHeaderColor];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

@end
