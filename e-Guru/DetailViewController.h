//
//  DetailViewController.h
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserDetails.h"
#import "UtilityMethods.h"
#import "ManageOpportunityViewController.h"
#import "EGCalenderViewCollectionViewController.h"
#import "NSDate+eGuruDate.h"
@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>
    
@property (weak, nonatomic) IBOutlet UIView *calContainer;
@property (weak, nonatomic) IBOutlet UIView *searchOptyContainer;
@property (weak, nonatomic) IBOutlet UILabel *currentdatelbl;
@property (weak, nonatomic) IBOutlet UIView *calenderHolder;
@property (strong, nonatomic) ManageOpportunityViewController *myOptyVC;
@property (strong, nonatomic) EGCalenderViewCollectionViewController *myCalVC;

@end


