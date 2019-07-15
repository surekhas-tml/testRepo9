//
//  FinancierTabsView.m
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierTabsView.h"
#import "PureLayout.h"
#import "UIColor+eGuruColorScheme.h"

#define CORNER_RADIUS   15.0F

@implementation FinancierTabsView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
        [self makeTopEdgesRound];
    }
    return self;
}

- (void)loadViewFromXib {
    UIView *nib = [[[UINib nibWithNibName:@"FinancierTabsView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

- (void)makeTopEdgesRound {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(CORNER_RADIUS, CORNER_RADIUS)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    // Layer to set border color
    CAShapeLayer *frameLayer = [CAShapeLayer layer];
    frameLayer.frame = self.bounds;
    frameLayer.path = maskPath.CGPath;
    frameLayer.strokeColor = [UIColor grayColor].CGColor;
    frameLayer.fillColor = nil;
    
    [self.layer addSublayer:frameLayer];
}

- (void)setTabSelected:(BOOL)selected {
    
    self.isTabSelected = selected;
    if (selected) {
        [self.button setBackgroundColor:[UIColor themePrimaryColor]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }
    else {
        [self.button setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor themePrimaryColor]];
    }
}

- (void)setStatusOfMandatoryFields:(BOOL)mandatoryFieldsFilled {
    self.mandatoryFilled = mandatoryFieldsFilled;
    if (mandatoryFieldsFilled) {
        [self.statusView setBackgroundColor:[UIColor mandatoryFieldStatusFilledColor]]; //green
    }
    else {
        [self.statusView setBackgroundColor:[UIColor mandatoryFieldStatusEmptyColor]];
    }
}

- (BOOL)getMandatoryFieldsFilledStatus {
    return self.mandatoryFilled;
}

@end

