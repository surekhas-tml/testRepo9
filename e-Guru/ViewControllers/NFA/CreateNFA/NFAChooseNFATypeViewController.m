//
//  NFAChooseNFATypeViewController.m
//  e-guru
//
//  Created by admin on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAChooseNFATypeViewController.h"

#define NFA_TYPE_ADDITIONAL_SUPPORT @"Additional Support"

@interface NFAChooseNFATypeViewController ()

@end

@implementation NFAChooseNFATypeViewController

#pragma mark - UI Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self addGestureToDropDownFields];
    if (self.currentNFAMode == NFAModeUpdate) {
        [self bindDataToFieldsFromNFAModel];
    }
    else {
        [self loadChooseNFAType];
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:@""];
    }

}

- (NFATypeDetailsModel *)nfaTypeDetails {
    if (!_nfaTypeDetails) {
        _nfaTypeDetails = [[NFATypeDetailsModel alloc] init];
    }
    return _nfaTypeDetails;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) loadChooseNFAType{
    self.chooseNFATypeTextField.enabled = false;
    [self.chooseNFATypeTextField setText:NFA_TYPE_ADDITIONAL_SUPPORT];
    
    [self.nfaRequestDateLabel setText:self.nfaTypeDetails.nfaRequestDate];
    [self.spendCategoryLabel setText:self.nfaTypeDetails.spendCategory];
    [self.categorySubTypeLabel setText:self.nfaTypeDetails.categorySubType];
    [self.spendLabel setText:self.nfaTypeDetails.spend];
}

- (DropDownTextField *)nfaTypeDropDownTextField {
    if (!_chooseNFATypeTextField.field) {
        _chooseNFATypeTextField.field = [[Field alloc] init];
    }
    return _chooseNFATypeTextField;
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.chooseNFATypeTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.chooseNFATypeTextField) {
                    //[self showPositionDropDown];
                    [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"Additional Support", nil]] andModelData:[NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"Additional Support", nil]]];
                }
            }
        }
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    NSLog(@"%ld",(long)textField.tag);
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)bindDataToNFAModel {
    if (self.nfaModel) {
        self.nfaModel.nfaType = NFA_TYPE_ADDITIONAL_SUPPORT;
        self.nfaModel.monthDate = self.nfaRequestDateLabel.text;
        self.nfaModel.spendCategory = self.spendCategoryLabel.text;
        self.nfaModel.categorySubType = self.categorySubTypeLabel.text;
        self.nfaModel.spend = self.spendLabel.text;
    }
}

- (void)bindDataToFieldsFromNFAModel {
    
    if (self.nfaModel) {
        [self.chooseNFATypeTextField setText:NFA_TYPE_ADDITIONAL_SUPPORT];
        [self.nfaRequestDateLabel setText:[self getLocalDateStringFromUTCDate:self.nfaModel.monthDate]];
        [self.spendCategoryLabel setText:self.nfaModel.spendCategory];
        [self.categorySubTypeLabel setText:self.nfaModel.categorySubType];
        [self.spendLabel setText:self.nfaModel.spend];
    }
}

- (NSString *)getLocalDateStringFromUTCDate:(NSString *)strUTCDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ]; //// here set format of date which is in your
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString: strUTCDate]; // here you can fetch date from string with define format
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:dateFormatddMMyyyy];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:date]; //here convert date in NSString
    return convertedString;
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        self.searchResultView.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)nextButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chooseNFATypeViewControllerNextButtonCliked)]) {
        [self bindDataToNFAModel];
        [self.delegate chooseNFATypeViewControllerNextButtonCliked];
    }
}

@end
