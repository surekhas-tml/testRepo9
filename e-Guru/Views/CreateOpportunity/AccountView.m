//
//  AccountView.m
//  e-Guru
//
//  Created by MI iMac04 on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AccountView.h"
#import "PureLayout.h"

@implementation AccountView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUIFromXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUIFromXib];
    }
    return self;
}

- (void)loadUIFromXib {
    UIView *nib = [[[UINib nibWithNibName:@"AccountView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

@end
