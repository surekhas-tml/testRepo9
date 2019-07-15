//
//  PINViewController.h
//  CRM_APP
//
//  Created by Admin on 03/08/16.
//  Copyright © 2016 TataTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINViewController : UIViewController

@property (nonatomic, assign) BOOL calledForSettingPIN;

@property (nonatomic, weak) IBOutlet UIButton *buttonZero;
@property (nonatomic, weak) IBOutlet UIButton *buttonOne;
@property (nonatomic, weak) IBOutlet UIButton *buttonTwo;
@property (nonatomic, weak) IBOutlet UIButton *buttonThree;
@property (nonatomic, weak) IBOutlet UIButton *buttonFour;
@property (nonatomic, weak) IBOutlet UIButton *buttonFive;
@property (nonatomic, weak) IBOutlet UIButton *buttonSix;
@property (nonatomic, weak) IBOutlet UIButton *buttonSeven;
@property (nonatomic, weak) IBOutlet UIButton *buttonEight;
@property (nonatomic, weak) IBOutlet UIButton *buttonNine;
@property (nonatomic, strong) IBOutlet UITextField *pinTextField;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelIncorrectPin;

@end
