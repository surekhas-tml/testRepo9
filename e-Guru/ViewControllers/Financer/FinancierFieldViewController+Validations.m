//
//  FinancierFieldViewController+Validations.m
//  e-guru
//
//  Created by Shashi on 15/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierFieldViewController+Validations.h"

@implementation FinancierFieldViewController (Validations)




- (BOOL)validateTextFields:(NSString **)warningMessage_p
{
    if (!([self.onRoadPriceTF.text length] < 9) || !([self.onRoadPriceTF.text length] > 4)){
        *warningMessage_p = @"Please enter valid onRoadPrice amount";
        return NO;
    } else if (!([self.exShowroomTF.text length] < 9) || !([self.exShowroomTF.text length] > 4)){
        *warningMessage_p = @"Please enter valid exShowroom amount";
        return NO;
    } else if ([self.exShowroomTF.text intValue] >= [self.onRoadPriceTF.text intValue]){
        *warningMessage_p = @"Please enter ExShowroom Amount less than OnRoadPrice amount";
        return NO;
    } else if (!([self.loanDetailsTF.text length] < 4)) {
        *warningMessage_p = @"Please enter valid Loan repayable amount";
        return NO;
    } else if ([self.panNoCompanyTF.text isEqualToString:@""] && ![UtilityMethods validatePanNumber:self.panNoCompanyTF.text]){
        *warningMessage_p = @"Please enter valid Pan Number";
        return NO;
    } else if ([self.panNoIndividual.text isEqualToString:@""] && ![UtilityMethods validatePanNumber:self.panNoIndividual.text]){
        *warningMessage_p = @"Please enter valid Pan Number";
        return NO;
    } else if (!([self.indicativeLoanTF.text length] < 9) || !([self.indicativeLoanTF.text length] > 4)) {
        *warningMessage_p = @"Please enter valid Indicative Loan amount";
        return NO;
    } else if ([self.indicativeLoanTF.text intValue]  >= [self.exShowroomTF.text intValue]) {
        *warningMessage_p = @"Please enter Loan Amount less than ExShowroom amount";
        return NO;
    } else if (!([self.loanTenorTF.text length] < 4)) {
        *warningMessage_p = @"Please enter valid Loan Tenor amount";
        return NO;
    }
    return YES;
}

                                                                                                                       
@end
