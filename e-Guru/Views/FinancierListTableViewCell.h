//
//  FinancierListTableViewCell.h
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//
//Local
#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface FinancierListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CustomButton *radioRetailButton;

@property (weak, nonatomic) IBOutlet UILabel     *financierNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *optyIDLabel;
@property (weak, nonatomic) IBOutlet UILabel     *caseIDLabel;
@property (weak, nonatomic) IBOutlet UILabel     *caseStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel     *integrationStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel     *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UILabel     *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *plusIconImage;
//@property (weak, nonatomic) IBOutlet UIButton    *previewButton;
@property (weak, nonatomic) IBOutlet CustomButton *previewButton;

@property (weak, nonatomic) IBOutlet  UIView    *containerView;

- (void)setBorder;

@end
