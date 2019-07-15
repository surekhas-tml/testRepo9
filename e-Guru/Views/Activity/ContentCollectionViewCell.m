//
//  ContentCollectionViewCell.m
//  CustomCollection
//
//  Created by Apple on 20/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ContentCollectionViewCell.h"

@implementation ContentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.preferredMaxLayoutWidth = 42;
    // Initialization code
}

@end
