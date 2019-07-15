//
//  AdditionalView.m
//  e-guru
//
//  Created by Admin on 29/01/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "AdditionalView.h"
#import "PureLayout.h"

@implementation AdditionalView

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
    UIView *nib = [[[UINib nibWithNibName:@"AdditionalView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}


@end
