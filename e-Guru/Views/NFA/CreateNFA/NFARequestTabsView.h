//
//  NFARequestTabsView.h
//  e-guru
//
//  Created by MI iMac04 on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAUIHelper.h"
#import "CircularView.h"

@interface NFARequestTabsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CircularView *statusView;

@property (assign, nonatomic) NFASectionType sectionType;
@property (assign, nonatomic) BOOL isTabSelected;
@property (assign, nonatomic) BOOL mandatoryFilled;

- (BOOL)getMandatoryFieldsFilledStatus;
- (void)setTabSelected:(BOOL)selected;
- (void)setStatusOfMandatoryFields:(BOOL)mandatoryFieldsFilled;

@end
