//
//  DropDownTextField.m
//  e-Guru
//
//  Created by MI iMac04 on 30/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DropDownTextField.h"
#import "PureLayout.h"
#define HEIGHT_WIDTH 12.0f

@implementation DropDownTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    [self setEnabled:false];
    [self addDropDownIcon];
}

- (void)addDropDownIcon {
    UIImageView *icon = [[UIImageView alloc] init];
    [self addSubview:icon];
    [icon setImage:[UIImage imageNamed:@"temp_blueTriangle"]];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [icon autoSetDimension:ALDimensionWidth toSize:HEIGHT_WIDTH];
    [icon autoSetDimension:ALDimensionHeight toSize:HEIGHT_WIDTH];
    [icon setBackgroundColor:[UIColor clearColor]];

    self.icongImageView = icon;
}

@end
