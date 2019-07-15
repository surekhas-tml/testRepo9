//
//  LostOpportunityViewController.m
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LostOpportunityViewController.h"
#import "NSString+NSStringCategory.h"
#import "ScreenshotCapture.h"
#import "AppRepo.h"
@interface LostOpportunityViewController (){
    UITextField *activeField;
    UITapGestureRecognizer *tapRecognizer;
    NSString *strPostponedTillDate;
    BOOL isMakeLostToActive;
    BOOL isModelLostToActive;
}
@property (strong, nonatomic , readonly) UIDatePicker *postponedDatePicker;
@end

@implementation LostOpportunityViewController
@synthesize postponedDatePicker,currentoptyUsers;
- (void)viewDidLoad {
    [super viewDidLoad];
     [_commentTextView setDelegate:self];
    [self.optyLostReson setDelegate:self];
    [self.makeLostTo setDelegate:self];
    [self.modelLostTo setDelegate:self];
    [self configureView];
    _commentTextView.text = @"Add Your Comments";
    _commentTextView.textColor = [UIColor lightGrayColor];
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Lost_Opportunity];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];
    
}
-(void)configureView{
    self.contactName.text = [[self.contact.firstName stringByAppendingString:@" "] stringByAppendingString:self.contact.lastName];
    self.customeContactNumber.text = self.contact.contactNumber;
    self.saleStage.text = self.opportunity.salesStageName;
    self.commentTextView.delegate = self;
    
    [self addTapGestureToField:self.optyLostReson];
    [self addTapGestureToField:self.makeLostTo];
    [self addTapGestureToField:self.modelLostTo];
    
    [self addGestureRecogniserToView];
    [self validation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIDatePicker *)postponedDatePicker{
    if (postponedDatePicker != nil) {
        return postponedDatePicker;
    }else{
        UIDatePicker *aDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        aDatePicker.backgroundColor = [UIColor lightGrayColor];
        aDatePicker.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [aDatePicker setDate:[NSDate date] animated:YES];
        [aDatePicker setMinimumDate:[NSDate date]];
        [aDatePicker setDatePickerMode:UIDatePickerModeDate];
        //[aDatePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        postponedDatePicker = aDatePicker;
        // Toolbar
        [self setToolbarForPicker:postponedDatePicker andCancelButtonHidden:false];
        return postponedDatePicker;
    }
}
#pragma mark - validations
-(void)validation{
    [UtilityMethods setGreyBoxBorder:self.postponedToDate];
    [UtilityMethods setGreyBoxBorder:self.makeLostTo];
    [UtilityMethods setGreyBoxBorder:self.modelLostTo];
    
    self.optyLostReson.layer.borderWidth = 0.5f;
    self.optyLostReson.layer.borderColor = [UIColor mandatoryFieldRedBorderColor].CGColor;  //new
    self.commentTextView.layer.borderWidth = 1.0f;
    self.commentTextView.layer.borderColor = [UIColor mandatoryFieldRedBorderColor].CGColor;

    if ([self.optyLostReson.text isEqualToString:@"Postponed"]) {
        [UtilityMethods setRedBoxBorder:self.postponedToDate];
//        [self.modelLostTo setEnabled:NO];
//        [self.makeLostTo setEnabled:NO];
        isModelLostToActive = false;
        isMakeLostToActive = false;
        [self.postponedToDate setEnabled:YES];
        
    }else if ([self.optyLostReson.text containsString:@"LTC"]){
        [UtilityMethods setRedBoxBorder:self.makeLostTo];
        [UtilityMethods setRedBoxBorder:self.modelLostTo];
//        [self.modelLostTo setEnabled:YES];
//        [self.makeLostTo setEnabled:YES];
        isModelLostToActive = true;
        isMakeLostToActive = true;
        [self.postponedToDate setEnabled:NO];
    }else{
//        [self.modelLostTo setEnabled:NO];
//        [self.makeLostTo setEnabled:NO];
        isModelLostToActive = false;
        isMakeLostToActive = false;
        [self.postponedToDate setEnabled:NO];
    }
    
    
    if ([self.optyLostReson.text isEqualToString:@"Postponed"]) {
        if (self.postponedToDate.text.length > 0 && self.commentTextView.text.length >0) {
            [self.saveButton setEnabled:YES];
            [self.saveButton setBackgroundColor:[UIColor navBarColor]];
        }
    }else if ([self.optyLostReson.text containsString:@"LTC"] && self.commentTextView.text.length >0 ){
        if (self.makeLostTo.text.length > 0 && self.makeLostTo.text.length > 0 && self.commentTextView.text.length >0) {
            [self.saveButton setEnabled:YES];
            [self.saveButton setBackgroundColor:[UIColor navBarColor]];
        }
    }else if (self.commentTextView.text.length >0 && self.optyLostReson.text.length > 0){
        [self.saveButton setEnabled:YES];
        [self.saveButton setBackgroundColor:[UIColor navBarColor]];
    }
    else{
        [self.saveButton setEnabled:NO];
        [self.saveButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}



    
-(void)APICallsForTextField:(UITextField *)textField{
    //[textField resignFirstResponder];
    if ([textField isEqual: self.optyLostReson]) {
        [textField resignFirstResponder];

        [self getOptyLostResons];
    }else if ([textField isEqual: self.modelLostTo]) {
        [textField resignFirstResponder];

        [self getOptyLostModel];

    }else if ([textField isEqual: self.makeLostTo]) {
        [textField resignFirstResponder];

        [self getOptyLostMake];

    }else if ([textField isEqual:self.postponedToDate]){
        textField.inputView = [self postponedDatePicker];
    }
}

-(void)getOptyLostResons{
    
    [[EGRKWebserviceRepository sharedRepository]opprtunityLostResoneList:@{
        @"salestagename" : self.opportunity.salesStageName
    } andSucessAction:^(id contact) {
        NSLog(@"%@", [contact description]);
        [self showDataDropdownWithData:contact];
        
    } andFailuerAction:^(NSError *error) {
        [ScreenshotCapture takeScreenshotOfView:self.view];
        AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
        appDelegate.screenNameForReportIssue = @"Lost Opportunity:Reason List";

        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
            
        } andReportIssueAction:^{
            
        }];

        //[UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
    }];
}
-(void)getOptyLostModel{
    NSString *lob = (nil != self.opportunity.toVCNumber.lob) ? self.opportunity.toVCNumber.lob : nil;
    if(nil == lob)
        return;

    NSDictionary *requestDict = nil;
    requestDict = @{
                    @"lob_name" : lob? : @""
                };
    
    [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
        NSMutableArray *nameResponseArray = [NSMutableArray array];
        if (responseArray && [responseArray count] > 0) {
            nameResponseArray = [responseArray valueForKey:@"pplName"];
        }
        [self showPopOver:activeField withDataArray:nameResponseArray andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailuerAction:^(NSError *error) {
        
    }];
}

-(void)getOptyLostMake{
    [[EGRKWebserviceRepository sharedRepository]opprtunityLostMakeList:@{
        @"salestagename" : self.opportunity.salesStageName
    } andSucessAction:^(id contact) {
        NSLog(@"%@", [contact description]);
        [self showDataDropdownWithData:contact];
    } andFailuerAction:^(NSError *error) {
        [ScreenshotCapture takeScreenshotOfView:self.view];
        AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
        appDelegate.screenNameForReportIssue = @"Lost Opportunity:Make_Lost_to";

        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
            
        } andReportIssueAction:^{
            
        }];

        
        //[UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
    }];
}


