//
//  NFACollectionViewCell.m
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFACollectionViewCell.h"

@implementation NFACollectionViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0f;
}
- (IBAction)updateNFAAction:(id)sender {
//    [self.delegate updateNFAForTag:sender];
}
@end
