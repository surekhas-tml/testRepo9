//
//  PotentialDropOffTableViewCell.m
//  e-guru
//
//  Created by Apple on 21/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "PotentialDropOffTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"

@implementation PotentialDropOffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //    _stakeholderTextField.layer.borderColor = [UIColor clearColor].CGColor;
    //    _supportIterventionTextField.layer.borderColor = [UIColor clearColor].CGColor;
    //    _stakeholderResponseTextField.layer.borderColor = [UIColor clearColor].CGColor;
      _potentialDropOffLabel.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    _potentialDropOffLabel.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)updateActivityClicked:(UIButton *)sender {
        self.updateActivityBlock(sender.tag);
    
}
- (void)onupdatebtnclicked:(updateBlock)blck{
        self.updateActivityBlock = blck;
}
@end
