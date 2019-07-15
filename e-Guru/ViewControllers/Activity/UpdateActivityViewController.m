//
//  UpdateActivityViewController.m
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UpdateActivityViewController.h"
#import "UtilityMethods.h"
#import "CreateOpportunityViewController.h"
#import "AppRepo.h"
#import "NSString+NSStringCategory.h"
#import "ActivityViewController.h"
#import "ScreenshotCapture.h"
#import "PendingActivitiesListViewController.h"
#import "Constant.h"
#import "InfluencerViewModel.h"

@interface UpdateActivityViewController (){
UITextField *activeField;
    UITapGestureRecognizer *tapRecognizer;
            
}
@property (strong, nonatomic , readonly) UIDatePicker *datePicker;
@property (strong, nonatomic , readonly) UIDatePicker *timePicker;
@end
@implementation UpdateActivityViewController

@synthesize datePicker,timePicker,dsenamelbl,DSEname,assignToView,opportunity;
- (void)viewDidLoad {
    [super viewDidLoad];
    assignToView=[[AssignTO alloc]init];
    if (self.activity.toOpportunity) {
        self.opportunity = self.activity.toOpportunity;
    }
    
    if (([self isGTMEActivity]) && ([[AppRepo sharedRepo] isDSEUser])) {
        self.createOptyButton.hidden = NO;
        self.markAsJunkButton.hidden = NO;

        if([self.activity.junk.lowercaseString isEqualToString:@"junk"]){
            [self.markAsJunkButton setBackgroundColor:[UIColor lightGrayColor]];
            [self.markAsJunkButton setEnabled:NO];
        }else{
            [self.markAsJunkButton setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
            [self.markAsJunkButton setEnabled:YES];
        }
        //Check is channel type is key customer or not
        if ([self isValidReferralOpty]){
             self.createReferralOptyButton.hidden = NO;
        }else{
             self.createReferralOptyButton.hidden = YES;
        }
    } else {
        self.createOptyButton.hidden = YES;
        self.markAsJunkButton.hidden = YES;
        self.createReferralOptyButton.hidden = YES;
    }
    
    
    
    // Do any additional setup after loading the view.
    self.comment.text = @"Add Your Comments";
    self.comment.textColor = [UIColor lightGrayColor];
    
    [self configureView];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Update_Activity];

}

-(BOOL)isValidReferralOpty{
    
    if ([self.activity.activityType isEqualToString:@"GTME_KC"]){
        return YES;
    }
    
    if ([self.activity.activityType isEqualToString:@"GTME_RV"]){
        return YES;
    }
    
    if ([self.activity.activityType isEqualToString:@"GTME_OT"]){
        return YES;
    }
    
    return NO;
}


-(NSDictionary *)getJsonForComment:(NSString *)str{
    
    NSString *strReplaced = [str stringByReplacingOccurrencesOfString:@"u'" withString:@"\""];
    strReplaced = [strReplaced stringByReplacingOccurrencesOfString:@"':" withString:@"\":"];
    strReplaced = [strReplaced stringByReplacingOccurrencesOfString:@"'," withString:@"\","];
    strReplaced = [strReplaced stringByReplacingOccurrencesOfString:@"'}" withString:@"\"}"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *commentJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"commentJson %@",commentJson);
    
    return commentJson;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) changeFrameOfCancelButton{
    
    [self.cancelButton setHidden:NO];
    [self.cancelButton setFrame:CGRectMake(self.cancelButton.frame.origin.x + 80
                                           ,self.cancelButton.frame.origin.y,self.cancelButton.frame.size.width, self.cancelButton.frame.size.height)];
    
}

