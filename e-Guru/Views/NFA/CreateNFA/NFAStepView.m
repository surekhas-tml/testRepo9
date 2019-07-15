//
//  NFAStepView.m
//  e-guru
//
//  Created by MI iMac04 on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAStepView.h"
#import "PureLayout.h"
#import "UIColor+eGuruColorScheme.h"

#define CURRENT_STEP_FONT [UIFont fontWithName:@"Roboto-Medium" size:16.0f]
#define DEFAULT_STEP_FONT [UIFont fontWithName:@"Roboto-Regular" size:16.0f]

@implementation NFAStepView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCurrentStep:self.isCurrentStep];
}

- (void)loadViewFromXib {
    UIView *nib = [[[UINib nibWithNibName:@"NFAStepView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    [self.button setEnabled:false];
}

- (void)setCurrentStep:(BOOL)currentStep {
    
    self.isCurrentStep = currentStep;
    [self.checkMarkImageView setHidden:!currentStep];
    if (currentStep) {
        [self.stepNameLabel setTextColor:[UIColor themePrimaryColor]];
        [self.stepNameLabel setFont:CURRENT_STEP_FONT];
        [self.button setEnabled:true];
    }
    else {
        [self.stepNameLabel setTextColor:[UIColor themeDisabledColor]];
        [self.stepNameLabel setFont:DEFAULT_STEP_FONT];
        [self.button setEnabled:false];
    }
}

@end
