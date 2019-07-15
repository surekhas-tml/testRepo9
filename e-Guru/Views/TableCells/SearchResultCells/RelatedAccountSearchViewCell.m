//
//  RelatedAccountSearchViewCell.m
//  e-Guru
//
//  Created by MI iMac01 on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "RelatedAccountSearchViewCell.h"

@implementation RelatedAccountSearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButtonAccount.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
