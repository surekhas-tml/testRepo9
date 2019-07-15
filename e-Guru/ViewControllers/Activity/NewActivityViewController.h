//
//  NewActivityViewController.h
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityMethods.h"
#import "DropDownViewController.h"
#import "UserDetails.h"
#import "AppRepo.h"
#import "NSDate+eGuruDate.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
@interface NewActivityViewController : UIViewController<UISplitViewControllerDelegate,UIGestureRecognizerDelegate,DropDownViewControllerDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;

@property (strong, atomic) EGContact *contact;
@property (strong, atomic) EGOpportunity *opportunity;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UITextField *selectActivityTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UITextField *selctActivityDate;
@property (weak, nonatomic) IBOutlet UITextField *selectActivityTime;
@property (weak, nonatomic) IBOutlet UIView *textFieldHolder;

- (IBAction)saveNewActivity:(id)sender;
- (IBAction)clearAllFields:(id)sender;

@end
