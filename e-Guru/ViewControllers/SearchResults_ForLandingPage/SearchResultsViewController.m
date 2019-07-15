//
//  SearchResultsViewController.m
//  e-Guru
//
//  Created by MI iMac01 on 30/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "EGAddress.h"
#import "EGAccount.h"
#import "EGContact.h"
#import "UtilityMethods.h"
#import "UIColor+eGuruColorScheme.h"
#import "UserDetails.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "NSString+NSStringCategory.h"
#import "CreateOpportunityViewController.h"
#import "OpportunityDetailsViewController.h"
#import "EGErrorTableViewCell.h"
#import "ScreenshotCapture.h"
#define SIZE_FOR_PAGINATION @"20"

#define OPPORTUNITY_BUTTON 0
#define ACCOUNT_BUTTON 1
#define ADDRESS_BUTTON 2

#define RELATED_CONTACT_SEARCHRESULT_TABLEVIEW_CELL @"RelatedContactSearchResultViewCell"
#define RELATED_ACCOUNT_SEARCHRESULT_TABLEVIEW_CELL @"RelatedAccountSearchViewCell"
#define RELATED_OPPORTUNITY_SEARCHRESULT_TABLEVIEW_CELL @"RelatedOptySearchResultViewCell"

#define ACCOUNT_TABLE_VIEW_SELECTED @"account_tableView_selected"
#define CONTACT_TABLE_VIEW_SELECTED @"contact_tableView_selected"

#define CURRENT_API_CALL_ACCOUNT 21
#define CURRENT_API_CALL_CONTACT 22
#define CURRENT_API_CALL_OPPORTUNITY 23

#define ENTER_AT_LEAST_ONE_FIELD @"Please enter at least one field value"
#define ENTER_VALID_MOBILE_NUMBER   @"Please enter valid mobile number"
#define ENTER_VALID_PAN   @"Please enter valid Pan Number"

@interface SearchResultsViewController ()<HHSlideViewDelegate>
{
    
    EGAddress * contactAddress;
    EGContact * contactObj;
    EGAccount * accountObj;
    EGContact * oldContactObj;
    EGAccount * oldAccountObj;
    
    NSInteger selectedTitleBarButton;
    
    EGPagedArray * contactsPagedArray;
    EGPagedArray * accountsApgedArray;
    EGPagedArray * opportunityPagedArray;

    NSString * tableViewSelected;
    BOOL isFromSearchBtton;
    BOOL isJustLoaded;
    BOOL isOpportunityDataSourceAndCallbackSet;
    BOOL isAccContactDataSourceAndCallbackSet;
    
    NSInteger currentSelectedCellIndex;
}
@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isJustLoaded = YES;
    [UtilityMethods navigationBarSetupForController:self];
    selectedTitleBarButton = OPPORTUNITY_BUTTON;
    
    if (self.entryPoint == InvokeFromProductApp) {
        self.firstNameTextField.text = _firstName;
        self.LastNameTextField.text = _LastName;
    }

    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        self.title=@"Search By Contact";
    }
    else  if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON) {
        self.title=@"Search By Account";
    }
    
    [self configureView];
    
    self.relatedAccountContactTableView.bounces = FALSE;
    self.contactAccResultTableView.bounces = FALSE;
    self.relatedOpportunityResultTableView.bounces = FALSE;
    
    [self.contactAccResultTableView setPagedTableViewCallback:self];
    [self.contactAccResultTableView setTableviewDataSource:self];
    
    [self.third_OpportunityView setHidden:true];
    currentSelectedCellIndex = -1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];
    self.searchButton.layer.cornerRadius = 6;
    self.searchButton.clipsToBounds = YES;

}

-(void)viewDidAppear:(BOOL)animated{


}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureView {
    
    isFromSearchBtton = TRUE;
    
    [self titleBarDependingOnSegmentSelection];
    [self titleBarShowForSelectedOption];
    
    contactAddress = [EGAddress new];
    
    NSLog(@"details-%@ , %d",self.searchByValue.stringToSearch,self.searchByValue.radioButtonSelected);
    self.addressDetailsView.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.addressDetailsView.layer.borderWidth = 1.5f;
    self.addressBackButton.layer.cornerRadius = 5.0f;
    self.slideView.delegate = self;
}

#pragma mark - HHSlideViewDelegate

- (NSInteger)numberOfSlideItemsInSlideView:(HHSlideView *)slideView {
    
    return 3;
}

- (NSArray *)namesOfSlideItemsInSlideView:(HHSlideView *)slideView {
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        return  @[OPPORTUNITIES, E_ACCOUNT, E_CONTACTADDRESS];
    }
    else
    {
        return  @[OPPORTUNITIES, E_CONTACT, E_ACCOUNTADDRESS];
    }
}