-(void)configureView{
    self.updateButton.layer.cornerRadius = 5.0f;
    self.cancelButton.layer.cornerRadius = 5.0f;
   if ([[AppRepo sharedRepo] isDSMUser]){
    if([self.checkuser isEqualToString:@"My_Activity"]){
        self.dsenamelbl.hidden=YES;
        self.DSEname.hidden=YES;
        self.assignButton.hidden=YES;
        [self.updateButton setHidden:false];

    }else{
        self.dsenamelbl.hidden=NO;
        self.DSEname.hidden=NO;
        self.DSEname.text = [[self.opportunity.leadAssignedName stringByAppendingString:@" "] stringByAppendingString:self.opportunity.leadAssignedLastName];
        self.assignButton.hidden=YES;
        [self.updateButton setHidden:true];
         [self.activityStatus setEnabled:NO];
        
        [self.cancelButton setHidden:YES];
        [self performSelector:@selector(changeFrameOfCancelButton) withObject:nil afterDelay:0.3];

    }}
   else{
       self.dsenamelbl.hidden=YES;
       self.DSEname.hidden=YES;
       self.assignButton.hidden=YES;
       [self.updateButton setHidden:false];
       

   }
    
    if ([self.entryPoint isEqualToString:ACTIVITY] || [self.entryPoint isEqualToString:PENDINGSACTIVITY]) {//Enter From Activity Screen
        self.contactName.text = [[self.activity.toOpportunity.toContact.firstName stringByAppendingString:@" "] stringByAppendingString:self.activity.toOpportunity.toContact.lastName];
        self.mobileNumber.text = self.activity.toOpportunity.toContact.contactNumber;
        self.opportunityID.text = self.activity.toOpportunity.optyID;
        self.activityStatus.text =   self.activity.status;
        self.activityType.text = self.activity.activityType;
        self.date.text = [self makePlannedDateOnly];
        self.time.text = [self makePlannedTimeOnly];
        self.comment.text = self.activity.activityDescription;
        self.DSEname.text = [[self.activity.toOpportunity.leadAssignedName stringByAppendingString:@" "] stringByAppendingString:self.activity.toOpportunity.leadAssignedLastName];
       

    }
    else {
        //Enter From Create Opty Screen
      
        self.contactName.text = [[self.opportunity.toContact.firstName stringByAppendingString:@" "] stringByAppendingString:self.opportunity.toContact.lastName];
        self.mobileNumber.text = self.opportunity.toContact.contactNumber;
        self.opportunityID.text = self.opportunity.optyID;
        self.activityStatus.text = self.activity.status;
        self.activityType.text = self.activity.activityType;
        self.date.text = [self makePlannedDateOnly];
        self.time.text = [self makePlannedTimeOnly];
        
        assignToView.opty=self.opportunity;

        self.comment.text = self.activity.activityDescription;
    }
    [self validations];
}

#pragma mark - API Calls

-(void)apiCallForActivityTypeList:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository]getActivityTypeListForGivenOpportunity:nil andSucessAction:^(id type) {
     if ([[[type allValues] firstObject] count] > 0)
     {
         [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:type] andModelData:[NSMutableArray arrayWithArray:type]];
     }
     else{
         [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
         
     }
        

    } andFailuerAction:^(NSError *error) {
        //[UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
        
    }];

}

# pragma mark - UI Picker Methods

