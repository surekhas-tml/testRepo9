//
//  MyTeamViewController.h
//  e-guru
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamViewModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface MyTeamViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate>


//
@property (weak, nonatomic) IBOutlet UITableView *dseTableView;
@property (weak, nonatomic) IBOutlet UIButton *fetchDSEButton;
@property (weak, nonatomic) IBOutlet UISwitch *manageMMGEOSwitch;
- (IBAction)fetchDSEMethod:(id)sender;
- (IBAction)manageLocationMethod:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *mmgeoCollectionView;





@end

NS_ASSUME_NONNULL_END
