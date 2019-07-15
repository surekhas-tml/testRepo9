//
//  ActivityView
//  e-Guru
//
//  Created by Juili on 04/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "ActivityView.h"
#import "ActivityViewController.h"
#import "EGLob.h"
#import "EGDse.h"
#import "NSString+NSStringCategory.h"
#import "AppDelegate.h"
#import "ActivityHelper.h"
#import "ActivityTypeDBHelper.h"
#import "EGRKWebserviceRepository.h"

@interface ActivityView(){
    UIDatePicker *fromDatePickerActivity;
    UIDatePicker *toDatePickerActivity;
    UITapGestureRecognizer *tapRecognizer;
    UITextField *activeField1;
    NSMutableArray *activityarray;
    NSArray *talukaArray;
    EGLob *selectedlob;
    EGDse *selectedDse;
    NSMutableArray *LOBResponseArray;
    NSMutableArray *DSEResponseArray;
    NSMutableArray *DSEfullname;
     EGLob *selectedLOBObj;
    AppDelegate *appDelegate;
    EGRKWebserviceRepository *currentTalukaOperation;
    BOOL fetchTaluka;
}
@property (strong,nonatomic)    UIActivityIndicatorView *actIndicator;
@end
@implementation ActivityView
@synthesize requestDictionary,actIndicator;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        fetchTaluka = YES;
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSBundle mainBundle] loadNibNamed:@"ActivityView" owner:self options:nil];
        [self.view setFrame:frame];
                [self layoutSubviews];
        [self addSubview:self.view];
        [self addGestureRecogniserToView];
        self.fromdateimage.hidden = (self.fromDateActivity.text.length > 0 );
        self.todateimage.hidden = (self.toDateActivity.text.length > 0 );
        [self.activityStatus setText:@"Open"]; // Default Activity Status
         LOBResponseArray = [NSMutableArray array];
         DSEResponseArray = [NSMutableArray array];
        DSEfullname = [NSMutableArray array];
        self.requestDictionary = [NSMutableDictionary dictionary];
        [self UserCheck];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [UtilityMethods setRedBoxBorder:self.fromDateActivity];
    [UtilityMethods setRedBoxBorder:self.toDateActivity];
    
    [UtilityMethods setLeftPadding:self.txtSelectMmgeo];
    [UtilityMethods setLeftPadding:self.txtSelectChannelType];
    [UtilityMethods setLeftPadding:self.txtSelectApplicationType];
    
    [self addGestureToDropDownFields];

    self.layer.borderWidth = 0.5f;
    self.searchButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.cornerRadius = 5.0f;
    [self setInitialDates];
    [self validations];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentActivityUser isEqualToString:@"My_Activity"]) {
            
            self.dselbl.hidden = YES;
            self.dsenametxtfld.hidden = YES;
            self.salesStageTrailingSpace.constant = 8;
        }else{
            self.dselbl.hidden = NO;
            self.dsenametxtfld.hidden = NO;
            self.salesStageTrailingSpace.constant = 215;
        }
    }
    
}

- (void)addGestureToDropDownFields{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.txtSelectMmgeo superview] addGestureRecognizer:tapGesture];
    [[self.txtSelectChannelType superview] addGestureRecognizer:tapGesture];
    [[self.txtSelectApplicationType superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    CGPoint point = [gesture locationInView:gesture.view];
    for (id view in [gesture.view subviews]){
        if ([view isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.txtSelectMmgeo){
                }else if (textField == self.txtSelectChannelType){
                    
                }else if (textField == self.txtSelectApplicationType){
                    
                }

            }
        }
    }
}

-(void)UserCheck{
if([[AppRepo sharedRepo] isDSMUser])
{
    self.dselbl.hidden=NO;
    self.dsenametxtfld.hidden=NO;
    self.salesStageTrailingSpace.constant = 215;
}
    else
    {
  
        self.dselbl.hidden=YES;
        self.dsenametxtfld.hidden=YES;
        self.salesStageTrailingSpace.constant = 8;
    }
}

