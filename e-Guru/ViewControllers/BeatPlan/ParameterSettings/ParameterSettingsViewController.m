//
//  ParameterSettingsViewController.m
//  e-guru
//
//  Created by Apple on 15/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "ParameterSettingsViewController.h"
#import "GreyBorderUITextField.h"
#import "UIColor+eGuruColorScheme.h"


@interface ParameterSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *startDateValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *endDateValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *maxMeetingNumberValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *divisionNameValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *dealerNameValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *c0Value;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *c1Value;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *c1aValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *c2Value;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *financeExecutivePriorityValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *bodyBuilderPriorityValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *KeyCustomerPriorityValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *regularVisitPriorityValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *financeExecutiveMinimumAllocationValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *bodyBuilderMinimumAllocationValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *KeyCustomerMinimumAllocationValue;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *regularVisitMinimumAllocationValue;

@end

@implementation ParameterSettingsViewController
@synthesize parameterSettingsViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    parameterSettingsViewModel = [[EGParameterSettingViewModel alloc]init];
    _view_meetingFrequency.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    _view_meetingFrequency.layer.borderWidth = 1.0;
    _view_channelPriorityBackground.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    _view_channelPriorityBackground.layer.borderWidth = 1.0;
    [self setBackgroundOfFields];
    [self getParameterFromServer];
//    [self setInitialDates];
    // Do any additional setup after loading the view.
}
-(void)setInitialDates
{
    //---//
    [self fromDatePicker];
//    [self toDatePicker];
    NSDate *today = [[NSDate alloc] init];
    fromDatePickerActivity.date = today;
    NSString *dateString = [NSDate getCurrentDateInFormat:dateFormatyyyyMMddhyp];
    self.startDateValue.text = dateString;
    [self getParameterFromServer];
}

-(UIDatePicker *)fromDatePicker{
    
    if (fromDatePickerActivity != nil) {
        
        self.tappedView = fromDatePickerActivity;
        return fromDatePickerActivity;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate getNoOfMonths:1 pastDateInFormat:dateFormatyyyyMMddhyp] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //[datePickerNew addTarget:self action:@selector(onFromDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        fromDatePickerActivity = datePickerNew;
        
        
        self.tappedView = fromDatePickerActivity;
        // Toolbar
        [self setToolbarForPicker:fromDatePickerActivity andCancelButtonHidden:false];
        
        return fromDatePickerActivity;
    }
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
        self.startDateValue.inputAccessoryView = self.toolbar;
        
    }
//    else if (_tappedView == toDatePickerActivity){
//        self.toDateActivity.inputAccessoryView = self.toolbar;
//
//    }
    
}

- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [fromDatePickerActivity removeFromSuperview];
    
    self.startDateValue.inputAccessoryView = nil;
    
    [self.startDateValue resignFirstResponder];
}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == fromDatePickerActivity) {
        [self.startDateValue setText:[NSDate formatDate:[fromDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp]];
            [ self getParameterFromServer ];

    }
//    else if (self.tappedView == toDatePickerActivity) {
//        [self.toDateActivity setText:[NSDate formatDate:[toDatePickerActivity.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
//    }
//    [self validations];
}

-(void)setBackgroundOfFields{
    self.maxMeetingNumberValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.endDateValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.divisionNameValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.dealerNameValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.c0Value.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.c1Value.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.c1aValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.c2Value.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.financeExecutiveMinimumAllocationValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.regularVisitMinimumAllocationValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.KeyCustomerMinimumAllocationValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.bodyBuilderMinimumAllocationValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.financeExecutivePriorityValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.regularVisitPriorityValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.KeyCustomerPriorityValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.bodyBuilderPriorityValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.startDateValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
    self.endDateValue.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.2];
}
-(void)getParameterFromServer{
    self.maxMeetingNumberValue.text = @"";
    self.endDateValue.text = @"";
    self.divisionNameValue.text = @"";
    self.dealerNameValue.text = @"";
    self.c0Value.text = @"";
    self.c1Value.text = @"";
    self.c1aValue.text = @"";
    self.c2Value.text = @"";
    self.financeExecutiveMinimumAllocationValue.text = @"";
    self.regularVisitMinimumAllocationValue.text = @"";
    self.KeyCustomerMinimumAllocationValue.text = @"";
    self.bodyBuilderMinimumAllocationValue.text = @"";
    self.financeExecutivePriorityValue.text = @"";
    self.regularVisitPriorityValue.text = @"";
    self.KeyCustomerPriorityValue.text = @"";
    self.bodyBuilderPriorityValue.text = @"";
    self.startDateValue.text = @"";
    self.endDateValue.text = @"";

    [parameterSettingsViewModel getParameterSettingForDate:[NSDate getCurrentDateInFormat:dateFormatyyyyMMddhyp] success:^(bool status) {
        if (status){
            self.maxMeetingNumberValue.text = [parameterSettingsViewModel setMeetingFrequency];
            self.startDateValue.text = [parameterSettingsViewModel setStartDate];
            self.endDateValue.text = [parameterSettingsViewModel setParamsEndDate];
            self.divisionNameValue.text = [parameterSettingsViewModel setDivisionName];
            self.dealerNameValue.text = [parameterSettingsViewModel setDealerName];
            self.c0Value.text = [parameterSettingsViewModel setMeetingFrequencyC0];
            self.c1Value.text = [parameterSettingsViewModel setMeetingFrequencyC1];
            self.c1aValue.text = [parameterSettingsViewModel setMeetingFrequencyC1a];
            self.c2Value.text = [parameterSettingsViewModel setMeetingFrequencyC2];
            self.financeExecutiveMinimumAllocationValue.text = [parameterSettingsViewModel setChannelFinancierMinimumAllocation];
            self.regularVisitMinimumAllocationValue.text = [parameterSettingsViewModel setChannelRegularVisitsMinimumAllocation];
//            self.KeyCustomerMinimumAllocationValue.text = [parameterSettingsViewModel setChannelKeyCustMinimumAllocation];
//            self.bodyBuilderMinimumAllocationValue.text = [parameterSettingsViewModel setChannelBodyBuilderMinimumAllocation];
            self.financeExecutivePriorityValue.text = [parameterSettingsViewModel setChannelFinancierPriority];
            self.regularVisitPriorityValue.text = [parameterSettingsViewModel setChannelRegularVisitsPriority];
            self.KeyCustomerPriorityValue.text = [parameterSettingsViewModel setChannelKeyCustPriority];
            self.bodyBuilderPriorityValue.text = [parameterSettingsViewModel setChannelBodyBuilderPriority];
            self.KeyCustomerMinimumAllocationValue.text = [parameterSettingsViewModel setChannelKeyCustMinimumAllocation];
            self.bodyBuilderMinimumAllocationValue.text = [parameterSettingsViewModel setChannelBodyBuilderMinimumAllocation];

        }
    }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - textFieldDelegates


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    if (textField == self.startDateValue) {
        // Toolbar
        [self setToolbarForPicker:fromDatePickerActivity andCancelButtonHidden:false];
        
    }
  
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    if (textField == self.startDateValue) {
        textField.inputView = [self fromDatePicker];
    }
}
@end
