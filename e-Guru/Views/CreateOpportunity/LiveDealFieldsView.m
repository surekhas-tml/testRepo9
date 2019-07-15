//
//  LiveDealFieldsView.m
//  e-Guru
//
//  Created by MI iMac04 on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LiveDealFieldsView.h"
#import "PureLayout.h"

@implementation LiveDealFieldsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUIFromXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUIFromXib];
    }
    return self;
}

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"LiveDealFieldsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

//- (LiveDealFieldsView *)loadUIFromXib {
//    
//    LiveDealFieldsView *liveDealFieldsView;
//    NSArray *viewStack = [[NSBundle mainBundle] loadNibNamed:@"LiveDealFieldsView" owner:self options:nil];
//    for (id view in viewStack) {
//        
//        if ([view isKindOfClass:[UIView class]]) {
//            liveDealFieldsView = view;
//        }
//    }
//    return liveDealFieldsView;
//}

@end
