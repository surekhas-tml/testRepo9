//
//  LocationDetailsTableViewCell.h
//  e-guru
//
//  Created by Apple on 21/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *talukaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *microMarketNameLAbel;
@property (weak, nonatomic) IBOutlet UILabel *lobNameLabel;

@end

NS_ASSUME_NONNULL_END
