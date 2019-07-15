//
//  PendingActivityTableViewHeader.h
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+eGuruColorScheme.h"
@interface PendingActivityTableViewHeader : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *planedDate;
@property (weak, nonatomic) IBOutlet UILabel *plannedTime;
@property (weak, nonatomic) IBOutlet UILabel *activityType;
@property (weak, nonatomic) IBOutlet UILabel *activityStatus;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end
