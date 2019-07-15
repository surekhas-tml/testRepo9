//
//  WeekCalendarViewController.h
//  e-guru
//
//  Created by local admin on 12/21/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityMethods.h"
#import "ActivityView.h"
#import "DashboardViewController.h"

@interface WeekCalendarViewController : UIViewController{
}
@property (strong, nonatomic) DashboardViewController *dashboardViewController;
@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (weak, nonatomic) IBOutlet UIView *calenderContainer;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
- (IBAction)openFilter:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dayViewSwitchButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySwitchDSE_DSM;
- (IBAction)switchNumberOfDays:(id)sender;
- (IBAction)calVieButton:(id)sender;

- (void)toggleDayViewButton:(BOOL)enable;
- (IBAction)activitySegmentswitch:(UISegmentedControl *)sender;
- (IBAction)activitySegmentSwitch:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *activitysegement;

@end
