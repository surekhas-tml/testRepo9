//
//  UtilityMethods.m
//  CRM_APP
//
//  Created by Juili on 24/05/16.
//  Copyright © 2016 TataTechnologies. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "UtilityMethods.h"
#import "MBProgressHUD.h"
#import "NSString+NSStringCategory.h"
#import "Home_LandingPageViewController.h"
#import "EGDraftStatus.h"
#import "PINViewController.h"
#import "ReportIssueViewController.h"
#import "LocationManagerSingleton.h"
#import "NotificationViewController.h"

@implementation UtilityMethods
static NSMutableArray* ShowStates = nil;
static NSMutableDictionary* AllStateCodes = nil;
static UtilityMethods*  _sharedobject=nil;

+(UtilityMethods *)sharedobject

{
    @synchronized([UtilityMethods class])
    {
        if (!_sharedobject)
            _sharedobject=[[self alloc] init];
        
        return _sharedobject;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([UtilityMethods class])
    {
        NSAssert(_sharedobject == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedobject = [super alloc];
        return _sharedobject;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}
//Delete Draft from DraftDB when draft.status == EGDraftStatusSyncing
+(void) resetDraftStatus
{

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPredicate *predicateStatus = [NSPredicate predicateWithFormat:@"status ==%d",EGDraftStatusSyncing];
    NSPredicate *predicateSearch = [NSCompoundPredicate andPredicateWithSubpredicates:@[ predicateStatus]];
    
    NSFetchRequest *requestDrafts = [AAADraftMO fetchRequest];
    [requestDrafts setPredicate:predicateSearch];
    NSError *error;
    NSMutableArray *opportunitytinfoarray = [NSMutableArray arrayWithArray:[appDelegate.managedObjectContext executeFetchRequest:requestDrafts error:&error]];
    for (AAADraftMO *draft in opportunitytinfoarray) {
        draft.status = EGDraftStatusQueuedToSync;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error while deleting draft");
        }
    }
}

+ (NSString *)uuid
{
    return [[NSUUID UUID] UUIDString];
}

+(NSString *)errorMessages_For_ErrorCode:(NSInteger)errorCode{
    switch (errorCode) {
        case NSURLErrorBadServerResponse:
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
}

+ (NSString *)errorMessageForErrorCode:(NSInteger)errorCode{
    
    switch (errorCode) {
        case 200:
            return NoDataFoundError;
            break;
        
        case 404:
            return NoDataFoundError;
            break;
        case 408:
        case 504:
            return EndpointReqTimedOut;
        case 440:
        case 524:
            return RequestTimeOutError;
            break;
            
        case 500:
            return ServerError;
            break;
            
        case 66601:
            return NoNetworkError;
            break;
            
        case 0:
            return NoNetworkError;
            break;
            
        default:
            return UnableToProcessRequest;
            break;
    }
    
}

+(void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title onViewController:(UIViewController *)currentViewControler{

    UIAlertController *alertMessage = [UIAlertController
                                       alertControllerWithTitle:title
                                       message:message
                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertMessage addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Alert Message of %@",[[currentViewControler class]description] );

            [currentViewControler presentViewController:alertMessage animated:YES completion:nil];
        });
}
+(void)openHomeScreen{
    [[AppRepo sharedRepo]showHomeScreen];

}

+(void)navigationBarSetupForController:(UIViewController *__weak)uiviewController {
    
    
    AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; //AppDelegate instance
    if( [uiviewController conformsToProtocol:@protocol(UISplitViewControllerDelegate)]){
        appdelegate.splitViewController.delegate = (id<UISplitViewControllerDelegate>)uiviewController;
    }
    
    uiviewController.navigationItem.leftItemsSupplementBackButton = YES;
    uiviewController.navigationItem.hidesBackButton = NO;

    UIBarButtonItem *showMasterButton = uiviewController.splitViewController.displayModeButtonItem;
    
    double width = 220;
    
    UILabel* titleVC = [[UILabel alloc] init];
    if ([uiviewController isKindOfClass:[NotificationViewController class]]) {
        width = 3 * width;
    }
    
    [titleVC setFrame:CGRectMake(0, 0, uiviewController.navigationController.navigationBar.frame.size.width - width, uiviewController.navigationController.navigationBar.frame.size.height)];
    
//    UILabel* titleVC = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,uiviewController.navigationController.navigationBar.frame.size.width,uiviewController.navigationController.navigationBar.frame.size.height)];
    titleVC.textAlignment = NSTextAlignmentLeft;
    
    if ([[uiviewController.navigationController viewControllers]count] <= 1 ) {
        titleVC.text = uiviewController.navigationController.title;
        [titleVC setTextColor:[UIColor whiteColor]];
        UIBarButtonItem *titleVCButton = [[UIBarButtonItem alloc]initWithCustomView:titleVC];
        
         UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        [button setImage:[UIImage imageNamed:@"Home1"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openHomeScreen) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *homeButtonNavBar = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        [button1 setTitle:@"Report an Issue" forState:UIControlStateNormal];
        [button1 setBackgroundColor:[UIColor whiteColor]];
        button1.layer.cornerRadius=5.0f;
        [button1 setTitleColor:[UIColor navBarColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [button1 addTarget:self action:@selector(reportIssueMethod) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *homeButtonNavBar1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
        /**
         Added to prevent crash if any BarButtonItem is nil
         **/
        NSMutableArray *homeButtonArray = [[NSMutableArray alloc] init];
        if (homeButtonNavBar) {
            [homeButtonArray addObject:homeButtonNavBar];
        }
        if (homeButtonNavBar1) {
            [homeButtonArray addObject:homeButtonNavBar1];
        }
        
        [uiviewController.navigationItem setRightBarButtonItems:homeButtonArray];

        
        NSMutableArray *letButtonArray = [[NSMutableArray alloc] init];
        if (showMasterButton) {
            [letButtonArray addObject:showMasterButton];
        }
        if (titleVCButton) {
            [letButtonArray addObject:titleVCButton];
        }
        
        uiviewController.navigationItem.leftBarButtonItems = letButtonArray;
        uiviewController.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"Menu"];
        uiviewController.navigationController.navigationBar.topItem.title = nil;

        uiviewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Menu"];
        
    }
    else{
        titleVC.text = uiviewController.title;
        [titleVC setTextColor:[UIColor whiteColor]];
        UIBarButtonItem *titleVCButton = [[UIBarButtonItem alloc]initWithCustomView:titleVC];
        uiviewController.navigationController.navigationBar.topItem.title = nil;
        uiviewController.navigationItem.leftBarButtonItems = @[titleVCButton];
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        [button setImage:[UIImage imageNamed:@"Home1"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openHomeScreen) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *homeButtonNavBar = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        [button1 setTitle:@"Report an Issue" forState:UIControlStateNormal];
        [button1 setBackgroundColor:[UIColor whiteColor]];
        button1.layer.cornerRadius=5.0f;
        [button1 setTitleColor:[UIColor navBarColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [button1 addTarget:self action:@selector(reportIssueMethod) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *homeButtonNavBar1 = [[UIBarButtonItem alloc]initWithCustomView:button1];

        [uiviewController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:homeButtonNavBar,homeButtonNavBar1,nil]];
        
        uiviewController.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back_button"];
        uiviewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_button"];
        
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(lostNetwork)
//                                                 name:NOTIFICATION_NETWORK_NOT_AVAILABLE
//                                               object:nil];
    }

+(void)alert_ShowMessage:(NSString*)message withTitle:(NSString *)title andOKAction:(void (^)(void))okBlock{
    
    [self alert_ShowMessage:message withTitle:title onController:nil andOKAction:^{
        if (okBlock) {
            okBlock();
        }
    }];
}

+ ( void )alert_ShowMessagewithCreate:(NSString*)message withTitle:(NSString *)title andOKAction:(void (^)(void))okBlock andCreateContactAction:(void (^)(void))createContactBlock{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    if (okBlock) {
                                        okBlock();
                                    }
                                }];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"Create Contact"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   if (createContactBlock) {
                                       createContactBlock();
                                   }
                               }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:alert animated:YES completion:nil];
}

+(void)alert_ShowMessage:(NSString*)message withTitle:(NSString *)title onController:(UIViewController *)viewController andOKAction:(void (^)(void))okBlock{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }]];
        
        if (viewController) {
            [viewController presentViewController:alertController animated:true completion:nil];
        } else {
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
            }];
        }
    });
}

