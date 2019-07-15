//
//  SearchFinancierView.h
//  e-guru
//
//  Created by apple on 25/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "AppRepo.h"
#import "EGSearchOptyFilter.h"
#import "NSDate+eGuruDate.h"
#import "AutoCompleteUITextField.h"
#import "EGSearchFinancierOptyFilterModel.h"

@protocol SearchFinancierViewDelegate
-(void)financierSearchOpportunityForQuery;
-(void)financierClosedSearchDrawer;
-(void)financierFieldsCleared;
@end

@interface SearchFinancierView : UIView<UIGestureRecognizerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate, AutoCompleteUITextFieldDelegate>
{
    NSArray *talukaArray;
    UITextField *activeField;
    
}

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;

@property (strong,nonatomic, readwrite) EGSearchFinancierOptyFilterModel *searchFilter;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) id<SearchFinancierViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView1;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView2;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView3;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *fromDate;
@property (weak, nonatomic) IBOutlet UITextField *todate;
@property (weak, nonatomic) IBOutlet UITextField *salesStage;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *closeSearchDrawerButton;
- (IBAction)searchOpportunityButtonClicked:(id)sender;
- (IBAction)clearAllSearchButtons:(id)sender;
- (IBAction)closeSearchDrawer:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *fromdateimage;
@property (weak, nonatomic) IBOutlet UIImageView *todateimage;

@property (nonatomic, strong) NSString *currentoptyUser;
@property (weak, nonatomic) IBOutlet UILabel *financierLabel;
@property (weak, nonatomic) IBOutlet AutoCompleteUITextField *financierTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UIView *mContainerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchDrawerView3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * searchDrawerView3TopConstraint;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
- (void)setCurrentUserOpportunity:(NSString *)currentUser;

@end
