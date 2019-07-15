//
//  SearchOpportunityView.h
//  e-Guru
//
//  Created by Juili on 04/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "AppRepo.h"
#import "EGSearchOptyFilter.h"
#import "NSDate+eGuruDate.h"
#import "AutoCompleteUITextField.h"

@protocol SearchOpportunityViewDelegate
-(void)searchOpportunityForQuery;
-(void)closedSearchDrawer;
-(void)fieldsCleared;
@end
@interface SearchOpportunityView : UIView<UIGestureRecognizerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate, AutoCompleteUITextFieldDelegate>
{
    NSArray *talukaArray;
    UITextField *activeField;

}

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;

@property (strong,nonatomic, readwrite) EGSearchOptyFilter *searchFilter;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) id<SearchOpportunityViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView1;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView2;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView3;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *fromDate;
@property (weak, nonatomic) IBOutlet UITextField *todate;
@property (weak, nonatomic) IBOutlet UITextField *salesStage;
@property (weak, nonatomic) IBOutlet UITextField *ppl;
@property (weak, nonatomic) IBOutlet UITextField *taluka;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UITextField *liveDeal;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *closeSearchDrawerButton;
- (IBAction)searchOpportunityButtonClicked:(id)sender;
- (IBAction)clearAllSearchButtons:(id)sender;
- (IBAction)closeSearchDrawer:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *fromdateimage;
@property (weak, nonatomic) IBOutlet UIImageView *todateimage;
@property (weak, nonatomic) IBOutlet UILabel *dsenamelbl;
@property (weak, nonatomic) IBOutlet UITextField *dsenametxtfld;
@property (weak, nonatomic) IBOutlet UITextField *lob_textfield;
@property (weak, nonatomic) IBOutlet UILabel *nfalbl;
@property (weak, nonatomic) IBOutlet UITextField *nfatxtfld;
@property (weak, nonatomic) IBOutlet UITextField *eventxtfld;
@property (nonatomic, strong) NSString *currentoptyUser;
@property (weak, nonatomic) IBOutlet UILabel *financierLabel;
@property (weak, nonatomic) IBOutlet AutoCompleteUITextField *financierTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UIView *mContainerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchDrawerView3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dseTopSpacing;

- (void)setCurrentUserOpportunity:(NSString *)currentUser;
@end
