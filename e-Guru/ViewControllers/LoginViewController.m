//
//  LoginViewController.m
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LoginViewController.h"
#import "AAATokenMO+CoreDataClass.h"
#import "AAATokenMO+CoreDataProperties.h"
#import "AAAUserDataMO+CoreDataClass.h"
#import "AAAUserDataMO+CoreDataProperties.h"
#import "AppRepo.h"
#import "NSString+NSStringCategory.h"
#import "ReachabilityManager.h"
#import "PushNotificationHelper.h"
#import "AsyncLocationManager.h"

@interface LoginViewController (){
    AppDelegate *appdelegate;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; //AppDelegate instance
    self.userName.delegate = self;
    self.password.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    self.versionAndBuildInfoLAbel.text = [NSString stringWithFormat:@"%@", version];
    [UtilityMethods clearAllTextFiledsInView:self.loginView];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Login];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"%@",appdelegate.userName);
    if ([appdelegate.userName hasValue]) {
        
        self.userName.text = appdelegate.userName;
        self.userName.enabled = NO;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(BOOL)isInputValid{
    if ([[ReachabilityManager sharedInstance] isInternetAvailable]) {
    if ([self.userName.text length] == 0) {
        [UtilityMethods showAlertWithMessage:@"Please enter User ID" andTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType onViewController:self];
        [self.userName becomeFirstResponder];
        return NO;
    }
    if ([self.password.text length] == 0) {
        [UtilityMethods showAlertWithMessage:@"Please enter Password" andTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType onViewController:self];
        [self.password becomeFirstResponder];
        return NO;
    }
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange usernameRange = [self.userName.text rangeOfCharacterFromSet:whitespace];
    if (usernameRange.location != NSNotFound) {
        // There is whitespace.
        [UtilityMethods showAlertWithMessage:@"Please enter valid User ID/Password" andTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType onViewController:self];
        return NO;
    }
    
    NSRange passwordRange = [self.userName.text rangeOfCharacterFromSet:whitespace];
    if (passwordRange.location != NSNotFound) {
        // There is whitespace.
        [UtilityMethods showAlertWithMessage:@"Please enter valid User ID/Password" andTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType onViewController:self];
        return NO;
    }

    }
    else
    {
        [UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
            
        }];
        return NO;

        
    }
    return YES;
}

-(void)checkUserAuthenticity {
    [self callLoginAPI];
}

-(void)loginFailedWithErrorMessage:(NSString *)errroMessage {
    [UtilityMethods clearAllTextFiledsInView:self.loginView];
    [UtilityMethods showAlertWithMessage:errroMessage andTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType onViewController:self];
}

#pragma mark - UITextFieldDelegate Methods

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
        if ([textField isEqual:self.password]) {
            [textField resignFirstResponder];
            [self loginAction:nil];
        }
    }
    return true;
}

#pragma mark - IBAction

- (IBAction)loginAction:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    if ([self isInputValid]) {
        [self checkUserAuthenticity];
    }
}

#pragma mark - API Calls

- (void)callLoginAPI {
    NSDictionary *requestDictionary = @{@"username": self.userName.text,
                                        @"password": self.password.text,
                                        @"device_id": [UtilityMethods getVendorID],
                                        @"app_version": [UtilityMethods getAppVersion],
                                        @"app_name": [UtilityMethods getAppBundleID]};
    
    [[EGRKWebserviceRepository sharedRepository] performLogin:requestDictionary andSuccessAction:^(Login *response) {
        if (response) {
            for (EGUserData *userData in response.usersArray) {
                if ([userData.positionID isEqualToString:userData.primaryPositionID]) {
                    [[AppRepo sharedRepo] loginUser:userData token:response.token];
                    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).hasJustLoggedIn = true;
                    //OFFLINEMASTERSYNC ------------------------------
                    [self checkForOfflineMasterSync];
                    //OFFLINEMASTERSYNC ------------------------------
                    
                    // Register device for Push Notifications
                    [[PushNotificationHelper sharedHelper] registerDevice];
                    
                    // Start Location Capture
                    [[AsyncLocationManager sharedInstance] startAsyncLocationFetch];
                }
            }
        }
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Login withEventCategory:GA_CL_Authentication withEventResponseDetails:GA_EA_LoginSuccessful];
    } andFailureAction:^(NSError *error) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Login withEventCategory:GA_CL_Authentication withEventResponseDetails:GA_EA_LoginFailed];

    }];
}

-(void)checkForOfflineMasterSync{
        
    if ([EGOfflineMasterSyncHelper isFirstLoginOfTheDay] || [EGOfflineMasterSyncHelper isLocalVersionNumberZero]) {
        [EGOfflineMasterSyncHelper autoSyncOfflineMaster];
    }
    else if(![EGOfflineMasterSyncHelper isFirstLoginOfTheDay]){
         [EGOfflineMasterSyncHelper forceSyncOfflineMaster];
    }
    else{
        [[DBManager sharedInstance] setUpDB:MASTER_DB];
    }
    
}



@end
