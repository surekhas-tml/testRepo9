//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+eGuruColorScheme.h"
#import "Masonry.h"
#import "Constant.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGActivity.h"
#import "AppRepo.h"

@interface MSEventCell : UICollectionViewCell

@property (nonatomic, weak) EGActivity *event;

@property (nonatomic, strong) UILabel *contactName;
@property (nonatomic, strong) UILabel *salesStage;
@property (nonatomic, strong) UILabel *activityType;
@property (nonatomic, strong) UILabel *lob;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *contactNumber;
@property (nonatomic, strong) UILabel *dSENameNumber;

- (void)updateColors;

@end
