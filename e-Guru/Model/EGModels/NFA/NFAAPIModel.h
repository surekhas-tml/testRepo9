//
//  NFAAPIModel.h
//  e-guru
//
//  Created by MI iMac04 on 22/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGNFA;

@interface NFAAPIModel : NSObject

@property (nonatomic) NSString *location;
@property (nonatomic) NSString *c0;
@property (nonatomic) NSString *closureStatus;
@property (nonatomic) NSString *activityType;
@property (nonatomic) NSString *rsmPosition;
@property (nonatomic) NSString *spendCategory;
@property (nonatomic) NSString *tsmPosition;
@property (nonatomic) NSString *application;
@property (nonatomic) NSString *userPosition;
@property (nonatomic) NSString *tsmLastName;
@property (nonatomic) NSString *tmlContribution;
@property (nonatomic) NSString *dealerName;
@property (nonatomic) NSString *dealerCode;
@property (nonatomic) NSString *tsmLogin;
@property (nonatomic) NSString *nfaID;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *dealerContribution;
@property (nonatomic) NSString *BU;
@property (nonatomic) NSString *nfaType;
@property (nonatomic) NSString *tsmFirstName;
@property (nonatomic) NSString *tsmEmail;
@property (nonatomic) NSString *monthDate;
@property (nonatomic) NSString *spend;
@property (nonatomic) NSString *supportVehicle;
@property (nonatomic) NSString *lastUpdatedDate;
@property (nonatomic) NSString *lob;
@property (nonatomic) NSString *tsmComment;
@property (nonatomic) NSString *version;
@property (nonatomic) NSString *categorySubType;
@property (nonatomic) NSString *createdBy;
@property (nonatomic) NSString *instanceID;
@property (nonatomic) NSString *tsmMobile;
@property (nonatomic) NSString *region;
@property (nonatomic) NSString *lastApprover;
@property (nonatomic) NSString *nfaRequestNumber;
@property (nonatomic) NSString *rsmLogin;
@property (nonatomic) NSString *expectedAttendees;
@property (nonatomic) NSString *totalActivityCost;
@property (nonatomic) NSString *createdDate;
@property (nonatomic) NSString *c1;
@property (nonatomic) NSString *rsmEmail;
@property (nonatomic) NSString *plannedDateOfActivity;
@property (nonatomic) NSString *optySalesStage;
@property (nonatomic) NSString *optyID;
@property (nonatomic) NSString *tmlFleetSize;
@property (nonatomic) NSString *dealType;
@property (nonatomic) NSString *customerNameActual;
@property (nonatomic) NSString *rsmComment;
@property (nonatomic) NSString *lobHeadComment;
@property (nonatomic) NSString *marketingHeadComment;
@property (nonatomic) NSString *dsmComment;
@property (nonatomic) NSString *rmComment;
@property (nonatomic) NSString *vehicleRegistrationState;
@property (nonatomic) NSString *contactNumber;
@property (nonatomic) NSString *dealSize;
@property (nonatomic) NSString *billing;
@property (nonatomic) NSString *vc;
@property (nonatomic) NSString *productDescription;
@property (nonatomic) NSString *flatScheme;
@property (nonatomic) NSString *priceHike;
@property (nonatomic) NSString *financier;
@property (nonatomic) NSString *ltv;
@property (nonatomic) NSString *finSubvn;
@property (nonatomic) NSString *dealerMargin;
@property (nonatomic) NSString *retention;
@property (nonatomic) NSString *exShowRoomTML;
@property (nonatomic) NSString *discountTML;
@property (nonatomic) NSString *landingPriceTML;
@property (nonatomic) NSString *competitor;
@property (nonatomic) NSString *modelCompetitor;
@property (nonatomic) NSString *exShowRoomCompetitor;
@property (nonatomic) NSString *discountCompetitor;
@property (nonatomic) NSString *landingPriceCompetitor;
@property (nonatomic) NSString *optyCreatedDate;
@property (nonatomic) NSString *quantity;
@property (nonatomic) NSString *accountName;
@property (nonatomic) NSString *overallFleetSize;
@property (nonatomic) NSString *netSupportPerVehicle;
@property (nonatomic) NSString *totalSupportSought;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *model;
@property (nonatomic) NSString *additionalCustomer;
@property (nonatomic) NSString *ppl;
@property (nonatomic) NSString *dsmRequestedAmount;
@property (nonatomic) NSString *dsmDealSize;
@property (nonatomic) NSString *reqAmountPerVehicle;
@property (nonatomic) NSString *totalReqAmount;
@property (nonatomic) NSString *reqDealSize;
@property (nonatomic) NSString *competitorFleetSize;
@property (nonatomic) NSString *declaration;
@property (nonatomic) NSString *finalStatus;
@property (nonatomic) NSString *nextAuthority;

- (instancetype)initWithNFAModel:(EGNFA *)nfaModel;

@end
