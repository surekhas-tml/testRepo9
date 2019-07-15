//
//  DraftsViewController.h
//  e-Guru
//
//  Created by Apple on 29/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "ProspectViewController.h"
#import "CreateOpportunityViewController.h"


@interface DraftsViewController : UIViewController<UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contact_view;
@property (weak, nonatomic) IBOutlet UIView *account_view;
@property (weak, nonatomic) IBOutlet UIView *drafts_not_availble_view;
@property (weak, nonatomic) IBOutlet UIView *opportunity_view;
@property (weak, nonatomic) IBOutlet UIView *financier_view;  //new
@property (weak, nonatomic) IBOutlet UILabel *notavailbledrafts;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_contact;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_account;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_opportunity;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_financier; //new

@property (strong,nonatomic)NSString * detailsObj;
@property (strong,nonatomic)NSString * entryPoint;



@end
