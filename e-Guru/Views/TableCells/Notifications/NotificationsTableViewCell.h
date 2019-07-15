//
//  NotificationsTableViewCell.h
//  e-guru
//
//  Created by Ashish Barve on 1/20/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notificationTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationTime;

@end
