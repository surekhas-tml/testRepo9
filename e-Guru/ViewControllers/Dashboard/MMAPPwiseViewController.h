//
//  MMAPPwiseViewController.h
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"
#import "BlueUIButton.h"

@interface MMAPPwiseViewController : UIViewController
@property (weak, nonatomic) IBOutlet EGPagedTableView *mmAppwiseTableView;
@property (weak, nonatomic) IBOutlet BlueUIButton *dateFilterButton;
@property (weak, nonatomic) IBOutlet BlueUIButton *liveTillDateButton;

@end
