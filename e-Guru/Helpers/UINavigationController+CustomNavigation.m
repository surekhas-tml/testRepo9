//
//  UINavigationController+CustomNavigation.m
//  e-guru
//
//  Created by Apple on 04/04/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "UINavigationController+CustomNavigation.h"
#import "CreateOpportunityViewController.h"
#import "MandatoryFieldsViewController.h"
@implementation UINavigationController (CustomNavigation)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topViewController = self.topViewController;
    NSLog(@"%@",topViewController.description);
   __block BOOL pop = false;
    
    if(item == self.topViewController.navigationItem && [topViewController isKindOfClass:[CreateOpportunityViewController class]] ){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Do you really want to leave this page?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pop = true;
            [self popViewControllerAnimated:YES];
//            return YES;
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pop = FALSE;
        }];
        [alert addAction:cancel2];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
        return pop;
    }
    else   if(item == self.topViewController.navigationItem ){
        [self popViewControllerAnimated:YES];}    return YES;
}
@end
