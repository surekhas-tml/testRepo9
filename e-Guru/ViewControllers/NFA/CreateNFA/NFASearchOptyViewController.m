//
//  NFASearchOptyViewController.m
//  e-guru
//
//  Created by admin on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFASearchOptyViewController.h"
#import "Constant.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "EGSearchOptyFilter.h"
#import "AppRepo.h"
#import "NFACreationValidationHelper.h"

#define PICKER_HEIGHT   300
#define ANIMATION_TIME  0.3

@interface NFASearchOptyViewController (){
    
    AppDelegate *appDelegate;
    NSString *CurrentDateTap;
    BOOL maximizeFilter;
    EGSearchOptyFilter *serchOptyFilter;
    BOOL searchButtonClickedOnce;
}
@property (nonatomic, strong) EGOpportunity *selectedOpportunity;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIView *tappedView;

@end

@implementation NFASearchOptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self addGestureToDateFilterAndDropDownField];

    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.relatedOpportunityResultTableView.hidden = YES;
    self.searchFilterView.hidden = YES;
    
    self.searchbylbl.constant = 300;
    self.miniSearchFilterView.layer.cornerRadius = 5.0f;
    self.searchFilterView.layer.cornerRadius = 5.0f;
    
    self.relatedOpportunityResultTableView.bounces = FALSE;
    self.relatedOpportunityResultTableView.backgroundColor = [UIColor clearColor];
//    [self.relatedOpportunityResultTableView setTableviewDataSource:self];
//    [self.relatedOpportunityResultTableView setPagedTableViewCallback:self];
    
    serchOptyFilter = [[EGSearchOptyFilter alloc] init];
    
    //NFA Create From Manage Opportunity Screen
    if (*(self->_invokedFromManageOpportunity)) {
        [self prefilledAllTextField];
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchOpportunity_NFA];
    }
    else if (self.currentNFAMode == NFAModeUpdate) {
        [self bindDataToFieldsForUpdateNFA];
    }
    else{
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchOpportunity_NFA];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardShown:(NSNotification *)notification {
    
    [self datePickerCancelButtonTapped];
}

- (EGPagedArray *)opportunityPagedArray {
    if (!_opportunityPagedArray) {
        _opportunityPagedArray = [[EGPagedArray alloc] init];
    }
    return _opportunityPagedArray;
}

- (void) prefilledAllTextField{
    
    self.miniSearchOpptyIDTextField.text = self.opportunity.optyID;
    self.miniSearchcontactNoTextField.text = self.opportunity.toContact.contactNumber;
    self.pplDropDownTextField.text = self.opportunity.toVCNumber.ppl;
    self.salesStageDropDownTextField.text = self.opportunity.salesStageName;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_FOR_API * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self searchButtonClick:self.searchButton];
    });
}

- (void) bindDataToFieldsForUpdateNFA {
    
    if (self.nfaModel) {
        self.miniSearchOpptyIDTextField.text = self.nfaModel.nfaDealerAndCustomerDetails.oppotunityID;
        self.miniSearchcontactNoTextField.text = self.nfaModel.nfaDealerAndCustomerDetails.customerNumber;
        self.pplDropDownTextField.text = self.nfaModel.nfaDealDetails.ppl;
        self.salesStageDropDownTextField.text = self.nfaModel.optySalesStage;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_FOR_API * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self searchButtonClick:self.searchButton];
        });
    }
}

- (void)addGestureToDateFilterAndDropDownField{
    
    [[self.pplDropDownTextField superview] addGestureRecognizer:[self setRecognizer]];
    [[self.fromDateTextField superview] addGestureRecognizer:[self setRecognizer]];
    [[self.toDateTextField superview] addGestureRecognizer:[self setRecognizer]];
}

- (UITapGestureRecognizer*)setRecognizer{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromDateFieldTapped:)];
    [gestureRecognizer setNumberOfTapsRequired:1];
    [gestureRecognizer setNumberOfTouchesRequired:1];
    return gestureRecognizer;
}

- (DropDownTextField *)pplDropDownTextField {
    if (!_pplDropDownTextField.field) {
        _pplDropDownTextField.field = [[Field alloc] init];
    }
    return _pplDropDownTextField;
}

