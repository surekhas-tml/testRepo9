//
//  ActivityTableViewCellDSM.h
//  e-guru
//
//  Created by MI iMac04 on 17/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCellDSM : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesStageLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pplLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannedDateAndTime;
@property (weak, nonatomic) IBOutlet UILabel *dseName;

@end
