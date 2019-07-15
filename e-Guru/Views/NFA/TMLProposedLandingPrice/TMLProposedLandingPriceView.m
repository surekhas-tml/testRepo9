//
//  TMLProposedLandingPriceView.m
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "TMLProposedLandingPriceView.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation TMLProposedLandingPriceView

#pragma mark - UI Initialization

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"TMLProposedLandingPriceView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    self.sectionType = NFASectionTMLProposedLandingPrice;
}

- (NFATMLProposedLandingPrice *)nfaDealerAndCustomerDetails {
    if (_nfaTMLProposedLandingPrice) {
        _nfaTMLProposedLandingPrice = [[NFATMLProposedLandingPrice alloc] init];
    }
    return _nfaTMLProposedLandingPrice;
}

#pragma mark - Private Methods

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaTMLProposedLandingPrice = model;
    [self bindDataToFieldsFromModel:model];
    
    switch (mode) {
        case NFAModeCreate:
            [self markMandatoryFields];
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
    [UtilityMethods setRedBoxBorder:self.exShowRoomTextField];
    [UtilityMethods setRedBoxBorder:self.discountTextField];
}

- (void)bindDataToFieldsFromModel:(NFATMLProposedLandingPrice *)tmlProposedLandingPrice {
    if (!tmlProposedLandingPrice) {
        return;
    }
    [self.exShowRoomTextField setText:tmlProposedLandingPrice.exShowRoom];
    [self.discountTextField setText:tmlProposedLandingPrice.discount];
    [self.landingPriceTextField setText:tmlProposedLandingPrice.landingPrice];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.exShowRoomTextField.text hasValue] &&
        [self.discountTextField.text hasValue]) {
        mandatoryFieldsFilled = true;
    }
    
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

- (void)resetFields {
    [self.exShowRoomTextField setText:@""];
    [self.discountTextField setText:@""];
    [self.landingPriceTextField setText:@""];
    
    self.nfaTMLProposedLandingPrice.exShowRoom = @"";
    self.nfaTMLProposedLandingPrice.discount = @"";
    self.nfaTMLProposedLandingPrice.landingPrice = @"";
    
    [self checkIfMandatoryFieldsAreFilled];
}

- (void)calculateLandingPrice {
    
    if (![self.exShowRoomTextField.text hasValue] && ![self.discountTextField.text hasValue]) {
        [self.landingPriceTextField setText:@""];
        self.nfaTMLProposedLandingPrice.landingPrice = @"";
        return;
    }
    
    NSInteger landingPrice = 0;
    NSInteger exShowRoomPrice = [self.exShowRoomTextField.text integerValue];
    NSInteger discount = [self.discountTextField.text integerValue];
    
    if (discount <= exShowRoomPrice) {
        landingPrice = exShowRoomPrice - discount;
        [self.landingPriceTextField setText:[NSString stringWithFormat:@"%ld", (long)landingPrice]];
        self.nfaTMLProposedLandingPrice.landingPrice = self.landingPriceTextField.text;
    }
    else {
        
        [UtilityMethods alert_ShowMessage:HIGHER_DISCOUNT_ERROR_MESSAGE
                                withTitle:APP_NAME andOKAction:^{
                                    
                                    self.discountTextField.text = @"";
                                    [self.landingPriceTextField setText:self.exShowRoomTextField.text];
                                    
                                    self.nfaTMLProposedLandingPrice.discount = @"";
                                    self.nfaTMLProposedLandingPrice.landingPrice = self.landingPriceTextField.text;
                                }];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.exShowRoomTextField) {
        [self calculateLandingPrice];
        self.nfaTMLProposedLandingPrice.exShowRoom = self.exShowRoomTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.discountTextField) {
        [self calculateLandingPrice];
        self.nfaTMLProposedLandingPrice.discount = self.discountTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.landingPriceTextField) {
        self.nfaTMLProposedLandingPrice.landingPrice = self.landingPriceTextField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.exShowRoomTextField == textField) {
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

@end
