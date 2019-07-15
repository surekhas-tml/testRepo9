//
//  PotentialDropOffViewController.h
//  e-guru
//
//  Created by Apple on 22/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTextField.h"
#import "DropDownViewController.h"
#import "GreyBorderUITextField.h"
#import "EGOpportunity.h"
#import "EGPagedArray.h"
#import "EGPagedTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PotentialDropOffViewController : UIViewController<DropDownViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet DropDownTextField *potentialDropOffDropDownTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *supportInterventionTextField;
@property (weak, nonatomic) IBOutlet EGPagedTableView *potentialDropTableView;
@property (weak, nonatomic) IBOutlet UIView *potentialDropDownSelectionView;
@property (nonatomic, strong) EGOpportunity * opportunity;
@property (strong, nonatomic) EGPagedArray *activityList;

- (IBAction)createOrUpdateActivityClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
