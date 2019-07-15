//
//  FinancierTabsView.h
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAUIHelper.h"
#import "CircularView.h"

@interface FinancierTabsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CircularView *statusView;

@property (assign, nonatomic) FinancierSectionType sectionType;
@property (assign, nonatomic) BOOL isTabSelected;
@property (assign, nonatomic) BOOL mandatoryFilled;

- (BOOL)getMandatoryFieldsFilledStatus;
- (void)setTabSelected:(BOOL)selected;
- (void)setStatusOfMandatoryFields:(BOOL)mandatoryFieldsFilled;

@end
