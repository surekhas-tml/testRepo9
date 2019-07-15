//
//  FinancierListTableViewCell.m
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierListTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"

@implementation FinancierListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBorder {
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.borderColor = [UIColor pplWiseReportCellBorderColor].CGColor;
}

@end
