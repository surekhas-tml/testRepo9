//
//  DSEwiseTableViewCell.h
//  e-guru
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSEwiseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DSENameLabel;
@property (weak, nonatomic) IBOutlet UILabel *c0Label;
@property (weak, nonatomic) IBOutlet UILabel *c1Label;
@property (weak, nonatomic) IBOutlet UILabel *c1ALabel;
@property (weak, nonatomic) IBOutlet UILabel *c2Label;
@property (strong, nonatomic) IBOutlet UILabel *R1Label;
@property (strong, nonatomic) IBOutlet UILabel *R2Label;
@property (strong, nonatomic) IBOutlet UILabel *c0qtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *c1qtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *c1AqtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *c2qtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *retailLabel;

@end
