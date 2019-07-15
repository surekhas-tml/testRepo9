//
//  LoginViewController.h
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UserDetails.h"
#import "UtilityMethods.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginPerformed;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *loginBGImage;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *versionAndBuildInfoLAbel;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) id <LoginViewControllerDelegate> delegate;

@end
