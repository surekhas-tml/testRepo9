//
//  EGCalenderViewControllerCollectionViewController.h
//  e-guru
//
//  Created by local admin on 12/20/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCollectionViewCalendarLayout.h"
#import "EGMSCollectionViewCalendarLayout.h"
#import "EGActivity.h"
// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "UpdateActivityViewController.h"
#import "WeekCalendarViewController.h"
#import "NSDate+eGuruDate.h"

@class ActivityViewController;
@interface EGCalenderViewCollectionViewController : UICollectionViewController{
    BOOL isFilterSet;
    
}
@property (strong, nonatomic) DashboardViewController *dashboardViewController;
@property (strong, nonatomic) WeekCalendarViewController *weekViewController;
@property (assign, nonatomic) InvokedFrom invokedFrom;
@property (nonatomic, strong) NSString *viewMode;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;
@property (strong, nonatomic) ActivityViewController *activityViewController;
@property (strong, nonatomic) WeekCalendarViewController *weekCalendarViewController;
@property (strong, nonatomic) NSString *activity;

- (void)searchActivityWithQueryParameters:(NSDictionary *)queryParams;
- (id)initWithViewMode:(NSString *)mode;
-(void)refreshCollectionView;
-(void)filterAppliedWithQueryParams:(NSDictionary *)queryParams;
-(void)resetFilter;
-(void)refreshMode;
@end
