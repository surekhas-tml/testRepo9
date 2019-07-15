//
//  PPLwiseChildTableViewCell.m
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "PPLwiseChildTableViewCell.h"
#import "PureLayout.h"

@implementation PPLwiseChildTableViewCell

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
    UIView *nib = [[[UINib nibWithNibName:@"PPLwiseChildTableViewCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

@end
