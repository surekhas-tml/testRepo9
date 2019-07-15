//
//  ActivityViewController.h
//  e-guru
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityTableHederView.h"
#import "ActivityView.h"
#import "UpdateActivityViewController.h"
#import "DashboardViewController.h"
#import "EGCalenderViewCollectionViewController.h"

@interface ActivityViewController : UIViewController<UISplitViewControllerDelegate,ActivityViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    ActivityView *activityView;
     PendingActivitiesListViewController *pendingActivityView;
    }
@property (weak, nonatomic) IBOutlet UIView *legendsCal;
@property (strong, nonatomic) EGCalenderViewCollectionViewController *myCalVC;
- (IBAction)showOrHideCalenderView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *calenderContainer;
- (IBAction)ActivitySearchOpenDrawea:(id)sender;
- (void)setDateRange:(NSString *)dateRange;
- (void)showFilter:(NSString *)filterText;
- (void)hideFilter;
@property (weak, nonatomic) IBOutlet EGPagedTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appliedFilterLabel;
@property (weak, nonatomic) IBOutlet UIView *filterSeparator;
@property (weak, nonatomic) IBOutlet UIButton *calenderView;
@property (weak, nonatomic) IBOutlet UIButton *showDayViewButton;
@property (weak, nonatomic) IBOutlet UILabel *activitiesMissedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchButtonLeading;

- (IBAction)showDayOrWeekView:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySwitchDSE_DSM;

@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (strong, nonatomic) DashboardViewController *dashboardViewController;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;
@property (strong, nonatomic) EGPagedArray *activityList;
@property (assign, nonatomic) BOOL filterApplied;

@property (assign, nonatomic) DSMDSEACTIVITY isdsmdseactivity;

@property (assign, nonatomic) BOOL shouldShowTeamsActivity;

-(void)updateTableView;
- (void)toggleDayViewButton:(BOOL)enable;
- (IBAction)activitySegmentSwitch:(UISegmentedControl *)sender;
@end
