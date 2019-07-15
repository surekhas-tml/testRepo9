//
//  ReportIssueViewController.h
//  e-guru
//
//  Created by admin on 4/18/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRepo.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface ReportIssueViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UITextField *idTextfield;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailidTextfield;
@property (strong, nonatomic) IBOutlet UITextField *mobilenumberTextfield;

@property (strong, nonatomic) IBOutlet UIButton *closeMainView;

@property (nonatomic,strong) NSString *errorDiscription;

- (IBAction)closeMainViewAction:(id)sender;

-(void)bindValuestoReportIssue;
-(void)validations;
- (IBAction)resetAction:(id)sender;
- (IBAction)submitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *issueTextview;
- (void)showReportIssuefromViewController:(id)controller;
@end
