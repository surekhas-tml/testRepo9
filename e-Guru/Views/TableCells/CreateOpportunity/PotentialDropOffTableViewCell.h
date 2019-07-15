//
//  PotentialDropOffTableViewCell.h
//  e-guru
//
//  Created by Apple on 21/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreyBorderUITextField.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^updateBlock)(NSInteger index);

@interface PotentialDropOffTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *potentialDropOffLabel;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *supportIterventionTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *stakeholderTextField;
- (IBAction)updateActivityClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *stakeholderResponseTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (copy, nonatomic) updateBlock updateActivityBlock;
- (void)onupdatebtnclicked:(updateBlock)blck;
@end

NS_ASSUME_NONNULL_END