-(UIDatePicker *)datePicker{
    if (datePicker != nil) {
        self.tappedView = datePicker;
        return datePicker;
    }else{
        UIDatePicker *aDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        [aDatePicker setMinimumDate:[NSDate date]];
        aDatePicker.backgroundColor = [UIColor lightGrayColor];
        aDatePicker.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [aDatePicker setDate:[NSDate date] animated:YES];
        [aDatePicker setDatePickerMode:UIDatePickerModeDate];
        [aDatePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
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
        UIDatePicker *aDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        if ([datePicker.date compare:[NSDate date]] == NSOrderedSame) {
            [aDatePicker setMinimumDate:[NSDate date]];
        }
        aDatePicker.backgroundColor = [UIColor lightGrayColor];
        aDatePicker.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [aDatePicker setDate:[NSDate date] animated:YES];
        [aDatePicker setDatePickerMode:UIDatePickerModeTime];
        [aDatePicker addTarget:self action:@selector(onTimePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        timePicker = aDatePicker;
        
        self.tappedView = timePicker;
        // Toolbar
        [self setToolbarForPicker:timePicker andCancelButtonHidden:false];

        return timePicker;
    }
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePickerL
{
//    NSString *dateString =[NSDate formatDate:[datePickerL.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
//    if ([timePicker.date compare:[NSDate date]] == NSOrderedAscending) {
//        self.nextPlannedTime.text = @"";
//    }
//    ((UITextField *)activeField).text = dateString;
}
- (void)onTimePickerValueChanged:(UIDatePicker *)timePickerL
{

//    NSString *timeString =[NSDate formatDate:[timePickerL.date description] FromFormat:dateFormatNSDateDate toFormat:@"HH:mm"];
//    ((UITextField *)activeField).text = timeString;
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
        self.nextPlannedDate.inputAccessoryView = self.toolbar;
        
    }
    else if (_tappedView == timePicker){
        self.nextPlannedTime.inputAccessoryView = self.toolbar;
        
    }
    

}

#pragma mark - TextFieldDelegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;

    if (textField == self.date) {
        textField.inputView = [self datePicker];
    }
    else if (textField == self.time){
        textField.inputView = [self timePicker];
        
    }
    else if (textField == self.nextPlannedDate){
        textField.inputView = [self datePicker];
    }
    else if (textField == self.nextPlannedTime){
        textField.inputView = [self timePicker];
    }
    else if (textField == self.activityType){
        [self apiCallForActivityTypeList:textField];
    }
    else if (textField == self.activityStatus){
        [self showPopOver:activeField withDataArray:[NSMutableArray arrayWithArray:@[@"Done",@"Open"]] andModelData:[NSMutableArray arrayWithArray:@[@"Done",@"Open"]]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self validations];

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField*)textField{
    [self validations];
    [textField resignFirstResponder];

   
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField != self.nextPlannedDate && textField != self.nextPlannedTime) {
        [textField resignFirstResponder];
    }
    
    if (textField == self.nextPlannedDate) {
        // Toolbar
        [self setToolbarForPicker:datePicker andCancelButtonHidden:false];
        
    }
    else if (textField == self.nextPlannedTime){
        // Toolbar
        [self setToolbarForPicker:timePicker andCancelButtonHidden:false];
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self validations];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   
    self.comment.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self validations];
}


-(BOOL)isActivityEditNotAllowed{
    return ([self.opportunity.salesStageName containsString:C3] || [self.activity.status isEqualToString:@"Done"] || [self.opportunity.salesStageName containsString:LOST]);
}

# pragma mark - validations
//To check that is opportunity is not associated with curren activity then consider its backend added activity
-(BOOL)isGTMEActivity{
    
    if (((self.activity.toOpportunity.optyID.length == 0) || [self.activity.toOpportunity.optyID isEqualToString:@""]) && [self.entryPoint isEqualToString:ACTIVITY])  {
        return YES;
    } else {
        return NO;
    }
}

-(void)validations{
    
    [self.date setEnabled:NO];
    [self.time setEnabled:NO];
    [self.activityType setEnabled:NO];
    
    if ([self isActivityEditNotAllowed]) {
        [self.updateButton setEnabled:NO];
        [self.updateButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.activityStatus setEnabled:NO];
        [self.nextPlannedDate setEnabled:NO];
        [self.nextPlannedTime setEnabled:NO];
        [self.activityStatus setEnabled:NO];
        [self.comment setEditable:NO];


        }
    else
    {
        [self.activityStatus setEnabled:YES];
    
        if ([self.activityStatus.text isEqualToString:@"Done"]){
            [UtilityMethods setRedBoxBorder:self.nextPlannedDate];
            [UtilityMethods setRedBoxBorder:self.nextPlannedTime];
            [self.nextPlannedDate setEnabled:YES];
            [self.nextPlannedTime setEnabled:YES];
        }else{
            [self.nextPlannedDate setEnabled:NO];
            [self.nextPlannedTime setEnabled:NO];
            [UtilityMethods setGreyBoxBorder:self.nextPlannedDate];
            [UtilityMethods setGreyBoxBorder:self.nextPlannedTime];
        }
     
        if ([self.activityStatus.text isEqualToString:@"Done"])
        {
            if(self.nextPlannedTime.text.length > 0 && self.nextPlannedDate.text.length > 0)
            {
                [self.updateButton setEnabled:YES];
                [self.updateButton setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
            }
            else if([self.activityType.text isEqualToString:@"Papers Submitted"]){
                self.nextPlannedDate.enabled=false;
                self.nextPlannedTime.enabled=false;
                [UtilityMethods setGreyBoxBorder:self.nextPlannedDate];
                [UtilityMethods setGreyBoxBorder:self.nextPlannedTime];
                [self.updateButton setEnabled:YES];
                [self.updateButton setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
            }
            
        }
        
        else if ([self.activityStatus.text isEqualToString:@"Open"]){
            NSLog(@"%@ == %@",self.comment.text,self.activity.activityDescription);
            if (![self.comment.text isEqualToString:self.activity.activityDescription]) {
                [self.updateButton setEnabled:YES];
                [self.updateButton setBackgroundColor:[UIColor buttonBackgroundBlueColor]];
            }
            else{
                [self.updateButton setEnabled:NO];
                [self.updateButton setBackgroundColor:[UIColor buttonBackgroundGrayColor]];
            }
        }
    else{
        [self.updateButton setEnabled:NO];
        [self.updateButton setBackgroundColor:[UIColor lightGrayColor]];
    }}
    
    if ([[AppRepo sharedRepo] isDSMUser]){
        if([self.checkuser isEqualToString:@"My_Activity"]){
             [self.activityStatus setEnabled:YES];
        }
        else{
            [self.activityStatus setEnabled:NO];
        }}else{
            [self.activityStatus setEnabled:YES];
        }
    
}
-(NSString *)makePlannedDateOnly{

    return [self.activity planedDateSystemTimeInFormat:dateFormatddMMyyyy];
}
-(NSString *)makePlannedTimeOnly{
    return [self.activity planedDateSystemTimeInFormat:pendingActivityTimeFormat];
}

-(NSString *)makeNextPlanned{
    if (datePicker.date && timePicker.date) {
        NSDate *date = [NSDate generateCombinedDateTimeForDate:datePicker.date andTime:timePicker.date];
        NSString * dateString = [date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];
        return dateString;
    }
    return @"";

}

- (NSString *)makeStartDate {
    if ([self.activity.planedDate hasValue]) {
        return [self.activity planedDateTimeInFormat:dateFormatMMddyyyyHHmmss] ;
    }
    return @"";
}

- (NSString *)getActivityStartDate:(EGActivity *)mActivity {
    return mActivity.planedDate;
}

- (IBAction)updateAction:(id)sender {
    if (self.pendingActivitiesViewController) {
        // Added to fix issue: Pending Activity list not refreshing
        // on updating activity and returning to PendinActivitiesListViewController
        self.pendingActivitiesViewController.isActivityUpdated = true;
    }
    NSString * comment = [self.comment.text isEqualToString:@"Add Your Comments"]?@"":self.comment.text;

    NSMutableDictionary *requestDictionary;
    if ([self.entryPoint  isEqual: CREATEOPTY]) {
        requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                             @"opty" : @{
                                     @"opportunity_id" : self.opportunity.optyID
                                     },
                             @"status" : self.activityStatus.text,
                             @"type" : self.activityType.text,
                             @"comments" : comment,
                             @"activity_id" : self.activity.activityID,
                             @"contact_id":self.opportunity.toContact.contactID,
                             @"start_date": [self makeStartDate]
                             }];

    }
    else{
        requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                           @"opty" : @{
                                                                                   @"opportunity_id" :self.activity.toOpportunity.optyID
                                                                                   },
                                                                           @"status" : self.activityStatus.text,
                                                                           @"type" : self.activityType.text,
                                                                           @"comments" : comment,
                                                                           @"activity_id" : self.activity.activityID,
                                                                           @"contact_id":self.activity.toOpportunity.toContact.contactID,
                                                                           @"start_date": [self makeStartDate]
                                                                           
                                                                           }];

    }
    
    if (![self.activityType.text isEqualToString:@"Papers Submitted"]){
     if([self.activityStatus.text isEqualToString:@"Done"]) {
        [requestDictionary setObject:[self makeNextPlanned] forKey:@"next_plan_date"];
    }
    }
    
    [[EGRKWebserviceRepository sharedRepository] updateActivity:requestDictionary andSucessAction:^(id responseDict) {
        NSLog(@"Update Activity");
        NSString *message = @"Activity Updated Successfully";
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            if ([((NSDictionary *) responseDict) objectForKey:@"msg"]) {
                message = [((NSDictionary *) responseDict) objectForKey:@"msg"];
            }
        }
        
        if ([self.activityType.text isEqualToString:@"Papers Submitted"] &&
            [self.activityStatus.text isEqualToString:@"Done"]) {
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:PapersSubmittedDone
//             object:self];
//            self.pendingActivitiesViewController.isPaperSubmittedDone = true;
        }
        
        [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME onController:self andOKAction:^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"UpdateActivityScreen"
             object:self];
            
            if (self.isInvokedFromPushNotification) {
                self.isInvokedFromPushNotification = false;
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:true];
            }
            
        }];
        
        
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_UpdateActivity_Submit_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_Update_Activity_Successful];

    } andFailuerAction:^(NSError *error) {
        [ScreenshotCapture takeScreenshotOfView:self.view];
        AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appdelegate.screenNameForReportIssue = @"Update Activity";

        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME onController:self andOKAction:^{
            
        } andReportIssueAction:^{
            
        }];
        
         [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_UpdateActivity_Submit_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_Update_Activity_Failed];

            }];

}