-(void)setInitialDates
{
    //---//
    [self fromDatePicker];
    [self toDatePicker];
    
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1]; // note that I'm setting it to -1
    NSDate *oneMonthsBefore = [gregorianCalender dateByAddingComponents:offsetComponents toDate:today options:0];
    
    fromDatePickerActivity.date = oneMonthsBefore;
    NSLog(@"--%@", oneMonthsBefore);
    
    
    NSString *dateString = [NSDate getDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatddMMyyyy] InFormat:dateFormatddMMyyyy];
    self.fromDateActivity.text = dateString;
    self.fromdateimage.hidden = (self.fromDateActivity.text.length > 0 );
    self.todateimage.hidden = (self.toDateActivity.text.length > 0 );
    
//    [self onFromDatePickerValueChanged:fromDatePickerActivity];
    [self onToDatePickerValueChanged:toDatePickerActivity];
    
    //---//
    
    
}


#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
        return YES;
    }
    else if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.view]) {
        return YES;
    }
    return NO;
}
-(void)gestureHandlerMethod:(id)sender{
    [activeField resignFirstResponder];
}

#pragma mark - search Drawer Open Close Action Methods


- (IBAction)CloseDrawer:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromLeft;
    animation.duration = 0.2;
    [self.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:self
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self setHidden:!self.hidden];
                    }
                    completion:^(BOOL finished) {
                    }];
    
}

-(void)setToolbarForPicker:(UIDatePicker *)datePicker andCancelButtonHidden:(BOOL)hideCancelButton{
    
    // Toolbar
    if (!self.toolbar) {
        self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    
    [self.toolbar setBarTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(datePickerCancelButtonTapped)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:self
                                                                                   action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(datePickerDoneButtonTapped)];
    [doneButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 16;
    
    
    if (hideCancelButton) {
        [self.toolbar setItems:@[flexibleSpace, doneButton]];
    }
    else {
        [self.toolbar setItems:@[space, cancelButton, flexibleSpace, doneButton, space]];
    }
    
    if (_tappedView == fromDatePickerActivity) {
        self.fromDateActivity.inputAccessoryView = self.toolbar;

    }
    else if (_tappedView == toDatePickerActivity){
        self.toDateActivity.inputAccessoryView = self.toolbar;

    }

}

-(UIDatePicker *)fromDatePicker{
    
    if (fromDatePickerActivity != nil) {
        //validate dates
        if (fromDatePickerActivity.date >toDatePickerActivity.date) {
            [toDatePickerActivity setMinimumDate:fromDatePickerActivity.date];
            self.toDateActivity.text = @"";
        }
        self.tappedView = fromDatePickerActivity;
        return fromDatePickerActivity;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatddMMyyyy] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //[datePickerNew addTarget:self action:@selector(onFromDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        fromDatePickerActivity = datePickerNew;
        
        //validate dates
        if (fromDatePickerActivity.date >toDatePickerActivity.date) {
            [toDatePickerActivity setMinimumDate:fromDatePickerActivity.date];
            self.toDateActivity.text = @"";
        }
        
        //----//
        self.tappedView = fromDatePickerActivity;
        // Toolbar
        [self setToolbarForPicker:fromDatePickerActivity andCancelButtonHidden:false];

        return fromDatePickerActivity;
    }
}

-(UIDatePicker *)toDatePicker{
    if (toDatePickerActivity != nil) {
        //validate dates
        [toDatePickerActivity setMinimumDate:fromDatePickerActivity.date];
        self.tappedView = toDatePickerActivity;
        return toDatePickerActivity;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate date] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //[datePickerNew addTarget:self action:@selector(onToDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        toDatePickerActivity = datePickerNew;
        //validate dates
        [toDatePickerActivity setMinimumDate:fromDatePickerActivity.date];
        
        //----//
        self.tappedView = toDatePickerActivity;
        // Toolbar
        [self setToolbarForPicker:toDatePickerActivity andCancelButtonHidden:false];

        return toDatePickerActivity;
    }
}