- (void)slideView:(HHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
    
    if (selectedTitleBarButton == index) {
        return;
    }
    
    selectedTitleBarButton = index;
    [self titleBarDependingOnSegmentSelection];
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        oldContactObj = contactObj;
    }
    else {
        oldAccountObj = accountObj;
    }
    
    
    switch (index) {
        case OPPORTUNITY_BUTTON: {
           
            [self loadOpportunityTable];
        }
        break;
        case ACCOUNT_BUTTON: {
            isFromSearchBtton = false;

            [self loadAccountContactTable];
        }
        break;
        case ADDRESS_BUTTON: {
            
           

            EGAddress * addressObj = [EGAddress new];
            NSIndexPath *selectedIndexPath;
            NSInteger rowNumber;
            if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
                selectedIndexPath  = [self.contactAccResultTableView indexPathForSelectedRow];
                if (selectedIndexPath){
                    rowNumber = [selectedIndexPath row];
                }
                else{
                    rowNumber = 0;
                }
                //get address object
                if (contactsPagedArray && [contactsPagedArray count] > 0) {
                    addressObj = [(EGContact *)[contactsPagedArray objectAtIndex:selectedIndexPath.row] toAddress];
                    [self bindDataInAddressTab:addressObj];
                }
                
                
                
            }
            else if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON){
                selectedIndexPath = [self.contactAccResultTableView indexPathForSelectedRow];
                if (selectedIndexPath){
                    rowNumber = [selectedIndexPath row];
                }
                else{
                    rowNumber = 0;
                }
                //get address object
                if (accountsApgedArray && [accountsApgedArray count] > 0) {
                    addressObj = [(EGContact *)[accountsApgedArray objectAtIndex:selectedIndexPath.row] toAddress];
                    [self bindDataInAddressTab:addressObj];
                }
            }
        }
        break;
            
        default:
            break;
    }
}

- (void)bindDataInAddressTab:(EGAddress *)addressObj {
    self.stateLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.state.name];
    self.cityLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.city];
    self.talukaLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.taluka.talukaName];
    self.areaLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.area];
    self.districtLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.district];
    self.panchayatLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.panchayat];
    self.pincodeLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.pin];
    self.addressLineOneLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.addressLine1];
    self.addressLineTwoLabel.text = [UtilityMethods getDisplayStringForValue:addressObj.addressLine2];
}

- (NSArray *)childViewControllersInSlideView:(HHSlideView *)slideView {
    
    UIViewController *subVC_1 = [[UIViewController alloc] init];
    
    UIViewController *subVC_2 = [[UIViewController alloc] init];
    
    UIViewController *subVC_3 = [[UIViewController alloc] init];
    
    
    NSArray *childViewControllersArray = @[subVC_1, subVC_2, subVC_3];
    
    return childViewControllersArray;
}

- (UIColor *)colorOfSlideView:(HHSlideView *)slideView {
    return [UIColor tableHeaderColor];
}

- (UIColor *)colorOfSliderInSlideView:(HHSlideView *)slideView {
    return [UIColor slideViewSliderColor];
}


