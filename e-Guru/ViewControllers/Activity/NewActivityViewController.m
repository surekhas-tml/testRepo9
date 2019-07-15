//
//  NewActivityViewController.m
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "NewActivityViewController.h"
#import "ManageOpportunityViewController.h"
#import "OpportunityDetailsViewController.h"
#import "ScreenshotCapture.h"
@interface NewActivityViewController ()
{
    UITextField *activeField;
    UITapGestureRecognizer *tapRecognizer;
}
@property (strong, nonatomic , readonly) UIDatePicker *datePicker;
@property (strong, nonatomic , readonly) UIDatePicker *timePicker;
@end

@implementation NewActivityViewController
@synthesize datePicker,timePicker;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButton.layer.cornerRadius = 4.0f;
    self.clearButton.layer.cornerRadius = 4.0f;
    self.commentsTextView.text = @"Add Your Comments";
    self.commentsTextView.textColor = [UIColor lightGrayColor];
    [self datePicker];
    [self timePicker];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Create_Activity];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];

    [self onDatePickerValueChanged:[self datePicker]];
    [self onTimePickerValueChanged:[self timePicker]];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self validations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Text field
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        activeField = textField;
        [self APICallsForTextField:textField];

}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [self validations];
    [textField resignFirstResponder];

}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.commentsTextView.text = @"";
    self.commentsTextView.textColor = [UIColor blackColor];
    if (textField != self.selctActivityDate && textField != self.selectActivityTime) {
        [textField resignFirstResponder];
    }
    if (textField == self.selctActivityDate) {
        // Toolbar
        [self setToolbarForPicker:datePicker andCancelButtonHidden:false];
        
    }
    else if (textField == self.selectActivityTime){
        // Toolbar
        [self setToolbarForPicker:timePicker andCancelButtonHidden:false];
        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Add Your Comments";
        [textView resignFirstResponder];
    }
}

