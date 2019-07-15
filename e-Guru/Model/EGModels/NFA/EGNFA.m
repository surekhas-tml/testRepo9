//
//  EGNFA.m
//  e-guru
//
//  Created by Juili on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGNFA.h"
#import "Constant.h"
@implementation EGNFA
- (instancetype)init
{
    self = [super init];
    if (self) {
        _rsmPosition = [NSString string];
        _spendCategory = [NSString string];
        _tsmPosition = [NSString string];
        _userPosition = [NSString string];
        _tsmLastName = [NSString string];
        _tsmLogin = [NSString string];
        _nfaID = [NSString string];
        _BU = [NSString string];
        _nfaType = [NSString string];
        _tsmFirstName = [NSString string];
        _tsmEmail = [NSString string];
        _monthDate = [NSString string];
        _spend = [NSString string];
        _supportVehicle = [NSString string];
        _lastUpdatedDate = [NSString string];
        _tsmComment = [NSString string];
        _categorySubType = [NSString string];
        _createdBy = [NSString string];
        _instanceID = [NSString string];
        _tsmMobile = [NSString string];
        _region = [NSString string];
        _lastApprover = [NSString string];
        _nfaRequestNumber = [NSString string];
        _rsmLogin = [NSString string];
        _createdDate = [NSString string];
        _rsmEmail = [NSString string];
        _optySalesStage = [NSString string];
        _rsmComment = [NSString string];
        _lobHeadComment = [NSString string];
        _marketingHeadComment = [NSString string];
        _rmComment = [NSString string];
        _optyCreatedDate = [NSString string];
        _quantity = [NSString string];
        _dsmRequestedAmount = [NSString string];
        _dsmDealSize = [NSString string];
        _reqAmountPerVehicle = [NSString string];
        _totalReqAmount = [NSString string];
        _reqDealSize = [NSString string];
        _competitorFleetSize = [NSString string];
        _declaration = [NSString string];
        _finalStatus = [NSString string];
        _nextAuthority = [NSString string];
        [self initializeProperties];
    }
    return self;
}


- (void)initializeProperties {
    self.nfaDealerAndCustomerDetails = [[NFADealerAndCustomerDetails alloc] init];
    self.nfaDealDetails = [[NFADealDetails alloc] init];
    self.nfaCompetitionDetails = [[NFACompetitionDetails alloc] init];
    self.nfaTMLProposedLandingPrice = [[NFATMLProposedLandingPrice alloc] init];
    self.nfaDealerMarginAndRetention = [[NFADealerMarginAndRetention alloc] init];
    self.nfaSchemeDetails = [[NFASchemeDetails alloc] init];
    self.nfaFinancierDetails = [[NFAFinancierDetails alloc] init];
    self.nfaRequestModel = [[NFARequestModel alloc] init];
}

- (instancetype)initNFAWithModel:(NFAAPIModel *)nfaAPIModel {
    
    EGNFA *nfaModel = [[EGNFA alloc] init];
    if (nfaAPIModel) {
        
        /**
         Dealer & Customer Details
         **/
        nfaModel.nfaDealerAndCustomerDetails.oppotunityID = nfaAPIModel.optyID;
        nfaModel.nfaDealerAndCustomerDetails.dealerCode = nfaAPIModel.dealerCode;
        nfaModel.nfaDealerAndCustomerDetails.dealerName = nfaAPIModel.dealerName;
        nfaModel.nfaDealerAndCustomerDetails.accountName = nfaAPIModel.accountName;
        nfaModel.nfaDealerAndCustomerDetails.location = nfaAPIModel.location;
        nfaModel.nfaDealerAndCustomerDetails.mmIntendedApplication = nfaAPIModel.application;
        nfaModel.nfaDealerAndCustomerDetails.tmlFleetSize = nfaAPIModel.tmlFleetSize;
        nfaModel.nfaDealerAndCustomerDetails.overAllFleetSize = nfaAPIModel.overallFleetSize;
        nfaModel.nfaDealerAndCustomerDetails.dealType = nfaAPIModel.dealType;
        nfaModel.nfaDealerAndCustomerDetails.customerName = nfaAPIModel.customerNameActual;
        nfaModel.nfaDealerAndCustomerDetails.additionalCustomers = nfaAPIModel.additionalCustomer;
        nfaModel.nfaDealerAndCustomerDetails.customerComments = nfaAPIModel.dsmComment; // Mapping Doubt
        nfaModel.nfaDealerAndCustomerDetails.vehicleRegistrationState = nfaAPIModel.vehicleRegistrationState;
        nfaModel.nfaDealerAndCustomerDetails.customerNumber = nfaAPIModel.contactNumber;
        nfaModel.nfaDealerAndCustomerDetails.remark = nfaAPIModel.remark;
        
        /**
         Deal Details
         **/
        nfaModel.nfaDealDetails.lob = nfaAPIModel.lob;
        nfaModel.nfaDealDetails.ppl = nfaAPIModel.ppl;
        nfaModel.nfaDealDetails.model = nfaAPIModel.model;
        nfaModel.nfaDealDetails.vc = nfaAPIModel.vc;
        nfaModel.nfaDealDetails.productDescription = nfaAPIModel.productDescription;
        nfaModel.nfaDealDetails.dealSize = nfaAPIModel.dealSize;
        nfaModel.nfaDealDetails.billing = nfaAPIModel.billing;
        
        /**
         Competition Details
         **/
        nfaModel.nfaCompetitionDetails.competitor = nfaAPIModel.competitor;
        nfaModel.nfaCompetitionDetails.model = nfaAPIModel.modelCompetitor;
        nfaModel.nfaCompetitionDetails.exShowroom = nfaAPIModel.exShowRoomCompetitor;
        nfaModel.nfaCompetitionDetails.discount = nfaAPIModel.discountCompetitor;
        nfaModel.nfaCompetitionDetails.landingPrice = nfaAPIModel.landingPriceCompetitor;
        
        /**
         TML Proposed Landing Price
         **/
        nfaModel.nfaTMLProposedLandingPrice.exShowRoom = nfaAPIModel.exShowRoomTML;
        nfaModel.nfaTMLProposedLandingPrice.discount = nfaAPIModel.discountTML;
        nfaModel.nfaTMLProposedLandingPrice.landingPrice = nfaAPIModel.landingPriceTML;
        
        /**
         Dealer Margin & Retention
         **/
        nfaModel.nfaDealerMarginAndRetention.dealerMargin = nfaAPIModel.dealerMargin;
        nfaModel.nfaDealerMarginAndRetention.retention = nfaAPIModel.dealerMargin;
        
        /**
         Scheme Details
         **/
        nfaModel.nfaSchemeDetails.flatScheme = nfaAPIModel.flatScheme;
        nfaModel.nfaSchemeDetails.priceHike = nfaAPIModel.priceHike;
        
        /**
         Financier Details
         **/
        nfaModel.nfaFinancierDetails.financier = nfaAPIModel.financier;
        nfaModel.nfaFinancierDetails.ltvField = nfaAPIModel.ltv;
        nfaModel.nfaFinancierDetails.finSubvn = nfaAPIModel.finSubvn;
        
        /**
         NFA Request
         **/
        nfaModel.nfaRequestModel.netSupportPerVehicle = nfaAPIModel.netSupportPerVehicle;
        nfaModel.nfaRequestModel.totalSupportSought = nfaAPIModel.netSupportPerVehicle;
    }
    
    return nfaModel;
}

@end