- (void)APIsalesStageForTextField:(UITextField *)textField {
    [[EGRKWebserviceRepository sharedRepository] getSalesStageSuccessAction:^(NSArray *responseArray) {
        NSLog(@"Sucess");

        [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:responseArray] andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailureAction:^(NSError *error) {
        NSLog(@"Failed");

    }];
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    //[self.view endEditing:true];
    
    // Below check added to prevent blank dropdowns
    // from showing
    if (!array || [array count] < 1) {
        return;
    }
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)showPPLDropDown:(NSMutableArray *)pplArray {
    NSArray *nameResponseArray = [pplArray valueForKey:@"pplName"];
    self.pplDropDownTextField.field.mValues = [nameResponseArray mutableCopy];
    self.pplDropDownTextField.field.mDataList = [pplArray mutableCopy];
    [self showDropDownForView:self.pplDropDownTextField];
}

- (void)showDropDownForView:(DropDownTextField *)textField {
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
//        if (![textField.text isEqualToString:selectedValue]) {
//            //[self.vcDetailsArray clearAllItems];
//        }
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
    }
}

- (BOOL)dataExistsForField:(DropDownTextField *)textField {
    
    if (textField.field.mDataList &&
        [textField.field.mDataList count] > 0 &&
        textField.field.mValues &&
        [textField.field.mValues count] > 0) {
        return true;
    }
    return false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreSearchButtonClick:(id)sender{
    maximizeFilter = YES;
    self.miniSearchFilterView.hidden = YES;
    self.searchFilterView.hidden = NO;
    UIButton *moreSearchBtn = (UIButton *)sender;
    moreSearchBtn.hidden = YES;
    self.searchbylbl.constant = 0;
    
    self.opptyIDTextField.text = self.miniSearchOpptyIDTextField.text;
    self.contactNoTextField.text = self.miniSearchcontactNoTextField.text;
    
    [self.searchByOptionText setText:@"Any Fields"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.contactNoTextField == textField || self.miniSearchcontactNoTextField == textField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }
    return true;
}

#pragma Dates Method

- (BOOL)isDatePickerVisible {
    if ([self.datePicker isDescendantOfView:self.view]) {
        return true;
    }
    return false;
}

- (void) toDateFieldTapped:(UIGestureRecognizer *)gesture{
    
    [self.toolbar removeFromSuperview];
    [self.datePicker removeFromSuperview];
    
    if ([self isDatePickerVisible]) {
        return;
    }
    CurrentDateTap = @"TO_DATE";
    if ([self.fromDateTextField.text hasValue]) {
        
        NSDate *selectedDate;
        if ([self.toDateTextField.text hasValue]) {
            selectedDate = [NSDate getNSDateFromString:self.toDateTextField.text havingFormat:dateFormatddMMyyyy];
        }
        [self showDatePickerWithSelectedDate:selectedDate
                                     minDate:[NSDate getNSDateFromString:self.fromDateTextField.text havingFormat:dateFormatddMMyyyy]
                                     maxDate:nil
                       andCancelButtonHidden:false];
    }
    else {
       // [self showAlertWithMessage:@"Please select from date"];
    }
}

- (void) fromDateFieldTapped:(UIGestureRecognizer *)gesture{
    
    [self.toolbar removeFromSuperview];
    [self.datePicker removeFromSuperview];
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(self.fromDateTextField.frame, point)) {
            CurrentDateTap = @"FROM_DATE";
            
            NSDate *selectedDate;
            if ([self.fromDateTextField.text hasValue]) {
                selectedDate = [NSDate getNSDateFromString:self.fromDateTextField.text havingFormat:dateFormatddMMyyyy];
            }
            [self showDatePickerWithSelectedDate:selectedDate minDate:nil maxDate:nil andCancelButtonHidden:false];
        }else if(CGRectContainsPoint(self.toDateTextField.frame, point)){
            CurrentDateTap = @"TO_DATE";
            NSDate *selectedDate;
            if ([self.fromDateTextField.text hasValue]) {
                selectedDate = [NSDate getNSDateFromString:self.fromDateTextField.text havingFormat:dateFormatddMMyyyy];
            }
            [self showDatePickerWithSelectedDate:selectedDate minDate:nil maxDate:nil andCancelButtonHidden:false];
        }
        else if(CGRectContainsPoint(self.pplDropDownTextField.frame, point)){
            [self fetchPPLForSelectedLOB:self.nfaModel.lobName];
        }else if(CGRectContainsPoint(self.salesStageDropDownTextField.frame, point)){
            [self APIsalesStageForTextField:self.salesStageDropDownTextField];
        }
    }
}

