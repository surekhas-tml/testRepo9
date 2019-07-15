//
//  DealerMarginAndRetentionView.m
//  e-guru
//
//  Created by admin on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "DealerMarginAndRetentionView.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation DealerMarginAndRetentionView

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"DealerMarginAndRetentionView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    self.sectionType = NFASectionDealerMarginAndRetention;
}

- (NFADealerMarginAndRetention *)nfaDealerAndCustomerDetails {
    if (!_nfaDealerMarginAndRetention) {
        _nfaDealerMarginAndRetention = [[NFADealerMarginAndRetention alloc] init];
    }
    return _nfaDealerMarginAndRetention;
}

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaDealerMarginAndRetention = model;
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
    [UtilityMethods setRedBoxBorder:self.dealerMarginTextField];
    [UtilityMethods setRedBoxBorder:self.retentionTextField];
}

- (void)bindDataToFieldsFromModel:(NFADealerMarginAndRetention *)dealerMarginAndRetention {
    if (!dealerMarginAndRetention) {
        return;
    }
    
    self.nfaDealerMarginAndRetention = dealerMarginAndRetention;
    
    [self.dealerMarginTextField setText:dealerMarginAndRetention.dealerMargin];
    [self.retentionTextField setText:dealerMarginAndRetention.retention];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.dealerMarginTextField.text hasValue] &&
        [self.retentionTextField.text hasValue]) {
        mandatoryFieldsFilled = true;
    }
    
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

- (void)resetFields {
    [self.dealerMarginTextField setText:@""];
    [self.retentionTextField setText:@""];
    
    self.nfaDealerMarginAndRetention.dealerMargin = @"";
    self.nfaDealerMarginAndRetention.retention = @"";
    
    [self checkIfMandatoryFieldsAreFilled];
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.dealerMarginTextField) {
        self.nfaDealerMarginAndRetention.dealerMargin = self.dealerMarginTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.retentionTextField) {
        self.nfaDealerMarginAndRetention.retention = self.retentionTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.dealerMarginTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }else if (self.retentionTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }
    return true;
}

@end
