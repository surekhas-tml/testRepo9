//
//  SearchOpportunityView.m
//  e-Guru
//
//  Created by Juili on 04/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchOpportunityView.h"
#import "EGSearchOptyFilter.h"

#import "EGLob.h"
#import "EGDse.h"
#import "NSString+NSStringCategory.h"
#import "FinanciersDBHelpers.h"
#import "EventDBHelper.h"

@interface SearchOpportunityView() {
    UIDatePicker *fromDatePicker;
    UIDatePicker *toDatePicker;
    UITapGestureRecognizer *tapRecognizer;
    UITextField *activeField1;
    NSMutableArray *LOBResponseArray;
    NSMutableArray *eventResponseArray;
    NSMutableArray *DSEResponseArray;
    EGLob *selectedlob;
    EGDse *selectedDse;
    NSString *selectedLiveDeal;
    NSString *selectedNFA;
    AppDelegate *appDelegate;
    NSMutableArray *DSEfullname;
    EGRKWebserviceRepository *currentTalukaOperation;
    BOOL fetchTaluka;
    EGFinancier *mFinancier;
    EGEvent *mSelectedEvent;
}
@property (strong,nonatomic)    UIActivityIndicatorView *actIndicator;

@end

@implementation SearchOpportunityView

@synthesize searchFilter=_searchFilter;
@synthesize actIndicator;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        fetchTaluka = YES;

        [[NSBundle mainBundle] loadNibNamed:@"SearchOpportunityView" owner:self options:nil];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        [self addGestureRecogniserToView];
        _fromdateimage.hidden=NO;
        _todateimage.hidden=NO;
        _salesStage.text = SEARCH_FILTER_SALES_STAGE_C0;
        _nfalbl.hidden = YES;
        _nfatxtfld.hidden = YES;
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LOBResponseArray = [NSMutableArray array];
        DSEResponseArray = [NSMutableArray array];
        DSEfullname = [NSMutableArray array];
        
        [self UserCheck];
        
        [self setupFinancierTextField];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.searchButton setEnabled:FALSE];
    [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
    [UtilityMethods setRedBoxBorder:self.fromDate];
    [UtilityMethods setRedBoxBorder:self.todate];
    self.searchButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.cornerRadius = 5.0f;
    
    self.layer.borderWidth = 1.0f;
    self.closeSearchDrawerButton.layer.cornerRadius = 10.0f;
    
    [self setInitialDates];
    
    [self validations];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentoptyUser isEqualToString:@"My_Opportunity"]) {
            
            self.dsenamelbl.hidden = YES;
            self.dsenametxtfld.hidden = YES;

        }else{
            self.dsenamelbl.hidden = NO;
            self.dsenametxtfld.hidden = NO;

        }
    }
    
    [self bindTapToView:self.view];
}

-(void)UserCheck {
    
    if([[AppRepo sharedRepo] isDSMUser]) {
        self.dseTopSpacing.constant = -30;
        self.searchDrawerView3Height.constant = 330;
        self.dsenamelbl.hidden = NO;
        self.dsenametxtfld.hidden=NO;
    } else {
        self.searchDrawerView3Height.constant = 290;
        self.dsenamelbl.hidden = YES;
        self.dsenametxtfld.hidden=YES;
    }
}

-(void) setSearchFilter:(EGSearchOptyFilter *)filter {
    if(![_searchFilter isEqual:filter]) {
        _searchFilter = filter;
        [self setInitialDates];
        ///TODO to set all values in view.
    }
}

-(void)setInitialDates
{
    [self fromDatePicker];
    [self toDatePicker];

    NSDate *from_date = nil;
    if( [_searchFilter.from_date hasValue] )
    {
        from_date = [[NSDate getNSDateFromString:_searchFilter.from_date havingFormat:dateFormatyyyyMMddTHHmmssZ]toLocalTime];
    }
    
    if(from_date)
    {
        fromDatePicker.date = from_date;
    } else{
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *indianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIndian];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setMonth:-6];
        NSDate *sixMonthsBefore = [indianCalender dateByAddingComponents:offsetComponents toDate:today options:0];
        fromDatePicker.date = sixMonthsBefore;
    }
    
    NSDate *to_date = nil;
    if( [_searchFilter.to_date hasValue] )
    {
        to_date = [[NSDate getNSDateFromString:_searchFilter.to_date havingFormat:dateFormatyyyyMMddTHHmmssZ]toLocalTime];
    }
    
    if(to_date)
    {
        [toDatePicker setDate:to_date animated:YES];
    } else {
        [toDatePicker setDate:[NSDate date] animated:YES];
    }
    
    [self onFromDatePickerValueChanged:fromDatePicker];
    [self onToDatePickerValueChanged:toDatePicker];
    
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
        self.fromDate.inputAccessoryView = self.toolbar;
        
    }
    else if (_tappedView == toDatePicker){
        self.todate.inputAccessoryView = self.toolbar;
        
    }
    
}