- (void)onFromDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSString *dateString =[NSDate formatDate:[fromDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.fromDateActivity.text = dateString;
    self.fromdateimage.hidden = (self.fromDateActivity.text.length > 0 );
    self.todateimage.hidden = (self.toDateActivity.text.length > 0 );

}
-(void)onToDatePickerValueChanged:(UIDatePicker *)datePicker{
    NSString *dateString = [NSDate formatDate:[toDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.toDateActivity.text = dateString;
    self.fromdateimage.hidden = (self.fromDateActivity.text.length > 0 );
    self.todateimage.hidden = (self.toDateActivity.text.length > 0 );

    
}

# pragma mark - Text field
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    [self APICallsForTextField:textField];
}
-(void)APICallsForTextField:(UITextField *)textField{
    if (textField == self.fromDateActivity) {
        textField.inputView = [self fromDatePicker];
    }
    else if (textField == self.toDateActivity){
        textField.inputView = [self toDatePicker];
    }
    else if (textField == self.activityStatus){
        [self showPopOver:self.activityStatus withDataArray:[NSMutableArray arrayWithArray:@[@"Open",@"Done"]] andModelData:[NSMutableArray arrayWithArray:@[@"Open",@"Done"]]];
    }
    else if (textField == self.activityType){
        [self APIactivityTypeForTextField:textField];
    }
    else if (textField == self.salesStage){
        [self APIsalesStageForTextField:textField];
    }
    else if (textField == self.PPL){
        if([self.LOB_textfield.text isEqualToString:@""])
        {
            [textField resignFirstResponder];
            [UtilityMethods alert_ShowMessage:@"Please Select LOB" withTitle:APP_NAME andOKAction:nil];
        }
        else
        {
            [self APIpplForTextField:textField];
        }
    }
    else if (textField == self.LOB_textfield){
        [self APILobForTextField:textField];
    }
    else if (textField == self.dsenametxtfld){
        [self APIDSEForTextField:textField];
    }
    else if (textField == self.txtSelectMmgeo){
        // Get all MMGEO list with respect to DSE ID
        NSString *dseID = [[AppRepo sharedRepo] getLoggedInUser].userName;
        [self getDSEWiseMMGeoListWithDSEID:dseID withSuccessAction:^(id response) {
          
            NSMutableArray * arrMMGEO  = [(NSArray*)response mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopOver:textField
                    withDataArray:arrMMGEO
                     andModelData:arrMMGEO];
                
            }];
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
    else if (textField == self.txtSelectChannelType){
      
        [self getAllChannelTypesListWithSuccessAction:^(id response) {
            NSMutableArray * arrChannelType  = [(NSArray*)response mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopOver:textField
                    withDataArray:arrChannelType
                     andModelData:arrChannelType];
                
            }];
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
    else if (textField == self.txtSelectApplicationType){
        [self getAllApplicationTypesListWithSuccessAction:^(id response) {
            
            NSMutableArray * arrApplicationType  = [(NSArray*)response mutableCopy];
            [UtilityMethods RunOnMainThread:^{
                [self showPopOver:textField
                    withDataArray:arrApplicationType
                     andModelData:arrApplicationType];
                
            }];
        } andFailuerAction:^(NSError *error) {
            
        }];
        
    }
}

-(UIActivityIndicatorView *)actIndicatorForView:(UIView *)view{
    if(self.actIndicator) {
        return self.actIndicator;
    }else{
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.actIndicator setHidesWhenStopped:YES];
        CGFloat halfButtonHeight = view.bounds.size.height / 2;
        CGFloat buttonWidth = view.bounds.size.width;
        self.actIndicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    }
    return self.actIndicator;
}
# pragma mark - API Calls

-(void)APIactivityTypeForTalukaTextField:(UITextField *)textField WithString:(NSString *)string{
    [textField addSubview:[self actIndicatorForView:textField]];
    [textField setClearButtonMode:UITextFieldViewModeUnlessEditing];
    currentTalukaOperation = [EGRKWebserviceRepository sharedRepository];
    [self.actIndicator stopAnimating];
    [self.actIndicator startAnimating];

    [currentTalukaOperation getAllTaluka:@{@"taluka":string} andSucessAction:^(id contact , EGRKWebserviceRepository *sender) {
        
        if ([sender isEqual:currentTalukaOperation]) {
            [self.actIndicator stopAnimating];
            fetchTaluka = NO;
        talukaArray = [NSArray arrayWithArray:[[contact allValues] firstObject]];
        NSMutableArray *talArray = [NSMutableArray array];
        for (EGTaluka *tal in talukaArray) {
            [talArray addObject:[NSString stringWithFormat:@"%@ - %@ - %@ - %@" , tal.talukaName , tal.city , tal.district , tal.state.code]];
        }
        if ([talArray count]> 0) {
            [self showPopOver:textField withDataArray:talArray andModelData:[NSMutableArray arrayWithArray:talukaArray]];
        }else{
            [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
        }
        }
    } andFailuerAction:^(NSError *error) {

        [ScreenshotCapture takeScreenshotOfView:self.view.superview];
        appDelegate.screenNameForReportIssue = @"Activity View - Get Taluka";
        
        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{

        } andReportIssueAction:^{
           
        }];
    }];
}

-(void)APIactivityTypeForTextField:(UITextField *)textField {

    [UtilityMethods RunOnOfflineDBThread:^{
        ActivityTypeDBHelper *activityTypeDBHelper = [ActivityTypeDBHelper new];
        NSMutableArray * activityTypeArray  = [[activityTypeDBHelper fetchAllActivityTypes] mutableCopy];
        [activityTypeArray addObject:GTME_APP.uppercaseString];
        [UtilityMethods RunOnMainThread:^{
            [self showPopOver:textField
                withDataArray:activityTypeArray
                 andModelData:activityTypeArray];

        }];
    }];

}

-(void)APILobForTextField:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository] getListOfLOBsandSuccessAction:^(NSArray *responseArray)
    {
        if (responseArray && [responseArray count] > 0) {
            LOBResponseArray = [NSMutableArray arrayWithArray:responseArray];
            
            [self showPopOver:textField
                withDataArray:[NSMutableArray arrayWithArray:[responseArray valueForKey:@"lobName"]]
                 andModelData:[NSMutableArray arrayWithArray:LOBResponseArray]];
        }
    } andFailuerAction:^(NSError *error) {
    }];
}


