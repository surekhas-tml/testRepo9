//
//  PPLwiseViewController.h
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueUIButton.h"

@interface PPLwiseViewController : UIViewController

@property (weak, nonatomic) IBOutlet BlueUIButton *dateFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *liveTillDateButton;

@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentStockLabel;

@end



