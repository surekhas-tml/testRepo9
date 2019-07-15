//
//  RelatedOptySearchResultViewCell.h
//  e-Guru
//
//  Created by MI iMac01 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RelatedOptySearchResultViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * label;

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesStageLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pplLabel;
@property (weak, nonatomic) IBOutlet UILabel *optyCreatedDateLabel;
@property (weak, nonatomic) IBOutlet CustomButton *viewOptyButton;

@end
