//
//  NFAAPIModel.m
//  e-guru
//
//  Created by MI iMac04 on 22/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAAPIModel.h"
#import "EGNFA.h"

@implementation NFAAPIModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _location = [NSString string];
        _c0 = [NSString string]; // Not Needed
        _closureStatus = [NSString string]; // Not Needed
        _activityType = [NSString string]; // Not Needed
        _rsmPosition = [NSString string];
        _spendCategory = [NSString string];
        _tsmPosition = [NSString string];
        _application = [NSString string];
        _userPosition = [NSString string];
        _tsmLastName = [NSString string];
        _tmlContribution = [NSString string];
        _dealerName = [NSString string];
        _dealerCode = [NSString string];
        _tsmLogin = [NSString string];
        _nfaID = [NSString string]; // Not Needed
        _status = [NSString string]; // Not Needed
        _dealerContribution = [NSString string];
        _BU = [NSString string];
        _nfaType = [NSString string];
        _tsmFirstName = [NSString string];
        _tsmEmail = [NSString string];
        _monthDate = [NSString string];
        _spend = [NSString string];
        _supportVehicle = [NSString string];
        _lastUpdatedDate = [NSString string];
        _lob = [NSString string];
        _tsmComment = [NSString string];
        _version = [NSString string];
        _categorySubType = [NSString string];
        _createdBy = [NSString string];
        _instanceID = [NSString string];
        _tsmMobile = [NSString string];
        _region = [NSString string];
        _lastApprover = [NSString string];
        _nfaRequestNumber = [NSString string];
        _rsmLogin = [NSString string];
        _expectedAttendees = [NSString string];
        _totalActivityCost = [NSString string];
        _createdDate = [NSString string];
        _c1 = [NSString string];
        _rsmEmail = [NSString string];
        _plannedDateOfActivity = [NSString string];
        _optySalesStage = [NSString string];
        _optyID = [NSString string];
        _tmlFleetSize = [NSString string];
        _dealType = [NSString string];
        _customerNameActual = [NSString string];
        _rsmComment = [NSString string];
        _lobHeadComment = [NSString string];
        _marketingHeadComment = [NSString string];
        _dsmComment = [NSString string];
        _rmComment = [NSString string];
        _vehicleRegistrationState = [NSString string];
        _contactNumber = [NSString string];
        _dealSize = [NSString string];
        _billing = [NSString string];
        _vc = [NSString string];
        _productDescription = [NSString string];
        _flatScheme = [NSString string];
        _priceHike = [NSString string];
        _financier = [NSString string];
        _ltv = [NSString string];
        _finSubvn = [NSString string];
        _dealerMargin = [NSString string];
        _retention = [NSString string];
        _exShowRoomTML = [NSString string];
        _discountTML = [NSString string];
        _landingPriceTML = [NSString string];
        _competitor = [NSString string];
        _modelCompetitor = [NSString string];
        _exShowRoomCompetitor = [NSString string];
        _discountCompetitor = [NSString string];
        _landingPriceCompetitor = [NSString string];
        _optyCreatedDate = [NSString string];
        _quantity = [NSString string];
        _accountName = [NSString string];
        _overallFleetSize = [NSString string];
        _netSupportPerVehicle = [NSString string];
        _totalSupportSought = [NSString string];
        _remark = [NSString string];
        _model = [NSString string];
        _additionalCustomer = @"";
        _ppl = [NSString string];
        _dsmRequestedAmount = [NSString string];
        _dsmDealSize = [NSString string];
        _reqAmountPerVehicle = [NSString string];
        _totalReqAmount = [NSString string];
        _reqDealSize = [NSString string];
        _competitorFleetSize = [NSString string];
        _declaration = [NSString string];
        _finalStatus = [NSString string];
        _nextAuthority = [NSString string];
        
    }
    return self;
}