-(UIDatePicker *)fromDatePicker{
    if (fromDatePicker != nil) {
        //validate dates
        [fromDatePicker setMaximumDate:[NSDate date]];
        if (fromDatePicker.date >toDatePicker.date) {
            [toDatePicker setMinimumDate:fromDatePicker.date];
            self.todate.text = @"";
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
            self.todate.text = @"";
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
        //[datePickerNew addTarget:self action:@selector(onToDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
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
    NSString *dateString =[NSDate formatDate:[fromDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.fromDate.text = dateString;
}
-(void)onToDatePickerValueChanged:(UIDatePicker *)datePicker{
    NSString *dateString =[NSDate formatDate:[toDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy];
    self.todate.text = dateString;
    
}

- (void)showAutoCompleteTableForFinancierField {
    
    if (self.financierTextField.field.mValues && [self.financierTextField.field.mValues count] > 0) {
        
        [self.financierTextField loadTableViewForTextFiled:self.financierTextField.frame
                                                    onView:self.searchDrawerView3
                                                 withArray:self.financierTextField.field.mValues
                                                     atTop:true];
        
        [self.financierTextField.resultTableView reloadData];
        
    } else {
        [self setFinancierValuesInFinancierField];
    }
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

- (void)getEventList:(UITextField *)textField {
    
    [MBProgressHUD showHUDAddedTo:self.superview animated:true];
    
    // Delay added since without delay the above loader was not seen
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        [UtilityMethods RunOnOfflineDBThread:^{
            EventDBHelper *eventDBHelper = [EventDBHelper new];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"mEventName" ascending:true];
            NSMutableArray *eventsArray = [[[eventDBHelper fetchAllEvents] sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
            
            if (eventsArray && [eventsArray count] > 0) {
                [UtilityMethods RunOnMainThread:^{
                    [MBProgressHUD hideHUDForView:self.superview animated:true];
                    [self showPopOver:textField withDataArray:[eventsArray valueForKey:@"mEventName"] andModelData:eventsArray];
                }];

            } else {
                [UtilityMethods alert_ShowMessage:@"No events found" withTitle:APP_NAME andOKAction:^{
                    
                }];
            }
        }];
    });
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

-(void)APIactivityTypeForTalukaTextField:(UITextField *)textField WithString:(NSString *)string{
    [textField addSubview:[self actIndicatorForView:textField]];
    [textField setClearButtonMode:UITextFieldViewModeUnlessEditing];
    currentTalukaOperation = [EGRKWebserviceRepository sharedRepository];
    [self.actIndicator stopAnimating];
    [self.actIndicator startAnimating];
    [currentTalukaOperation getAllTaluka:@{@"taluka":string} andSucessAction:^(id contact, EGRKWebserviceRepository *sender) {
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
        talukaArray = [NSArray array];
        [UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
    }];
}

#pragma mark - search Drawer Open Close Action Methods

- (IBAction)closeSearchDrawer:(id)sender {
    
    // As the filter is closing, remove
    // the financier list tableview
    [self removeFinancierListTableView];
    
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


- (IBAction)searchOpportunityButtonClicked:(id)sender {
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Search_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];

    EGSearchOptyFilter *filter = [[EGSearchOptyFilter alloc] init];
    if (self.fromDate.text.length > 0 && self.todate.text.length > 0) {
        if (self.lastName.text.length > 0) {
            filter.contact_last_name = self.lastName.text;
        }
        if ([UtilityMethods validateMobileNumber:self.mobileNumber.text]){
            
            filter.customer_cellular_number = self.mobileNumber.text;
        }
        
        if (self.fromDate.text.length > 0) {
            NSDate *from_date = [NSDate getNSDateFromString: self.fromDate.text havingFormat: dateFormatddMMyyyy];
            //TODO - revisit this logic
            NSString *formattedStartDate = [NSDate getDate:[[NSDate getSOD:from_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
            filter.from_date = formattedStartDate;
        }
        if (self.todate.text.length > 0) {
            NSDate *to_date = [NSDate getNSDateFromString: self.todate.text havingFormat: dateFormatddMMyyyy];
            //TODO - revisit this logic
            NSString *formattedStartDate = [NSDate getDate:[[NSDate getEOD:to_date]toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ];
            filter.to_date = formattedStartDate;
        }
        if (self.salesStage.text.length > 0) {
            filter.sales_stage_name = self.salesStage.text;
        }
        if (self.ppl.text.length > 0) {
            filter.pplname = self.ppl.text;
        }
        if (self.taluka.text.length > 0) {
            filter.tehsil_name = self.taluka.text;
        }
        if (self.lob_textfield.text.length > 0) {
            filter.lob = self.lob_textfield.text;
        }
        
        if ([self.dsenametxtfld.text hasValue]) {
            filter.dse_position_id = selectedDse.leadAssignedPositionID;
        }
        
        if (self.liveDeal.text.length > 0) {
            if([self.liveDeal.text  isEqual: @"Yes"])
            {
                filter.live_deal_flag = @"Y";
            }
            else if([self.liveDeal.text  isEqual: @"No"])
            {
                filter.live_deal_flag = @"N";
            }
        }
        if (self.nfatxtfld.text.length > 0) {
            if([self.nfatxtfld.text  isEqual: @"Yes"])
            {
                filter.nfa_available = @"Y";
            }
            else if([self.nfatxtfld.text  isEqual: @"No"])
            {
                filter.nfa_available = @"N";
            }
        }
        filter.primary_employee_id = [[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID;
        
        if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
            if ([self.currentoptyUser isEqualToString:@"My_Opportunity"]) {
                
                filter.search_status=MYOPTY;
                
            }else{
                filter.search_status=TEAMOPTY;
            }
        }

        if (![filter.sales_stage_name hasValue]) {
            filter.sales_stage_name = SEARCH_FILTER_SALES_STAGE_C0;
        }
        // Financier Details
        if (self.financierTextField.text.length > 0) {
            filter.financier_id = mFinancier.financierID;
        }
        // Event Details
        if (self.eventxtfld.text.length > 0) {
            filter.event_id = mSelectedEvent.mEventID;
        }
        
        self.searchFilter = filter;
        [self.delegate searchOpportunityForQuery];
    }else{
        [UtilityMethods alert_ShowMessage:@"Fromdate And to Date are Mandetory Fields" withTitle:APP_NAME andOKAction:nil];
    }
}

- (IBAction)clearAllSearchButtons:(id)sender {
   
    // Remove the financier list tableview
    [self removeFinancierListTableView];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        self.dseTopSpacing.constant = -30;
        self.searchDrawerView3Height.constant = 330;
    }else{
        self.searchDrawerView3Height.constant = 290;
    }
    _nfatxtfld.hidden = true;
    _nfalbl.hidden = true;

    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerView1];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerView2];
    [UtilityMethods clearAllTextFiledsInView:self.searchDrawerView3];
    _salesStage.text = SEARCH_FILTER_SALES_STAGE_C0;
    [self.delegate fieldsCleared];
    [self validations];
    
}


# pragma mark - Text field
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    if (textField == self.fromDate) {
        textField.inputView = [self fromDatePicker];
    }
    else if (textField == self.todate){
        textField.inputView = [self toDatePicker];
    }
    else if (textField == self.salesStage){
        [self APIsalesStageForTextField:textField];
    }
    else if (textField == self.ppl){
        if([self.lob_textfield.text isEqual:@""])
        {
            [textField resignFirstResponder];
            
            [UtilityMethods alert_ShowMessage:@"Please Select LOB" withTitle:APP_NAME andOKAction:nil];
        }else{
            [self APIpplForTextField:textField];
        }
    }else if (textField == self.lob_textfield){
        selectedlob = nil;
        [self APILobForTextField:textField];
    }
    
    else if (textField == self.dsenametxtfld){
        [self APIDSEForTextField:textField];
    }
    else if (textField == self.nfatxtfld){
        selectedNFA = nil;
        [self showPopOver:activeField withDataArray:[NSMutableArray arrayWithArray:@[@"Yes",@"No"]] andModelData:[NSMutableArray arrayWithArray:@[@"Y",@"N"]]];
    }
    else if (textField == self.liveDeal){
        selectedLiveDeal = nil;
        [self showPopOver:activeField withDataArray:[NSMutableArray arrayWithArray:@[@"Yes",@"No"]] andModelData:[NSMutableArray arrayWithArray:@[@"Y",@"N"]]];
    }
    else if (textField == self.eventxtfld) {
        [self getEventList:textField];
    }
    else if (textField == self.financierTextField) {
        [self showAutoCompleteTableForFinancierField];
    }
    else{
        if (textField == self.mobileNumber) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }else{
            textField.keyboardType = UIKeyboardTypeDefault;
        }
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self validations];
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    if (textField == self.lob_textfield || textField == self.ppl || textField == self.salesStage || textField == self.liveDeal|| textField == self.nfatxtfld) {
        return NO;
    }else if(textField == self.taluka){
        if (textField == self.taluka && length > 3 && fetchTaluka){
            
            [self APIactivityTypeForTalukaTextField:textField WithString:currentString];
        }
    }else if (textField == self.mobileNumber) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    } else if (textField == self.financierTextField) {
        [self.financierTextField reloadDropdownList_ForString:currentString];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [self validations];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    fetchTaluka = YES;
    if (textField == self.fromDate) {
        // Toolbar
        [self setToolbarForPicker:fromDatePicker andCancelButtonHidden:false];
        
    }
    else if (textField == self.todate){
        // Toolbar
        [self setToolbarForPicker:toDatePicker andCancelButtonHidden:false];
        
    }

    if(textField != self.taluka && textField != self.mobileNumber && textField != self.lastName && textField != self.fromDate && textField != self.todate && textField != self.financierTextField){
        [textField resignFirstResponder];
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


#pragma mark - validations

-(void)validations{
    if(self.fromDate.text.length > 0 )
    {
        _fromdateimage.hidden=YES;
    }
    else
    {
        _fromdateimage.hidden=NO;
    }
    if(self.todate.text.length > 0 )
    {
        _todateimage.hidden=YES;
    }
    else
    {
        _todateimage.hidden=NO;
    }
    
    if (self.fromDate.text.length > 0  && self.todate.text.length > 0) {
        [self.searchButton setEnabled:TRUE];
        [self.searchButton setBackgroundColor:[UIColor navBarColor]];
        
    }else{
        
        [self.searchButton setEnabled:FALSE];
        [self.searchButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}
#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    else if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
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
-(void)gestureHandlerMethod:(UITapGestureRecognizer *)gesture{
    [activeField resignFirstResponder];
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

- (void)bindTapToView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAutoCompleteTableView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setDelegate:self];
    [view addGestureRecognizer:tapGesture];
}

- (void)removeAutoCompleteTableView:(UITapGestureRecognizer *)gesture {
    [self removeFinancierListTableView];
}

- (void)removeFinancierListTableView {
    if (self.financierTextField && [self.financierTextField.resultTableView isDescendantOfView:self.searchDrawerView3]) {
        [self.financierTextField.resultTableView removeFromSuperview];
        [self.financierTextField resignFirstResponder];
    }
}

- (void)adjustFilterViewsBasedOnSalesStage:(NSString *)selectedValue {
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        
        [self adjustFilterViewsForDSMBasedOnSalesStage:selectedValue];
        
    } else {
        
        [self adjustFilterViewsForDSEBasedOnSalesStage:selectedValue];
    }
}

- (void)adjustFilterViewsForDSMBasedOnSalesStage:(NSString *)selectedValue {
    
    if (![selectedValue containsString:@"C0"]) {
        
        self.dseTopSpacing.constant = 10;
        if (self.searchFilter.search_status == TEAMOPTY) {
            self.searchDrawerView3Height.constant = 370;
        } else {
            self.searchDrawerView3Height.constant = 330;
        }
        
        _nfatxtfld.hidden = false;
        _nfalbl.hidden = false;
        
    } else {
        
        self.dseTopSpacing.constant = -30;
        if (self.searchFilter.search_status == TEAMOPTY) {
            self.searchDrawerView3Height.constant = 330;
        } else {
            self.searchDrawerView3Height.constant = 290;
        }
        
        _nfatxtfld.hidden = true;
        _nfalbl.hidden = true;
    }
}

- (void)adjustFilterViewsForDSEBasedOnSalesStage:(NSString *)selectedValue {
    
    if (![selectedValue containsString:@"C0"]) {
        self.searchDrawerView3Height.constant = 330;
        
        _nfatxtfld.hidden = false;
        _nfalbl.hidden = false;
    } else {
        self.searchDrawerView3Height.constant = 290;
        
        _nfatxtfld.hidden = true;
        _nfalbl.hidden = true;
    }
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    // Below check added to prevent blank dropdowns
    // from showing
    if (!array || [array count] < 1) {
        return;
    }
    
    DropDownViewController *dropDown;
    if (textField == self.taluka) {
        dropDown = [[DropDownViewController alloc]initWithWidth:TALUKA_DROP_DOWN_WIDTH];
    }else{
        dropDown = [[DropDownViewController alloc] init];
    }
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}


- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    if([dropDownForView isEqual:self.lob_textfield]){
        selectedlob = selectedObject;
        self.lob_textfield.text = selectedValue;
    }
    else if ([dropDownForView isEqual:self.salesStage]){
        [self adjustFilterViewsBasedOnSalesStage:selectedValue];
    }
    else if([dropDownForView isEqual:self.taluka]){
        self.taluka.text = [(EGTaluka *)selectedObject talukaName];
    }else if ([dropDownForView isEqual:self.liveDeal]){
        selectedLiveDeal = selectedObject;
    }
    else if ([dropDownForView isEqual:self.nfatxtfld]){
        selectedNFA = selectedObject;
    }
    else if([dropDownForView isEqual:self.dsenametxtfld]){
        selectedDse = selectedObject;
    }
    else if([dropDownForView isEqual:self.eventxtfld]) {
        mSelectedEvent = selectedObject;
    }
}

- (void)datePickerCancelButtonTapped {

    [self.toolbar removeFromSuperview];
    [toDatePicker removeFromSuperview];
    [fromDatePicker removeFromSuperview];
    
    self.fromDate.inputAccessoryView = nil;
    self.todate.inputAccessoryView = nil;
    
    [self.fromDate resignFirstResponder];
    [self.todate resignFirstResponder];
}


- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == fromDatePicker) {
        [self.fromDate setText:[NSDate formatDate:[fromDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    else if (self.tappedView == toDatePicker) {
        [self.todate setText:[NSDate formatDate:[toDatePicker.date description] FromFormat:dateFormatNSDateDate toFormat:dateFormatddMMyyyy]];
    }
    [self validations];

}

- (void)setCurrentUserOpportunity:(NSString *)currentUser{
    
    self.currentoptyUser = currentUser;
    
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.currentoptyUser isEqualToString:@"My_Opportunity"]) {
            
            self.dsenametxtfld.hidden = YES;
            self.dsenamelbl.hidden = YES;
            
        }else{
            self.dsenametxtfld.hidden = NO;
            self.dsenamelbl.hidden = NO;
        }
        
        [self adjustFilterViewsForDSMBasedOnSalesStage:self.salesStage.text];
    }

}

#pragma mark - AutoCompleteUITextFieldDelegate Methods
- (void)selectedActionSender:(id)sender {
    [self.view endEditing:true];
    [self getFinancierObjectForFinancierName:self.financierTextField.text];
}

#pragma mark - Private Methods

- (void)setupFinancierTextField {
    
    self.financierTextField.autocompleteTableRowSelectedDelegate = self;
    self.financierTextField.field = [[Field alloc] init];
    self.financierTextField.layer.cornerRadius = 5;
    self.financierTextField.clipsToBounds = true;
}

- (void)setFinancierValuesInFinancierField {
    [UtilityMethods RunOnBackgroundThread:^{
        [UtilityMethods RunOnOfflineDBThread:^{
            FinanciersDBHelpers *financierDBHelper = [FinanciersDBHelpers new];
            self.financierTextField.field.mDataList = [[financierDBHelper fetchAllFinanciers] mutableCopy];
            self.financierTextField.field.mValues = [[[[financierDBHelper fetchAllFinanciers] valueForKey:@"financierName"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
            
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                [self showAutoCompleteTableForFinancierField];
            }];
        }];
    }];
}

- (void)getFinancierObjectForFinancierName:(NSString *)financierName {
    if (self.financierTextField.field.mDataList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"financierName == %@", financierName];
        NSArray *filteredArray = [self.financierTextField.field.mDataList filteredArrayUsingPredicate:predicate];
        if (filteredArray && [filteredArray count] > 0) {
            mFinancier = [filteredArray objectAtIndex:0];
        }
    }
}

@end
