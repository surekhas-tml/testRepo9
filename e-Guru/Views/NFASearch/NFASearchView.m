//
//  NFASearchView.m
//  e-guru
//
//  Created by Juili on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFASearchView.h"
@interface NFASearchView(){
    AppDelegate *appDelegate;
    UIDatePicker *fromDatePicker;
    UIDatePicker *toDatePicker;
    UIDatePicker *fromOptyDatePicker;
    UIDatePicker *toOptyDatePicker;
    UITextField *activeField;
    NSMutableArray *LOBResponseArray;
    EGLob *selectedlob;

}
@end
@implementation NFASearchView
@synthesize searchFilter;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        
        [[NSBundle mainBundle] loadNibNamed:@"NFASearchView" owner:self options:nil];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        LOBResponseArray = [NSMutableArray array];
        _fromDateImage.hidden=NO;
        _toDateImage.hidden=NO;
        _fromOptyDateImage.hidden=NO;
        _toOptyDateImage.hidden=NO;
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
       
        }
    return self;
}
-(EGSearchNFAFilter *)searchFilter{
    if (!searchFilter) {
        searchFilter = [[EGSearchNFAFilter alloc]init];
    }
    return searchFilter;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.searchButton setEnabled:FALSE];
    [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
    self.searchButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.cornerRadius = 5.0f;
    self.searchFilter = [[EGSearchNFAFilter alloc]init];

    self.layer.borderWidth = 1.0f;
    
    [self setInitialDates];
    
    [self validations];
}
-(void)setInitialDates
{
    [self fromDatePicker];
    [self toDatePicker];
    
    /**
     Change done as part of 22nd June 2017 enhancement
     -  Made opty date range fields non mandatory
     -  Fixed a bug that when clear button was tapped, API was fired with default NFA
        date range but the NFA date range text fields were not set with the default date
        range.
     **/
    
    fromDatePicker.date = [NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ];
    [toDatePicker setDate:[NSDate date] animated:YES];
    
    [self onFromDatePickerValueChanged:fromDatePicker];
    [self onToDatePickerValueChanged:toDatePicker];
    
    
    [self fromOptyDatePicker];
    [self toOptyDatePicker];
    
    [fromOptyDatePicker setDate:[NSDate date] animated:YES];
    [toOptyDatePicker setDate:[NSDate date] animated:YES];
    
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
    
    if (_tappedView == fromDatePicker) {
        self.nfaFromDate.inputAccessoryView = self.toolbar;

    }
    else if (_tappedView == toDatePicker){
        self.nfaToDate.inputAccessoryView = self.toolbar;

    }else if (_tappedView == fromOptyDatePicker){
        self.optyFromDate.inputAccessoryView = self.toolbar;

    }else if (_tappedView == toOptyDatePicker){
        self.optyToDate.inputAccessoryView = self.toolbar;
    }
    
    
    
}
-(UIDatePicker *)fromOptyDatePicker{
    if (fromOptyDatePicker != nil) {
        //validate dates
        [fromOptyDatePicker setMaximumDate:[NSDate date]];
        if (fromOptyDatePicker.date >toOptyDatePicker.date) {
            [toOptyDatePicker setMinimumDate:fromOptyDatePicker.date];
        }
        self.tappedView = fromOptyDatePicker;
        return fromOptyDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate date] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //[datePickerNew addTarget:self action:@selector(onFromDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        fromOptyDatePicker = datePickerNew;
        
        //validate dates
        [fromOptyDatePicker setMaximumDate:[NSDate date]];
        if (fromOptyDatePicker.date >toDatePicker.date) {
            [toOptyDatePicker setMinimumDate:fromOptyDatePicker.date];
        }
        self.tappedView = fromOptyDatePicker;
        // Toolbar
        [self setToolbarForPicker:fromOptyDatePicker andCancelButtonHidden:false];
        
        return fromOptyDatePicker;
    }
}
-(UIDatePicker *)toOptyDatePicker{
    if (toOptyDatePicker != nil) {
        //validate dates
        [toOptyDatePicker setMinimumDate:fromOptyDatePicker.date];
        self.tappedView = toOptyDatePicker;
        return toOptyDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //        [datePickerNew addTarget:self action:@selector(onToDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        toOptyDatePicker = datePickerNew;
        
        //validate dates
        [toOptyDatePicker setMinimumDate:fromOptyDatePicker.date];
        
        self.tappedView = toOptyDatePicker;
        // Toolbar
        [self setToolbarForPicker:toOptyDatePicker andCancelButtonHidden:false];
        
        return toOptyDatePicker;
    }
}