- (instancetype)initWithNFAModel:(EGNFA *)nfaModel {
    NFAAPIModel *nfaAPIModel = [[NFAAPIModel alloc] init];
    
    if (nfaModel) {
        
        nfaAPIModel.nfaID = nfaModel.nfaID;
        nfaAPIModel.nextAuthority = nfaModel.nextAuthority;
        nfaAPIModel.nfaRequestNumber = nfaModel.nfaRequestNumber;
        
        /**
         Position Details
         **/
        nfaAPIModel.userPosition = nfaModel.userPosition;
        nfaAPIModel.tsmFirstName = nfaModel.tsmFirstName;
        nfaAPIModel.tsmLastName = nfaModel.tsmLastName;
        nfaAPIModel.tsmPosition = nfaModel.tsmPosition;
        nfaAPIModel.tsmEmail = nfaModel.tsmEmail;
        nfaAPIModel.createdBy = nfaModel.createdBy;
        nfaAPIModel.region = nfaModel.region;
        
        /**
         NFA Type Details
         **/
        nfaAPIModel.nfaType = nfaModel.nfaType;
        nfaAPIModel.monthDate = nfaModel.monthDate;
        nfaAPIModel.spendCategory = nfaModel.spendCategory;
        nfaAPIModel.categorySubType = nfaModel.categorySubType;
        nfaAPIModel.spend = nfaModel.spend;
        
        /**
         Opportunity Detials
         **/
        
        /**
         Dealer & Customer Details
         **/
        nfaAPIModel.optyID = nfaModel.nfaDealerAndCustomerDetails.oppotunityID;
        nfaAPIModel.dealerCode = nfaModel.nfaDealerAndCustomerDetails.dealerCode;
        nfaAPIModel.dealerName = nfaModel.nfaDealerAndCustomerDetails.dealerName;
        nfaAPIModel.accountName = nfaModel.nfaDealerAndCustomerDetails.accountName;
        nfaAPIModel.location = nfaModel.nfaDealerAndCustomerDetails.location;
        nfaAPIModel.application = nfaModel.nfaDealerAndCustomerDetails.mmIntendedApplication;
        nfaAPIModel.tmlFleetSize = nfaModel.nfaDealerAndCustomerDetails.tmlFleetSize;
        nfaAPIModel.overallFleetSize = nfaModel.nfaDealerAndCustomerDetails.overAllFleetSize;
        nfaAPIModel.dealType = nfaModel.nfaDealerAndCustomerDetails.dealType;
        nfaAPIModel.customerNameActual = nfaModel.nfaDealerAndCustomerDetails.customerName;
        nfaAPIModel.additionalCustomer = nfaModel.nfaDealerAndCustomerDetails.additionalCustomers;
        nfaAPIModel.dsmComment = nfaModel.nfaDealerAndCustomerDetails.customerComments; // Mapping Doubt
        nfaAPIModel.vehicleRegistrationState = nfaModel.nfaDealerAndCustomerDetails.vehicleRegistrationState;
        nfaAPIModel.contactNumber = nfaModel.nfaDealerAndCustomerDetails.customerNumber;
        nfaAPIModel.remark = nfaModel.nfaDealerAndCustomerDetails.remark;
        nfaAPIModel.declaration = nfaModel.declaration;
        
        // Mapping competitor fleet size
        nfaAPIModel.competitorFleetSize = nfaAPIModel.overallFleetSize;
        
        /**
         Deal Details
         **/
        nfaAPIModel.lob = nfaModel.nfaDealDetails.lob;
        nfaAPIModel.ppl = nfaModel.nfaDealDetails.ppl;
        nfaAPIModel.model = nfaModel.nfaDealDetails.model;
        nfaAPIModel.vc = nfaModel.nfaDealDetails.vc;
        nfaAPIModel.productDescription = nfaModel.nfaDealDetails.productDescription;
        nfaAPIModel.dealSize = nfaModel.nfaDealDetails.dealSize;
        nfaAPIModel.billing = nfaModel.nfaDealDetails.billing;
        
        // Mapping deal size
        nfaAPIModel.dsmDealSize = nfaAPIModel.dealSize;
        nfaAPIModel.reqDealSize = nfaAPIModel.dealSize;
        
        /**
         Competition Details
         **/
        nfaAPIModel.competitor = nfaModel.nfaCompetitionDetails.competitor;
        nfaAPIModel.modelCompetitor = nfaModel.nfaCompetitionDetails.model;
        nfaAPIModel.exShowRoomCompetitor = nfaModel.nfaCompetitionDetails.exShowroom;
        nfaAPIModel.discountCompetitor = nfaModel.nfaCompetitionDetails.discount;
        nfaAPIModel.landingPriceCompetitor = nfaModel.nfaCompetitionDetails.landingPrice;
        
        /**
         TML Proposed Landing Price
         **/
        nfaAPIModel.exShowRoomTML = nfaModel.nfaTMLProposedLandingPrice.exShowRoom;
        nfaAPIModel.discountTML = nfaModel.nfaTMLProposedLandingPrice.discount;
        nfaAPIModel.landingPriceTML = nfaModel.nfaTMLProposedLandingPrice.landingPrice;
        
        /**
         Dealer Margin & Retention
         **/
        nfaAPIModel.dealerMargin = nfaModel.nfaDealerMarginAndRetention.dealerMargin;
        nfaAPIModel.retention = nfaModel.nfaDealerMarginAndRetention.retention;
        
        /**
         Scheme Details
         **/
        nfaAPIModel.flatScheme = nfaModel.nfaSchemeDetails.flatScheme;
        nfaAPIModel.priceHike = nfaModel.nfaSchemeDetails.priceHike;
        
        /**
         Financier Details
         **/
        nfaAPIModel.financier = nfaModel.nfaFinancierDetails.financier;
        nfaAPIModel.ltv = nfaModel.nfaFinancierDetails.ltvField;
        nfaAPIModel.finSubvn = nfaModel.nfaFinancierDetails.finSubvn;
        
        /**
         NFA Request
         **/
        nfaAPIModel.netSupportPerVehicle = nfaModel.nfaRequestModel.netSupportPerVehicle;
        nfaAPIModel.totalSupportSought = nfaModel.nfaRequestModel.totalSupportSought;
        nfaAPIModel.dsmRequestedAmount = nfaModel.dsmRequestedAmount;
        nfaAPIModel.reqAmountPerVehicle = nfaModel.reqAmountPerVehicle;
    }
    
    return nfaAPIModel;
}

@end