+ ( void )alert_ShowMessagewithreportissue:(NSString*)message withTitle:(NSString *)title andOKAction:(void (^)(void))okBlock andReportIssueAction:(void (^)(void))reportBlock{
    
    [self alert_ShowMessagewithreportissue:message withTitle:title onController:nil andOKAction:^{
        if (okBlock) {
            okBlock();
        }
    } andReportIssueAction:^{
        if (reportBlock) {
            reportBlock();
        }
    }];
        
}


+ ( void )alert_ShowMessagewithreportissue:(NSString*)message withTitle:(NSString *)title onController:(UIViewController *)viewController andOKAction:(void (^)(void))okBlock andReportIssueAction:(void (^)(void))reportBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        if (okBlock) {
                                            okBlock();
                                        }
                                    }];
        
        [alert addAction:yesAction];
        
        if (![message isEqualToString:NoNetworkError]) {
            
            UIAlertAction* noAction = [UIAlertAction
                                       actionWithTitle:@"Report Issue"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                           [self reportIssueMethodWithErrorDiscription:message];
                                           if (reportBlock) {
                                               reportBlock();
                                           }
                                           
                                       }];
            [alert addAction:noAction];
            
        }
        
        if (viewController) {
            [viewController presentViewController:alert animated:true completion:nil];
        } else {
            
            UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [window presentViewController:alert animated:YES completion:nil];
        }
        
    });
    
    
}

