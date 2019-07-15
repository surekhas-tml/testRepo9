//
//  ActivityView.h
//  e-Guru
//
//  Created by Juili on 04/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "WeekCalendarViewController.h"
#import "DropDownViewController.h"
#import "NSDate+eGuruDate.h"
#import "Constant.h"

@protocol ActivityViewDelegate<NSObject>
-(void)searchWithActivityDictionary:(NSDictionary *)searchQuery;
-(void)searchClose;
@end
@interface ActivityView : UIView<UIGestureRecognizerDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    NSMutableArray *activityList;
    UITextField *activeField;
    

}
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIDatePicker *tappedView;


@property (weak, nonatomic) IBOutlet UILabel *searchlbl;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerview1;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) id<ActivityViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerview2;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *salestagelblwidth;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerview3;
@property (weak, nonatomic) IBOutlet UIView *searchDrawerview4;
@property (weak, nonatomic) IBOutlet UIImageView *todateimage;

@property (weak, nonatomic) IBOutlet UIImageView *fromdateimage;
@property (weak, nonatomic) IBOutlet UITextField *salesStage;
- (IBAction)CloseDrawer:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *fromDateActivity;
@property (weak, nonatomic) IBOutlet UITextField *toDateActivity;
@property (weak, nonatomic) IBOutlet UITextField *taluka;

@property (weak, nonatomic) IBOutlet UITextField *activityStatus;
@property (weak, nonatomic) IBOutlet UITextField *activityType;
@property (weak, nonatomic) IBOutlet UITextField *PPL;
@property (weak, nonatomic) IBOutlet UITextField *LOB_textfield;

- (IBAction)clearButton:(id)sender;
- (IBAction)searchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dselbl;
@property (weak, nonatomic) IBOutlet UITextField *dsenametxtfld;
@property (strong, nonatomic)NSString *currentActivityUser;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (assign, nonatomic) DSMDSEACTIVITY dsmdseactivity;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesStageTrailingSpace;

- (void)setCurrentUser:(NSString *)user;


@property (weak, nonatomic) IBOutlet UIView *searchDrawerGTMEFilterView;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectMmgeo;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectChannelType;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectApplicationType;

@property (weak, nonatomic) IBOutlet UIButton *btnRadioDSEWiseMMGeo;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioChannelType;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioApplicationType;
@property (weak, nonatomic) IBOutlet UIButton *btnDSEWiseMMGeo;
@property (weak, nonatomic) IBOutlet UIButton *btnChannelType;
@property (weak, nonatomic) IBOutlet UIButton *btnApplicationType;

//New Filter API's

- (void)getAllApplicationTypesListWithSuccessAction:(UITextField *)textField :(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock;
- (void)getAllChannelTypesListWithSuccessAction:(UITextField *)textField :(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock;
- (void)getDSEWiseMMGeoListWithDSEID:(UITextField *)textField dseID:(NSString*)dseID withSuccessAction:(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock;

@end