-(UIDatePicker *)fromDatePicker{
    if (fromDatePicker != nil) {
        //validate dates
        [fromDatePicker setMaximumDate:[NSDate date]];
        if (fromDatePicker.date >toDatePicker.date) {
            [toDatePicker setMinimumDate:fromDatePicker.date];
        }
        self.tappedView = fromDatePicker;
        return fromDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDate:[NSDate date] animated:YES];
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        //[datePickerNew addTarget:self action:@selector(onFromDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        fromDatePicker = datePickerNew;
        
        //validate dates
        [fromDatePicker setMaximumDate:[NSDate date]];
        if (fromDatePicker.date >toDatePicker.date) {
            [toDatePicker setMinimumDate:fromDatePicker.date];
        }
        self.tappedView = fromDatePicker;
        // Toolbar
        [self setToolbarForPicker:fromDatePicker andCancelButtonHidden:false];
        
        return fromDatePicker;
    }
}

-(UIDatePicker *)toDatePicker{
    if (toDatePicker != nil) {
        //validate dates
        [toDatePicker setMinimumDate:fromDatePicker.date];
        self.tappedView = toDatePicker;
        return toDatePicker;
    }else{
        UIDatePicker *datePickerNew = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        datePickerNew.backgroundColor = [UIColor lightGrayColor];
        datePickerNew.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        [datePickerNew setDatePickerMode:UIDatePickerModeDate];
        toDatePicker = datePickerNew;
        //validate dates
        [toDatePicker setMinimumDate:fromDatePicker.date];
        
        self.tappedView = toDatePicker;
        // Toolbar
        [self setToolbarForPicker:toDatePicker andCancelButtonHidden:false];
        
        return toDatePicker;
    }
}