+(void) reportIssueMethod{

    [ScreenshotCapture sharedSetup].issueReportScreenshortImageData = nil;
    
    [UtilityMethods reportIssueMethodWithErrorDiscription:@""];
}

+(void)reportIssueMethodWithErrorDiscription:(NSString *)errorDiscription{

    ReportIssueViewController *reportIssueViewController = [[ReportIssueViewController alloc] init];
    reportIssueViewController.errorDiscription = errorDiscription;
    [reportIssueViewController showReportIssuefromViewController:self];
}


+ ( void )alert_showMessage:(NSString*)message withTitle:(NSString *)title andOKAction:(void (^)(void))okBlock andNoAction:(void (^)(void))noBlock{
    dispatch_async(dispatch_get_main_queue(), ^{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    if (okBlock) {
                                        okBlock();
                                    }
                                }];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   if (noBlock) {
                                       noBlock();
                                   }
                               }];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
        
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:alert animated:YES completion:nil];
            });
}


+(void)clearAllTextFiledsInView:(UIView *)fromView
{
    for (UIView *view in [fromView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.text = @"";
        }
    }
}

+(BOOL)isAnyTextFieldHasUpdated:(UIView *)fromView
{
    for (UIView *view in [fromView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (![textField.text isEqualToString:@""]) {
                return TRUE;
            }
        }
    }
    return FALSE;
}


+(NSString *)getErrorMessage:(NSError *)err{
    
    NSString * __block errorMessage = @"";

//    NSString *errorMessage_old = [NSString stringWithFormat:@"Domain : %@ \n Code : %ld \n Failing URL : %@ \n Description : %@ \n Reson : %@", [err domain],(long)[err code],[[err userInfo] objectForKey:@"NSErrorFailingURLKey"],[err localizedDescription],[err localizedFailureReason]];
    
    [UtilityMethods convertJSONStringToDictionary:err.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
         errorMessage = [jsonDictionary objectForKey:@"msg"];
    } failure:^(NSError * _Nullable error) {
        
    }];
    

    if (errorMessage.length > 0) {
        return errorMessage;
    }else{
        return [UtilityMethods errorMessageForErrorCode:[err code]];
    }
}

+(void)setRedBoxBorder:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor mandatoryFieldRedBorderColor].CGColor;
}