#pragma mark - EGPagedTableView

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    
}

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource forTable:(UITableView *)tableView {
    
    // TODO: Optimize these if-else conditions
    if (tableView == self.contactAccResultTableView) {
        if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
            if (isFromSearchBtton) {
                [self callSearch_Contact_APIWithDictionary:[self getPayloadFor_Contact_withOffset_FromSearchButton:[pagedTableViewDataSource.data count]]];
            }
            else {
                [self callSearch_Contact_APIWithDictionary:[self getPayloadFor_Contact_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
            }
        }
        else if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON) {
            if (isFromSearchBtton) {
                [self callSearch_Account_APIWithDictionary:[self getPayloadFor_Account_withOffset_FromSearchButton:[pagedTableViewDataSource.data count]]];
            }
            else {
                [self callSearch_Account_APIWithDictionary:[self getPayloadFor_Account_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
            }
        }
    }
    else if (tableView == self.relatedAccountContactTableView) {
        if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
//            if (isFromSearchBtton) {
//                [self callSearch_Account_APIWithDictionary:[self getPayloadFor_Account_withOffset_FromSearchButton:[pagedTableViewDataSource.data count]]];
//            }
//            else {
//                [self callSearch_Account_APIWithDictionary:[self getPayloadFor_Account_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
//            }
            [self callSearch_Account_APIWithDictionary:[self getPayloadFor_Account_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
        }
        else if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON) {
//            if (isFromSearchBtton) {
//                [self callSearch_Contact_APIWithDictionary:[self getPayloadFor_Contact_withOffset_FromSearchButton:[pagedTableViewDataSource.data count]]];
//            }
//            else {
//                [self callSearch_Contact_APIWithDictionary:[self getPayloadFor_Contact_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
//            }
            [self callSearch_Contact_APIWithDictionary:[self getPayloadFor_Contact_withOffset_FromSelectedCell:[pagedTableViewDataSource.data count]]];
        }
    }
    else if (tableView == self.relatedOpportunityResultTableView) {
        [self callSearch_Opportunity_APIWithDictionary:[self getPayloadFor_Opportunity_withOffset:0]];
    }
}

#pragma mark

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


#pragma mark - Helper Methods

-(BOOL)validateTextFields
{
    /*
     **This sprint validation - minimum one text field is mandatory
     */
    NSString * errorMessage = @"";
    BOOL flag = TRUE;
    
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        if ((![self.firstNameTextField.text isEqualToString:@""]) || (![self.LastNameTextField.text isEqualToString:@""]) || (![self.ContactNumberTextField.text isEqualToString:@""])) {
            if ([self.ContactNumberTextField.text hasValue]) {
                if (![UtilityMethods validateMobileNumber:self.ContactNumberTextField.text]) {
                    errorMessage = ENTER_VALID_MOBILE_NUMBER;
                    flag = FALSE;
                }
            }
            else {
                flag = TRUE;
            }
        }
        else{
            errorMessage = ENTER_AT_LEAST_ONE_FIELD;
            flag = FALSE;
        }

    }
    else{
        if ((![self.accountNameTextField.text isEqualToString:@""]) ||
            (![self.siteTextField.text isEqualToString:@""]) ||
            (![self.mainPhoneNumberTextField.text isEqualToString:@""]) ||
            ![self.panNumberTextField.text isEqualToString:@""]) {
            
            if ([self.mainPhoneNumberTextField.text hasValue]) {
                if (![UtilityMethods validateMobileNumber:self.mainPhoneNumberTextField.text]) {
                    errorMessage = ENTER_VALID_MOBILE_NUMBER;
                    flag = FALSE;
                }
            }
            else if ([self.panNumberTextField.text hasValue]) {
                if (![UtilityMethods validatePanNumber:self.panNumberTextField.text]) {
                    errorMessage = ENTER_VALID_PAN;
                    flag = FALSE;
                }
            }
            else {
                flag = TRUE;
            }
        }
        else{
            errorMessage = ENTER_AT_LEAST_ONE_FIELD;
            flag = FALSE;
        }

    }
    
    if (![errorMessage isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    }
    return flag;
    
}

-(void)getAndShowAddressFromResponse{
    [self bindDataInAddressTab:contactAddress];
}

/***** When Account search from search button *****/
-(NSDictionary *)getPayloadFor_Account_withOffset_FromSearchButton:(NSInteger)offset{
    NSDictionary * payload;
    payload = @{@"name":self.accountNameTextField.text,
                @"phone":self.mainPhoneNumberTextField.text,
                @"PAN_number":self.panNumberTextField.text,
                @"site":self.siteTextField.text,
                @"offset":[NSString stringWithFormat:@"%ld",(long)offset],
                @"size":SIZE_FOR_PAGINATION};
    return payload;
}

/***** When Account search from Contact selected *****/
-(NSDictionary *)getPayloadFor_Account_withOffset_FromSelectedCell:(NSInteger)offset{
    NSDictionary * payload;
    //TODO: change to contact id search
    payload = @{@"name": @"",
                @"contact_id":(![contactObj.contactID isEqualToString:@""] && contactObj!=nil) ? contactObj.contactID : @"",
                @"offset":[NSString stringWithFormat:@"%ld",(long)offset],
                @"size":SIZE_FOR_PAGINATION};
    return payload;
}

/***** When Contact search from search button *****/
-(NSDictionary *)getPayloadFor_Contact_withOffset_FromSearchButton:(NSInteger)offset{
    NSDictionary * payload;
    payload = @{@"first_name":self.firstNameTextField.text,
                @"last_name":self.LastNameTextField.text,
                @"phone":self.ContactNumberTextField.text,
                @"offset":[NSString stringWithFormat:@"%ld",(long)offset],
                @"size":SIZE_FOR_PAGINATION};
    
    return payload;
}

/***** When Contact search from account selected *****/
-(NSDictionary *)getPayloadFor_Contact_withOffset_FromSelectedCell:(NSInteger)offset{
    NSDictionary * payload;
    payload = @{@"first_name":@"",
                @"last_name":@"",
                @"phone":@"",//(![accountObj.contactNumber isEqualToString:@""] && accountObj!=nil) ? accountObj.contactNumber : @"",
                @"offset":[NSString stringWithFormat:@"%ld",(long)offset],
                @"account_id" :(![accountObj.accountID isEqualToString:@""] && accountObj!=nil) ? accountObj.accountID : @"",
                @"size":SIZE_FOR_PAGINATION};
    return payload;
}


-(NSDictionary *)getPayloadFor_Opportunity_withOffset:(NSInteger)offset{
    NSDictionary * payload;
    int searchStatus;
    NSString * contactId =(![contactObj.contactID isEqualToString:@""] && contactObj!=nil) ? contactObj.contactID : @"";
    NSString * accountId =(![accountObj.accountID isEqualToString:@""] && accountObj!=nil) ? accountObj.accountID : @"";
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        searchStatus=3;
    }
    else{
        searchStatus=1;
    }
    NSLog(@"contact id %@-account id %@",contactId,accountId);
    payload = @{
                @"contact_id": contactId,
                @"account_id" : accountId,
                @"salestagename": @"",
                @"primary_employee_id": [[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID,
                @"sales_stage_name": @"",
                @"buid": @"",
                @"pplname": @"",
                @"tehsil_name": @"",
                @"assign_name": @"",
                @"customer_cellular_number": @"",
                @"dse_position_id": @"",
                @"contact_last_name":@"",
                @"contact_first_name": @"",
                @"search_status":[NSNumber numberWithInt:searchStatus],
                @"campaign_name": @"",
                @"live_deal_flag":@"",
                @"contact_id":@"",
                @"offset" : [NSString stringWithFormat:@"%ld",(long)offset],
                @"size" : SIZE_FOR_PAGINATION
                };
    
    return payload;
}


-(void)titleBarDependingOnSegmentSelection{
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        switch (selectedTitleBarButton) {
            case  OPPORTUNITY_BUTTON:
                self.titleBarForOpportunity.hidden = FALSE;
                self.titleBarForAccount_thirdView.hidden = TRUE;
                self.titleBarForContact_thirdView.hidden = TRUE;
                
                self.addressDetailsView.hidden = TRUE;
                self.relatedOpportunityResultTableView.hidden = FALSE;
                self.relatedAccountContactTableView.hidden = TRUE;
                
                break;
            case  ACCOUNT_BUTTON:
                self.titleBarForOpportunity.hidden = TRUE;
                self.titleBarForAccount_thirdView.hidden = FALSE;
                self.titleBarForContact_thirdView.hidden = TRUE;
                
                self.addressDetailsView.hidden = TRUE;
                self.relatedOpportunityResultTableView.hidden = TRUE;
                self.relatedAccountContactTableView.hidden = FALSE;

                break;
            case  ADDRESS_BUTTON:
                self.titleBarForOpportunity.hidden = TRUE;
                self.addressDetailsView.hidden = FALSE;
                self.relatedOpportunityResultTableView.hidden = TRUE;
                self.relatedAccountContactTableView.hidden = TRUE;

                break;
                
            default:
                break;
        }
        
    }
    else if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON){
        
        switch (selectedTitleBarButton) {
            case  OPPORTUNITY_BUTTON:
                self.titleBarForOpportunity.hidden = FALSE;
                self.titleBarForAccount_thirdView.hidden = TRUE;
                self.titleBarForContact_thirdView.hidden = TRUE;
                self.addressDetailsView.hidden = TRUE;
                
                self.relatedOpportunityResultTableView.hidden = FALSE;
                self.relatedAccountContactTableView.hidden = TRUE;

                break;
            case  ACCOUNT_BUTTON:
                self.titleBarForOpportunity.hidden = TRUE;
                self.titleBarForAccount_thirdView.hidden = TRUE;
                self.titleBarForContact_thirdView.hidden = FALSE;
                self.addressDetailsView.hidden = TRUE;
                
                self.relatedOpportunityResultTableView.hidden = TRUE;
                self.relatedAccountContactTableView.hidden = FALSE;
                
                break;
            case  ADDRESS_BUTTON:
                self.titleBarForOpportunity.hidden = TRUE;

                self.addressDetailsView.hidden = FALSE;
                
                self.relatedOpportunityResultTableView.hidden = TRUE;
                self.relatedAccountContactTableView.hidden = TRUE;
                break;
                
            default:
                break;
        }
        
    }

}
-(void)titleBarShowForSelectedOption{
    
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        
        self.firstSectionLabel.text = @"Search Contact";
        self.secondSectionLabel.text = @"Search Results";
        self.thirdSectionLabel.text = @"Related Details";
        
        if (self.searchByValue.stringToSearch) {
            
            if([UtilityMethods isCharacterSetOnlyNumber:self.searchByValue.stringToSearch]){
                self.ContactNumberTextField.text = self.searchByValue.stringToSearch;
            }else{
                 self.firstNameTextField.text = self.searchByValue.stringToSearch;
            }
        }
        
        tableViewSelected = CONTACT_TABLE_VIEW_SELECTED;
        
        self.titleBarForContact_secondView.hidden = FALSE;
        self.titleBarForAccount_secondView.hidden = TRUE;
        
        self.contactSearchView.hidden = FALSE;
        self.accountSearchView.hidden = TRUE;
        self.searchButtonTrailingSpaceConstraint.constant = 205;
        
        
    }
    else if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON){
        
        self.firstSectionLabel.text = @"Search Account";
        self.secondSectionLabel.text = @"Search Results";
        self.thirdSectionLabel.text = @"Account Details";

        if (self.searchByValue.stringToSearch) {
            if ([UtilityMethods validatePanNumber:self.searchByValue.stringToSearch]) {
                self.panNumberTextField.text = self.searchByValue.stringToSearch;
            } else {
                self.mainPhoneNumberTextField.text = self.searchByValue.stringToSearch;
            }
        }
        
        tableViewSelected = ACCOUNT_TABLE_VIEW_SELECTED;
        
        self.titleBarForContact_secondView.hidden = TRUE;
        self.titleBarForAccount_secondView.hidden = FALSE;
        
        self.contactSearchView.hidden = TRUE;
        self.accountSearchView.hidden = FALSE;
        
        self.searchButtonTrailingSpaceConstraint.constant = 20;
    }
}