- (IBAction)createOptyAction:(id)sender {
    
    
    NSString *evntActionTitle = (sender == self.createReferralOptyButton) ? GA_EA_Activity_Create_Referral_Opportunity_Button_Click : GA_EA_Activity_Create_Opportunity_Button_Click;
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:evntActionTitle withEventCategory:GA_CL_Activity withEventResponseDetails:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle: nil];
    
    CreateOpportunityViewController *tempCreateOptyVC = (CreateOpportunityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create Opportunity_View"];
    tempCreateOptyVC.entryPoint = InvokeForCreateOpportunity;
    //tempCreateOptyVC.commentsString = self.activity.stakeholderResponse;
    tempCreateOptyVC.activityObj = self.activity;//---carry forword GTME activity Data
    //To check that is from refferal opportunity creation
    
    tempCreateOptyVC.isFromReferralOptyCreatioin = (sender == self.createReferralOptyButton) ? YES : NO ;
    
    [self.navigationController pushViewController:tempCreateOptyVC animated:YES];
}

- (IBAction)createReferralOptyAction:(id)sender {
    [self createOptyAction:self.createReferralOptyButton];
}

- (IBAction)markAsJunkAction:(id)sender {
    
    NSDictionary *stackHolderResponseDict = [UtilityMethods getJSONFrom:self.activity.stakeholderResponse];
    
    if(stackHolderResponseDict == nil){
        [UtilityMethods alert_ShowMessage:@"Customer name and contact number should not be empty." withTitle:APP_NAME andOKAction:nil];
        return;
    }
    
    NSString *customerName = [NSString stringWithFormat:@"%@",stackHolderResponseDict[@"first_name"]];
    customerName = [customerName stringByTrimmingPrefixCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    customerName = [customerName stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:customerName forKey:@"customer_name"];
    [params setValue:stackHolderResponseDict[@"contact_no"] forKey:@"contact_num"];
    [params setValue:stackHolderResponseDict[@"channel_type"] forKey:@"channel_type"];
    [params setValue:@"junk" forKey:@"status"];

    InfluencerViewModel *influencerViewModel = [[InfluencerViewModel alloc]init];
    [influencerViewModel addCustomerWithParams:params isUpdate:YES withCompletionBlock:^(id  _Nonnull response) {
        NSDictionary *responseDic = (NSDictionary*)response;
        NSDictionary *responseData = responseDic[@"data"];

        if(responseData!=nil){
            [UtilityMethods alert_ShowMessage:@"Customer marked as junk successfully" withTitle:APP_NAME andOKAction:^{
                [self.markAsJunkButton setEnabled:NO];
                [self.markAsJunkButton setBackgroundColor:[UIColor lightGrayColor]];
            }];
        }
    } withFailureBlock:^(NSError * _Nonnull error) {
    }];
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.isInvokedFromPushNotification) {
        self.isInvokedFromPushNotification = false;
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)assignAction:(id)sender {
    
    [[EGRKWebserviceRepository sharedRepository]getDSElist:@{
                                                             @"dsm_id": @""                                                                     } andSucessAction:^(id contact) {
                                                                 self.assignToView = [[AssignTO  alloc]initWithFrame:CGRectMake(0, 0, 500, 350)];
                                                                 self.assignToView.currentAssignment.text = self.activity.toOpportunity.leadAssignedName;
                                                                 assignToView.layer.borderWidth = 0.5f;
                                                                 assignToView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                                                                 if ([[[contact allValues] firstObject] count] > 0) {
                                                                     NSArray * dseArray = [[contact allValues] firstObject];
                                                                     self.assignToView.delegate = self;
                                                                     self.assignToView.center = CGPointMake(self.view.center.x, self.view.center.y - 90);
                                                                     [self.view addSubview:self.assignToView];
                                                                     assignToView.opportunity = self.opportunity;
                                                                     assignToView.activity = self.activity;
                                                                     assignToView.entryPoint=ACTIVITY;
                                                                     self.assignToView.pickerViewArray = dseArray;
                                                                     [self.assignToView.pickerView reloadAllComponents];
                                                                 }else{
                                                                     [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                                                                     
                                                                 }
                                                                 
                                                                 
                                                                 
                                                             } andFailuerAction:^(NSError *error) {
                                                                 [ScreenshotCapture takeScreenshotOfView:self.view];
                                                                 AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                 appdelegate.screenNameForReportIssue = @"Update Activity";

                                                                 [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                                     
                                                                 } andReportIssueAction:^{
                                                                     
                                                                 }];
                                            
                                                             } showLoader:YES];

}

-(void)assignToDSEactivity:(EGDse *)dse{
    if (dse)
    {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_UpdateActivity_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:nil];

        [[EGRKWebserviceRepository sharedRepository]assignActivityDSM:@{
                                                                    @"dse_id" : dse.leadid,
                                                                    @"activity_id" : dse.toActivity.activityID,
                                                                    @"dse_name" : dse.leadLogin,
                                                                    @"opty_id" : dse.toOpportunity.optyID
                                                                    } andSucessAction:^(NSDictionary *contact) {
                                                                        [self.assignToView removeFromSuperview];
                                                                        [UtilityMethods alert_ShowMessage:@"Activity Assigned Successfully" withTitle:APP_NAME andOKAction:nil];
                                                                        
                                                                        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Assign_Activity_To_DSE_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_AssignToDSE_Successful];

                                                                    } andFailuerAction:^(NSError *error) {
                                                                        [ScreenshotCapture takeScreenshotOfView:self.assignToView];
                                                                        
                                                                        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                        appdelegate.screenNameForReportIssue = @"Update Activity";
                                                                       
                                                                        [self.assignToView removeFromSuperview];
                                                                        
                                                                        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                                            
                                                                        } andReportIssueAction:^{
                                                                            
                                                                        }];
                               [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Assign_Activity_To_DSE_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Activity withEventResponseDetails:GA_EA_AssignToDSE_Failed];

                                                                    }];
    }
    
    
    NSLog(@"selct");
    
    
    [assignToView removeFromSuperview];
}

-(void)cancelAssignmentActivityOperation{
    [self.assignToView removeFromSuperview];
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
    if ([selectedValue isEqualToString: @"Open"]) {
        self.nextPlannedDate.text = @"";
        self.nextPlannedTime.text = @"";

    }
    [self validations];

}

- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [datePicker removeFromSuperview];
    [timePicker removeFromSuperview];
    
    self.nextPlannedDate.inputAccessoryView = nil;
    self.nextPlannedTime.inputAccessoryView = nil;
    
    [self.nextPlannedDate resignFirstResponder];
    [self.nextPlannedTime resignFirstResponder];
}
- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == datePicker) {
        [self.nextPlannedDate setText:[NSDate getDate:datePicker.date InFormat:dateFormatddMMyyyy]];
    }
    else if (self.tappedView == timePicker) {
        [self.nextPlannedTime setText:[NSDate getDate:timePicker.date InFormat:pendingActivityTimeFormat]];
    }
    [self validations];
}

@end
