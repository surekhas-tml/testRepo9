//
//  RelatedContactSearchResultViewCell.h
//  e-Guru
//
//  Created by MI iMac01 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RelatedContactSearchResultViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firsrtNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNoLabel;
@property (weak, nonatomic) IBOutlet CustomButton *createNewOptyButton;
@property (weak, nonatomic) IBOutlet CustomButton *selectButton;


@end
