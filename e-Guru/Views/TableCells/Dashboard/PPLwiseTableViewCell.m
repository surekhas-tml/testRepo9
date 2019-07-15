//
//  PPLwiseTableViewCell.m
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "PPLwiseTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"

@implementation PPLwiseTableViewCell

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
