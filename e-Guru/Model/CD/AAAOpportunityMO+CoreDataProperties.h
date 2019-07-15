//
//  AAAOpportunityMO+CoreDataProperties.h
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAOpportunityMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAOpportunityMO (CoreDataProperties)

+ (NSFetchRequest<AAAOpportunityMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *is_quote_submitted_to_crm;
@property (nullable, nonatomic, copy) NSString *is_quote_submitted_to_financier;
@property (nullable, nonatomic, copy) NSString *is_time_before_48_hours;
@property (nullable, nonatomic, copy) NSString *is_Any_Case_Approved;
@property (nullable, nonatomic, copy) NSString *is_eligible_for_insert_quote;
@property (nullable, nonatomic, copy) NSString *is_first_case_rejected;

@property (nullable, nonatomic, copy) NSString *ppl_for_exchange;
@property (nullable, nonatomic, copy) NSString *pl_for_exchange;
@property (nullable, nonatomic, copy) NSString *registration_no;
@property (nullable, nonatomic, copy) NSString *tml_src_chassisnumber;
@property (nullable, nonatomic, copy) NSString *milage;
@property (nullable, nonatomic, copy) NSString *age_of_vehicle;
@property (nullable, nonatomic, copy) NSString *tml_ref_pl_id;
@property (nullable, nonatomic, copy) NSString *tml_src_assset_id;
@property (nullable, nonatomic, copy) NSString *interested_in_exchange;

@property (nullable, nonatomic, copy) NSString *bodyType;
@property (nullable, nonatomic, copy) NSString *businessUnit;
@property (nullable, nonatomic, copy) NSString *channel;
@property (nullable, nonatomic, copy) NSString *competitor;
@property (nullable, nonatomic, copy) NSString *competitorModel;
@property (nullable, nonatomic, copy) NSString *competitorRemark;
@property (nullable, nonatomic, copy) NSString *customerType;
@property (nullable, nonatomic, copy) NSString *fromContext;
@property (nullable, nonatomic, copy) NSString *idLocal;
@property (nullable, nonatomic, copy) NSString *influencer;
@property (nullable, nonatomic, copy) NSString *leadAssignedName;
@property (nullable, nonatomic, copy) NSString *leadAssignedPhoneNumber;
@property (nullable, nonatomic, copy) NSString *leadAssignedPosition;
@property (nullable, nonatomic, copy) NSString *leadAssignedPositionID;
@property (nullable, nonatomic, copy) NSString *license;
@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *lostMake;
@property (nullable, nonatomic, copy) NSString *lostModel;
@property (nullable, nonatomic, copy) NSString *lostReson;
@property (nullable, nonatomic, copy) NSString *opportunityCreatedDate;
@property (nullable, nonatomic, copy) NSString *opportunityName;
@property (nullable, nonatomic, copy) NSString *opportunityStatus;
@property (nullable, nonatomic, copy) NSString *optyID;
@property (nullable, nonatomic, copy) NSString *pl;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *productCatagory;
@property (nullable, nonatomic, copy) NSString *productIntegrationID;
@property (nullable, nonatomic, copy) NSString *prospectType;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *reffralType;
@property (nullable, nonatomic, copy) NSString *rev_productID;
@property (nullable, nonatomic, copy) NSString *salesStageName;
@property (nullable, nonatomic, copy) NSString *saleStageUpdatedDate;
@property (nullable, nonatomic, copy) NSString *saletageDate;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *sourceOfContact;
@property (nullable, nonatomic, copy) NSString *tmlFleetSize;
@property (nullable, nonatomic, copy) NSString *totalFleetSize;
@property (nullable, nonatomic, copy) NSString *usageCatagory;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *vhApplication;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, retain) AAAAccountMO *toAccount;
@property (nullable, nonatomic, retain) AAABrokerMO *toBroker;
@property (nullable, nonatomic, retain) AAACampaignMO *toCampaign;
@property (nullable, nonatomic, retain) AAAContactMO *toContact;
@property (nullable, nonatomic, retain) AAAEventMO *toEvent;
@property (nullable, nonatomic, retain) AAAFinancerMO *toFinancer;
@property (nullable, nonatomic, retain) AAAActivityMO *toLastDoneActivity;
@property (nullable, nonatomic, retain) AAAActivityMO *toLastPendingActivity;
@property (nullable, nonatomic, retain) AAALobInformation *toLobInfo;
@property (nullable, nonatomic, retain) AAAMMGeographyMO *toMMGeo;
@property (nullable, nonatomic, retain) AAAReferralCustomerMO *toRefferal;
@property (nullable, nonatomic, retain) AAATGMMO *toTGM;
@property (nullable, nonatomic, retain) AAAVCNumberMO *toVC;
@property (nullable, nonatomic, retain) AAAExchangeDetailsMO *toExchangeDetails;

@end

NS_ASSUME_NONNULL_END
