//
//  SchemeDetailsView.m
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "SchemeDetailsView.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation SchemeDetailsView

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"SchemeDetailsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    self.sectionType = NFASectionSchemeDetails;
}

- (NFASchemeDetails *)nfaDealerAndCustomerDetails {
    if (_nfaSchemeDetails) {
        _nfaSchemeDetails = [[NFASchemeDetails alloc] init];
    }
    return _nfaSchemeDetails;
}

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaSchemeDetails = model;
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

- (void)bindDataToFieldsFromModel:(NFASchemeDetails *)schemeDetails {
    if (!schemeDetails) {
        return;
    }
    [self.flatSchemeTextField setText:schemeDetails.flatScheme];
    [self.priceHikeTextField setText:schemeDetails.priceHike];
}

- (void)resetFields {
    [self.flatSchemeTextField setText:@""];
    [self.priceHikeTextField setText:@""];
    
    self.nfaSchemeDetails.flatScheme = @"";
    self.nfaSchemeDetails.priceHike = @"";
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.flatSchemeTextField) {
        self.nfaSchemeDetails.flatScheme = self.flatSchemeTextField.text;
    }
    else if (textField == self.priceHikeTextField) {
        self.nfaSchemeDetails.priceHike = self.priceHikeTextField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.flatSchemeTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }else if (self.priceHikeTextField == textField) {
        if (length > 9)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
        
    }
    return true;
}
@end
