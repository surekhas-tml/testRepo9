//
//  FinancierSectionView.h
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAUIHelper.h"
#import "NSString+NSStringCategory.h"
#import "UtilityMethods.h"
#import "UIColor+eGuruColorScheme.h"
#import "GreyBorderUITextField.h"
#import "DropDownTextField.h"

@protocol FinancierSectionViewDelegate <NSObject>
@optional
- (void)mandatoryFieldsFilled:(BOOL)fieldsFilled inView:(id)sectionView;

@end

@interface FinancierSectionView : UIView

- (instancetype)initWithMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint;

- (void)loadUIFromXib;
-(void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint;
- (void)resetFields;

@property (assign, nonatomic) FinancierSectionType sectionType;
@property (weak, nonatomic) id<FinancierSectionViewDelegate> delegate;

- (FinancierSectionType)getSectionType;
- (void)checkIfMandatoryFieldsAreFilled;

@end

