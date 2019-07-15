//
//  DSEwiseViewController.h
//  e-guru
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"
#import "EGDse.h"
#import "BlueUIButton.h"
@interface DSEwiseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet EGPagedTableView *DSEwiseTableView;
@property (weak, nonatomic) IBOutlet BlueUIButton *dateFilterButton;
- (IBAction)filterButtonTapped:(id)sender;
- (IBAction)liveTillDateButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet BlueUIButton *liveTillDateButton;
@end