+(void)setGreyBoxBorder:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor=[UIColor textFieldGreyBorder].CGColor;
}

+(void)setBlackBoxBorder:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor=[UIColor blackColor].CGColor;
}

+(void)setLeftPadding:(UITextField *)textField{
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
}

+ (void)showAlertMessageOnWindowWithMessage:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIWindow __block *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        alertWindow.tintColor = delegate.window.tintColor;
    }
    
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [alertWindow makeKeyAndVisible];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
        [alertWindow setHidden:true];
        alertWindow = nil;
        handler(action);
    }]];
    
    [alertWindow.rootViewController presentViewController:alertController animated:true completion:nil];
}

+ (void)showErroMessageFromAPICall:(NSError *)error  defaultMessage:(NSString *)defaultMessage {
   
    [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
     
        id responseMessage = [jsonDictionary objectForKey:@"msg"];
     
        if ([responseMessage isKindOfClass:[NSString class]]) {
            [self alert_ShowMessagewithreportissue:[jsonDictionary objectForKey:@"msg"] withTitle:APP_NAME andOKAction:^{} andReportIssueAction:^{}];
        }
        else if([responseMessage isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDictionary = (NSDictionary *)responseMessage;
            id message = [responseDictionary objectForKey:@"Failed"];
            if (message && [message isKindOfClass:[NSString class]]) {

                [self alert_ShowMessagewithreportissue:[jsonDictionary objectForKey:@"msg"] withTitle:APP_NAME andOKAction:^{} andReportIssueAction:^{}];

            }
        }
        
    } failure:^(NSError * _Nullable error) {

        [self alert_ShowMessagewithreportissue:defaultMessage withTitle:APP_NAME andOKAction:^{} andReportIssueAction:^{}];

    }];
}

+ (NSString *)extractMessageFromError:(NSError *)error {
    
    
    NSString *messageString = error.localizedRecoverySuggestion;
    if (![messageString hasValue]) {
        return nil;
    }
    
    NSError *jsonError;
    NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if(jsonError) {
        return nil;
    } else {
        id responseMessage = [json objectForKey:@"msg"];
        if ([responseMessage isKindOfClass:[NSString class]]) {
            return responseMessage;
        }
        else if([responseMessage isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDictionary = (NSDictionary *)responseMessage;
            id message = [responseDictionary objectForKey:@"Failed"];
            if (message && [message isKindOfClass:[NSString class]]) {
                return message;
            }
        }
    }
    
    return nil;
}

#pragma mark - Deveice Details

+ (NSString *)getVendorID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark - App Details

+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAppBundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

#pragma mark - View and ViewController Methods

+ (UIView *)getTopMostView {
    UIViewController *currentViewController = [self getCurrentViewController];
    if (currentViewController) {
        return currentViewController.view;
    }
    return nil;
}

+ (UIViewController *)getCurrentViewController {
    
    UINavigationController *navigationController = [self getNavigationController];
    if (navigationController) {
        return navigationController.visibleViewController;
    }
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (rootViewController) {
        UIViewController *currentViewController = rootViewController;
        while (currentViewController.presentedViewController) {
            if (![currentViewController.presentedViewController isKindOfClass:[UIAlertController class]] && ![currentViewController.presentedViewController isKindOfClass:[PINViewController class]]) {
                currentViewController = currentViewController.presentedViewController;
            }
            else {
                break;
            }
        }
        return currentViewController;
    }
    return nil;
}

+ (UINavigationController *)getNavigationController {
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)controller;
    }
    return nil;
}

+ (void)convertResponseToJSON:(id)response success:(void (^)(id jsonResponse))success failure:(void(^)(NSError *error))failure {
    
    NSError *jsonError;
    id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&jsonError];
    if(jsonError) {
        failure(jsonError);
    } else {
        success(jsonDictionaryOrArray);
    }
}

+ (void)convertJSONStringToDictionary:(NSString *)strResponse success:(void (^)(NSDictionary *jsonDictionary))success failure:(void(^)(NSError *error))failure {
    if (![strResponse hasValue]) {
        failure(nil);
        return;
    }
    NSError *jsonError;
    NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if(jsonError) {
        failure(jsonError);
    } else {
        success(json);
    }
}

