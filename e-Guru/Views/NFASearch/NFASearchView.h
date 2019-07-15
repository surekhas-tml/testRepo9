//
//  NFASearchView.h
//  e-guru
//
//  Created by Juili on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASearchView.h"
#import "EGSearchNFAFilter.h"
#import "DropDownViewController.h"
#import "AppDelegate.h"
#import "NSString+NSStringCategory.h"
#import "NSDate+eGuruDate.h"
#import "NFAStatusMode.h"
@protocol SearchNFAViewDelegate
-(void)searchNFAForQuery;
-(void)closeSearchDrawer;
-(void)fieldsCleared;
@end
@interface NFASearchView : UIView<UITextViewDelegate,UIPickerViewDelegate,DropDownViewControllerDelegate>
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;
@property (strong,nonatomic) EGSearchNFAFilter *searchFilter;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) id<SearchNFAViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView1;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerView2;
@property (weak, nonatomic) IBOutlet UITextField *nfaRequestNumberTB;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *nfaStatusTB;
@property (weak, nonatomic) IBOutlet UITextField *nfaFromDate;
@property (weak, nonatomic) IBOutlet UITextField *nfaToDate;
@property (weak, nonatomic) IBOutlet UIImageView *fromDateImage;
@property (weak, nonatomic) IBOutlet UIImageView *toDateImage;

@property (weak, nonatomic) IBOutlet UIImageView *toOptyDateImage;
@property (weak, nonatomic) IBOutlet UIImageView *fromOptyDateImage;

@property (weak, nonatomic) IBOutlet UITextField *selectLOBTB;
@property (weak, nonatomic) IBOutlet UITextField *selectPPLTB;
@property (weak, nonatomic) IBOutlet UITextField *selectSalesStageTB;
@property (weak, nonatomic) IBOutlet UITextField *optyFromDate;
@property (weak, nonatomic) IBOutlet UITextField *optyToDate;
- (IBAction)clearSearchFilter:(id)sender;
- (IBAction)searchWithSelectedFilter:(id)sender;
- (IBAction)closeSearchDrawer:(id)sender;
@end
