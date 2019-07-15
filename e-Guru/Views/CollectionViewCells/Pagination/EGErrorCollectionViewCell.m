//
//  EGErrorCollectionViewCell.m
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGErrorCollectionViewCell.h"

@implementation EGErrorCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.refreshButton.layer.cornerRadius = 4.0f;
}
- (IBAction)refreshButtonClicked:(id)sender {
    
    [self.loaderView setHidden:false];
    
}
@end