+ (CGRect)getFrameForDynamicField:(AutoCompleteUITextField *)autocompleteTextField {
    CGRect containerFrame = [autocompleteTextField superview].frame;
    CGRect fieldFrame = CGRectMake(containerFrame.origin.x, containerFrame.origin.y + autocompleteTextField.frame.origin.y, autocompleteTextField.frame.size.width, autocompleteTextField.frame.size.height);

    return fieldFrame;
}

+ (void)resetDynamicField:(GreyBorderUITextField *)textField {
    [textField setText:@""];
    textField.field.mSelectedValue = false;
    textField.field.mValues = nil;
    textField.field.mDataList = nil;
}

+ (NSString *)getDisplayStringForValue:(NSString *)inputString {
    if ([inputString hasValue]) {
        return inputString;
    }
    return @"-";
}

+ (NSArray *)getFromDateAndToDateFromString:(NSString *)inputString {
    if ([inputString containsString:@"to"]) {
        inputString = [inputString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *separatedDates = [inputString componentsSeparatedByString:@"to"];
        if (separatedDates && [separatedDates count] == 2) {
            return separatedDates;
        }
        else {
            return nil;
        }
    }
    return nil;
}


+ (void)makeUnselected:(UIButton *)button {
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
}

+ (void)makeSelected:(UIButton *)button {
    [button setBackgroundColor:[UIColor themePrimaryColor]];
    [button.layer setBorderColor:[UIColor themePrimaryColor].CGColor];
}

+ (NSString *)getNotNilValueForString:(NSString *)inputString {
    if ([inputString hasValue]) {
        return inputString;
    }
    return @"";
}

#pragma mark - Progress Loaders

+ (void)showProgressHUD:(BOOL)show {
    if (show) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UtilityMethods getTopMostView] animated:true];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
}

+ (void)showToastWithMessage:(NSString *)message {
    // hideProgressHUD Added to solve the issue of loader not dismissing
    // if toast is shown while loader was showing
    [self hideProgressHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UtilityMethods getTopMostView] animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    // Automatically hide
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:[UtilityMethods getTopMostView] animated:true];
}


#pragma mark getting Main Thread..and background thread..
+(void)RunOnMainThread:(void (^)(void))block
{
	//Check Recieved Block Of Code whether they are running on main thread or not .if Not then Forcefully make run them on main thread
	if ([NSThread isMainThread]) {
		block();
	}else{
		dispatch_sync(dispatch_get_main_queue(), block);
	}
}

+(void)RunOnBackgroundThread:(void (^)(void))block
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}
+(void)RunOnOfflineDBThread:(void (^)(void))block
{
    @synchronized (self) {
    dispatch_sync([EGOfflineMasterSyncHelper offlineDBQueue],block);
    }
}
+(void)lostNetwork{
    [UtilityMethods hideProgressHUD];
}

#pragma mark - NFA

+ (BOOL)canNFABeCreatedForOpportunity:(EGOpportunity *)opportunity {
    return [self canNFABeCreatedForOpportunity:opportunity nfaModel:nil inMode:NFAModeCreate showMessage:false];
}


