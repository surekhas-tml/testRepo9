//
//  ActualVsTargetViewController.h
//  e-guru
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"
#import "EGDse.h"
@interface ActualVsTargetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet EGPagedTableView *TargetVsActualTableView;
@end