#pragma mark - textFiled delegate methods
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.ContactNumberTextField || textField == self.mainPhoneNumberTextField) {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.ContactNumberTextField || textField == self.mainPhoneNumberTextField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else{
        textField.keyboardType = UIKeyboardTypeDefault;
    }
}
- (void)textFieldDidEndEditing:(UITextField*)textField{
    [textField resignFirstResponder];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        
        [nextResponder becomeFirstResponder];
        
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contactAccResultTableView) {
        if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
            return [contactsPagedArray currentSize];
        }
        else{
            return [accountsApgedArray count];
        }
    }
    else if (tableView == self.relatedOpportunityResultTableView){
        return [opportunityPagedArray count];
    }
    else{
        
        if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON) {
            return [contactsPagedArray currentSize];
        }
        else{
            return [accountsApgedArray count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.contactAccResultTableView) {
        
        isFromSearchBtton = TRUE;
        tableViewSelected = ACCOUNT_TABLE_VIEW_SELECTED;
        
        if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
            RelatedContactSearchResultViewCell *relatedContactCell = [tableView dequeueReusableCellWithIdentifier:RELATED_CONTACT_SEARCHRESULT_TABLEVIEW_CELL];
            
            if (relatedContactCell == nil) {
                relatedContactCell = [[RelatedContactSearchResultViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RELATED_CONTACT_SEARCHRESULT_TABLEVIEW_CELL];
            }
            relatedContactCell = [self related_Contact_SearchCellDisplay:relatedContactCell withIndexPath:indexPath];
            
//            if([[AppRepo sharedRepo] isDSMUser])
//            {
//                relatedContactCell.selectButton.hidden=YES;
//                relatedContactCell.createNewOptyButton.hidden=YES;
//                
//            }
//            else
//            {
                if(self.entryPoint==InvokeFromPROSPECTEdit) {
                    relatedContactCell.selectButton.hidden=NO;
                    relatedContactCell.createNewOptyButton.hidden=YES;
                }
                else {
                    relatedContactCell.selectButton.hidden=YES;
                    relatedContactCell.createNewOptyButton.hidden=NO;
                }
//            }
            
//            if (tableView == self.contactAccResultTableView && ![[tableView cellForRowAtIndexPath:indexPath]isSelected] && isJustLoaded) {
//                isJustLoaded = NO;
//                [self.contactAccResultTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//                [self tableView:self.contactAccResultTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            }
            return relatedContactCell;
        }
        else {
            RelatedAccountSearchViewCell *relatedAccountCell = [tableView dequeueReusableCellWithIdentifier:RELATED_ACCOUNT_SEARCHRESULT_TABLEVIEW_CELL];
            if (relatedAccountCell == nil) {
                relatedAccountCell = [[RelatedAccountSearchViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RELATED_ACCOUNT_SEARCHRESULT_TABLEVIEW_CELL];
                
                
            }
            
            if(self.searchResultFrom == SearchResultFrom_OpportunityPage || self.searchResultFrom == SearchReferralResultFrom_OpportunityPage) {
                 relatedAccountCell.selectButtonAccount.hidden=NO;
            }
            else {
                relatedAccountCell.selectButtonAccount.hidden=YES;
            }
            
//            if (tableView == self.contactAccResultTableView && ![[tableView cellForRowAtIndexPath:indexPath]isSelected] && isJustLoaded) {
//                isJustLoaded = NO;
//                [self.contactAccResultTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//                [self tableView:self.contactAccResultTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            }
            return [self related_Account_SearchCellDisplay:relatedAccountCell withIndexPath:indexPath];
        }
    }
    else if (tableView == self.relatedOpportunityResultTableView) {
        RelatedOptySearchResultViewCell *relatedOpportunityCell = [tableView dequeueReusableCellWithIdentifier:RELATED_OPPORTUNITY_SEARCHRESULT_TABLEVIEW_CELL];
        if (relatedOpportunityCell == nil) {
            relatedOpportunityCell = [[RelatedOptySearchResultViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RELATED_OPPORTUNITY_SEARCHRESULT_TABLEVIEW_CELL];
        }
        
        return [self related_Opportunity_SearchCellDisplay:relatedOpportunityCell withIndexPath:indexPath];

    }
    else {
        if (self.searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON) {
            RelatedContactSearchResultViewCell *relatedContactCell = [tableView dequeueReusableCellWithIdentifier:RELATED_CONTACT_SEARCHRESULT_TABLEVIEW_CELL];
            if (relatedContactCell == nil) {
                relatedContactCell = [[RelatedContactSearchResultViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RELATED_CONTACT_SEARCHRESULT_TABLEVIEW_CELL];
            }
            return [self related_Contact_SearchCellDisplay:relatedContactCell withIndexPath:indexPath];
        }
        else {
            RelatedAccountSearchViewCell *relatedAccountCell = [tableView dequeueReusableCellWithIdentifier:RELATED_ACCOUNT_SEARCHRESULT_TABLEVIEW_CELL];
            if (relatedAccountCell == nil) {
                relatedAccountCell = [[RelatedAccountSearchViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RELATED_ACCOUNT_SEARCHRESULT_TABLEVIEW_CELL];
            }

            return [self related_Account_SearchCellDisplay:relatedAccountCell withIndexPath:indexPath];
            
        }
    }
}

- (BOOL)errorCellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[EGErrorTableViewCell class]]) {
        return true;
    }
    return false;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentSelectedCellIndex == indexPath.row || [self errorCellInTableView:tableView atIndexPath:indexPath]) {
        return;
    }
    
    currentSelectedCellIndex = indexPath.row;
    
    if (tableView == self.contactAccResultTableView) {
        
        self.third_OpportunityView.hidden = FALSE;
       
       
        isFromSearchBtton = FALSE;

        if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
            
            if (!contactsPagedArray || [contactsPagedArray count] == 0) {
                return;
            }
            
            tableViewSelected = CONTACT_TABLE_VIEW_SELECTED;
            contactObj = [contactsPagedArray objectAtIndex:indexPath.row];
            contactAddress = contactObj.toAddress;
        }
        else {
            
            if (!accountsApgedArray || [accountsApgedArray count] == 0) {
                return;
            }
            
            tableViewSelected = ACCOUNT_TABLE_VIEW_SELECTED;
            accountObj = [accountsApgedArray objectAtIndex:indexPath.row];
            contactAddress = accountObj.toAddress;
        }
        
        [self getAndShowAddressFromResponse];
        
        if (selectedTitleBarButton == OPPORTUNITY_BUTTON) {
            [self loadOpportunityTable];
        }
        else if (selectedTitleBarButton == ACCOUNT_BUTTON) {
            [self loadAccountContactTable];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"IndexPath Row:%ld", (long)indexPath.row);
    NSLog(@"LastObj IndexPath Row:%ld", (long)((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row);
    
    BOOL hasRecords = false;
    
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        if (contactsPagedArray && [contactsPagedArray count] > 0) {
            hasRecords = true;
        }
    }
    else {
        if (accountsApgedArray && [accountsApgedArray count] > 0) {
            hasRecords = true;
        }
    }
    
//    if(indexPath.row && ([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)) {
//        if (tableView == self.contactAccResultTableView && ![[tableView cellForRowAtIndexPath:indexPath]isSelected] && isJustLoaded) {
//            isJustLoaded = NO;
//            [self.contactAccResultTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//            [self tableView:self.contactAccResultTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        }
//    }
    
    if (hasRecords) {
        if (tableView == self.contactAccResultTableView && ![[tableView cellForRowAtIndexPath:indexPath]isSelected] && isJustLoaded) {
            isJustLoaded = NO;
            [self.contactAccResultTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.contactAccResultTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
}

- (void)loadAccountContactTable {
//    if (isAccContactDataSourceAndCallbackSet) {
//        [self.relatedAccountContactTableView clearAllData];
//        [self.relatedAccountContactTableView reloadData];
//    }
//    else {
        [self.relatedAccountContactTableView setTableviewDataSource:self];
        [self.relatedAccountContactTableView setPagedTableViewCallback:self];
        [self.relatedAccountContactTableView clearAllData];
        [self.relatedAccountContactTableView reloadData];
        isAccContactDataSourceAndCallbackSet = true;
//    }
}

- (void)loadOpportunityTable {
//    if (isOpportunityDataSourceAndCallbackSet) {
//        [self.relatedOpportunityResultTableView clearAllData];
//        [self.relatedOpportunityResultTableView reloadData];
//    }
//    else {
        [self.relatedOpportunityResultTableView setTableviewDataSource:self];
        [self.relatedOpportunityResultTableView setPagedTableViewCallback:self];
        [self.relatedOpportunityResultTableView clearAllData];
        [self.relatedOpportunityResultTableView reloadData];
        isOpportunityDataSourceAndCallbackSet = true;
//    }
}

#pragma mark - Configure cell methods

- (RelatedContactSearchResultViewCell *)related_Contact_SearchCellDisplay:(RelatedContactSearchResultViewCell *)relatedContactCell withIndexPath:(NSIndexPath *)indexPath{
    
    EGContact * contactDetailsObj = [contactsPagedArray objectAtIndex:indexPath.row];
    relatedContactCell.firsrtNameLabel.text = contactDetailsObj.firstName;
    relatedContactCell.lastNameLabel.text = contactDetailsObj.lastName;
    relatedContactCell.customerNoLabel.text = contactDetailsObj.contactNumber;
    
//    if ([[AppRepo sharedRepo] isDSMUser]) {
//        [relatedContactCell.createNewOptyButton setHidden:true];
//    }
//    else {
        [relatedContactCell.createNewOptyButton setHidden:false];
        if (self.searchResultFrom == SearchResultFrom_OpportunityPage || self.searchResultFrom == SearchReferralResultFrom_OpportunityPage) {
            [relatedContactCell.createNewOptyButton setTitle:@"  Select" forState:UIControlStateNormal];
        }
        else{
            [relatedContactCell.createNewOptyButton setTitle:@"  Create New Opportunity" forState:UIControlStateNormal];
        }
        relatedContactCell.createNewOptyButton.tag = indexPath.row;
        relatedContactCell.createNewOptyButton.userData = contactDetailsObj;
        relatedContactCell.selectButton.userData = contactDetailsObj;
//        relatedContactCell.editButton.userData = contactDetailsObj; //new line
    
        [relatedContactCell.selectButton addTarget:self action:@selector(goToCreateContact:) forControlEvents:UIControlEventTouchUpInside];
//        [relatedContactCell.editButton addTarget:self action:@selector(goToUpdateContact:) forControlEvents:UIControlEventTouchUpInside];
        [relatedContactCell.createNewOptyButton addTarget:self action:@selector(goToCreateOpportunity:) forControlEvents:UIControlEventTouchUpInside];
    
//    }
    
    return relatedContactCell;
}

- (RelatedAccountSearchViewCell *)related_Account_SearchCellDisplay:(RelatedAccountSearchViewCell *)relatedAccountCell withIndexPath:(NSIndexPath *)indexPath{
    
    EGAccount * accountDetailsObj = [accountsApgedArray objectAtIndex:indexPath.row];
    relatedAccountCell.contactNameLabel.text = accountDetailsObj.accountName;
    relatedAccountCell.siteLabel.text = accountDetailsObj.siteName;
    relatedAccountCell.customerNoLabel.text = accountDetailsObj.contactNumber;
    relatedAccountCell.mPANLabel.text = [UtilityMethods getDisplayStringForValue:accountDetailsObj.mPAN];
     relatedAccountCell.selectButtonAccount.userData = accountDetailsObj;
    [relatedAccountCell.selectButtonAccount addTarget:self action:@selector(goToCreateAccount:) forControlEvents:UIControlEventTouchUpInside];
    return relatedAccountCell;
}

- (RelatedOptySearchResultViewCell *)related_Opportunity_SearchCellDisplay:(RelatedOptySearchResultViewCell *)relatedOpportunityCell withIndexPath:(NSIndexPath *)indexPath{
    EGOpportunity * opportunityDetailsObj = [opportunityPagedArray objectAtIndex:indexPath.row];
    relatedOpportunityCell.contactNameLabel.text = [[opportunityDetailsObj.toContact.firstName stringByAppendingString:@" "] stringByAppendingString:opportunityDetailsObj.toContact.lastName];
    relatedOpportunityCell.salesStageLabel.text = opportunityDetailsObj.salesStageName;
    relatedOpportunityCell.customerNoLabel.text = opportunityDetailsObj.toContact.contactNumber;
    relatedOpportunityCell.pplLabel.text = opportunityDetailsObj.toVCNumber.ppl;
    relatedOpportunityCell.optyCreatedDateLabel.text = [NSDate formatDate:opportunityDetailsObj.opportunityCreatedDate FromFormat:dateFormatyyyyMMddTHHmmssZ toFormat:dateFormatddMMyyyyHyphen];
    
    relatedOpportunityCell.viewOptyButton.tag = indexPath.row;
    relatedOpportunityCell.viewOptyButton.userData = opportunityDetailsObj;
    [relatedOpportunityCell.viewOptyButton addTarget:self action:@selector(viewOrEditOpportunityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return relatedOpportunityCell;
}

#pragma mark - Button Action

-(void)goToCreateOpportunity:(CustomButton *)sender{
    
    EGContact * contactObject = [[EGContact alloc] init];
    contactObject = sender.userData;
    NSLog(@"index path row- %@",contactObject.firstName);
    
    if (self.searchResultFrom == SearchResultFrom_OpportunityPage || self.searchResultFrom == SearchReferralResultFrom_OpportunityPage) {
        // Send the created contact model to the invoker of this screen
       if ([self.delegate respondsToSelector:@selector(contactCreationSuccessfull:fromView:)]) {
        
           if (self.searchResultFrom == SearchReferralResultFrom_OpportunityPage) {
               [self.delegate contactCreationSuccessfull:contactObject fromView:SearchReferralResultFrom_OpportunityPage];
           }else{
               [self.delegate contactCreationSuccessfull:contactObject fromView:SearchResultFrom_ManageOpportunity];
           }
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    else{
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchContact_ContinueToOpportunity_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];

        CreateOpportunityViewController *createOpty = [[UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"Create Opportunity_View"];
        createOpty.entryPoint = InvokeForCreateOpportunity;
        EGOpportunity * opportunityObj = [[EGOpportunity alloc] init];
        opportunityObj.toContact = contactObject;
        createOpty.opportunity = opportunityObj;
        [self.navigationController pushViewController:createOpty animated:YES];
        
    }  
}

-(void)goToCreateContact:(CustomButton *)sender{
    
    EGContact * contactObject = [[EGContact alloc] init];
    contactObject = sender.userData;
    NSLog(@"index path row- %@",contactObject.firstName);
    
    if (self.searchResultFrom == SearchResultFrom_Prospect) {
        // Send the created contact model to the invoker of this screen
        if ([self.delegate respondsToSelector:@selector(contactCreationSuccessfull:fromView:)]) {
            
            [self.delegate contactCreationSuccessfull:contactObject fromView:self.searchResultFrom];
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    
}

    /*Edit buton Event  */
-(void)goToUpdateContact:(CustomButton *)sender{

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateNewProspect" bundle: nil];
        ProspectViewController *tempProspectVC = (ProspectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create New Prospect_View"];
        tempProspectVC.detailsObj = PROSPECT_CONTACT;
    
    
        tempProspectVC.opportunityContact =  sender.userData; //contactObject
        tempProspectVC.contactAddress = contactAddress;
    
        NSLog(@"index path row- %@",tempProspectVC.opportunityContact);
    
        [self.navigationController pushViewController:tempProspectVC animated:YES];
    
}

-(void)goToCreateAccount:(CustomButton *)sender{
    
    EGAccount * accountObject = [[EGAccount alloc] init];
    accountObject = sender.userData;
    NSLog(@"index path row- %@",accountObject.contactNumber);
    
    if (self.searchResultFrom == SearchResultFrom_OpportunityPage || self.searchResultFrom == SearchReferralResultFrom_OpportunityPage) {
        // Send the created contact model to the invoker of this screen
        if ([self.delegate respondsToSelector:@selector(accountCreationSuccessfull:fromView:)]) {
            
            [self.delegate accountCreationSuccessfull:accountObject fromView:SearchResultFrom_ManageOpportunity];
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    
}


-(void)viewOrEditOpportunityButtonClicked:(CustomButton *)sender{
    NSLog(@"index path row-%ld",(long)[sender tag]);
    EGOpportunity * opportunityObj = sender.userData;
    OpportunityDetailsViewController * optyViewController = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"opportunityDetails"];
    optyViewController.opportunity = opportunityObj;
    [self.navigationController pushViewController:optyViewController animated:YES];

}


- (IBAction)searchButtonClicked:(id)sender {
    
    isFromSearchBtton = TRUE;
    isJustLoaded = TRUE;
    [self.view endEditing:true];

    if ([self validateTextFields]) {
        
        [self.contactAccResultTableView clearAllData];
        [self.relatedOpportunityResultTableView clearAllData];
        [self.relatedAccountContactTableView clearAllData];
     
        self.third_OpportunityView.hidden = TRUE;
        
        currentSelectedCellIndex = -1;
        [self.contactAccResultTableView setPagedTableViewCallback:self];
        [self.contactAccResultTableView setTableviewDataSource:self];
        [self.contactAccResultTableView clearAllData];
        [self.contactAccResultTableView reloadData];
    }
    
  if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchContact_Search_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];
  }
  else{
      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchAccount_Search_Button_Click withEventCategory:GA_CL_Prospect withEventResponseDetails:nil];
  }
}

#pragma mark - API call And Responses
-(void)callSearch_Contact_APIWithDictionary:(NSDictionary *)dictionary{
    if (dictionary){
        _searchButton.enabled = false;
        [[EGRKWebserviceRepository sharedRepository]searchContactWithContactNumber:dictionary//@{@"number":@"9879879870"}
                                                                   andSucessAction:^(EGPagination *paginationObj) {
                                                                       _searchButton.enabled = true;
                                                                       [self contact_SearchedSucessfully:paginationObj];
                                                                   } andFailuerAction:^(NSError *error) {
                                                                       _searchButton.enabled = true;
                                                                       [self contact_SearchedFailedWithError:error];
                                                                   }];
    }else{
        [UtilityMethods alert_ShowMessage:@"Please enter valid Values" withTitle:APP_NAME andOKAction:nil];
    }
}

-(void)contact_SearchedFailedWithError:(NSError *)error {
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        [self.contactAccResultTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.contactAccResultTableView reloadData];
    }
    else {
        [self.relatedAccountContactTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.relatedAccountContactTableView reloadData];
    }
    
}

- (void)contact_SearchedSucessfully:(EGPagination *)paginationObj {
    contactsPagedArray = [EGPagedArray mergeWithCopy:contactsPagedArray withPagination:paginationObj];
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        [self.contactAccResultTableView refreshData:contactsPagedArray];
        [self.contactAccResultTableView reloadData];
        
        if (_searchResultFrom == SearchReferralResultFrom_OpportunityPage){
            if (contactsPagedArray.getEmbededArray.count == 0){
                
                [self.delegate moveToNewContactCreation:SearchReferralResultFrom_OpportunityPage];
            }
        }
    }
    else {
        [self.relatedAccountContactTableView refreshData:contactsPagedArray];
        [self.relatedAccountContactTableView reloadData];
    }
}

#pragma mark - Account search
-(void)callSearch_Account_APIWithDictionary:(NSDictionary *)dictionary{
    if (dictionary){
        [[EGRKWebserviceRepository sharedRepository] searchAccount:dictionary andSucessAction:^(EGPagination *paginationObj) {
            [self Account_SearchedSucessfully:paginationObj];
        } andFailuerAction:^(NSError *error) {
            [self Account_SearchedFailedWithError:error];
        }];
        
    }else{
        [UtilityMethods alert_ShowMessage:@"Please enter valid values" withTitle:APP_NAME andOKAction:nil];
    }
}

- (void)Account_SearchedSucessfully:(EGPagination *)paginationObj {
    accountsApgedArray = [EGPagedArray mergeWithCopy:accountsApgedArray withPagination:paginationObj];
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        [self.relatedAccountContactTableView refreshData:accountsApgedArray];
        [self.relatedAccountContactTableView reloadData];
    }
    else {
        [self.contactAccResultTableView refreshData:accountsApgedArray];
        [self.contactAccResultTableView reloadData];
    }
}

- (void)Account_SearchedFailedWithError:(NSError *)error {
    if (self.searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON) {
        [self.relatedAccountContactTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.relatedAccountContactTableView reloadData];
    }
    else {
        [self.contactAccResultTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.contactAccResultTableView reloadData];
    }
}

- (void)contactSearchFailedWithErrorMessage:(NSString *)errorMessage {
    [ScreenshotCapture takeScreenshotOfView:self.view];
    AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appdelegate.screenNameForReportIssue = @"Contact Search";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}

#pragma mark - opportunity search

-(void)callSearch_Opportunity_APIWithDictionary:(NSDictionary *)dictionary{
    if (dictionary){
        
        [[EGRKWebserviceRepository sharedRepository]searchOpportunity:dictionary//@{@"number":@"9879879870"}
                                                                   andSucessAction:^(EGPagination *paginationObj) {
                                                                       
                                                                       [self opportunity_SearchedSucessfully:paginationObj];
                                                                   } andFailuerAction:^(NSError *error) {
                                                                       [self opportunity_SearchedFailedWithError:error];

                                                                   }];
    }else{
        [UtilityMethods alert_ShowMessage:@"Please enter valid Values" withTitle:APP_NAME andOKAction:nil];
    }
}

-(void)opportunity_SearchedFailedWithError:(NSError *)error {
    [self.relatedOpportunityResultTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
    [self.relatedOpportunityResultTableView reloadData];
    
}

-(void)opportunity_SearchedSucessfully:(EGPagination *)paginationObj {
    
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    if (nil != opportunityPagedArray) {
        [self.relatedOpportunityResultTableView refreshData:opportunityPagedArray];
        [self.relatedOpportunityResultTableView reloadData];
    }
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

- (void)segmentControlValueChanged:(id)sender {
    
}

@end