+ (BOOL)canNFABeCreatedForOpportunity:(EGOpportunity *)opportunity nfaModel:(EGNFA *)nfaModel inMode:(NFAMode) nfaMode showMessage:(BOOL) shouldShowMessage {
    
    NSString *optyNfaStatus = opportunity.nfaStatus;
    NSString *optySalesStage = opportunity.salesStageName;
    
    BOOL liveNFAFound = true;
    BOOL validSalesStage = true;
    
    if (![optyNfaStatus hasValue] || nfaMode == NFAModeUpdate) {
        liveNFAFound = false;
    }
    
    // Check against NFA model
//    if (nfaModel &&
//        [opportunity.nfaNumber hasValue] &&
//        [nfaModel.nfaRequestNumber hasValue] &&
//        [opportunity.nfaNumber caseInsensitiveCompare:nfaModel.nfaRequestNumber] != NSOrderedSame) {
//        liveNFAFound = true;
//    }
    
    // Check against NFA Status
    for (NSString *status in @[@"reject", @"expire", @"cancel"]) {
        if ([optyNfaStatus rangeOfString:status options:NSCaseInsensitiveSearch].location != NSNotFound) {
            liveNFAFound = false;
            break;
        }
    }
    
    // Check against Opportunity sales stage
    for (NSString *stage in @[@"c0", @"c3", @"lost"]) {
        if ([optySalesStage rangeOfString:stage options:NSCaseInsensitiveSearch].location != NSNotFound) {
            validSalesStage = false;
            break;
        }
    }
    
    if (liveNFAFound && shouldShowMessage) {
        NSString *erroMessage = [NSString stringWithFormat:@"The selected opportunity is already associated to a live NFA %@. Request you to select the correct opportunity id or modify the existing NFA", opportunity.nfaNumber];
        [UtilityMethods alert_ShowMessage:erroMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    else if (!validSalesStage && shouldShowMessage) {
        
        NSString *erroMessage = [NSString stringWithFormat:@"The selected opportunity is in %@ sales stage. Hence NFA cannot be created against it.", opportunity.salesStageName];
        
        if (nfaMode == NFAModeUpdate) {
            erroMessage = [NSString stringWithFormat:@"The selected opportunity is in %@ sales stage. Hence NFA cannot be updated against it.", opportunity.salesStageName];
        }
        
        [UtilityMethods alert_ShowMessage:erroMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    else if ([opportunity.invoiceCount hasValue] && [opportunity.invoiceCount integerValue] > 0 && shouldShowMessage) {
        validSalesStage = false;
        
        NSString *erroMessage = [NSString stringWithFormat:@"Invoice has been generated for the selected opportunity. Hence NFA cannot be created against it."];
        
        if (nfaMode == NFAModeUpdate) {
            erroMessage = [NSString stringWithFormat:@"Invoice has been generated for the selected opportunity. Hence NFA cannot be updated against it."];
        }
        
        [UtilityMethods alert_ShowMessage:erroMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
    
    return !liveNFAFound && validSalesStage;
    
}

#pragma mark - NSDictionary Helpers

+ (void)removeNSNullValuesFromDictionary:(NSDictionary **) dictionary {
    
    for (NSString *key in [*dictionary allKeys]) {
        if ([[*dictionary valueForKey:key] isKindOfClass:[NSNull class]]) {
            [*dictionary setValue:@"" forKey:key];
        }
    }
}

#pragma mark - Location Services

+ (BOOL) isLocationCaptureEnabled {
    
    BOOL locationAccessAllowed = false;
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            locationAccessAllowed = true;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            locationAccessAllowed = true;
            break;
        case kCLAuthorizationStatusDenied:
            locationAccessAllowed = false;
            break;
        case kCLAuthorizationStatusRestricted:
            locationAccessAllowed = false;
            break;
        case kCLAuthorizationStatusNotDetermined:
            locationAccessAllowed = false;
            break;
        default:
            locationAccessAllowed = false;
            break;
    }
    
    return locationAccessAllowed;
}

+ (void)showLocationAccessDeniedAlert {
    
    NSString *message = [NSString stringWithFormat:LOCATION_DISABLED_MSG, APP_NAME];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *openSettingsAction = [UIAlertAction actionWithTitle:OPEN_SETTINGS
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION/com.tatamotors.egurucrm"]];
                                                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:openSettingsAction];
    
    UIViewController *window = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [window presentViewController:alertController animated:true completion:nil];
}

+(NSDictionary *_Nullable)getJSONFrom:(NSString*_Nonnull)str {
   
    str = [str stringByReplacingOccurrencesOfString:@"u'" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"':" withString:@"\":"];
    str = [str stringByReplacingOccurrencesOfString:@"'," withString:@"\","];
    str = [str stringByReplacingOccurrencesOfString:@"'}" withString:@"\"}"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return dic;
}

@end

