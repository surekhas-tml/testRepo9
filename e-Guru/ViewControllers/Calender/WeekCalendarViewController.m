//
//  WeekCalendarViewController.m
//  e-guru
//
//  Created by local admin on 12/21/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "WeekCalendarViewController.h"
#import "EGCalenderViewCollectionViewController.h"

@interface WeekCalendarViewController ()<ActivityViewDelegate>
{
    ActivityView *activityView;
    UITapGestureRecognizer *tapRecognizer;
    EGCalenderViewCollectionViewController *myCalVC;
   

}

@end

@implementation WeekCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addChildViewController:self.myCalVC];
    [self.calenderContainer addSubview:self.myCalVC.view];
    [self.myCalVC.view setFrame:self.calenderContainer.bounds];
    self.filterButton.layer.cornerRadius = 5.0f;
    self.dayViewSwitchButton.layer.cornerRadius = 5.0f;
if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
    self.activitysegement.hidden=NO;
}
else{
    self.activitysegement.hidden=YES;

}
    [self.myCalVC didMoveToParentViewController:self];
    if (self.invokedFrom == Home) {
        [UtilityMethods navigationBarSetupForController:self];
    }
    [self searchViewConfiguration];
    [self addGestureRecogniserToView];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_CalenderPage];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
         _activitySwitchDSE_DSM.hidden=NO;
     }
     else{
         _activitySwitchDSE_DSM.hidden=YES;
     }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(EGCalenderViewCollectionViewController *)myCalVC{
    if (myCalVC== nil) {
        myCalVC = [[EGCalenderViewCollectionViewController alloc] initWithViewMode:MSWeekView];
        myCalVC.activity = @"My_Activity";
        myCalVC.invokedFrom = self.invokedFrom;
        myCalVC.weekViewController = self;
    }
    return myCalVC;
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}
-(void)searchViewConfiguration{
    
    activityView = [[ActivityView alloc]initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    activityView.delegate = self;
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        activityView.currentActivityUser = @"My_Activity";
    }
    [activityView setHidden:YES];
    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:activityView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:activityView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                         constant:0];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint]];
    
    
}
#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodToDissmissSearchView:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (![activityView isHidden]) {
        if (![touch.view isDescendantOfView:activityView]) {
            return YES;
        }
    }else{
        return NO;
    }
    return NO;
}
-(void)gestureHandlerMethodToDissmissSearchView:(id)sender{
    if (![activityView isHidden]) {
        [activityView CloseDrawer:sender];
    }
}
- (IBAction)openFilter:(id)sender{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    [activityView.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:activityView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [activityView setHidden:!activityView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@"Search Open");
                    }];
}
- (void)searchWithActivityDictionary:(NSDictionary *)searchQuery {
    [self.myCalVC filterAppliedWithQueryParams:searchQuery];
}
-(IBAction)switchNumberOfDays:(id)sender{
    if ([myCalVC.viewMode isEqualToString:MSWeekView]) {
        myCalVC.viewMode =  MSDayView;
        [self.dayViewSwitchButton setTitle:@"Switch to Week View" forState:UIControlStateNormal];
    }else if ([myCalVC.viewMode isEqualToString:MSDayView]) {
        myCalVC.viewMode = MSWeekView;
        [self.dayViewSwitchButton setTitle:@"Switch to Day View" forState:UIControlStateNormal];
    }
    [myCalVC refreshMode];

}

- (void)toggleDayViewButton:(BOOL)enable {
    if (enable) {
        [self.dayViewSwitchButton setBackgroundColor:[UIColor themePrimaryColor]];
        [self.dayViewSwitchButton setEnabled:true];
    }
    else {
        [self.dayViewSwitchButton setBackgroundColor:[UIColor themeDisabledColor]];
        [self.dayViewSwitchButton setEnabled:false];
    }
}

- (IBAction)activitySegmentswitch:(UISegmentedControl *)sender {
}

-(void)hideFilter{
    [myCalVC resetFilter];
    [self gestureHandlerMethodToDissmissSearchView:nil];

}

- (IBAction)activitySegmentSwitch:(UISegmentedControl *)sender {
    UpdateActivityViewController *updateactivity=[[UpdateActivityViewController alloc]init];
    if (![activityView isHidden]) {
        [activityView CloseDrawer:sender];
    }
    
    if (sender.selectedSegmentIndex == 0) {//My Activity
        [activityView setCurrentUser:@"My_Activity"];
        updateactivity.checkuser=@"My_Activity";
        
        self.myCalVC.activity = @"My_Activity";
    }
    else{//Team Opportunity
        [activityView setCurrentUser:@"Team_Activity"];
        updateactivity.checkuser=@"Team_Activity";
        self.myCalVC.activity = @"Team_Activity";
    }
     [myCalVC refreshMode];
    //Refrersh Calender View
    
}

@end