- (void)showDatePickerWithSelectedDate:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate andCancelButtonHidden:(BOOL)hideCancelButton {
    
    // Added to hide the keyboard when date picker
    // will be opened
    [self.view endEditing:true];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.datePicker];
    self.pickerBottomEdgeConstratint = [self.datePicker autoPinEdge:ALEdgeBottom
                                                             toEdge:ALEdgeBottom
                                                             ofView:self.view
                                                         withOffset:PICKER_HEIGHT];
    [self.datePicker autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.datePicker autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    // Set selcted date
    if (selectedDate) {
        self.datePicker.date = selectedDate;
    }
    // Set minimum date
    if (minDate) {
        self.datePicker.minimumDate = minDate;
    }
    // Set maximum date
    if (maxDate) {
        self.datePicker.maximumDate = maxDate;
    }
    
    // Toolbar
    self.toolbar = [[UIToolbar alloc] initForAutoLayout];
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
    
    [self.view addSubview:self.toolbar];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.toolbar autoPinEdge:ALEdgeBottom
                       toEdge:ALEdgeTop
                       ofView:self.datePicker];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:ANIMATION_TIME
                     animations: ^{
                         self.pickerBottomEdgeConstratint.constant = 0;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)datePickerCancelButtonTapped {
    
    [UIView animateWithDuration:ANIMATION_TIME
                     animations: ^{
                         self.pickerBottomEdgeConstratint.constant = PICKER_HEIGHT;
                         [self.view layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {
                         [self.datePicker removeFromSuperview];
                         [self.toolbar removeFromSuperview];
                     }];
}

- (void)datePickerDoneButtonTapped {
    NSLog(@"%@",CurrentDateTap);
    [self datePickerCancelButtonTapped];
    if ([CurrentDateTap isEqualToString:@"FROM_DATE"]) {
        [self.fromDateTextField setText:[NSDate getDate:self.datePicker.date InFormat:dateFormatddMMyyyy]];
        //[self.toDateTextField setText:@""];
    }
    else if ([CurrentDateTap isEqualToString:@"TO_DATE"]) {
        [self.toDateTextField setText:[NSDate getDate:self.datePicker.date InFormat:dateFormatddMMyyyy]];
    }
}


- (IBAction)searchButtonClick:(id)sender{
    
    [self.toolbar removeFromSuperview];
    [self.datePicker removeFromSuperview];
    
    searchButtonClickedOnce = true;
    [self.view endEditing:true];
    
    if (maximizeFilter) {
        
        if (![self.opptyIDTextField.text hasValue] &&
            ![self.contactNoTextField.text hasValue] &&
            ![self.pplDropDownTextField.text hasValue] &&
            ![self.salesStageDropDownTextField.text hasValue] &&
            ![self.toDateTextField.text hasValue] &&
            ![self.fromDateTextField.text hasValue]) {
            
            [UtilityMethods alert_ShowMessage:@"Please provide a search criteria." withTitle:APP_NAME andOKAction:nil];
            
        }else{
            self.searchButton.userInteractionEnabled = false;
            self.relatedOpportunityResultTableView.hidden = false;
            [self.relatedOpportunityResultTableView setPagedTableViewCallback:self];
            [self.relatedOpportunityResultTableView setTableviewDataSource:self];
            [self.relatedOpportunityResultTableView clearAllData];
            [self.relatedOpportunityResultTableView reloadData];
        }
    }else{
        if ([self.miniSearchOpptyIDTextField.text hasValue] || [self.miniSearchcontactNoTextField.text hasValue]) {
            
            if ([self.miniSearchcontactNoTextField.text hasValue] && [self.miniSearchcontactNoTextField.text length] != 10) {
                
                [UtilityMethods alert_ShowMessage:@"Please enter correct input details." withTitle:APP_NAME andOKAction:nil];
            }else{
                self.searchButton.userInteractionEnabled = false;
                self.relatedOpportunityResultTableView.hidden = false;
                [self.relatedOpportunityResultTableView setPagedTableViewCallback:self];
                [self.relatedOpportunityResultTableView setTableviewDataSource:self];
                [self.relatedOpportunityResultTableView clearAllData];
                [self.relatedOpportunityResultTableView reloadData];
            }
            
        }else{
            
            [UtilityMethods alert_ShowMessage:@"Please enter either Opportunity ID or Contact Number." withTitle:APP_NAME andOKAction:nil];
        }
    }
}


-(EGSearchOptyFilter *)lastWeekC0OptyQuery{
    
    NSDate *now = [[NSDate getEOD:[[NSDate date]toLocalTime]]toGlobalTime];
    NSDate *sevenDaysAgo = [[NSDate getSOD:[[NSDate getNoOfDays:7 pastDateInFormat:dateFormatyyyyMMddTHHmmssZ]toLocalTime]]toGlobalTime];
    
    EGSearchOptyFilter *searchFilter = [[EGSearchOptyFilter alloc] init];
    if ([self.toDateTextField.text hasValue]) {
        searchFilter.to_date = [NSDate getDate:now InFormat:dateFormatyyyyMMddTHHmmssZ];
    }
    
    if ([self.fromDateTextField.text hasValue]) {
        searchFilter.from_date = [NSDate getDate:sevenDaysAgo InFormat:dateFormatyyyyMMddTHHmmssZ];
    }
    
    if ([self.salesStageDropDownTextField.text hasValue]) {
        
        searchFilter.sales_stage_name = self.salesStageDropDownTextField.text;
    }else{
        searchFilter.sales_stage_name = @""; //SEARCH_FILTER_SALES_STAGE_C0;
    }
    
    searchFilter.primary_employee_id = [[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID;
    searchFilter.pplname = self.pplDropDownTextField.text;
    if (maximizeFilter) {
        searchFilter.opty_id = self.opptyIDTextField.text;
        searchFilter.customer_cellular_number = self.contactNoTextField.text;
    }else{
        searchFilter.opty_id = self.miniSearchOpptyIDTextField.text;
        searchFilter.customer_cellular_number = self.miniSearchcontactNoTextField.text;
    }
    
    searchFilter.search_status = BOTHOPTY;
    
    return searchFilter;
}

- (void)bindOpportunityDataToNFAModel:(EGOpportunity *)opportunityModel {
    if (!self.nfaModel) {
        return;
    }
    
    // Dealer & Customer Details
    self.nfaModel.nfaDealerAndCustomerDetails.oppotunityID = opportunityModel.optyID;
    self.nfaModel.nfaDealerAndCustomerDetails.accountName = opportunityModel.toAccount.accountName?:@"";
    self.nfaModel.nfaDealerAndCustomerDetails.location = opportunityModel.toLOBInfo.mmGeography;
    self.nfaModel.nfaDealerAndCustomerDetails.mmIntendedApplication = opportunityModel.toLOBInfo.vehicleApplication;
    self.nfaModel.nfaDealerAndCustomerDetails.tmlFleetSize = opportunityModel.toLOBInfo.tmlFleetSize;
    self.nfaModel.nfaDealerAndCustomerDetails.overAllFleetSize = opportunityModel.toLOBInfo.totalFleetSize;
    self.nfaModel.competitorFleetSize = opportunityModel.toLOBInfo.totalFleetSize;
    
    NSString *firstName = opportunityModel.toContact.firstName;
    NSString *lastName = opportunityModel.toContact.lastName;
    NSString *customerName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    self.nfaModel.nfaDealerAndCustomerDetails.customerName = customerName;
    self.nfaModel.nfaDealerAndCustomerDetails.customerNumber = opportunityModel.toContact.contactNumber;
    
    // Deal Details
    self.nfaModel.nfaDealDetails.lob = opportunityModel.toVCNumber.lob;
    self.nfaModel.nfaDealDetails.ppl = opportunityModel.toVCNumber.ppl;
    self.nfaModel.nfaDealDetails.model = opportunityModel.toVCNumber.pl;
    self.nfaModel.nfaDealDetails.vc = opportunityModel.toVCNumber.vcNumber;
    self.nfaModel.nfaDealDetails.productDescription = opportunityModel.toVCNumber.productDescription;
    self.nfaModel.nfaDealDetails.dealSize = opportunityModel.quantity;
}

#pragma mark - EGPagedTableView

-(void)searchOpportunityWithQueryParameters:(NSDictionary *) queryParams{
    
    [[EGRKWebserviceRepository sharedRepository]searchOpportunity:queryParams andSucessAction:^(EGPagination *oportunity) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Search_Opportunity_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_SearchOpportunity_NFA_Successful];

        self.searchButton.userInteractionEnabled = true;
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Search_Opportunity_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_SearchOpportunity_NFA_Failed];

        self.searchButton.userInteractionEnabled = true;
        [UtilityMethods hideProgressHUD];
        [self.relatedOpportunityResultTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.relatedOpportunityResultTableView reloadData];
    }];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    
    self.opportunityPagedArray = [EGPagedArray mergeWithCopy:self.opportunityPagedArray withPagination:paginationObj];
    if(self.opportunityPagedArray) {
        [self.relatedOpportunityResultTableView refreshData:self.opportunityPagedArray];
        [self.relatedOpportunityResultTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.opportunityPagedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NFASearchOptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelatedOptySearchResultViewCell"];
    EGOpportunity *opportunity = [_opportunityPagedArray objectAtIndex:indexPath.row];
    cell.optyIDLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.optyID];
    cell.customerNumberLabel.text =
    [[[UtilityMethods getDisplayStringForValue:opportunity.toContact.firstName]stringByAppendingString:@" "]stringByAppendingString:[UtilityMethods getDisplayStringForValue:opportunity.toContact.lastName]];
    
    cell.locationLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.toLOBInfo.mmGeography];
    cell.MIntendedAppLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.toLOBInfo.vehicleApplication];
    cell.tmlFleetSizeLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.toLOBInfo.tmlFleetSize];
    cell.nfaStatusLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.nfaStatus];
    cell.nfaRequestNOLabel.text = [UtilityMethods getDisplayStringForValue:opportunity.nfaNumber];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([NFACreationValidationHelper errorCellInTableView:tableView atIndexPath:indexPath]) {
        return;
    }
    
    [self performSelector:@selector(setDoNotFetchDataFlagNO) withObject:nil afterDelay:1.0];
    
    EGOpportunity *opportunity = [_opportunityPagedArray objectAtIndex:indexPath.row];
    // Allow Create NFA when opty nfa status is "Rejected/Expired/Cancelled/nil"
   
    if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity nfaModel:self.nfaModel inMode:self.currentNFAMode showMessage:true]) {
        if ([self.delegate respondsToSelector:@selector(opportunitySelected)]) {
            [self bindOpportunityDataToNFAModel:opportunity];
            self.selectedOpportunity = opportunity;
            [self.delegate opportunitySelected];
            
            appDelegate.doNotFetchData = YES;
            [self removeAllElementsExceptSelected:indexPath.row];

        }
    }
}