#pragma mark - validations
-(void)validations{
    [UtilityMethods setRedBoxBorder:self.selectActivityTextField];
    [UtilityMethods setRedBoxBorder:self.selectActivityTime];
    [UtilityMethods setRedBoxBorder:self.selctActivityDate];

    if (self.selectActivityTextField.text.length > 0  && self.selctActivityDate.text.length > 0 && self.selectActivityTime.text.length > 0) {
        [self.saveButton setEnabled:YES];
        [self.saveButton setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
    }
    else{
        [self.saveButton setEnabled:NO];
        [self.saveButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}



# pragma mark - API Calls

-(void)APICallsForTextField:(UITextField *)textField{
    if ([textField isEqual:self.selctActivityDate]){
        textField.inputView = [self datePicker];
    }
    else if ([textField isEqual:self.selectActivityTime]){
        textField.inputView = [self timePicker];
    }else{
    [[EGRKWebserviceRepository sharedRepository]getActivityTypeListForGivenOpportunity:nil andSucessAction:^(id type) {
        
        NSMutableArray *activityTypeArray = [NSMutableArray arrayWithArray:type];
        if (self.opportunity && ([self.opportunity.salesStageName caseInsensitiveCompare:SEARCH_FILTER_SALES_STAGE_C0]) == NSOrderedSame) {
            [activityTypeArray removeObject:@"Papers Submitted"];
        }
        
        [self showPopOver:activeField withDataArray:activityTypeArray andModelData:[NSMutableArray arrayWithArray:type]];
    } andFailuerAction:^(NSError *error) {
//        [UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
//        }];
        
    }];
    }
}

- (IBAction)saveNewActivity:(id)sender {
    NSString * comment = [self.commentsTextView.text isEqualToString:@"Add Your Comments"]?@"":self.commentsTextView.text;

    NSDictionary *inputDictionary = @{
                                      @"opty": @{
                                              @"opportunity_id" : [UtilityMethods serviceInputConversionFor:self.opportunity.optyID]
                                              },
                                      @"status": @"Open",
                                      @"type": [UtilityMethods serviceInputConversionFor:self.selectActivityTextField.text],
                                      @"start_date": [self makeStartDate],
                                      @"comments" : comment,
                                      @"contact_id" : [UtilityMethods serviceInputConversionFor:self.opportunity.toContact.contactID]
                                      };
    
    [[EGRKWebserviceRepository sharedRepository]createActivity:inputDictionary
      andSucessAction:^(id activity) {
         [UtilityMethods alert_ShowMessage:[NSString stringWithFormat:@"Activity Created for Opportunity with ID : %@",self.opportunity.optyID] withTitle:APP_NAME andOKAction:^{
             [self clearAllFields:nil];
             
             [self.navigationController popViewControllerAnimated:YES];
         }];

    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewActivity_Submit_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_Create_Activity_Successful];
   
     } andFailuerAction:^(NSError *error) {
         [ScreenshotCapture takeScreenshotOfView:self.view];
         AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
         appdelegate.screenNameForReportIssue = @"Create New Activity";

         [UtilityMethods showErroMessageFromAPICall:error defaultMessage:CREATE_ACTIVITY_FAILED_MESSAGE];
         
         [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_CreateNewActivity_Submit_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_Create_Activity_Failed];

     }];
}


-(IBAction)clearAllFields:(id)sender{
    [UtilityMethods clearAllTextFiledsInView:self.textFieldHolder];
    self.commentsTextView.text = @"";
//    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - UI Picker Methods

-(UIDatePicker *)datePicker{
    if (datePicker != nil) {
        self.tappedView = datePicker;
        return datePicker;
    }else{
        UIDatePicker *aDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        aDatePicker.backgroundColor = [UIColor lightGrayColor];
        aDatePicker.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [aDatePicker setDate:[NSDate date] animated:YES];
        [aDatePicker setDatePickerMode:UIDatePickerModeDate];
        //[aDatePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        aDatePicker.minimumDate = [NSDate date];
        datePicker = aDatePicker;
        self.tappedView = datePicker;
        // Toolbar
        [self setToolbarForPicker:datePicker andCancelButtonHidden:false];
        return datePicker;
}
}
-(UIDatePicker *)timePicker{
    if (timePicker != nil) {
        self.tappedView = timePicker;
        return timePicker;
    }else{
        UIDatePicker *aTimePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        aTimePicker.backgroundColor = [UIColor lightGrayColor];
        aTimePicker.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [aTimePicker setDate:[NSDate date] animated:YES];
        [aTimePicker setDatePickerMode:UIDatePickerModeTime];
        //[aTimePicker addTarget:self action:@selector(onTimePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        if ([datePicker.date compare:[NSDate date]] == NSOrderedSame) {
            [aTimePicker setMinimumDate:[NSDate date]];
        }
        
        timePicker = aTimePicker;
        self.tappedView = timePicker;
        // Toolbar
        [self setToolbarForPicker:timePicker andCancelButtonHidden:false];
        return timePicker;
    }
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePickerL
{
    NSString *dateString = [NSDate formatDate:[self.datePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.selctActivityDate.text = dateString;
    self.selectActivityTime.text = @"";
    
}

- (void)onTimePickerValueChanged:(UIDatePicker *)datePickerL
{
    NSString *timeString =[NSDate formatDate:[self.timePicker.date description] FromFormat:dateFormatNSDateDate toFormat:pendingActivityTimeFormat];
    self.selectActivityTime.text = timeString;
}
-(void)setToolbarForPicker:(UIDatePicker *)date_Picker andCancelButtonHidden:(BOOL)hideCancelButton{
    
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
    
    if (_tappedView == datePicker) {
        self.selctActivityDate.inputAccessoryView = self.toolbar;
        
    }
    else if (_tappedView == timePicker){
        self.selectActivityTime.inputAccessoryView = self.toolbar;
        
    }
    
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}
- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    [self validations];

}

-(NSString *)makeStartDate{
    if (datePicker.date && timePicker.date) {
        NSDate *date = [NSDate generateCombinedDateTimeForDate:datePicker.date andTime:timePicker.date];
        NSString * dateString = [date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];
        return dateString;
    }
    return @"";
}

- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    [timePicker removeFromSuperview];
    
    self.selctActivityDate.inputAccessoryView = nil;
    self.selectActivityTime.inputAccessoryView = nil;
    
    [self.selctActivityDate resignFirstResponder];
    [self.selectActivityTime resignFirstResponder];
}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == datePicker) {
        [self.selctActivityDate setText:[NSDate formatDate:[self.datePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
        self.selectActivityTime.text = @"";

    }
    else if (self.tappedView == timePicker) {
        [self.selectActivityTime setText:[NSDate formatDate:[self.timePicker.date description] FromFormat:dateFormatNSDateDate toFormat:pendingActivityTimeFormat]];
    }
    [self validations];
}



@end
