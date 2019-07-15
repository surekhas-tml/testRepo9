//
//  Home_LandingPageViewController.m
//  e-Guru
//
//  Created by MI iMac01 on 29/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//


//gray-search

#import "UtilityMethods.h"
#import "ScreenshotCapture.h"
#import "Home_LandingPageViewController.h"
#import "MasterViewController.h"
#import "AppRepo.h"
#import "SearchResultsViewController.h"
//#import <Crashlytics/Crashlytics.h>

@interface Home_LandingPageViewController ()
{
    EGsearchByValues * searchByValue;
    BOOL isFromCreateNew;
}
@end

@implementation Home_LandingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Home_LandingPageViewController");
    self.navigationController.title = HOME;
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; //AppDelegate instance
    appdelegate.splitViewController.delegate = self;
    appdelegate.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
  
    if(!(self.searchTextField.text==nil)){
        self.searchTextField.text=self.contactnumber;
    }

    [self addNavigationBarRightSideButtons];
    
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.view.window endEditing:YES];
    
    [self localNavBarSetup];
}

-(void)viewWillDisappear:(BOOL) animated{

    [self.view.window endEditing:YES];        
}
    
- (void)configureView {
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_HomePage];

    searchByValue = [EGsearchByValues new];
    [self selectRadioButtonWithTag:RADIO_CONTACT_BUTTON];
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;

    self.createNewButton.layer.borderColor = [UIColor textFieldGreyBorder].CGColor;
    self.createNewButton.layer.borderWidth = 1.5f;
    
    self.LogedinUser.text = [NSString stringWithFormat:@"Hi, %@", [[AppRepo sharedRepo] getLoggedInUser].userName];
    
    isFromCreateNew = FALSE;
    
    [self adjustUserBasedOnRole];
}

- (void)addNavigationBarRightSideButtons {
    
    // Report an Issue Button
    UIButton* reportIssueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    [reportIssueButton setTitle:@"Report an Issue" forState:UIControlStateNormal];
    [reportIssueButton setBackgroundColor:[UIColor whiteColor]];
    [reportIssueButton.layer setCornerRadius:5.0f];
    [reportIssueButton setTitleColor:[UIColor navBarColor] forState:UIControlStateNormal];
    [reportIssueButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [reportIssueButton addTarget:self action:@selector(reportIssueMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reportIssueBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:reportIssueButton];
    
    // Notification Button
    UIButton* notificationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    [notificationButton setImage:[UIImage imageNamed:@"bell_nav_bar"] forState:UIControlStateNormal];
    [notificationButton addTarget:self action:@selector(openNotificationScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *notificationBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:notificationButton];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:notificationBarButtonItem, reportIssueBarButtonItem, nil]];
}

- (void)adjustUserBasedOnRole {
    
//    if ([[AppRepo sharedRepo] isDSMUser]) {
//        [self.dseOptionsView removeFromSuperview];
//        [self.createNewButton setHidden:true];
//        [self.searchFieldsRightMarginConstraint setConstant:4.0f];
//        [self.searchButtonRightMarginConstraint setConstant:8.0f];
//    }
   // else {
        [self.dsmOptionsView removeFromSuperview];
        [self.createNewButton setHidden:false];
        [self.searchFieldsRightMarginConstraint setConstant:100.0f];
        [self.searchButtonRightMarginConstraint setConstant:104.0f];
    //}
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
    [self.buttonbasedonrole setImage:[UIImage imageNamed:@"NFA"] forState:UIControlStateNormal];
        self.basedonrolelabel.text=@"NFA";
    }
    else{
        [self.buttonbasedonrole setImage:[UIImage imageNamed:@"contactLanding"] forState:UIControlStateNormal];
        self.basedonrolelabel.text=@"Contact";
    }
}

-(void)localNavBarSetup{
    
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"Menu"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Menu"];
    
    UIBarButtonItem *showMasterButton = self.splitViewController.displayModeButtonItem;
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [logo setImage:[UIImage imageNamed:@"eguru"]];
    UIBarButtonItem *logoButton = [[UIBarButtonItem alloc]initWithCustomView:logo];
    
    self.navigationItem.leftBarButtonItems = @[showMasterButton,logoButton];

}

#pragma mark Helper Method
-(void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"contactID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OrgID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPosition"];
    [[AppRepo sharedRepo] logoutUser];
    appdelegate.userName = nil;
}

