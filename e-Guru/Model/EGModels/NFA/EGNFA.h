//
//  EGNFA.h
//  e-guru
//
//  Created by Juili on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFADealerAndCustomerDetails.h"
#import "NFADealDetails.h"
#import "NFATMLProposedLandingPrice.h"
#import "NFASchemeDetails.h"
#import "NFAFinancierDetails.h"
#import "NFADealerMarginAndRetention.h"
#import "NFACompetitionDetails.h"
#import "NFARequestModel.h"
#import "NFAAPIModel.h"

@interface EGNFA : NSObject

@property (nonatomic) NSString *lobName;
@property (nonatomic) NSString *rsmPosition;
@property (nonatomic) NSString *spendCategory;
@property (nonatomic) NSString *tsmPosition;
@property (nonatomic) NSString *userPosition;
@property (nonatomic) NSString *tsmLastName;
@property (nonatomic) NSString *tsmLogin;
@property (nonatomic) NSString *nfaID;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *BU;
@property (nonatomic) NSString *nfaType;
@property (nonatomic) NSString *tsmFirstName;
@property (nonatomic) NSString *tsmEmail;
@property (nonatomic) NSString *monthDate;
@property (nonatomic) NSString *spend;
@property (nonatomic) NSString *supportVehicle;
@property (nonatomic) NSString *lastUpdatedDate;
@property (nonatomic) NSString *tsmComment;
@property (nonatomic) NSString *categorySubType;
@property (nonatomic) NSString *createdBy;
@property (nonatomic) NSString *instanceID;
@property (nonatomic) NSString *tsmMobile;
@property (nonatomic) NSString *region;
@property (nonatomic) NSString *dealerState;
@property (nonatomic) NSString *lastApprover;
@property (nonatomic) NSString *nfaRequestNumber;
@property (nonatomic) NSString *rsmLogin;
@property (nonatomic) NSString *createdDate;
@property (nonatomic) NSString *rsmEmail;
@property (nonatomic) NSString *optySalesStage;
@property (nonatomic) NSString *rsmComment;
@property (nonatomic) NSString *lobHeadComment;
@property (nonatomic) NSString *marketingHeadComment;
@property (nonatomic) NSString *rmComment;
@property (nonatomic) NSString *optyCreatedDate;
@property (nonatomic) NSString *quantity;
@property (nonatomic) NSString *dsmRequestedAmount;
@property (nonatomic) NSString *dsmDealSize;
@property (nonatomic) NSString *reqAmountPerVehicle;
@property (nonatomic) NSString *totalReqAmount;
@property (nonatomic) NSString *reqDealSize;
@property (nonatomic) NSString *competitorFleetSize;
@property (nonatomic) NSString *declaration;
@property (nonatomic) NSString *finalStatus;
@property (nonatomic) NSString *nextAuthority;

@property (nonatomic, strong) NFADealerAndCustomerDetails *nfaDealerAndCustomerDetails;
@property (nonatomic, strong) NFADealDetails *nfaDealDetails;
@property (nonatomic, strong) NFATMLProposedLandingPrice *nfaTMLProposedLandingPrice;
@property (nonatomic, strong) NFASchemeDetails *nfaSchemeDetails;
@property (nonatomic, strong) NFAFinancierDetails *nfaFinancierDetails;
@property (nonatomic, strong) NFADealerMarginAndRetention *nfaDealerMarginAndRetention;
@property (nonatomic, strong) NFACompetitionDetails *nfaCompetitionDetails;
@property (nonatomic, strong) NFARequestModel *nfaRequestModel;
@end