-(void)APIDSEForTextField:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository] getListOfDSEs:^(NSArray *responseArray)
     {
         DSEfullname=[[NSMutableArray alloc]init];
         if (responseArray && [responseArray count] > 0)
             DSEResponseArray = [NSMutableArray arrayWithArray:responseArray];
         
         for (EGDse *dse in responseArray) {
             NSString *fullname = [[dse.FirstName stringByAppendingString:@"  "]stringByAppendingString:dse.LastName];
             [DSEfullname addObject:fullname];
         }
         if ([responseArray count]> 0) {
             [self showPopOver:textField
                 withDataArray:[NSMutableArray arrayWithArray:DSEfullname]
                  andModelData:[NSMutableArray arrayWithArray:DSEResponseArray]];
         }else{
             [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
         }

        
     } andFailuerAction:^(NSError *error) {
     }];
}



- (void)APIpplForTextField:(UITextField *)textField {
    NSDictionary *requestDict = @{@"lob_name": selectedlob.lobName? : @""};
   
    [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
         NSMutableArray *nameResponseArray = [NSMutableArray array];
        if (responseArray && [responseArray count] > 0) {
            nameResponseArray = [responseArray valueForKey:@"pplName"];
            [self showPopOver:textField
                withDataArray:[NSMutableArray arrayWithArray:nameResponseArray]
                 andModelData:[NSMutableArray arrayWithArray:responseArray]];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];

    
    
}
- (void)APIsalesStageForTextField:(UITextField *)textField {
    [[EGRKWebserviceRepository sharedRepository] getSalesStageSuccessAction:^(NSArray *responseArray) {
        [self showPopOver:textField
            withDataArray:[NSMutableArray arrayWithArray:responseArray]
             andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailureAction:^(NSError *error) {
    }];

}

-(void)activityTypeFailedWithErrorMessage:(NSString *)errorMessage{
    
//    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    [ScreenshotCapture takeScreenshotOfView:self.view.superview];
    appDelegate.screenNameForReportIssue = @"Activity View - Activity Type";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

}

#pragma mark - New Filter API

- (void)getDSEWiseMMGeoListWithDSEID:(NSString*)dseID withSuccessAction:(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock {
    
    NSDictionary *requestDictionary = @{
                                       @"dse_id":dseID
                                        };
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GET_DSE_WISE_MMGEO :requestDictionary
                                                    andSucessAction:^(AFRKHTTPRequestOperation *op, id responseObject) {
                                                        successBlock(responseObject);
                                                    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Show Error %@",error.localizedDescription);
                                                        failuerBlock(error);
                                                }];
    
}

- (void)getAllChannelTypesListWithSuccessAction:(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock {
   
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GET_CHANNEL_TYPES : nil andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Show Error %@",error.localizedDescription);
            failuerBlock(error);
    }];
}

- (void)getAllApplicationTypesListWithSuccessAction:(void(^)(id response))successBlock andFailuerAction:(void(^)(NSError *error))failuerBlock {
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GET_APPLICATIONS_TYPES : nil andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
        } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Show Error %@",error.localizedDescription);
            failuerBlock(error);
    }];
}

