//
//  ReportViewController.m
//  e-guru
//
//  Created by Devendra on 24/01/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "ReportViewController.h"
#import "Constant.h"
#import "UtilityMethods.h"
#import "AppRepo.h"
#import "MBProgressHUD.h"

@interface ReportViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *report_webview;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setTitle:REPORT];

    [self callReportAPI];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Report];

    [UtilityMethods navigationBarSetupForController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)callReportAPI {
    
    NSURL * url = [NSURL URLWithString:@"https://analytics.user.tatamotors.com/tableau/obiee_trusted.php"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    
    //@"MANJESH1002850"
    NSString *postString = [NSString stringWithFormat:@"username=%@&site_name=CVBUTML",[[AppRepo sharedRepo] getLoggedInUser].userName];
    req.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:true];
            });

            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse*)response;
            
            if (urlResponse.statusCode != 200) {
            
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Something went wrong" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            
            NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *token = [responseString stringByReplacingOccurrencesOfString:@"\r\n\r\n\r\n\r\n\r\n" withString:@""];
            NSString *finalUrl = [NSString stringWithFormat:@"%@%@%@",@"https://infoviz.tatamotors.com/trusted/",token,@"/t/CVBUTML/views/DealerSalesExecutiveDashboard/DSESummaryDashboard?:embed=y&:showShareOptions=true&:display_count=no&:showVizHome=no"];
            NSLog(@"%@",responseString);
            NSLog(@"%@",finalUrl);
            NSURL *newUrl = [NSURL URLWithString:finalUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.report_webview loadRequest: [NSURLRequest requestWithURL:newUrl]];

            });

        }
    }];
    [task resume];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:true];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view animated:true];
//    });

}

@end
