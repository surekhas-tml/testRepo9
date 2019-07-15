//
//  UIResponder+UIResponder_CrashReport.h
//  e-Guru
//
//  Created by Juili on 10/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
//#import <Google/Analytics.h>
//#import <GAI.h>

@interface UIResponder (UIResponder_CrashReport)<MFMailComposeViewControllerDelegate>
-(void)setupGoogleAnalyticsWithTrackingID:(NSString *)trackingID;
-(void)sendCrashReportConfirmation:(UIWindow *)window toID:(NSString *)emailID;
void uncaughtExceptionHandler(NSException *exception);
@end
