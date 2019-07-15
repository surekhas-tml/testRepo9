//
//  EGDSELeaveView.h
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTextField.h"
#import "EGExclusionViewModel.h"
#import "AppDelegate.h"
#import "DropDownViewController.h"
#import "IQTextView.h"
#import "EGDse.h"
#import "GreyBorderUITextField.h"

NS_ASSUME_NONNULL_BEGIN
@protocol EGDSELeaveViewProtocol <NSObject>
@required
- (void)reloadDataForDate;
@end

@interface EGDSELeaveView : UIView<DropDownViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource>
{
    AppDelegate *appDelegate;
    EGDse *selectedDSE;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *displaydateFormatter;

    BOOL firstLoad;
}
- (IBAction)doneButtonActionClick:(id)sender;
@property (weak, nonatomic) IBOutlet DropDownTextField *dseDropDownTextField;
@property (weak, nonatomic) IBOutlet UIView *dseDropDownView;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *remarkTextView;
@property (strong, nonatomic)  EGExclusionViewModel * exclusionViewModel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *eventList;
@property (weak, nonatomic) IBOutlet UIView *viewEventList;
@property (weak, nonatomic) IBOutlet UIView *viewDSELeave;
@property ( nonatomic) BOOL showDSELeaveView;
@property (strong, nonatomic)  NSString * selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic)  NSDate * eventDate;
@property (weak, nonatomic) IBOutlet UIButton *deleteLeaveButton;
@property (nonatomic, strong) id <EGDSELeaveViewProtocol> protocolGDSELeaveView;
- (void)showDSEView;
- (void)showEventList;
- (IBAction)cancelLeaveClickd:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelLeaveActionButton;
- (IBAction)deleteLeaveUIClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *listDeleteDisabledButton;
- (IBAction)selectDatesClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightViewDoneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewSelectedDatesHeight;
@property (weak, nonatomic) IBOutlet UIButton *rightViewCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *selectDateArrowButton;
- (IBAction)addButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblViewSelectedDates;
@property (weak, nonatomic) IBOutlet UITableView *tableViewLeaves;
@property (strong, nonatomic) NSMutableArray * addedLeavesArray;
@property (strong, nonatomic) NSMutableArray * checkedDatedArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_ht_tableLeaves;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *rightViewTitle;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_LeaveList_Ht;

@end

NS_ASSUME_NONNULL_END
