//
//  NFASectionBaseView.h
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAUIHelper.h"
#import "NFADealerAndCustomerDetails.h"
#import "NSString+NSStringCategory.h"
#import "UtilityMethods.h"
#import "PureLayout.h"
#import "UIColor+eGuruColorScheme.h"
#import "GreyBorderUITextField.h"
#import "DropDownTextField.h"

@protocol NFASectionBaseViewDelegate <NSObject>

- (void)mandatoryFieldsFilled:(BOOL)fieldsFilled inView:(id)sectionView;

@end

@interface NFASectionBaseView : UIView

- (instancetype)initWithMode:(NFAMode)mode andModel:(id)model;

- (void)loadUIFromXib;
- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model;
- (void)resetFields;

@property (assign, nonatomic) NFASectionType sectionType;
@property (weak, nonatomic) id<NFASectionBaseViewDelegate> delegate;

- (NFASectionType)getSectionType;
- (void)checkIfMandatoryFieldsAreFilled;

@end
