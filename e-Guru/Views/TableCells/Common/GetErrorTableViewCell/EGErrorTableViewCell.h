//
//  EGErrorTableViewCell.h
//  e-guru
//
//  Created by MI iMac01 on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGErrorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@end
