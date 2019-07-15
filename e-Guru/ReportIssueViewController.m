//
//  ReportIssueViewController.m
//  e-guru
//
//  Created by admin on 4/18/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ScreenshotCapture.h"
#import "ReportIssueViewController.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "PostHelper.h"

@interface ReportIssueViewController ()

@end

@implementation ReportIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mainView.layer.cornerRadius=5.0f;
    self.closeMainView.layer.cornerRadius=15;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.idTextfield.leftView = paddingView;
    self.idTextfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.mobilenumberTextfield.leftView = paddingView1;
    self.mobilenumberTextfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.emailidTextfield.leftView = paddingView2;
    self.emailidTextfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.nameTextField.leftView = paddingView3;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self validations];
    [self bindValuestoReportIssue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeMainViewAction:(id)sender {
    
    [ScreenshotCapture sharedSetup].issueReportScreenshortImageData = nil;
    [self.view removeFromSuperview];
}

-(void)bindValuestoReportIssue{
    self.idTextfield.text=[[[AppRepo sharedRepo]getLoggedInUser]userName];
    self.mobilenumberTextfield.text=[[[AppRepo sharedRepo]getLoggedInUser]primaryEmployeeCellNum];
    self.nameTextField.text=[[[AppRepo sharedRepo]getLoggedInUser]dsmName];
    
}
-(void)validations{
    
    self.idTextfield.enabled=false;
    self.nameTextField.enabled=false;
    self.emailidTextfield.layer.borderWidth=1.0f;
    self.emailidTextfield.layer.borderColor=[UIColor redColor].CGColor;
    self.mobilenumberTextfield.layer.borderWidth=1.0f;
    self.mobilenumberTextfield.layer.borderColor=[UIColor redColor].CGColor;
    self.issueTextview.layer.borderWidth=1.0f;
    self.issueTextview.layer.borderColor=[UIColor redColor].CGColor;
    
}

- (IBAction)resetAction:(id)sender {
    self.mobilenumberTextfield.text=@"";
    self.emailidTextfield.text=@"";
    self.issueTextview.text=@"";
}

- (IBAction)submitAction:(id)sender {
    
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ReportIssue_Button_Click withEventCategory:GA_CL_ReportIssue withEventResponseDetails:nil];
    if([self.mobilenumberTextfield.text isEqualToString: @""])
    {
        [self showAlertWithMessage:@"Please enter Mobile Number"];
    }
    else if (![UtilityMethods validateMobileNumber:self.mobilenumberTextfield.text]) {
        [self showAlertWithMessage:@"Please enter Valid Mobile Number"];
    }
    else if([self.emailidTextfield.text isEqualToString:@""] || ![UtilityMethods validateEmail:self.emailidTextfield.text]){
        [self showAlertWithMessage:@"Please enter Valid Email Id"];
    }

    else if([self.nameTextField.text isEqualToString: @""])
    {
        [self showAlertWithMessage:@"Please enter Name"];
    }
    else if([self.issueTextview.text isEqualToString: @""])
    {
        [self showAlertWithMessage:@"Please enter Issue Description"];
    }
    else{

         [self uploadImageWithData];
        [UtilityMethods showProgressHUD:true];
    }
}

#pragma mark -  APIs
-(void) uploadImageWithData{
    
        NSData *imageData = [ScreenshotCapture sharedSetup].issueReportScreenshortImageData;
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        [manager.securityPolicy setAllowInvalidCertificates:NO ];  //for stoping crash we need to set it YES
    
        AAATokenMO *tokenObject = [[AppRepo sharedRepo] getTokenDetails];
        if (tokenObject) {
            NSString *value = [NSString stringWithFormat:@"%@ %@", tokenObject.tokenType, tokenObject.accessToken];
            [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
        }
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BaseURL,REPORTISSUEURL] parameters:[self createImageUploadParameterDictionary] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            if (imageData != nil) {
            
                [formData appendPartWithFileData:imageData
                                    name:@"attachment"
                                fileName:[NSString stringWithFormat:@"%@_%0.f.png",self.idTextfield.text,[NSDate timeIntervalSinceReferenceDate]] //photo.jpg
                                mimeType:@""];
            }
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UtilityMethods hideProgressHUD];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_IssueReport_Successful withEventCategory:GA_CL_ReportIssue withEventResponseDetails:nil];
        
        if(responseObject != nil){
            
            NSDictionary *jsonDict = (NSDictionary *)responseObject;
            
            NSString *responseMessage = [jsonDict objectForKey:@"msg"];
            
            [UtilityMethods alert_ShowMessage:responseMessage withTitle:APP_NAME andOKAction:nil];

            [self closeMainViewAction:nil];
            
        }else{
            
            [UtilityMethods alert_ShowMessage:ServerError withTitle:APP_NAME andOKAction:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_IssueReportingFailed  withEventCategory:GA_CL_ReportIssue withEventResponseDetails:nil];

        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        
        NSInteger statusCode = response.statusCode;

        if (statusCode == 401) { // access token expired
            
            [UtilityMethods showAlertMessageOnWindowWithMessage:@"Session Expired" handler:^(UIAlertAction *action) {
                [[AppRepo sharedRepo] logoutUser];
            }];
        }else{

            if (error != nil) {
                [UtilityMethods showToastWithMessage:error.localizedDescription];
            }else{
                [UtilityMethods alert_ShowMessage:UnableToProcessRequest withTitle:APP_NAME andOKAction:nil];
            }
        }
    }];
}

-(NSMutableDictionary *) createImageUploadParameterDictionary{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:self.issueTextview.text forKey:@"description"];
    [dict setValue:self.errorDiscription forKey:@"exception"];
    [dict setValue:@"e-Guru" forKey:@"app_name"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [dict setValue:appDelegate.screenNameForReportIssue forKey:@"module"];
    [dict setValue:self.emailidTextfield.text forKey:@"userEmailId"];
    [dict setValue:self.mobilenumberTextfield.text forKey:@"userMobileNo"];

    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [dict setValue:version forKey:@"app_version"];
    
    [dict setValue:@"iOS" forKey:@"app_technology"];

    return dict;
}



# pragma mark - Text field
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
#pragma mark - textFiled delegate methods
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.mobilenumberTextfield)  {
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField*)textField{
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES; // We do not want UITextField to insert line
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        
    }];
}

- (void)showReportIssuefromViewController:(id)controller {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController addChildViewController:self];
    self.view.frame = topRootViewController.view.frame;
    [topRootViewController.view addSubview:self.view];
    [self didMoveToParentViewController:topRootViewController];
    
    
}
@end