#pragma mark - Helper Methods

-(void) clearAllTextFields{
    
    [self.opptyIDTextField setText:@""];
    [self.contactNoTextField setText:@""];
    [self.salesStageDropDownTextField setText:@""];
    [self.pplDropDownTextField setText:@""];
    [self.toDateTextField setText:@""];
    [self.fromDateTextField setText:@""];
}

-(void) setDoNotFetchDataFlagNO{
    
    appDelegate.doNotFetchData = NO;
}

-(void) removeAllElementsExceptSelected:(NSInteger)selectedIndex{
    
    EGOpportunity *opportunity = [[EGOpportunity alloc]init];
    
    opportunity = [_opportunityPagedArray objectAtIndex:selectedIndex];
    
    [_opportunityPagedArray clearAllItems];
    
    [self.opportunityPagedArray addObject:opportunity];
    
    [self.relatedOpportunityResultTableView refreshData:self.opportunityPagedArray];
    [self.relatedOpportunityResultTableView reloadData];
    
    [self clearAllTextFields];
    
}

#pragma mark - EGPagedTableViewDelegate

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    if (searchButtonClickedOnce) { // To prevent API call as soon as screen loads
        serchOptyFilter = [self lastWeekC0OptyQuery];
        [self searchOpportunityForFilter:serchOptyFilter withOffset:[pagedTableViewDataSource.data count] withSize:10];
    }
}

