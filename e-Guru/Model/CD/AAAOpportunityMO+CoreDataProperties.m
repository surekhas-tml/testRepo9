//
//  AAAOpportunityMO+CoreDataProperties.m
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAOpportunityMO+CoreDataProperties.h"

@implementation AAAOpportunityMO (CoreDataProperties)

+ (NSFetchRequest<AAAOpportunityMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Opportunity"];
}

@dynamic is_quote_submitted_to_crm;
@dynamic is_quote_submitted_to_financier;
@dynamic is_time_before_48_hours;
@dynamic is_Any_Case_Approved;
@dynamic is_eligible_for_insert_quote;
@dynamic is_first_case_rejected;

@dynamic ppl_for_exchange;
@dynamic pl_for_exchange;
@dynamic registration_no;
@dynamic tml_src_chassisnumber;
@dynamic milage;
@dynamic age_of_vehicle;
@dynamic tml_ref_pl_id;
@dynamic tml_src_assset_id;
@dynamic interested_in_exchange;


@dynamic bodyType;
@dynamic businessUnit;
@dynamic channel;
@dynamic competitor;
@dynamic competitorModel;
@dynamic competitorRemark;
@dynamic customerType;
@dynamic fromContext;
@dynamic idLocal;
@dynamic influencer;
@dynamic leadAssignedName;
@dynamic leadAssignedPhoneNumber;
@dynamic leadAssignedPosition;
@dynamic leadAssignedPositionID;
@dynamic license;
@dynamic lob;
@dynamic lostMake;
@dynamic lostModel;
@dynamic lostReson;
@dynamic opportunityCreatedDate;
@dynamic opportunityName;
@dynamic opportunityStatus;
@dynamic optyID;
@dynamic pl;
@dynamic ppl;
@dynamic productCatagory;
@dynamic productIntegrationID;
@dynamic prospectType;
@dynamic quantity;
@dynamic reffralType;
@dynamic rev_productID;
@dynamic salesStageName;
@dynamic saleStageUpdatedDate;
@dynamic saletageDate;
@dynamic source;
@dynamic sourceOfContact;
@dynamic tmlFleetSize;
@dynamic totalFleetSize;
@dynamic usageCatagory;
@dynamic userID;
@dynamic vhApplication;
@dynamic latitude;
@dynamic longitude;
@dynamic toAccount;
@dynamic toBroker;
@dynamic toCampaign;
@dynamic toContact;
@dynamic toEvent;
@dynamic toFinancer;
@dynamic toLastDoneActivity;
@dynamic toLastPendingActivity;
@dynamic toLobInfo;
@dynamic toMMGeo;
@dynamic toRefferal;
@dynamic toTGM;
@dynamic toVC;
@dynamic toExchangeDetails;

@end
