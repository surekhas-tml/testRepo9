//
//  ContactAndAccountView.m
//  e-Guru
//
//  Created by Ashish Barve on 11/27/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ContactView.h"
#import "PureLayout.h"

@implementation ContactView

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
    UIView *nib = [[[UINib nibWithNibName:@"ContactView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

@end
