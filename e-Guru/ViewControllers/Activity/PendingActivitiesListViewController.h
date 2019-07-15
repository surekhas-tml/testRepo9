//
//  PendingActivitiesListViewController.h
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingActivityTableViewCell.h"
#import "PendingActivityTableViewHeader.h"
#import "UpdateActivityViewController.h"
#import "EGContact.h"
#import "EGActivity.h"
#import "EGPagedTableView.h"
#import "EGPagedTableViewDataSource.h"
#import "NSDate+eGuruDate.h"

@protocol PendingActivitiesListViewControllerDelegate<NSObject>
@end
@interface PendingActivitiesListViewController : UIViewController<PendingActivityTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,UISplitViewControllerDelegate,EGPagedTableViewDelegate>
@property (strong,nonatomic) EGContact *contact;
@property (strong,nonatomic) EGOpportunity *opportunity;
@property (strong,nonatomic) EGFinancierOpportunity *financierOpportunity;

@property (weak, nonatomic) id<PendingActivitiesListViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet EGPagedTableView *activityTable;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastname;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumebr;
@property (weak, nonatomic) IBOutlet UILabel *noOfPendingActivities;
@property (strong, nonatomic)NSString *currentpendingActivityUser;

@property (weak, nonatomic) IBOutlet UIButton *financierButton;

@property (nonatomic, assign) BOOL isActivityUpdated;

@end
