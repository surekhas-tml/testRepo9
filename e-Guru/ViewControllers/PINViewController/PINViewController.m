//
//  PINViewController.m
//  CRM_APP
//
//  Created by Admin on 03/08/16.
//  Copyright © 2016 TataTechnologies. All rights reserved.
//

#import "PINViewController.h"
#import "MBProgressHUD.h"
#import "SSKeychain.h"
#import "UtilityMethods.h"
#import "AppRepo.h"
#import "EGOfflineMasterSyncAlertsHelper.h"

#define SERVICE_NAME @"UserPIN"
#define ACCOUNT_NAME @"com.tatamotors.egurucrm"

@interface PINViewController ()

@property (nonatomic, strong) NSString *strPin;
@property (nonatomic, strong) NSString *strFirstPin;
@property (nonatomic, strong) NSString *strSecondPin;
@property (nonatomic, assign) NSInteger characterCount;
@property (nonatomic, assign) NSInteger incorrectAttempt;

@property (nonatomic, assign) BOOL isConfirmPINStage;

@end

@implementation PINViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the UI components
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.characterCount = 0;
    self.incorrectAttempt = 0;
    self.strPin = @"";
    if (self.calledForSettingPIN) {
        [self.instructionLabel setText:@"Please enter a four digit PIN"];
    }
    else {
        [self.instructionLabel setText:@"Please enter your four digit PIN"];
    }
    
    UIImage *buttonBGImage = [self imageWithColor:[UIColor colorWithRed:0.0f green:119.0f/255.0f blue:181.0f/255.0f alpha:1.0f]];
    
    [self makeButtonRound:self.buttonOne];
    [self.buttonOne setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonTwo];
    [self.buttonTwo setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonThree];
    [self.buttonThree setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonFour];
    [self.buttonFour setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonFive];
    [self.buttonFive setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonSix];
    [self.buttonSix setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonSeven];
    [self.buttonSeven setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonEight];
    [self.buttonEight setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonNine];
    [self.buttonNine setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
    [self makeButtonRound:self.buttonZero];
    [self.buttonZero setBackgroundImage:buttonBGImage forState:UIControlStateHighlighted];
}

- (void)makeButtonRound:(UIButton *)button {
    
    button.layer.cornerRadius = 30.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    button.clipsToBounds = true;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)numberSelected:(UIButton *)sender {
    
    if (self.characterCount < 4) {
        NSString *selectedNumber = sender.titleLabel.text;
        self.strPin = [NSString stringWithFormat:@"%@", [self.strPin stringByAppendingString:selectedNumber]];
        [self.pinTextField setText:self.strPin];
        self.characterCount ++;
    }
    
    if (self.characterCount == 4) {
        
        if (self.calledForSettingPIN) {
            
            if (self.isConfirmPINStage) {
                self.strSecondPin = self.strPin;
                
                if ([self.strFirstPin isEqualToString:self.strSecondPin]) {
                    [self savePinInKeychain:self.strSecondPin];
                    [self resetData];
                }
                else {
                    [self showAlertWithMessage:@"Confirm PIN doesn't match with enterd PIN." andTitle:@"Error"];
                    [self prepareViewForConfirmPINStage];
                }
            }
            else {
                self.strFirstPin = self.strPin;
                self.isConfirmPINStage = true;
                [self prepareViewForConfirmPINStage];
            }
        }
        else {
            
            NSError *error;
            NSString *savedPIN = [SSKeychain passwordForService:SERVICE_NAME account:ACCOUNT_NAME error:&error];
            if (!error) {
                
                if ([savedPIN isEqualToString:self.strPin]) {
                    [self resetData];
                    [self closeScreen];
                }
                else {
                    
                    [self resetData];
                    self.incorrectAttempt ++;
                    [self.labelIncorrectPin setHidden:false];
                    [self.labelIncorrectPin setText:[NSString stringWithFormat:@"Incorrect PIN. Attempt %ld out of 5", (long)self.incorrectAttempt]];
                    
                    if (self.incorrectAttempt >= 5) {
                        self.incorrectAttempt = 0;
                        [self showIncorrectPINLimitReachedMessage];
                    }
                    else {
                        
                        [self showAlertWithMessage:@"Incorrect PIN. Please try again." andTitle:@"Error"];
                    }
                }
            }
        }
        
    }
}

- (IBAction)clearCharacter:(UIButton *)sender {
    
    if (self.characterCount > 0) {
        self.strPin = [NSString stringWithFormat:@"%@", [self.strPin substringToIndex:[self.strPin length] - 1]];
        [self.pinTextField setText:self.strPin];
        self.characterCount --;
    }
}

- (void)closeScreen {
    
    [self dismissPinScreen];
    if (self.calledForSettingPIN) {
        [[AppRepo sharedRepo] showHomeScreen];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.productAppOpty){
        [appDelegate matchLoginWithProductApp];
    }
}

- (void)dismissPinScreen {
    [self dismissViewControllerAnimated:true completion:nil];
    [[EGOfflineMasterSyncAlertsHelper sharedInstance] pinScreenHasBeenDismissed];
    [[AppRepo sharedRepo] pinScreenDismissed];
}

#pragma mark - Private Methods -

- (void)prepareViewForConfirmPINStage {
    [self resetData];
    [self.instructionLabel setText:@"Please confirm your four digit PIN"];
}

- (void)resetData {
    self.characterCount = 0;
    self.strPin = @"";
    [self.pinTextField setText:@""];
}

- (void)savePinInKeychain:(NSString *)strPin {
    
    NSError *error;
    if ([SSKeychain setPassword:strPin forService:SERVICE_NAME account:ACCOUNT_NAME error:&error]) {
        [self closeScreen];
    }
    else {
        NSLog(@"%@", error.description);
    }
}

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)showIncorrectPINLimitReachedMessage {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You have reached the maximum limit of incorrect PIN attempts allowed. You will now be logged out of the application." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
        [self dismissPinScreen];
        [self showLoginScreen];
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)showLoginScreen {
    [[AppRepo sharedRepo] logoutUser];
}

@end
