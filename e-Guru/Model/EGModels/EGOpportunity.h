//
//  EGOpportunity.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AAAOpportunityMO+CoreDataClass.h"
#import "EGReferralCustomer.h"
#import "EGMMGeography.h"
#import "EGTGM.h"
#import "EGFinancier.h"
#import "EGVCNumber.h"
#import "EGBroker.h"
#import "EGAccount.h"
#import "EGCampaign.h"
#import "EGContact.h"
#import "EGActivity.h"
#import "EGLob.h"
#import "EGLOBInfo.h"
#import "EGEvent.h"
#import "EGPotentialDropOff.h"
#import "ExchangeDetails.h"

@class EGAccount, EGActivity, EGCampaign, EGContact, EGFinancier,EGBroker,EGTGM,EGVCNumber,EGMMGeography,EGReferralCustomer,EGDse,ExchangeDetails;
@interface EGOpportunity : NSObject

@property (nullable, nonatomic, copy) NSString *draftID;
@property (nullable, nonatomic, copy) NSString *bodyType;
@property (nullable, nonatomic, copy) NSString *competitor;             
@property (nullable, nonatomic, copy) NSString *competitorModel;
@property (nullable, nonatomic, copy) NSString *competitorRemark;
@property (nullable, nonatomic, copy) NSString *customerType;
@property (nullable, nonatomic, copy) NSString *influencer;

@property (nonatomic) BOOL isLiveDeal;
@property (nonatomic) BOOL is_quote_submitted_to_crm;
@property (nonatomic) BOOL is_quote_submitted_to_financier;
@property (nonatomic) BOOL is_time_before_48_hours;
@property (nonatomic) BOOL is_Any_Case_Approved;
@property (nonatomic) BOOL is_eligible_for_insert_quote;
@property (nonatomic) BOOL is_first_case_rejected;

@property (nullable, nonatomic, copy) NSString *ppl_for_exchange;
@property (nullable, nonatomic, copy) NSString *pl_for_exchange;
@property (nullable, nonatomic, copy) NSString *registration_no;
@property (nullable, nonatomic, copy) NSString *tml_src_chassisnumber;
@property (nullable, nonatomic, copy) NSString *milage;
@property (nullable, nonatomic, copy) NSString *age_of_vehicle;
@property (nullable, nonatomic, copy) NSString *tml_ref_pl_id;
@property (nullable, nonatomic, copy) NSString *tml_src_assset_id;
@property (nullable, nonatomic, copy) NSString *interested_in_exchange;
//@property (nonatomic) BOOL isLiveDeal;

@property (nullable, nonatomic, copy) NSString *liveDeal;
@property (nullable, nonatomic, copy) NSString *leadAssignedName;
@property (nullable, nonatomic, copy) NSString *leadAssignedLastName;
@property (nullable, nonatomic, copy) NSString *leadAssignedPhoneNumber;
@property (nullable, nonatomic, copy) NSString *leadAssignedPositionID;
@property (nullable, nonatomic, copy) NSString *leadAssignedPosition;
@property (nullable, nonatomic, copy) NSString *license;
@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *lostMake;
@property (nullable, nonatomic, copy) NSString *lostModel;
@property (nullable, nonatomic, copy) NSString *lostReson;
@property (nullable, nonatomic, copy) NSString *opportunityCreatedDate;
@property (nullable, nonatomic, copy) NSString *opportunityName;
@property (nullable, nonatomic, copy) NSString *optyID;
@property (nullable, nonatomic, copy) NSString *pl;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *rev_productID;
@property (nullable, nonatomic, copy) NSString *salesStageName;
@property (nullable, nonatomic, copy) NSString *saleStageUpdatedDate;
@property (nullable, nonatomic, copy) NSString *productCatagory;
@property (nullable, nonatomic, copy) NSString *productID;
@property (nullable, nonatomic, copy) NSString *saletageDate;
@property (nullable, nonatomic, copy) NSString *sourceOfContact;
@property (nullable, nonatomic, copy) NSString *usageCatagory;
@property (nullable, nonatomic, copy) NSString *vhApplication;
@property (nullable, nonatomic, copy) NSString *totalFleetSize;
@property (nullable, nonatomic, copy) NSString *tmlFleetSize;
@property (nullable, nonatomic, copy) NSString *fromContext;
@property (nullable, nonatomic, copy) NSString *idLocal;
@property (nullable, nonatomic, copy) NSString *prospectType;
@property (nullable, nonatomic, copy) NSString *opportunityStatus;
@property (nullable, nonatomic, copy) NSString *businessUnit;
@property (nullable, nonatomic, copy) NSString *reffralType;
@property (nullable, nonatomic, copy) NSString *potentialDropOff;

@property (nullable, nonatomic, copy) NSString *channel;
@property (nullable, nonatomic, copy) NSString *nfaStatus;
@property (nullable, nonatomic, copy) NSString *nfaNumber;
@property (nullable, nonatomic, copy) NSString *productIntegrationID; // For opty creation via Product App
@property (nullable, nonatomic, copy) NSString *invoiceCount;
@property (nullable, nonatomic, copy) NSString *eventName;
@property (nullable, nonatomic, copy) NSString *eventID;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;

@property (nullable, nonatomic, retain) EGReferralCustomer *toReferral;
@property (nullable, nonatomic, retain) EGMMGeography *toMMGEO;
@property (nullable, nonatomic, retain) EGTGM *toTGM;
@property (nullable, nonatomic, retain) EGFinancier *toFinancier;
@property (nullable, nonatomic, retain) EGVCNumber *toVCNumber;
@property (nullable, nonatomic, retain) EGBroker *toBroker;
@property (nullable, nonatomic, retain) EGAccount *toAccount;
@property (nullable, nonatomic, retain) EGCampaign *toCampaign;
@property (nullable, nonatomic, retain) EGContact *toContact;
@property (nullable, nonatomic, retain) EGActivity *toLastDoneActivity;
@property (nullable, nonatomic, retain) EGActivity *toLastPendingActivity;
@property (nullable, nonatomic, retain) EGLob *toLOB;
@property (nullable, nonatomic, retain) EGLOBInfo *toLOBInfo;
@property (nullable, nonatomic, retain) EGPotentialDropOff *toPotentialDropOff;
@property (nullable, nonatomic, retain) ExchangeDetails *toExchange;

-(_Nullable instancetype)initWithObject:(AAAOpportunityMO * _Nullable)object;

@end
