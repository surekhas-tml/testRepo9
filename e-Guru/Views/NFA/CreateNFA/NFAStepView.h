//
//  NFAStepView.h
//  e-guru
//
//  Created by MI iMac04 on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFAStepView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *stepNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic) BOOL isCurrentStep;

- (void)setCurrentStep:(BOOL)currentStep;

@end
