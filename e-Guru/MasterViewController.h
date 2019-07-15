//
//  MasterViewController.h
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserDetails.h"
#import "Constant.h"
#import "UtilityMethods.h"
#import "ManageOpportunityViewController.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController 

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *menueArray;

- (void)openActivityScreenWithTeamsActivityForNotification:(BOOL) forNotification;

@end

