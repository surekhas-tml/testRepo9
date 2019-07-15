//
//  OTPViewController.m
//  e-guru
//
//  Created by Shashi on 16/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "OTPViewController.h"
#import "ActivationCodeTextField.h"

@interface OTPViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ActivationCodeTextField *textField;

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger numDigits = 6;
    
    ActivationCodeTextField* textField = [ActivationCodeTextField new];
    textField.maxCodeLength = numDigits;
    textField.customPlaceholder = @"_";
    textField.delegate = self;
    [textField setTextColor:[UIColor blackColor]];
    self.textField = textField;
    
    [self.view addSubview:textField];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* acceptableCharacters = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
