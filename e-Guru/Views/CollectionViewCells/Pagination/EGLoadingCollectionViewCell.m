//
//  EGLoadingCollectionViewCell.m
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGLoadingCollectionViewCell.h"

@implementation EGLoadingCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
    [self.loadingIndicator startAnimating];
    self.loadingIndicator.layer.cornerRadius = 4.0f;
}
@end