-(BOOL)validateSearchBar
{
    NSString * errorMessage = @"";
    BOOL flag = TRUE;
    if([self.searchTextField.text isEqualToString:@""]){
        errorMessage = @"Please enter mobile number";
        flag = FALSE;
    }
    else if([self.searchTextField.text length] < 10){
        errorMessage = @"Please enter valid mobile number";
        flag = FALSE;
    }
    
    if (![errorMessage isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    }
    return flag;
    
}
#pragma mark - helper methods UI
-(void)selectRadioButtonWithTag:(NSInteger)buttonTag{

    switch (buttonTag) {
        case RADIO_OPPORTUNITY_BUTTON:
        {
            [self.radioOptyButton setImage:[UIImage imageNamed:@"radio-btn-on-blue"] forState:UIControlStateNormal];
            [self.radioContactButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            [self.radioAccountButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            searchByValue.radioButtonSelected = RADIO_OPPORTUNITY_BUTTON;
        }
            break;
        case RADIO_CONTACT_BUTTON:
        {
            [self.radioOptyButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            [self.radioContactButton setImage:[UIImage imageNamed:@"radio-btn-on-blue"] forState:UIControlStateNormal];
            [self.radioAccountButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            searchByValue.radioButtonSelected = RADIO_CONTACT_BUTTON;
        }
            break;
        case RADIO_ACCOUNT_BUTTON:
        {
            [self.radioOptyButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            [self.radioContactButton setImage:[UIImage imageNamed:@"radio-btn-off-blue"] forState:UIControlStateNormal];
            [self.radioAccountButton setImage:[UIImage imageNamed:@"radio-btn-on-blue"] forState:UIControlStateNormal];
            searchByValue.radioButtonSelected = RADIO_ACCOUNT_BUTTON;
        }
            break;
            
        default:
            break;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: [CREATEPROSPECT stringByAppendingString:SEGUE]]){
        ProspectViewController __weak *prospectVC = (ProspectViewController *)[[segue destinationViewController] topViewController];
        if (isFromCreateNew) {
            if (searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON){
                prospectVC.detailsObj = PROSPECT_CONTACT;
                
                self.contactnumber=self.searchTextField.text;

                prospectVC.demo= self.searchTextField.text;
            
            }
            else{
                self.accountnumber=self.searchTextField.text;
                prospectVC.detailsObj = PROSPECT_ACCOUNT;
                prospectVC.demo= self.searchTextField.text;
            }
        }
        else{
            prospectVC.detailsObj = PROSPECT_CONTACT;
        }
    }
    else if ([segue.identifier isEqualToString:@"showCal_Segue"]){
        WeekCalendarViewController *cal = [segue destinationViewController];
        cal.invokedFrom = Home;
    }
    else if ([segue.identifier isEqualToString: [CREATEOPTY stringByAppendingString:SEGUE]]){
        
    }
    else if ([segue.identifier isEqualToString: [DASHBOARD stringByAppendingString:SEGUE]]){
        
    }
    else if ([segue.identifier isEqualToString: [DRAFT stringByAppendingString:SEGUE]]){
        
    }
    else if ([segue.identifier isEqualToString: [FINANCER stringByAppendingString:SEGUE]]){
        
    }
    else if ([segue.identifier isEqualToString: [NFASearch stringByAppendingString:SEGUE]]){
        SearchNFAViewController *sNFAVC = (SearchNFAViewController *)[[segue destinationViewController] topViewController];
        sNFAVC.invokedFrom = Home;
    }
}

#pragma mark - textFiled delegate methods
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.searchTextField)  {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.searchTextField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
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
    [textField resignFirstResponder];
    self.searchTextField=textField;
    [self searchButtonClick:textField];
    return YES;
}


#pragma mark - button actions

- (void)openNotificationScreen {
    [self performSegueWithIdentifier:[NOTIFICATIONS stringByAppendingString:SEGUE] sender:nil];
}

- (void) reportIssueMethod{
    
    [ScreenshotCapture sharedSetup].issueReportScreenshortImageData = nil;
    
    [UtilityMethods reportIssueMethodWithErrorDiscription:@""];
}

- (IBAction)searchButtonClick:(id)sender {
    
    isFromCreateNew = FALSE;
    if ([self validateSearchBar]) {
        if ([UtilityMethods validateMobileNumber:self.searchTextField.text]) {
            if (searchByValue.radioButtonSelected == RADIO_OPPORTUNITY_BUTTON) {
                searchByValue.stringToSearch = self.searchTextField.text;
      
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ManageOpportunity" bundle: nil];
                ManageOpportunityViewController *tempCreateContactVC = (ManageOpportunityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Manage Opportunity_View"];
                tempCreateContactVC.searchByValue = searchByValue;
                tempCreateContactVC.invokedFrom = Home;

                [self.navigationController pushViewController:tempCreateContactVC animated:YES];
                
            }
            else if(searchByValue.radioButtonSelected == RADIO_CONTACT_BUTTON){
                searchByValue.stringToSearch = self.searchTextField.text;
               
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search_Result" bundle: nil];
                SearchResultsViewController *tempCreateContactVC = (SearchResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchResult"];
                tempCreateContactVC.detailsObj = PROSPECT_CONTACT;
                  tempCreateContactVC.searchByValue = searchByValue;
                 [self.navigationController pushViewController:tempCreateContactVC animated:YES];
               
            }
            
            else if(searchByValue.radioButtonSelected == RADIO_ACCOUNT_BUTTON){
                searchByValue.stringToSearch = self.searchTextField.text;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search_Result" bundle: nil];
                SearchResultsViewController *tempCreateContactVC = (SearchResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchResult"];
                tempCreateContactVC.detailsObj = PROSPECT_ACCOUNT;
                tempCreateContactVC.searchByValue = searchByValue;
                [self.navigationController pushViewController:tempCreateContactVC animated:YES];

        }
        
        else{
            [UtilityMethods alert_ShowMessage:@"Please enter valid Contact Number" withTitle:APP_NAME andOKAction:nil];
        }
        
        // Clear the number in search field (QK Bug resolution)
        [self.searchTextField setText:@""];
    }
}
}
- (IBAction)cirularButtonClicked:(id)sender {
    
    isFromCreateNew = FALSE;
    switch ([sender tag]) {
        case MYPAGEBUTTON:
        {
            [self performSegueWithIdentifier:[MYPAGE stringByAppendingString:SEGUE] sender:nil];

        }
            break;
        case MYOPPORTUNITYBUTTON:
        {
            [self performSegueWithIdentifier:[MANAGEOPTY stringByAppendingString:SEGUE] sender:nil];
        }
            break;
        case CALENDERBUTTON:
        {
        }
            break;
        case DASHBOARDBUTTON:
        {
            [self performSegueWithIdentifier:[DASHBOARD stringByAppendingString:SEGUE] sender:nil];
        }
            break;
        case DRAFTBUTTON:
        {
            [self performSegueWithIdentifier:[DRAFT stringByAppendingString:SEGUE] sender:nil];
        }
            break;
        case CONTACTBUTTON:
        {
             if ([[AppRepo sharedRepo] isDSMUser]) {
            [self performSegueWithIdentifier:[NFASearch stringByAppendingString:SEGUE] sender:nil];
             }
             else{
                 [self performSegueWithIdentifier:[CREATEPROSPECT stringByAppendingString:SEGUE] sender:nil];
             }
            
        }
        case NFABUTTON:
        {
            [self performSegueWithIdentifier:[NFASearch stringByAppendingString:SEGUE] sender:nil];
            
        }
        case FINANCERBUTTON:
        {
            [self performSegueWithIdentifier:[FINANCER stringByAppendingString:SEGUE] sender:nil];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)logOutButtonClicked:(id)sender {
    
    UIAlertController *alertMessage = [UIAlertController
                                       alertControllerWithTitle:nil
                                       message:@"Are you sure you want to logout?"
                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *YesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    [self logout];
                                }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"No action")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertMessage addAction:YesAction];
    [alertMessage addAction:noAction];
    [self presentViewController:alertMessage animated:YES completion:nil];
    
}

- (IBAction)radioButtonClicked:(id)sender {
    [self selectRadioButtonWithTag:[sender tag]];
}

-(IBAction)createNewButtonClicked:(id)sender{
    
    isFromCreateNew = TRUE;
    if (searchByValue.radioButtonSelected == RADIO_OPPORTUNITY_BUTTON) {
        [self performSegueWithIdentifier:[CREATEOPTY stringByAppendingString:SEGUE] sender:nil];
    }
    else{
        [self performSegueWithIdentifier:[CREATEPROSPECT stringByAppendingString:SEGUE] sender:nil];
    }
}
@end





