//
//  UpdateActivityViewController.h
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGActivity.h"
#import "DropDownViewController.h"
#import "AssignTO.h"
#import "NSDate+eGuruDate.h"
#import "AAADraftMO+CoreDataClass.h"

@class PendingActivitiesListViewController;

@interface UpdateActivityViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,DropDownViewControllerDelegate,UIGestureRecognizerDelegate,UISplitViewControllerDelegate,AssignTODelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;

@property (strong,nonatomic)EGActivity *activity;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (strong , nonatomic) EGOpportunity *opportunity;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *opportunityID;
@property (strong, nonatomic) IBOutlet UILabel *DSEname;
@property (strong, nonatomic) IBOutlet UILabel *dsenamelbl;
@property (weak, nonatomic) IBOutlet UITextField *activityType;
@property (weak, nonatomic) IBOutlet UITextField *activityStatus;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (strong) AssignTO *assignToView;

@property (weak, nonatomic) IBOutlet UITextField *nextPlannedDate;
@property (weak, nonatomic) IBOutlet UITextField *nextPlannedTime;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSString *entryPoint;
@property (strong, nonatomic) NSString *checkuser;
@property (weak, nonatomic) IBOutlet UIButton *createOptyButton;
@property (weak, nonatomic) IBOutlet UIButton *createReferralOptyButton;
@property (weak, nonatomic) IBOutlet UIButton *markAsJunkButton;

@property (strong, nonatomic) PendingActivitiesListViewController *pendingActivitiesViewController;

- (IBAction)updateAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)assignAction:(id)sender;
- (IBAction)createOptyAction:(id)sender;
- (IBAction)createReferralOptyAction:(id)sender;
- (IBAction)markAsJunkAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *assignButton;

@property (nonatomic, assign) BOOL isInvokedFromPushNotification;
@end
