//
//  MISalesViewController.h
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueUIButton.h"
#import "EGPagedTableView.h"

@interface MISalesViewController : UIViewController

@property (weak, nonatomic) IBOutlet EGPagedTableView *MIStableview;
@property (weak, nonatomic) IBOutlet BlueUIButton *dateFilterButton;

@end
