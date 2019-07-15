//
//  LostOpportunityViewController.h
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityMethods.h"
#import "DropDownViewController.h"
#import "NSDate+eGuruDate.h"



@interface LostOpportunityViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,DropDownViewControllerDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;

@property (strong, atomic) EGContact *contact;
@property (strong, atomic) EGOpportunity *opportunity;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *optyLostReson;
@property (weak, nonatomic) IBOutlet UITextField *makeLostTo;
@property (weak, nonatomic) IBOutlet UITextField *postponedToDate;
@property (weak, nonatomic) IBOutlet UITextField *modelLostTo;
@property (weak, nonatomic) IBOutlet UILabel *postponedlbl;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *customeContactNumber;
@property (weak, nonatomic) IBOutlet UIView *textFieldHolderView;
@property (nonatomic, strong) NSString *currentoptyUsers;
- (IBAction)saveLostOpportunityDetails:(id)sender;
- (IBAction)clearAllText:(id)sender;

@property (assign, nonatomic) DSMDSEOPTY isdsmdseopty1;
@property (weak, nonatomic) IBOutlet UILabel *saleStage;


@end
