//
//  UIResponder+UIResponder_CrashReport.m
//  e-Guru
//
//  Created by Juili on 10/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "UIResponder+UIResponder_CrashReport.h"
@implementation UIResponder (UIResponder_CrashReport)

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"Console.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"crashConsole.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    
    NSString * trace = [[exception callStackSymbols] description];
    [trace writeToFile:crashLogPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        // Internal error reporting
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Crashed"];
    
    
    //-------------GoogleAnalytics---------------
//    NSString *eName     =   (NSString *)exception.name;
//    NSString *eReson    =   exception.reason;
//    NSString *userInfo  =   [exception.userInfo description];
//    NSString *Excepptioninfo = [NSString stringWithFormat:@"Name : %@ Resone : %@ UserInfo: %@",eName,eReson,userInfo];
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:[[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"]];
//    [tracker send:[[GAIDictionaryBuilder createExceptionWithDescription:Excepptioninfo withFatal:nil] build]];
//    [tracker set:kGAIScreenName value:nil];
    //-------------GoogleAnalytics---------------

    
}
- (NSString *)readPlist
{
    NSString *crashed = [[NSUserDefaults standardUserDefaults] objectForKey:@"Crashed"];
    return crashed;
}

- (NSString *)readPlistAppname
{
    NSString *appname = [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"];

    return appname;
}

- (void)writeToPlist:(NSString *)value
{
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"Crashed"];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)sendCrashReport:(UIWindow *)window toEmailID:(NSString *)supportEmailID{

    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:supportEmailID];
    // Attach the Crash Log..
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"Console.log"];
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"crashConsole.log"];
    
    
    //Attachment
    NSData *myData = [NSData dataWithContentsOfFile:logPath];
    // email body text
    
    NSString * headder = [NSString stringWithFormat:
                          @"Application CRASH \n\n--------------------------------------------------------------------------\n\n Please assign the incident to AM-Mobility \n\n Error in %@ iOS Application on Date : %@ \n\n PFB Crash log File \n\n Regards, \n Username :%@ \n ContactNumer:%@ \n Org:%@ \n\n\n\n ------------------------------------- Crash log ------------------------------------- \n\n\n",
                          [self readPlistAppname],
                          [[NSDate date] description],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"contactID"],
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"OrgID"]];
    
    NSString * crashBody = [[NSString stringWithContentsOfFile:
                             crashLogPath encoding:
                             NSUTF8StringEncoding error:
                             nil] stringByAppendingString:
                            [NSString stringWithFormat:
                             @"\n\n ------------------------------------- ConsoleLog ------------------------------------- \n\n %@ \n -------------------------------------------------------------------------- \n",
                             [NSString stringWithContentsOfFile:
                              logPath encoding:
                              NSUTF8StringEncoding error:
                              nil]]];
    
    NSString * emailBody = [headder stringByAppendingString:crashBody];
    
    [self writeToPlist:@"NO"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:crashLogPath error:nil];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setToRecipients:toRecipients];
        [picker setSubject:@"Crash Log"];
        [picker setMessageBody:emailBody isHTML:NO];
        [picker addAttachmentData:myData mimeType:@"Text/XML" fileName:@"Console.log"];
        [window.rootViewController presentViewController:picker animated:YES completion:NULL];
    
}
-(void)sendCrashReportConfirmation:(UIWindow *)window toID:(NSString *)emailID{
    
    if ([[self readPlist] isEqualToString:@"YES"] ) {
        [self writeToPlist:@"NO"];
        UIAlertController *alertMessage = [UIAlertController
                                           alertControllerWithTitle:@"Crash Report"
                                           message:@"Application crashed on previous launch. Do you want to send crash logs to support team ?"
                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       if ([MFMailComposeViewController canSendMail]) {
                                           [self sendCrashReport:window toEmailID:emailID];
                                       }
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        [alertMessage addAction:cancelAction];
        [alertMessage addAction:okAction];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
            [window.rootViewController presentViewController:alertMessage animated:YES completion:nil];
        });
    }
}

-(void)setupGoogleAnalyticsWithTrackingID:(NSString *)trackingID{
    // Google Analytics Code
    // Configure tracker from GoogleService-Info.plist.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // report uncaught exceptions
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance]logger]setLogLevel:kGAILogLevelNone];
    id<GAITracker>tracker = [[GAI sharedInstance]trackerWithTrackingId:trackingID];
    [GAI sharedInstance].defaultTracker = tracker;
}
@end
