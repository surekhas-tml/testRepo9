//
//  PendingActivityTableViewCell.h
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PendingActivityTableViewCellDelegate



@end
@interface PendingActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *plannedDate;
@property (weak, nonatomic) IBOutlet UILabel *plannedTime;
@property (weak, nonatomic) IBOutlet UILabel *activityType;
@property (weak, nonatomic) IBOutlet UILabel *activityStatus;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UIButton *editActivityButton;
- (IBAction)editActivityAction:(id)sender;

@end
