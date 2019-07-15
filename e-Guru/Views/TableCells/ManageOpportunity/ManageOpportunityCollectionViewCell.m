//
//  ManageOpportunityCollectionViewCell.m
//  e-Guru
//
//  Created by Juili on 02/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ManageOpportunityCollectionViewCell.h"
#import "AppRepo.h"

@implementation ManageOpportunityCollectionViewCell

    -(void)awakeFromNib{
        [super awakeFromNib];
        self.layer.cornerRadius = 5.0f;
        
    }
- (IBAction)recycleBin:(id)sender {
    [self.delegate deleteCellAtIndex:(long)[(UIButton *)sender tag]];
}
@end