-(void)activityTypeSuccessfully{
    
    NSLog(@"success");
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.taluka && length > 3 && fetchTaluka){
        
        [self APIactivityTypeForTalukaTextField:textField WithString:currentString];
    }
    [self validations];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField == self.activityType){
        [self.searchDrawerGTMEFilterView setHidden:YES];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [self validations];
    [self.clearButton setBackgroundColor:[UIColor navBarColor]];
     [self.clearButton setEnabled:true];
    [textField resignFirstResponder];


}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    fetchTaluka = YES;
    if(textField != self.taluka && textField != self.fromDateActivity && textField != self.toDateActivity){
        [textField resignFirstResponder];
        [activeField resignFirstResponder];
    }
    
    if (textField == self.fromDateActivity) {
        // Toolbar
        [self setToolbarForPicker:fromDatePickerActivity andCancelButtonHidden:false];

    }
    else if (textField == self.toDateActivity){
        // Toolbar
        [self setToolbarForPicker:toDatePickerActivity andCancelButtonHidden:false];

    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self validations];
    return YES;
}

#pragma mark - validations

-(void)validations {
    
    BOOL enableSearchButton = true;
    
    // Enable Disable Search Button Validations
    if (![self.fromDateActivity.text hasValue]) {
        enableSearchButton = false;
    }else if (![self.toDateActivity.text hasValue]) {
        enableSearchButton = false;
    }
    else if ([self.LOB_textfield.text hasValue] && ![self.PPL.text hasValue]) {
        enableSearchButton = false;
    }
    
    // Validations For LOB and PPL Fields
    if ([self.LOB_textfield.text hasValue]) {
        [UtilityMethods setRedBoxBorder:self.PPL];
    }
    else {
        [self.PPL setText:@""];
        [UtilityMethods setBlackBoxBorder:self.PPL];
    }

    if (enableSearchButton) {
        [self.searchButton setEnabled:YES];
        [self.searchButton setBackgroundColor:[UIColor navBarColor]];
    }
    else {
        [self.searchButton setEnabled:NO];
        [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    self.fromdateimage.hidden = (self.fromDateActivity.text.length > 0 );
    self.todateimage.hidden = (self.toDateActivity.text.length > 0 );

    [self.clearButton setBackgroundColor:[UIColor navBarColor]];
}

- (IBAction)btnRadioAction:(id)sender {
    UIButton *button = (UIButton*) sender;
    UIImage *checked = [UIImage imageNamed:@"checked"];
    UIImage *unchecked = [UIImage imageNamed:@"uncheked "];

    self.txtSelectMmgeo.text = self.txtSelectChannelType.text = self.txtSelectApplicationType.text = @"";
  
    
    [self.btnRadioDSEWiseMMGeo setImage:unchecked forState:UIControlStateNormal];
    [self.btnRadioChannelType setImage:unchecked forState:UIControlStateNormal];
    [self.btnRadioApplicationType setImage:unchecked forState:UIControlStateNormal];

    self.txtSelectMmgeo.enabled = NO;
    self.txtSelectChannelType.enabled = NO;
    self.txtSelectApplicationType.enabled = NO;

    if (button == self.btnRadioDSEWiseMMGeo || button == self.btnDSEWiseMMGeo){
        [self.btnRadioDSEWiseMMGeo setImage:checked forState:UIControlStateNormal];
        self.txtSelectMmgeo.enabled = YES;

    }else if(button == self.btnRadioChannelType || button == self.btnChannelType){
        [self.btnRadioChannelType setImage:checked forState:UIControlStateNormal];
        self.txtSelectChannelType.enabled = YES;

    }else if(button == self.btnRadioApplicationType || button == self.btnApplicationType){
        [self.btnRadioApplicationType setImage:checked forState:UIControlStateNormal];
        self.txtSelectApplicationType.enabled = YES;
    }
}



- (IBAction)clearButton:(id)sender {
    
    [self.searchDrawerGTMEFilterView setHidden:YES];
    [self btnRadioAction:self];
    
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerview1];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerview2];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerview3];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerview4];
    [self validations];
    
    id pViewController;
    if ([self.delegate isKindOfClass:[ActivityViewController class]]) {
        pViewController = (ActivityViewController *)self.delegate;
        if ([pViewController respondsToSelector:@selector(searchWithActivityDictionary:)]) {
            ActivityViewController *viewController = (ActivityViewController *)pViewController;
            viewController.filterApplied = false;
            [viewController.activitiesMissedLabel setHidden:false];
            [viewController searchWithActivityDictionary:[self getDefaultDictionary]];
        }
        
    }else{
        pViewController = (WeekCalendarViewController *)self.delegate;
    }
        
    if ([pViewController respondsToSelector:@selector(hideFilter)]) {
        [pViewController hideFilter];
    }
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Search_Activity_Clear_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:nil];

}

