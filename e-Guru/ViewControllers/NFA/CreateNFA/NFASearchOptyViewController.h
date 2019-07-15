//
//  NFASearchOptyViewController.h
//  e-guru
//
//  Created by admin on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreyBorderUITextField.h"
#import "DropDownTextField.h"
#import "NSDate+eGuruDate.h"
#import "DropDownViewController.h"
#import "EGPpl.h"
#import "EGVCList.h"
#import "EGPagedTableViewDataSource.h"
#import "EGPagedTableView.h"
#import "EGPagedArray.h"
#import "VCNumberDBHelper.h"
#import "NSString+NSStringCategory.h"
#import "PureLayout.h"
#import "NFASearchOptyTableViewCell.h"
#import "EGErrorTableViewCell.h"
#import "EGNFA.h"
#import "EGOpportunity.h"
#import "NFAUIHelper.h"
@protocol NFASearchOptyViewControllerDelegate <NSObject>

- (void)opportunitySelected;

@end

@interface NFASearchOptyViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate,DropDownViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, EGPagedTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *miniSearchFilterView;
@property (weak, nonatomic) IBOutlet UIView *searchFilterView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *moreSearchButton;

@property (weak ,nonatomic) IBOutlet GreyBorderUITextField *opptyIDTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *contactNoTextField;

@property (weak ,nonatomic) IBOutlet GreyBorderUITextField *miniSearchOpptyIDTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *miniSearchcontactNoTextField;

@property (weak, nonatomic) IBOutlet DropDownTextField *salesStageDropDownTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *pplDropDownTextField;

@property (weak ,nonatomic) IBOutlet GreyBorderUITextField *toDateTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *fromDateTextField;

@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet EGPagedTableView * relatedOpportunityResultTableView;

- (IBAction)moreSearchButtonClick:(id)sender;
- (IBAction)searchButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *searchByOptionText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbylbl;

@property (weak, nonatomic) id<NFASearchOptyViewControllerDelegate> delegate;
@property (strong, nonatomic) EGNFA *nfaModel;

@property (strong, nonatomic) EGOpportunity *opportunity;
@property (assign, nonatomic) NFAMode currentNFAMode;
@property (strong, nonatomic) EGPagedArray *opportunityPagedArray;
@property (assign, nonatomic) BOOL *invokedFromManageOpportunity;

@end
