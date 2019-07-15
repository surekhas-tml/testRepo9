//
//  PPLwiseTableViewCell.h
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLwiseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pplName;
@property (weak, nonatomic) IBOutlet UILabel *c0OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c0VehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c1OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c1VehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c1AOptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c1AVehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c2OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c2VehicleCount;

@property (weak, nonatomic) IBOutlet UIButton *caretButton;
@property (strong, nonatomic) IBOutlet UILabel *currentStockCount;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)setBorder;


@end