- (void)onFromDatePickerValueChanged:(UIDatePicker *)datePicker
{
    if (datePicker == fromDatePicker) {
        NSString *dateString =[NSDate formatDate:[fromDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
        self.nfaFromDate.text = dateString;
    }else if (datePicker == fromOptyDatePicker){
        NSString *dateString =[NSDate formatDate:[fromOptyDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.optyFromDate.text = dateString;
    }
}
-(void)onToDatePickerValueChanged:(UIDatePicker *)datePicker{
    if (datePicker == toDatePicker) {
        NSString *dateString =[NSDate formatDate:[toDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
        self.nfaToDate.text = dateString;
    }else if (datePicker == toOptyDatePicker){
        NSString *dateString =[NSDate formatDate:[toOptyDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
        self.optyToDate.text = dateString;
    }

}

# pragma mark - Text field
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    if (textField == self.nfaFromDate) {
        textField.inputView = [self fromDatePicker];
    }
    else if (textField == self.nfaToDate){
        textField.inputView = [self toDatePicker];
    }else if (textField == self.optyToDate){
        textField.inputView = [self toOptyDatePicker];
    }else if (textField == self.optyFromDate){
        textField.inputView = [self fromOptyDatePicker];
    }else if (textField == self.selectSalesStageTB){
        [self APIsalesStageForTextField:textField];
    }
    else if (textField == self.selectPPLTB){
        if([self.selectLOBTB.text isEqual:@""])
        {
            [textField resignFirstResponder];
            
            [UtilityMethods alert_ShowMessage:@"Please Select LOB" withTitle:APP_NAME andOKAction:nil];
        }else{
            [self APIpplForTextField:textField];
        }
    }else if (textField == self.selectLOBTB){
        selectedlob = nil;
        [self APILobForTextField:textField];
    }else if (textField == self.nfaStatusTB){
        [self APIstatusForTextField:textField];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.nfaFromDate ) {
        // Toolbar
        [self setToolbarForPicker:fromDatePicker andCancelButtonHidden:false];
        
    }
    else if (textField == self.nfaToDate){
        // Toolbar
        [self setToolbarForPicker:toDatePicker andCancelButtonHidden:false];
        
    }
    else if ( textField == self.optyFromDate){
        // Toolbar
        [self setToolbarForPicker:fromOptyDatePicker andCancelButtonHidden:false];
        
    }
    else if (textField == self.optyToDate){
        // Toolbar
        [self setToolbarForPicker:toOptyDatePicker andCancelButtonHidden:false];
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES; // We do not want UITextField to insert line
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [activeField resignFirstResponder];
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    activeField = nil;
}
#pragma mark - validations

-(void)validations{
    if(self.nfaFromDate.text.length > 0 )
    {
        _fromDateImage.hidden=YES;
    }
    else
    {
        _fromDateImage.hidden=NO;
    }
    if(self.nfaToDate.text.length > 0 )
    {
        _toDateImage.hidden=YES;
    }
    else
    {
        _toDateImage.hidden=NO;
    }
    if(self.optyFromDate.text.length > 0 )
    {
        _fromOptyDateImage.hidden=YES;
    }
    else
    {
        _fromOptyDateImage.hidden=NO;
    }
    if(self.optyToDate.text.length > 0 )
    {
        _toOptyDateImage.hidden=YES;
    }
    else
    {
        _toOptyDateImage.hidden=NO;
    }
    
    // First validate NFA date range
    
    if (self.nfaFromDate.text.length > 0  && self.nfaToDate.text.length > 0) {
        [self.searchButton setEnabled:TRUE];
        [self.searchButton setBackgroundColor:[UIColor navBarColor]];
        
        // If NFA date range is valid/not empty the check the opty date range
        
        if ((self.optyFromDate.text.length == 0  && self.optyToDate.text.length == 0) ||
            (self.optyFromDate.text.length > 0  && self.optyToDate.text.length > 0)) {
            [self.searchButton setEnabled:TRUE];
            [self.searchButton setBackgroundColor:[UIColor navBarColor]];
            
        }else{
            
            [self.searchButton setEnabled:FALSE];
            [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        
    }else{
        
        [self.searchButton setEnabled:FALSE];
        [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}
- (IBAction)clearSearchFilter:(id)sender {
    
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerView1];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerView2];
    [self setInitialDates];
    [self validations];
    [self.delegate fieldsCleared];
    // Clear the opty date range in the filter parameters
    self.searchFilter.opty_from_date = @"";
    self.searchFilter.opty_to_date = @"";
}


-(IBAction)searchWithSelectedFilter:(id)sender {
    self.searchFilter.nfa_request_number = self.nfaRequestNumberTB.text;
    if ([self.nfaStatusTB.text length] > 0) {
        self.searchFilter.status = [[[NFAStatusMode map]objectForKey:self.nfaStatusTB.text]intValue];
    }else{
        self.searchFilter.status = all;
    }
    
    if (self.nfaFromDate.text.length > 0) {
        NSDate *nfa_from_date = [NSDate getNSDateFromString: self.nfaFromDate.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedStartDate = [NSDate getDate:[[NSDate getSOD:nfa_from_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        self.searchFilter.nfa_from_date = formattedStartDate;
    }
    if (self.nfaToDate.text.length > 0) {
        NSDate *nfa_to_date = [NSDate getNSDateFromString: self.nfaToDate.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedendDate = [NSDate getDate:[[NSDate getEOD:nfa_to_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        self.searchFilter.nfa_to_date = formattedendDate;
    }
    if (self.optyFromDate.text.length > 0) {
        NSDate *opty_from_date = [NSDate getNSDateFromString: self.optyFromDate.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedStartDate = [NSDate getDate:[[NSDate getSOD:opty_from_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        self.searchFilter.opty_from_date = formattedStartDate;
    }
    if (self.optyToDate.text.length > 0) {
        NSDate *opty_to_date = [NSDate getNSDateFromString: self.optyToDate.text havingFormat: dateFormatddMMyyyy];
        //TODO - revisit this logic
        NSString *formattedendDate = [NSDate getDate:[[NSDate getEOD:opty_to_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
        self.searchFilter.opty_to_date = formattedendDate;
    }
    
    self.searchFilter.lob = self.selectLOBTB.text;
    self.searchFilter.ppl = self.selectPPLTB.text;
    self.searchFilter.sales_stage = self.selectSalesStageTB.text;
    [self closeSearchDrawer:sender];
    [self.delegate searchNFAForQuery];
       
}

- (IBAction)closeSearchDrawer:(id)sender {
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
                        [self.delegate closeSearchDrawer];
                    }];
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Close_SearchNFAFilter_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

}
- (void)datePickerCancelButtonTapped {
    
    [self.toolbar removeFromSuperview];
    [toDatePicker removeFromSuperview];
    [fromDatePicker removeFromSuperview];
    [toOptyDatePicker removeFromSuperview];
    [fromOptyDatePicker removeFromSuperview];

    self.nfaFromDate.inputAccessoryView = nil;
    self.nfaToDate.inputAccessoryView = nil;
    
    [self.nfaFromDate resignFirstResponder];
    [self.nfaToDate resignFirstResponder];
    [self validations];

}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == fromDatePicker) {
        [activeField setText:[NSDate formatDate:[fromDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    else if (self.tappedView == toDatePicker) {
        [activeField setText:[NSDate formatDate:[toDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    if (self.tappedView == fromOptyDatePicker) {
        [activeField setText:[NSDate formatDate:[fromOptyDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];

    }else if (self.tappedView == toOptyDatePicker){
        [activeField setText:[NSDate formatDate:[toOptyDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }

    [self validations];
    
}
#pragma mark - API Calls for Search

- (void)APIsalesStageForTextField:(UITextField *)textField {
    [[EGRKWebserviceRepository sharedRepository] getSalesStageSuccessAction:^(NSArray *responseArray) {
        [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:responseArray] andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailureAction:^(NSError *error) {
        
    }];
    
}
-(void)getPPLListFromAPI{
    [[EGRKWebserviceRepository sharedRepository]pplList:@{@"lob" : @"tata"}
                                        andSucessAction:^(id contact) {
                                            [self showPopOver:activeField withDataArray:[NSMutableArray arrayWithArray:[contact valueForKeyPath:@"name"]] andModelData:[NSMutableArray arrayWithArray:[NSMutableArray arrayWithArray:contact]]];                                                                                                    }
                                       andFailuerAction:^(NSError *error) {
                                           [activeField resignFirstResponder];
                                       }];
}

-(void)APILobForTextField:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository] getListOfLOBsandSuccessAction:^(NSArray *responseArray)
     {
         if (responseArray && [responseArray count] > 0)
         {
             LOBResponseArray = [NSMutableArray arrayWithArray:responseArray];
         }
         [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[responseArray valueForKey:@"lobName"]] andModelData:LOBResponseArray];
     } andFailuerAction:^(NSError *error) {
     }];
}

-(void)APIpplForTextField:(UITextField *)textField{
    
    NSDictionary *requestDict = @{@"lob_name": selectedlob.lobName ? : @""};
    [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
        [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[responseArray valueForKey:@"pplName"]] andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailuerAction:^(NSError *error) {
    }];
}
-(void)APIstatusForTextField:(UITextField *)textField{
    [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[NFAStatusMode getLisOfEnum]] andModelData:[NFAStatusMode getLisOfEnum]];
}
- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    // Below check added to prevent blank dropdowns
    // from showing
    if (!array || [array count] < 1) {
        return;
    }
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    dropDown.delegate = self;
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}


- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    if([dropDownForView isEqual:self.selectLOBTB]){
        selectedlob = selectedObject;
        self.selectLOBTB.text = selectedValue;
    }
    else if ([dropDownForView isEqual:self.selectSalesStageTB]){
        self.selectSalesStageTB.text = selectedValue;
    }
  else if ([dropDownForView isEqual:self.selectPPLTB]){
        self.selectPPLTB.text = selectedValue;
    }
    else if ([dropDownForView isEqual:self.nfaStatusTB]){
        self.nfaStatusTB.text = selectedValue;
    }
}
@end
