//
//  BeatPlanHomeViewController.m
//  e-guru
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "BeatPlanHomeViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "HHSlideView.h"
#import "MyTeamViewController.h"
#import "InfluencerViewController.h"

#define TITLE_MY_TEAM               @"My Team"
#define TITLE_MY_INFLUENCER         @"My Influencer"
#define TITLE_MY_CUSTOMER           @"My Customer"
#define TITLE_PARAMETER_SETTINGS    @"Parameter Settings"
#define TITLE_EXCLUSION             @"Exclusion"

typedef enum {
    TabMyTeam,
    TabInfluencer,
    TabCustomer,
    TabParamaterSettings,
    TabExclusion,
}TabName;

@interface BeatPlanHomeViewController () <HHSlideViewDelegate>

@property (strong, nonatomic) HHSlideView *slideView;
@property (strong, nonatomic) NSMutableArray *viewControllersArray;
@property (strong, nonatomic) NSMutableArray *viewControllersTitleArray;
@end

@implementation BeatPlanHomeViewController
UILabel *lblTemp;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.dashboardNavigationController = self.navigationController;
    [UtilityMethods navigationBarSetupForController:self];
    [self.view addSubview:self.slideView];
    [self.navigationController setTitle:BEATPLAN];
    
    lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, 50)];
    lblTemp.backgroundColor = [UIColor whiteColor];
    lblTemp.text = TITLE_MY_TEAM;
    lblTemp.textAlignment = NSTextAlignmentCenter;
    [lblTemp setFont:[UIFont systemFontOfSize:16]];
    [lblTemp setTextColor:[UIColor navBarColor]];
    [self.view addSubview:lblTemp];
}

-(void) viewWillAppear:(BOOL)animated{
    [UtilityMethods navigationBarSetupForController:self];
}
-(void)viewDidAppear:(BOOL)animated{
    MyTeamViewController *VC = [self.viewControllersArray firstObject];
    if ([VC isKindOfClass:[MyTeamViewController class]]) {
        //            if (VC.activityList.count > 0) {
        //                [VC.activityList clearAllItems];
        //                [VC.tableView reloadData];
        //            }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (HHSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[HHSlideView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        _slideView.delegate = self;
        _slideView.isFromBeatPlan = YES;
    }
    return _slideView;
}

- (NSMutableArray *)viewControllersArray {
    if (!_viewControllersArray) {
        _viewControllersArray = [[NSMutableArray alloc] init];
        if([[AppRepo sharedRepo] isDSMUser])
        {
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMyTeam]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabInfluencer]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabCustomer]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabParamaterSettings]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabExclusion]];
        }
        else{
            [_viewControllersArray addObject:[self getViewControllerForTab:TabMyTeam]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabInfluencer]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabCustomer]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabParamaterSettings]];
            [_viewControllersArray addObject:[self getViewControllerForTab:TabExclusion]];
        }
    }
    return _viewControllersArray;
}

- (NSMutableArray *)viewControllersTitleArray {
    if (!_viewControllersTitleArray) {
        _viewControllersTitleArray = [[NSMutableArray alloc] init];
        if([[AppRepo sharedRepo] isDSMUser])
        {
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN];
            [_viewControllersTitleArray addObject:TITLE_MY_TEAM];
            [_viewControllersTitleArray addObject:TITLE_MY_INFLUENCER];
            [_viewControllersTitleArray addObject:TITLE_MY_CUSTOMER];
            [_viewControllersTitleArray addObject:TITLE_PARAMETER_SETTINGS];
            [_viewControllersTitleArray addObject:TITLE_EXCLUSION];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN];
        }
        else{
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN];
            [_viewControllersTitleArray addObject:TITLE_MY_TEAM];
            [_viewControllersTitleArray addObject:TITLE_MY_INFLUENCER];
            [_viewControllersTitleArray addObject:TITLE_MY_CUSTOMER];
            [_viewControllersTitleArray addObject:TITLE_PARAMETER_SETTINGS];
            [_viewControllersTitleArray addObject:TITLE_EXCLUSION];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN];
        }
    }
    return _viewControllersTitleArray;
}

#pragma mark - Private Methods

- (UIViewController *)getViewControllerForTab:(TabName)tabName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BeatPlan" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;

    switch (tabName) {
        case TabMyTeam:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MyTeamVCIdentifier"];
            break;
        case TabInfluencer:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"InfluencerVCIdentifier"];
            ((InfluencerViewController *)viewController).invokedFrom = Influencer;
            break;
        case TabCustomer:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"InfluencerVCIdentifier"];//CustomerVCIdentifier
            ((InfluencerViewController *)viewController).invokedFrom = MyCustomer;
            break;
        case TabParamaterSettings:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"ParameterSettingsVCIdentifier"];
            break;
        case TabExclusion:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"ExclusionVCIdentifier"];
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
            case TabMyTeam:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_MYTEAM];

                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_TEAM;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabInfluencer:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_INFLUENCER];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_INFLUENCER;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabCustomer:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_CUSTOMER];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(2*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_CUSTOMER;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabParamaterSettings:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_PARAMETERSETTINGS];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(3*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_PARAMETER_SETTINGS;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabExclusion:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_EXCLUSION];

                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(4*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_EXCLUSION;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
        }
    }
    else{
        switch (index) {
            case TabMyTeam:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_MYTEAM];
                break;
            case TabInfluencer:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_INFLUENCER];
                break;
            case TabCustomer:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_CUSTOMER];
                break;
            case TabParamaterSettings:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_PARAMETERSETTINGS];
                break;
            case TabExclusion:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_EXCLUSION];
                break;
        }
    }
}

- (void)didSlideToButton:(UIButton *)slideToButton{
    NSLog(@"%ld",(long)slideToButton.tag);
    if ([[AppRepo sharedRepo] isDSMUser]) {
        switch (slideToButton.tag) {
            case TabMyTeam:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_MYTEAM];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_TEAM;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabInfluencer:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_INFLUENCER];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_INFLUENCER;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabCustomer:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_CUSTOMER];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(2*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_MY_CUSTOMER;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabParamaterSettings:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_PARAMETERSETTINGS];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(3*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_PARAMETER_SETTINGS;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
            case TabExclusion:{
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_EXCLUSION];
                
                [lblTemp removeFromSuperview];
                lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(4*(SCREEN_WIDTH/5), 0, SCREEN_WIDTH/5, 50)];
                lblTemp.backgroundColor = [UIColor whiteColor];
                lblTemp.text = TITLE_EXCLUSION;
                lblTemp.textAlignment = NSTextAlignmentCenter;
                [lblTemp setFont:[UIFont systemFontOfSize:16]];
                [lblTemp setTextColor:[UIColor navBarColor]];
                [self.view addSubview:lblTemp];
            }
                break;
        }
    }
    else{
        switch (slideToButton.tag) {
            case TabMyTeam:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_MYTEAM];
                break;
            case TabInfluencer:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_INFLUENCER];
                break;
            case TabCustomer:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_CUSTOMER];
                break;
            case TabParamaterSettings:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_PARAMETERSETTINGS];
                break;
            case TabExclusion:
                [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Dashboard_BEAT_PLAN_EXCLUSION];
                break;
        }
    }
}

- (UIColor *)colorOfSliderInSlideView:(HHSlideView *)slideView {
    return [UIColor clearColor];
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
