//
//  CompetitionDetails.m
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "CompetitionDetailsView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation CompetitionDetailsView{
    AppDelegate *appDelegate;
    NSMutableArray *competitorList;
}

#pragma mark - UI Initialization
- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"CompetitionDetailsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    [self addGestureToDropDownFields];
    self.sectionType = NFASectionCompetitionDetails;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NFACompetitionDetails *)nfaDealerAndCustomerDetails {
    if (!_nfaCompetitionDetails) {
        _nfaCompetitionDetails = [[NFACompetitionDetails alloc] init];
    }
    return _nfaCompetitionDetails;
}

- (DropDownTextField *)vehicleRegistrationStateDropDownTextField {
    if (!_competitorTextField.field) {
        _competitorTextField.field = [[Field alloc] init];
    }
    return _competitorTextField;
}

#pragma mark - Private Methods
- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaCompetitionDetails = model;
    [self bindDataToFieldsFromModel:model];
    
    switch (mode) {
        case NFAModeCreate:
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeUpdate:
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeDisplay:
            [self setUserInteractionEnabled:false];
            break;
    }
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.competitorTextField];
    [UtilityMethods setRedBoxBorder:self.modelTextField];
    [UtilityMethods setRedBoxBorder:self.exShowroomTextField];
    [UtilityMethods setRedBoxBorder:self.discountTextField];
}

//- (void)checkIfMandatoryFieldsAreFilled {
//    
//    BOOL mandatoryFieldsFilled = false;
//    
//    if ([self.competitorTextField.text hasValue] &&
//        [self.modelTextField.text hasValue] &&
//        [self.exShowroomTextField.text hasValue] &&
//        [self.discountTextField.text hasValue]) {
//        mandatoryFieldsFilled = true;
//    }
//    
//    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
//}

- (void)bindDataToFieldsFromModel:(NFACompetitionDetails *)competitionDetails {
    if (!competitionDetails) {
        return;
    }
    [self.competitorTextField setText:competitionDetails.competitor];
    [self.modelTextField setText:competitionDetails.model];
    [self.exShowroomTextField setText:competitionDetails.exShowroom];
    [self.discountTextField setText:competitionDetails.discount];
    [self.landingPriceTextField setText:competitionDetails.landingPrice];
}

- (void)calculateLandingPrice {
    
    if (![self.exShowroomTextField.text hasValue] && ![self.discountTextField.text hasValue]) {
        [self.landingPriceTextField setText:@""];
        self.nfaCompetitionDetails.landingPrice = @"";
        return;
    }
    
    NSInteger landingPrice = 0;
    NSInteger exShowRoomPrice = [self.exShowroomTextField.text integerValue];
    NSInteger discount = [self.discountTextField.text integerValue];
    
    if (discount <= exShowRoomPrice) {
        landingPrice = exShowRoomPrice - discount;
        [self.landingPriceTextField setText:[NSString stringWithFormat:@"%ld", (long)landingPrice]];
        self.nfaCompetitionDetails.landingPrice = self.landingPriceTextField.text;
    }
    else {
        
        [UtilityMethods alert_ShowMessage:@""
                                withTitle:APP_NAME andOKAction:^{
                                    
                                    self.discountTextField.text = @"";
                                    [self.landingPriceTextField setText:self.exShowroomTextField.text];
                                    
                                    self.nfaCompetitionDetails.discount = @"";
                                    self.nfaCompetitionDetails.landingPrice = self.landingPriceTextField.text;
                                }];
    }
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.competitorTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[DropDownTextField class]]) {
            DropDownTextField *textField = (DropDownTextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.competitorTextField) {
                    
                    [self getCompetitorList:textField];
                }
            }
        }
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)resetFields {
    [self.competitorTextField setText:@""];
    [self.modelTextField setText:@""];
    [self.exShowroomTextField setText:@""];
    [self.discountTextField setText:@""];
    [self.landingPriceTextField setText:@""];
    
    self.nfaCompetitionDetails.competitor = @"";
    self.nfaCompetitionDetails.model = @"";
    self.nfaCompetitionDetails.exShowroom = @"";
    self.nfaCompetitionDetails.discount = @"";
    self.nfaCompetitionDetails.landingPrice = @"";
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.competitorTextField) {
        self.nfaCompetitionDetails.competitor = self.competitorTextField.text;
    }
    else if (textField == self.modelTextField) {
        self.nfaCompetitionDetails.model = self.modelTextField.text;
    }
    else if (textField == self.exShowroomTextField) {
        [self calculateLandingPrice];
        self.nfaCompetitionDetails.exShowroom = self.exShowroomTextField.text;
    }
    else if (textField == self.discountTextField) {
        [self calculateLandingPrice];
        self.nfaCompetitionDetails.discount = self.discountTextField.text;
    }
    else if (textField == self.landingPriceTextField) {
        self.nfaCompetitionDetails.landingPrice = self.landingPriceTextField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.exShowroomTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }else if (self.discountTextField == textField){
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }else if (self.landingPriceTextField == textField){
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    return true;
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        self.competitorTextField.text = selectedValue;
        self.nfaCompetitionDetails.competitor = self.competitorTextField.text;
        //[self checkIfMandatoryFieldsAreFilled];
    }
}

#pragma mark - API Calls

- (void)getCompetitorList:(DropDownTextField *)textField {
    
    if (competitorList && [competitorList count] > 0) {
        [self showPopOver:textField withDataArray:competitorList andModelData:competitorList];
        return;
    }
    
    [[EGRKWebserviceRepository sharedRepository] getCompetitorListSuccessAction:^(NSArray *responseArray) {
        if (responseArray && [responseArray count] > 0) {
            competitorList = [responseArray mutableCopy];
            [self showPopOver:textField withDataArray:competitorList andModelData:competitorList];
        }
    } andFailuerAction:^(NSError *error) {
        
    }];
    
}

@end
