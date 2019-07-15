//
//  UtilityMethods.h
//  CRM_APP
//
//  Created by Juili on 24/05/16.
//  Copyright © 2016 TataTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Constant.h"
#import "MBProgressHUD.h"
#import "UIColor+eGuruColorScheme.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "WebServiceConstants.h"
#import "AutoCompleteUITextField.h"
#import "GreyBorderUITextField.h"
#import "NFAUIHelper.h"

@interface UtilityMethods : NSObject

+ (UtilityMethods *_Nonnull)sharedobject;

+(void) resetDraftStatus;

+ (NSString *_Nonnull)uuid;

+(void)navigationBarSetupForController:(UIViewController __weak * _Nonnull)uiviewController;

+ (NSString *_Nonnull)errorMessageForErrorCode:(NSInteger)errorCode;

+(void)alert_ShowMessage:(NSString*_Nullable)message withTitle:(NSString *_Nonnull)title andOKAction:(void (^_Nullable)(void))okBlock;

+(void)alert_ShowMessage:(NSString*_Nullable)message withTitle:(NSString *_Nonnull)title onController:(UIViewController *_Nullable)viewController andOKAction:(void (^_Nullable)(void))okBlock;

+(void)alert_ShowMessagewithreportissue:(NSString*_Nullable)message withTitle:(NSString *_Nonnull)title andOKAction:(void (^_Nullable)(void))okBlock andReportIssueAction:(void (^_Nullable)(void))reportBlock;

+ ( void )alert_ShowMessagewithreportissue:(NSString*_Nullable)message withTitle:(NSString *_Nonnull)title onController:(UIViewController *_Nullable)viewController andOKAction:(void (^_Nullable)(void))okBlock andReportIssueAction:(void (^_Nullable)(void))reportBlock;

-(void)okButtonPressed;

+(void)showAlertWithMessage:(NSString *_Nullable)message andTitle:(NSString *_Nonnull)title onViewController:(UIViewController *_Nonnull)currentViewControler;
+(void)alert_showMessage:(NSString*_Nullable)message withTitle:(NSString *_Nonnull)title andOKAction:(void (^_Nullable)(void))okBlock andNoAction:(void (^_Nullable)(void))noBlock;

+ ( void )alert_ShowMessagewithCreate:(NSString*)message withTitle:(NSString *)title andOKAction:(void (^)(void))okBlock andCreateContactAction:(void (^)(void))createContactBlock;

-(void)reportIssueMethod;
+(void)clearAllTextFiledsInView:(UIView *_Nonnull)view;
+(BOOL)isAnyTextFieldHasUpdated:(UIView *_Nonnull)fromView;
+ (BOOL)canNFABeCreatedForOpportunity:(EGOpportunity *)opportunity nfaModel:(EGNFA *)nfaModel inMode:(NFAMode) nfaMode showMessage:(BOOL) shouldShowMessage;
+(BOOL)canNFABeCreatedForOpportunity:(EGOpportunity *)opportunity nfaModel:(EGNFA *)nfaModel inMode:(NFAMode) nfaMode showMessage:(BOOL) shouldShowMessage ;
+(NSString *_Nullable)getErrorMessage:(NSError *_Nullable)err;
+(void)setRedBoxBorder:(UITextField *_Nonnull)textField;
+(void)setGreyBoxBorder:(UITextField *_Nonnull)textField;
+(void)setBlackBoxBorder:(UITextField *_Nullable)textField;
+(void)setLeftPadding:(UITextField *)textField;
+ (void)showAlertMessageOnWindowWithMessage:(NSString *_Nullable)message handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;
+ (void)convertResponseToJSON:(id _Nullable)response success:(void (^ _Nullable)(id _Nullable jsonResponse))success failure:(void(^_Nullable)(NSError * _Nullable error))failure;
+ (CGRect)getFrameForDynamicField:(AutoCompleteUITextField * _Nullable)autocompleteTextField;
+ (void)resetDynamicField:(GreyBorderUITextField * _Nullable)textField;
+ (void)convertJSONStringToDictionary:(NSString * _Nullable)strResponse success:(void (^ _Nullable)(NSDictionary * _Nullable jsonDictionary))success failure:(void(^ _Nullable)(NSError * _Nullable error))failure;
+ (NSString * _Nonnull)getDisplayStringForValue:(NSString *_Nullable)inputString;
+ (NSString * _Nonnull)getNotNilValueForString:(NSString *_Nullable)inputString;
+ (void)showErroMessageFromAPICall:(NSError *_Nonnull)error  defaultMessage:(NSString *_Nonnull)defaultMessage;
+ (NSString *_Nullable)extractMessageFromError:(NSError *_Nonnull)error;
+(void)reportIssueMethodWithErrorDiscription:(NSString *)errorDiscription;

#pragma mark - Device Details

+ (nullable NSString *)getVendorID;

#pragma mark - App Details

+ (nullable NSString *)getAppVersion;
+ (NSString *_Nonnull)getAppBundleID;

#pragma mark - View and ViewController Methods

+ (nullable UIView *)getTopMostView;
+ (nullable UIViewController *)getCurrentViewController;
+ (NSArray *_Nullable)getFromDateAndToDateFromString:(NSString *_Nullable)inputString;
+ (void)makeUnselected:(UIButton *_Nullable)button;
+ (void)makeSelected:(UIButton *_Nullable)button;
+ (void)removeNSNullValuesFromDictionary:(NSDictionary **) dictionary;
+ (BOOL)canNFABeCreatedForOpportunity:(EGOpportunity *)opportunity;
#pragma mark - Progress Loaders

+ (void)showProgressHUD:(BOOL)show;
+ (void)showToastWithMessage:(NSString *_Nullable)message;
+ (void)hideProgressHUD;

#pragma mark getting Main Thread..and background thread..
+(void)RunOnMainThread:(void (^)(void))block;
+(void)RunOnBackgroundThread:(void (^)(void))block;
+(void)RunOnOfflineDBThread:(void (^)(void))block;
+(void)openHomeScreen;
+(void)lostNetwork;

#pragma mark - Location Sevices
+ (BOOL)isLocationCaptureEnabled;
+ (void)showLocationAccessDeniedAlert;

+(NSDictionary *_Nullable)getJSONFrom:(NSString*_Nonnull)str;
@end