- (IBAction)searchButton:(id)sender {
    [self validations];
    
    if (self.fromDateActivity.text.length > 0 && self.toDateActivity.text.length > 0) {
        [self prepareFilterDataAndApplyFilter];
        self.hidden = false;
        [self CloseDrawer:sender];

        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Search_Activity_Search_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:nil];

    }
    else {
        [UtilityMethods alert_ShowMessage:@"From Date and To Date are mandatory fields" withTitle:APP_NAME andOKAction:nil];
    }
}

- (NSMutableDictionary *)getDefaultDictionary {
    NSMutableDictionary *defaultDictionary = [[NSMutableDictionary alloc] init];
    [defaultDictionary setObject:@"" forKey:@"taluka"];
    [defaultDictionary setObject:@"" forKey:@"type"];
    [defaultDictionary setObject:@"Open" forKey:@"status"];
    [defaultDictionary setObject:@"0" forKey:@"offset"];
    [defaultDictionary setObject:GTME_APP forKey:@"app_name"];

    [defaultDictionary setObject:[[ActivityHelper sharedHelper] getActivityFilterUTCStartDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ]] forKey:@"start_date"];
    
    [defaultDictionary setObject:[[ActivityHelper sharedHelper] getActivityFilterUTCEndDate:[NSDate date]] forKey:@"end_date"];
    
    [defaultDictionary setObject:@"" forKey:@"stg_name_s"];
    [defaultDictionary setObject:@"" forKey:@"ppl"];
    [defaultDictionary setObject:@"20" forKey:@"size"];
    
    return defaultDictionary;
}

