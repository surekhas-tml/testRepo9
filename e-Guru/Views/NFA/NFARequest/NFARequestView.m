//
//  NFARequest.m
//  e-guru
//
//  Created by admin on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFARequestView.h"

@implementation NFARequestView

#pragma mark - UI Initialization

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"NFARequestView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    
    self.sectionType = NFASectionNFARequest;
}

- (NFARequestModel *)nfaDealerAndCustomerDetails {
    if (!_nfaRequestModel) {
        _nfaRequestModel = [[NFARequestModel alloc] init];
    }
    return _nfaRequestModel;
}

#pragma mark - Private Methods

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaModel = model;
    self.nfaRequestModel = self.nfaModel.nfaRequestModel;
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

- (void)bindDataToFieldsFromModel:(EGNFA *)nfaModel {
    if (!nfaModel) {
        return;
    }
    
    [self.netSupportPerVehicleTextField setText:nfaModel.nfaRequestModel.netSupportPerVehicle];
    [self.totalSupportSoughtTextField setText:nfaModel.nfaRequestModel.totalSupportSought];
}

- (void)calculateNetSupportPreVehicle {
    long long tmlProposedLandingPriceDiscount = [self.nfaModel.nfaTMLProposedLandingPrice.discount longLongValue];
    long long dealerMargin = [self.nfaModel.nfaDealerMarginAndRetention.dealerMargin longLongValue];
    long long retention = [self.nfaModel.nfaDealerMarginAndRetention.retention longLongValue];
    long long finSubvn = [self.nfaModel.nfaFinancierDetails.finSubvn longLongValue];
    long long flatScheme = [self.nfaModel.nfaSchemeDetails.flatScheme longLongValue];
    long long priceHike = [self.nfaModel.nfaSchemeDetails.priceHike longLongValue];
    
    long long netSupportPerVehicle = tmlProposedLandingPriceDiscount - dealerMargin + retention + finSubvn - flatScheme - priceHike;
    
    [self.netSupportPerVehicleTextField setText:[NSString stringWithFormat:@"%lld", (long long)netSupportPerVehicle]];
    
    [self calculateTotalSupportSought];
}

- (void)calculateTotalSupportSought {
    
    long long netSupportPerVehicle = [self.netSupportPerVehicleTextField.text longLongValue];
    long long dealSize = [self.nfaModel.nfaDealDetails.dealSize longLongValue];
    
    long long totalSupportSought = netSupportPerVehicle * dealSize;
    
    [self.totalSupportSoughtTextField setText:[NSString stringWithFormat:@"%lld", (long long)totalSupportSought]];
    
    [self bindValuesToNFAModel];
}

- (void)bindValuesToNFAModel {
    
    self.nfaRequestModel.totalSupportSought = self.totalSupportSoughtTextField.text;
    self.nfaRequestModel.netSupportPerVehicle = self.netSupportPerVehicleTextField.text;
    
    self.nfaModel.dsmRequestedAmount = self.nfaRequestModel.netSupportPerVehicle;
    self.nfaModel.reqAmountPerVehicle = self.nfaRequestModel.netSupportPerVehicle;
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.netSupportPerVehicleTextField) {
    }
    else if (textField == self.totalSupportSoughtTextField) {
    }
}

@end
