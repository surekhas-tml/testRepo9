//
//  RelatedAccountSearchViewCell.h
//  e-Guru
//
//  Created by MI iMac01 on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RelatedAccountSearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPANLabel;
@property (weak, nonatomic) IBOutlet CustomButton *selectButtonAccount;

@end
