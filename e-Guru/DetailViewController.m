//
//  DetailViewController.m
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    [self addChildViewController:self.myOptyVC];
    [self.searchOptyContainer addSubview:self.myOptyVC.view];
    [self.myOptyVC.view setFrame:self.searchOptyContainer.bounds];
    [self.myOptyVC didMoveToParentViewController:self];
    
    
    [self addChildViewController:self.myCalVC];
    [self.calenderHolder addSubview:self.myCalVC.view];
    [self.myCalVC.view setFrame:self.calenderHolder.bounds];
    [self.myCalVC didMoveToParentViewController:self];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = MYPAGE;
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_MyPage];

    [UtilityMethods navigationBarSetupForController:self];
    
  _currentdatelbl.text = [NSDate getDate:[NSDate date] InFormat:currentDateFormat];
    [self configureView];
}

-(ManageOpportunityViewController *)myOptyVC{
    if (_myOptyVC == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:[NSBundle mainBundle]];
        _myOptyVC = [storyboard instantiateViewControllerWithIdentifier:@"Manage Opportunity_View"];
        _myOptyVC.parentVC = MYPAGE;
    }
    return _myOptyVC;
    }

-(EGCalenderViewCollectionViewController *)myCalVC{
    if (_myCalVC == nil) {
        _myCalVC = [[EGCalenderViewCollectionViewController alloc] initWithViewMode:MSDayView];
        _myCalVC.invokedFrom = MyPage;
        if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
            _myCalVC.activity=@"My_Activity";
        }else{
             _myCalVC.activity=@"Team_Activity";
        }
    }
    return _myCalVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}
@end