-(void)showDataDropdownWithData:(id)array{
    [self showPopOver:activeField withDataArray:array andModelData:array];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self validation];
    return YES;}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

# pragma mark - Text field

- (void)addTapGestureToField:(UITextField *)mTextField {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldTapped:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [mTextField.superview addGestureRecognizer:tapGesture];
}

- (void)textFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded) {
                if (CGRectContainsPoint(textField.frame, point)) {
                    [self.view endEditing:true];
                    if (textField == self.modelLostTo && !isModelLostToActive) {
                        return;
                    } else if (textField == self.makeLostTo && !isMakeLostToActive) {
                        return;
                    } else {
                        activeField = textField;
                        [self APICallsForTextField:textField];
                    }
                }
            }
        }
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    [self validation];
    return YES;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.commentTextView resignFirstResponder];
//    
//        activeField = textField;
//     
//        [self APICallsForTextField:textField];
//}
//
//- (void)textFieldDidEndEditing:(UITextField*)textField{
//    [self validation];
//    [textField resignFirstResponder];
//}
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    [textView resignFirstResponder];
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    return YES;
//}
- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSString *dateString =[NSDate formatDate:[datePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    strPostponedTillDate = [datePicker.date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];
    self.postponedToDate.text = dateString;
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
    
    self.postponedToDate.inputAccessoryView = self.toolbar;

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField != self.postponedToDate) {
        [textField resignFirstResponder];
    }
    if (textField == self.postponedToDate) {
        // Toolbar
        textField.inputView = [self postponedDatePicker];
        [self setToolbarForPicker:postponedDatePicker andCancelButtonHidden:false];
        
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _commentTextView.text = @"";
    _commentTextView.textColor = [UIColor blackColor];
    return YES;
}



- (IBAction)saveLostOpportunityDetails:(id)sender {

    NSString * comment = [self.commentTextView.text isEqualToString:@"Add Your Comments"]?@"":self.commentTextView.text;
    NSString *postponedDate = @"";
    if ([self.postponedToDate.text hasValue] && [strPostponedTillDate hasValue]) {
        postponedDate = strPostponedTillDate;
    }
    if ([[AppRepo sharedRepo]isDSMUser]) {
    if([currentoptyUsers isEqual:@"My_Opportunity"])
    {
        self.isdsmdseopty1=MYOPTY;
        
    }
    else
    {
       self.isdsmdseopty1=TEAMOPTY;
    
    }}
    else{
        self.isdsmdseopty1=MYOPTY;
    }

    
    NSDictionary *requestDictionary = @{
                                        @"opty_id" : self.opportunity.optyID,
                                        @"closure_summary" : comment,
                                        @"make_lost_to" : self.makeLostTo.text,
                                        @"model_lost_to" : self.modelLostTo.text,
                                        @"reason_to_lost" : self.optyLostReson.text,
                                        @"postponed_date" : postponedDate,
                                        @"sales_stage_name" : self.saleStage.text,
                                        @"search_status" : [NSNumber numberWithInt:self.isdsmdseopty1]

                                        };
    
    [[EGRKWebserviceRepository sharedRepository] mark_as_lost:requestDictionary andSucessAction:^(id responseDict) {
        NSString *message = @"mark as lost Successfully";
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            if ([((NSDictionary *) responseDict) objectForKey:@"msg"]) {
                message = [((NSDictionary *) responseDict) objectForKey:@"msg"];
            }
        }
        
        if ([self.opportunity.salesStageName containsString:C0]) {
            self.opportunity.salesStageName = [CLOSEDLOST stringByAppendingString:C0];
        }else if ([self.opportunity.salesStageName containsString:C1A]) {
            self.opportunity.salesStageName = [CLOSEDLOST stringByAppendingString:C1A];
        }else if ([self.opportunity.salesStageName containsString:C1]) {
            self.opportunity.salesStageName = [CLOSEDLOST stringByAppendingString:C1];
        }else if ([self.opportunity.salesStageName containsString:C2]) {
            self.opportunity.salesStageName = [CLOSEDLOST stringByAppendingString:C2];
        }
        [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
            [self.navigationController popViewControllerAnimated:true];
        }];
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 504) {
            [UtilityMethods alert_ShowMessage:UnableToProcessRequest withTitle:APP_NAME andOKAction:^{
                
            }];
        }
    }];
    
}


- (IBAction)clearAllText:(id)sender {
    [UtilityMethods clearAllTextFiledsInView:self.textFieldHolderView];
    
    self.commentTextView.text = @"";
    [self validation];
}

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    if ([self conformsToProtocol:@protocol(UIGestureRecognizerDelegate)]) {
        tapRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

    }
    [self.view addGestureRecognizer:tapRecognizer];
}
#pragma mark - gesture methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}
-(void)gestureHandlerMethod:(id)sender{
}
#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Add Your Comments";
        [textView resignFirstResponder];
    }
}

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    if (dropDownForView == self.optyLostReson) {
        self.makeLostTo.text = @"";
        self.modelLostTo.text = @"";
        self.postponedToDate.text = @"";
        [self validation];
    }
}

- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [postponedDatePicker removeFromSuperview];
    
    self.postponedToDate.inputAccessoryView = nil;
    
    [self.postponedToDate resignFirstResponder];
}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    [self.postponedToDate setText:[NSDate formatDate:[postponedDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    strPostponedTillDate = [postponedDatePicker.date ToUTCStringInFormat:dateFormatMMddyyyyHHmmss];

}

    

@end
