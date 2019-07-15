//
//  InfluencerViewController.h
//  e-guru
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateActivityViewController.h"
#import "DashboardViewController.h"
#import "DropDownViewController.h"
#import "DropDownTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfluencerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DropDownViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *soureOfContactCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *mmGeoTableView;
@property (weak, nonatomic) IBOutlet UITableView *soureOfContactTableView;
@property (weak, nonatomic) IBOutlet UISwitch *manageInfluencerSwitch;
- (IBAction)manageInfluencerSwitchMethod:(id)sender;
@property (assign, nonatomic) InvokedFrom invokedFrom;
//@property (strong, nonatomic) DashboardViewController *dashboardViewController;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldDSEDropDown;
@property (weak, nonatomic) IBOutlet UILabel *lblSlideToManage;

@end

NS_ASSUME_NONNULL_END