- (void)searchOpportunityForFilter:(EGSearchOptyFilter *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size
{
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:[filter queryParamDict]];
    
    NSString * offsetStr = [NSString stringWithFormat:@"%lu",(unsigned long)offset];
    //TODO: remove hadrcode
    if (![[queryDict allKeys]containsObject:@"offset"]) {
        [queryDict addEntriesFromDictionary:@{@"offset":offsetStr}];
    }else{
        [queryDict setObject:offsetStr forKey:@"offset"];
    }
    
    NSString * sizeStr = [NSString stringWithFormat:@"%lu",(unsigned long)size];
    if (![[queryDict allKeys]containsObject:@"size"]) {
        [queryDict addEntriesFromDictionary:@{@"size":sizeStr}];
    }else{
        [queryDict setObject:sizeStr forKey:@"size"];
    }
    
    [queryDict setObject:self.nfaModel.lobName forKey:@"lob"];
    [self searchOpportunityWithQueryParameters:queryDict];
}

#pragma mark - API Calls

- (void)fetchPPLForSelectedLOB:(NSString *)lobName {
    
//    if ([self dataExistsForField:self.pplDropDownTextField]) {
//        [self showDropDownForView:self.pplDropDownTextField];
//        return;
//    }
    
    NSDictionary *requestDict = @{@"lob_name": lobName? : @""};
    [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            [self showPPLDropDown:[responseArray mutableCopy]];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
}


@end