- (void)prepareFilterDataAndApplyFilter {
    
    BOOL isFilterApplied = false;
    NSString *filterApplied = TEXT_FILTER_APPLIED;
    NSString *comma = @",";
    id pViewController;
    
    if ([self.delegate isKindOfClass:[ActivityViewController class]]) {
        pViewController = (ActivityViewController *)self.delegate;
    }else{
        pViewController = (WeekCalendarViewController *)self.delegate;
    }
    
    NSString *dateRange = @"";
    
    // From Date
    if ([self.fromDateActivity.text hasValue]) {

        NSDate *from_date = [NSDate getNSDateFromString: self.fromDateActivity.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedStartDate = [NSDate getDate:[[NSDate getSOD:from_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        [self.requestDictionary setObject:formattedStartDate forKey:@"start_date"];
        dateRange = self.fromDateActivity.text;
        
    }
    
    // To Date
    if ([self.toDateActivity.text hasValue]) {
        NSDate *to_date = [NSDate getNSDateFromString: self.toDateActivity.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedEndDate = [NSDate getDate:[[NSDate getEOD:to_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        [self.requestDictionary setObject:formattedEndDate forKey:@"end_date"];
        dateRange = [dateRange stringByAppendingString:[NSString stringWithFormat:@" to %@", self.toDateActivity.text]];
    }
    
    // Sales Stage
    if ([self.salesStage.text hasValue]) {
        [self.requestDictionary setObject:self.salesStage.text forKey:@"stg_name_s"];
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@" Sales Stage : %@", self.salesStage.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"stg_name_s"];
    }
    
    // Activity Type
    if ([self.activityType.text hasValue]) {
        [self.requestDictionary setObject:self.activityType.text forKey:@"type"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ Activity Type : %@", comma, self.activityType.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"type"];
    }
    
    // Activity Status
    if ([self.activityStatus.text hasValue]) {
        [self.requestDictionary setObject:self.activityStatus.text forKey:@"status"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ Activity Status : %@", comma, self.activityStatus.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"status"];
    }
    
    // LOB and PPL
    if ([self.LOB_textfield.text hasValue]) {
        
        if ([self.PPL.text hasValue]) {
            [self.requestDictionary setObject:self.PPL.text forKey:@"ppl"];
            [self.requestDictionary setObject:self.LOB_textfield.text forKey:@"lob"];

            if (isFilterApplied) {
                comma = @",";
            }
            else {
                comma = @"";
            }
            filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ LOB : %@", comma, self.LOB_textfield.text]];
            filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ PPL : %@", comma, self.PPL.text]];
            isFilterApplied = true;
        }
        else {
            [self.requestDictionary setObject:@"" forKey:@"ppl"];
        }
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"ppl"];
    }
    
    // Taluka
    if ([self.taluka.text hasValue]) {
        [self.requestDictionary setObject:self.taluka.text forKey:@"taluka"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ Taluka : %@", comma, self.taluka.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"taluka"];
    }
    
    // DSE
    if ([self.dsenametxtfld.text hasValue]) {
        [self.requestDictionary setObject:selectedDse.leadid forKey:@"dse_id"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ DSE Name : %@", comma, self.dsenametxtfld.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"dse_id"];
    }
    
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentActivityUser isEqualToString:@"My_Activity"]) {
            self.dsmdseactivity=MYACTIVITY;
            [self.requestDictionary setObject:[NSNumber numberWithInt:self.dsmdseactivity] forKey:@"search_status"];
           
        }else{
            self.dsmdseactivity=TEAMACTIVITY;
           [self.requestDictionary setObject:[NSNumber numberWithInt:self.dsmdseactivity] forKey:@"search_status"];
        }
    }
    
    //Newly Added for GTME filter types

    NSString *activityTypeOf = [self.requestDictionary valueForKey:@"type"];
    if ([activityTypeOf.lowercaseString isEqualToString:GTME_APP]){
        [self.requestDictionary removeObjectForKey:@"type"];
        [self.requestDictionary setObject:GTME_APP forKey:@"activity_type"];
    }
    
    // MMGEO
    if ([self.txtSelectMmgeo.text hasValue]) {
        [self.requestDictionary setObject:self.txtSelectMmgeo.text forKey:@"mm_geo"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ MM_GEO : %@", comma, self.txtSelectMmgeo.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"mm_geo"];
    }
    
    // Channel Type
    if ([self.txtSelectChannelType.text hasValue]) {
        [self.requestDictionary setObject:self.txtSelectChannelType.text forKey:@"channel_type"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ Channel_Type : %@", comma, self.txtSelectChannelType.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"channel_type"];
    }
    
    //Application Type
    if ([self.txtSelectApplicationType.text hasValue]) {
        [self.requestDictionary setObject:self.txtSelectApplicationType.text forKey:@"application"];
        if (isFilterApplied) {
            comma = @",";
        }
        else {
            comma = @"";
        }
        filterApplied = [filterApplied stringByAppendingString:[NSString stringWithFormat:@"%@ Application : %@", comma, self.txtSelectApplicationType.text]];
        isFilterApplied = true;
    }
    else {
        [self.requestDictionary setObject:@"" forKey:@"application"];
    }
    
    
    
    [self.requestDictionary setObject:@"0" forKey:@"offset"];
    [self.requestDictionary setObject:@"15" forKey:@"size"];
    
    [self.requestDictionary setObject:GTME_APP forKey:@"app_name"];

    if (isFilterApplied && [pViewController respondsToSelector:@selector(showFilter:)]) {
        [pViewController showFilter:filterApplied];
    }
    else {
        [pViewController hideFilter];
    }
    
    if ([pViewController respondsToSelector:@selector(setDateRange:)]) {
        [pViewController setDateRange:dateRange];
    }
    
    if ([self.delegate isKindOfClass:[ActivityViewController class]]) {
        ActivityViewController *activityViewController = (ActivityViewController *)self.delegate;
        activityViewController.filterApplied = true;
        [activityViewController.activitiesMissedLabel setHidden:true];
    }
    [self.delegate searchWithActivityDictionary:self.requestDictionary];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    DropDownViewController *dropDown;
    [self.view endEditing:true];
    if (textField == self.taluka) {
        dropDown = [[DropDownViewController alloc] initWithWidth:TALUKA_DROP_DOWN_WIDTH];
      
    }else{
    dropDown = [[DropDownViewController alloc] init];
    
    }
      [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    if([dropDownForView isEqual:self.LOB_textfield]){
        selectedlob = selectedObject;
        [self validations];
    }
    else if (dropDownForView == self.PPL) {
        [self validations];
    }
    else if ([dropDownForView isEqual:self.taluka]) {
        fetchTaluka = NO;
        activeField.text = [(EGTaluka *)selectedObject talukaName];
    }
    else if([dropDownForView isEqual:self.dsenametxtfld]){
        selectedDse = selectedObject;
    } else if([dropDownForView isEqual:self.activityType]){
        if([selectedValue isEqualToString:GTME_APP.uppercaseString]){
            //show new filter view and hide old filter view
            [self.searchDrawerGTMEFilterView setHidden:NO];
        } else{
          // unhide the old filter view
            [self.searchDrawerGTMEFilterView setHidden:YES];
        }
    }
}

- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [toDatePickerActivity removeFromSuperview];
    [fromDatePickerActivity removeFromSuperview];
    
    self.fromDateActivity.inputAccessoryView = nil;
    self.toDateActivity.inputAccessoryView = nil;
    
    [self.fromDateActivity resignFirstResponder];
    [self.toDateActivity resignFirstResponder];
}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == fromDatePickerActivity) {
        [self.fromDateActivity setText:[NSDate formatDate:[fromDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    else if (self.tappedView == toDatePickerActivity) {
        [self.toDateActivity setText:[NSDate formatDate:[toDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    [self validations];
}

- (void)setCurrentUser:(NSString *)user{
    
    self.currentActivityUser = user;
    
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentActivityUser isEqualToString:@"My_Activity"]) {
            
            self.dselbl.hidden = YES;
            self.dsenametxtfld.hidden = YES;
            self.salesStageTrailingSpace.constant = 8;
        }else{
            self.dselbl.hidden = NO;
            self.dsenametxtfld.hidden = NO;
            self.salesStageTrailingSpace.constant = 215;
        }
    }
}

@end
