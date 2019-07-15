//
//  FinancierDetailsView.m
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "FinancierDetailsView.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation FinancierDetailsView

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"FinancierDetailsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    self.sectionType = NFASectionFinancierDetails;
}

- (NFAFinancierDetails *)nfaDealerAndCustomerDetails {
    if (!_nfaFinancierDetails) {
        _nfaFinancierDetails = [[NFAFinancierDetails alloc] init];
    }
    return _nfaFinancierDetails;
}

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaFinancierDetails = model;
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
}

- (void)bindDataToFieldsFromModel:(NFAFinancierDetails *)financierDetails {
    if (!financierDetails) {
        return;
    }
    [self.financierTextField setText:financierDetails.financier];
    [self.ltvField setText:financierDetails.ltvField];
    [self.finSubvnTextField setText:financierDetails.finSubvn];
}

- (void)resetFields {
    [self.financierTextField setText:@""];
    [self.ltvField setText:@""];
    [self.finSubvnTextField setText:@""];
    
    self.nfaFinancierDetails.financier = @"";
    self.nfaFinancierDetails.ltvField = @"";
    self.nfaFinancierDetails.finSubvn = @"";
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.financierTextField) {
        self.nfaFinancierDetails.financier = self.financierTextField.text;
    }
    else if (textField == self.ltvField) {
        if ([self.ltvField.text integerValue] > 100) {
            self.ltvField.text = @"";
            [UtilityMethods alert_ShowMessage:@"LTV can\'t be greater then 100." withTitle:APP_NAME andOKAction:^{
                
            }];
        }
        self.nfaFinancierDetails.ltvField = self.ltvField.text;
    }
    else if (textField == self.finSubvnTextField) {
        self.nfaFinancierDetails.finSubvn = self.finSubvnTextField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.ltvField == textField) {
        if (length > 3)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }else if (self.finSubvnTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }
    return true;
}
@end
