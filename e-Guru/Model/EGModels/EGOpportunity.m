//
//  EGOpportunity.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGOpportunity.h"
#import "AAAEventMO+CoreDataProperties.h"
#import "NSString+NSStringCategory.h"

@implementation EGOpportunity
@synthesize bodyType;
@synthesize competitor;
@synthesize customerType;
@synthesize isLiveDeal;

@synthesize is_quote_submitted_to_crm;
@synthesize is_quote_submitted_to_financier;
@synthesize is_time_before_48_hours;
@synthesize is_Any_Case_Approved;
@synthesize is_eligible_for_insert_quote;
@synthesize is_first_case_rejected;

@synthesize ppl_for_exchange;
@synthesize pl_for_exchange;
@synthesize registration_no;
@synthesize milage;
@synthesize age_of_vehicle;
@synthesize tml_src_chassisnumber;
@synthesize tml_ref_pl_id;
@synthesize tml_src_assset_id;
@synthesize interested_in_exchange;

@synthesize leadAssignedName;
@synthesize leadAssignedPhoneNumber;
@synthesize leadAssignedPositionID;
@synthesize leadAssignedPosition;
@synthesize license;
@synthesize lob;
@synthesize lostMake;
@synthesize lostModel;
@synthesize lostReson;
@synthesize toMMGEO;
@synthesize opportunityCreatedDate;
@synthesize opportunityName;
@synthesize optyID;
@synthesize pl;
@synthesize ppl;
@synthesize productCatagory;
@synthesize quantity;
@synthesize reffralType;
@synthesize rev_productID;
@synthesize salesStageName;
@synthesize saleStageUpdatedDate;
@synthesize saletageDate;
@synthesize sourceOfContact;
@synthesize usageCatagory;
@synthesize vhApplication;
@synthesize toAccount;
@synthesize toCampaign;
@synthesize toContact;
@synthesize toLastDoneActivity;
@synthesize toLastPendingActivity;
@synthesize totalFleetSize;
@synthesize tmlFleetSize;
@synthesize fromContext;
@synthesize idLocal;
@synthesize prospectType;
@synthesize userID;
@synthesize source;
@synthesize opportunityStatus;
@synthesize businessUnit;
@synthesize draftID;
@synthesize channel;
@synthesize toLOB;
@synthesize competitorModel;
@synthesize toLOBInfo;
@synthesize productID;
@synthesize leadAssignedLastName;
@synthesize toFinancier;
@synthesize toPotentialDropOff;
@synthesize eventID;
@synthesize eventName;
@synthesize latitude;
@synthesize longitude;
@synthesize toReferral;

-(instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.is_quote_submitted_to_crm = @"";
//        self.is_quote_submitted_to_financier = @"";
//        self.is_time_before_48_hours = @"";
        
        self.channel = @"Mobile";
        self.bodyType = @"";
        self.competitor = @"";
        self.leadAssignedName = @"";
        self.leadAssignedPhoneNumber    = @"";
        self.leadAssignedPositionID     = @"";
        self.leadAssignedPosition       = @"";
        self.license                    = @"";
        self.lob                        = @"";
        self.lostMake = @"";
        self.lostModel = @"";
        self.lostReson = @"";
        self.opportunityCreatedDate = @"";
        self.opportunityName = @"";
        self.optyID = @"";
        self.pl = @"";
        self.ppl = @"";
        self.productCatagory = @"";
        self.quantity = @"";
        self.reffralType = @"";
        self.rev_productID = @"";
        self.salesStageName = @"";
        self.saleStageUpdatedDate = @"";
        self.saletageDate = @"";
        self.sourceOfContact = @"";
        self.usageCatagory = @"";
        self.vhApplication = @"";
        self.totalFleetSize = @"";
        self.tmlFleetSize = @"";
        self.fromContext = @"";
        self.idLocal = @"";
        self.prospectType = @"";
        self.userID = @"";
        self.source = @"";
        self.opportunityStatus = @"";
        self.businessUnit = @"";
        self.draftID = @"";
        self.competitorModel = @"";
        self.competitorRemark = @"";
        self.influencer = @"";
        self.liveDeal = @"N";
        self.productID = @"";
        self.leadAssignedLastName = @"";
        self.nfaStatus = @"";
        self.nfaNumber = @"";
        self.productIntegrationID = @"";
        self.invoiceCount = @"";
        self.eventName = @"";
        self.eventID = @"";

    }
    return self;
}

-(instancetype)initWithObject:(AAAOpportunityMO *)object{
    self = [super init];
   
    if (self) {
        //crash @draft was happening
        self.is_quote_submitted_to_crm       = object.is_quote_submitted_to_crm != nil ? object.is_quote_submitted_to_crm : @"";
        self.is_quote_submitted_to_financier = object.is_quote_submitted_to_financier != nil ? object.is_quote_submitted_to_financier: @"";
        self.is_time_before_48_hours         = object.is_time_before_48_hours != nil ? object.is_time_before_48_hours: @"";
        self.is_Any_Case_Approved            = object.is_Any_Case_Approved != nil ? object.is_Any_Case_Approved: @"";
        self.is_eligible_for_insert_quote    = object.is_eligible_for_insert_quote != nil ? object.is_eligible_for_insert_quote: @"";
        self.is_first_case_rejected          = object.is_first_case_rejected != nil ? object.is_first_case_rejected: @"";
        
        ppl_for_exchange        = object.ppl_for_exchange != nil ? object.ppl_for_exchange : @"";
        pl_for_exchange         = object.pl_for_exchange != nil ? object.pl_for_exchange : @"";
        registration_no         = object.registration_no != nil ? object.registration_no : @"";
        milage                  = object.milage != nil ? object.milage : @"";
        age_of_vehicle          = object.age_of_vehicle != nil ? object.age_of_vehicle : @"";
        tml_src_chassisnumber   = object.tml_src_chassisnumber != nil ? object.tml_src_chassisnumber : @"";
        tml_ref_pl_id           = object.tml_ref_pl_id != nil ? object.tml_ref_pl_id : @"";
        tml_src_assset_id       = object.tml_src_assset_id != nil ? object.tml_src_assset_id : @"";
        interested_in_exchange  = object.interested_in_exchange != nil ? object.interested_in_exchange : @"";
        
        self.bodyType = object.bodyType? : @"";
        self.competitor = object.competitor? : @"";
        self.competitorModel = object.competitorModel? : @"";
        self.competitorRemark = object.competitorRemark? : @"";
        self.customerType = object.customerType? : @"";
        self.influencer = object.influencer? : @"";
        self.leadAssignedName = object.leadAssignedName? : @"";
        self.leadAssignedPhoneNumber = object.leadAssignedPhoneNumber? : @"";
        self.leadAssignedPositionID = object.leadAssignedPositionID? : @"";
        self.leadAssignedPosition = object.leadAssignedPosition? : @"";
        self.license = object.license? : @"";
        self.lob = object.lob? : @"";
        self.lostMake = object.lostMake? : @"";
        self.lostModel = object.lostModel? : @"";
        self.lostReson = object.lostReson? : @"";
        self.opportunityCreatedDate = object.opportunityCreatedDate? : @"";
        self.opportunityName = object.opportunityName? : @"";
        self.optyID = object.optyID? : @"";
        self.pl = object.pl? : @"";
        self.ppl = object.ppl? : @"";
        self.productCatagory = object.productCatagory? : @"";
        self.userID = object.userID? : @"";
        self.source = object.source? : @"";
        self.quantity = object.quantity? : @"";
        self.rev_productID = object.rev_productID? : @"";
        self.productID = @"";
        self.salesStageName = object.salesStageName? : @"";
        self.saleStageUpdatedDate = object.saleStageUpdatedDate? : @"";
        self.saletageDate = object.saletageDate? : @"";
        self.sourceOfContact = object.sourceOfContact? : @"";
        self.usageCatagory = object.usageCatagory? : @"";
        self.vhApplication = object.vhApplication? : @"";
        self.totalFleetSize = object.totalFleetSize? : @"";
        self.tmlFleetSize = object.tmlFleetSize? : @"";
        self.fromContext = object.fromContext? : @"";
        self.idLocal = object.idLocal? : @"";
        self.prospectType = object.idLocal? : @"";
        self.opportunityStatus = object.opportunityStatus? : @"";
        self.businessUnit = object.businessUnit? : @"";
        self.reffralType = object.reffralType? : @"";
        self.channel = @"Mobile";
        self.liveDeal = @"";
        self.productIntegrationID = object.productIntegrationID? : @"";
        self.latitude = [object.latitude hasValue]? object.latitude : nil;
        self.longitude = [object.longitude hasValue]? object.longitude : nil;
        if (object.toRefferal) {
            self.toReferral = [[EGReferralCustomer alloc]initWithObject:object.toRefferal];
        }
        if (object.toMMGeo) {
            self.toMMGEO = [[EGMMGeography alloc]initWithObject:object.toMMGeo];
        }
        if (object.toTGM) {
            self.toTGM = [[EGTGM alloc]initWithObject:object.toTGM];
        }
        if (object.toFinancer) {
            self.toFinancier = [[EGFinancier alloc]initWithObject:object.toFinancer];
        }
        if (object.toVC) {
            self.toVCNumber = [[EGVCNumber alloc]initWithObject:object.toVC];
        }
        if (object.toBroker) {
            self.toBroker = [[EGBroker alloc]initWithObject:object.toBroker];
        }
        if (object.toAccount) {
            self.toAccount = [[EGAccount alloc]initWithObject:object.toAccount];
        }
        if (object.toCampaign) {
            self.toCampaign = [[EGCampaign alloc]initWithObject:object.toCampaign];
        }
        if (object.toContact) {
            self.toContact = [[EGContact alloc]initWithObject:object.toContact];
        }
        if (object.toLobInfo) {
            self.toLOBInfo = [[EGLOBInfo alloc] initWithObject:object.toLobInfo];
        }
        if (object.toEvent) {
            self.eventName = object.toEvent.eventName;
            self.eventID = object.toEvent.eventID;
        }
        if (object.toExchangeDetails) {
            self.toExchange = [[ExchangeDetails alloc] initWithObject:object.toExchangeDetails];
        }
       
    }
    return self;
}

- (EGLOBInfo *)toLOBInfo {
    if (!toLOBInfo) {
        toLOBInfo = [[EGLOBInfo alloc] init];
    }
    return toLOBInfo;
}

- (EGFinancier *)toFinancier {
    if (!toFinancier) {
        toFinancier = [[EGFinancier alloc] init];
    }
    return toFinancier;
}

- (EGPotentialDropOff *)toPotentialDropOff {
    if (!toPotentialDropOff) {
        toPotentialDropOff = [[EGPotentialDropOff alloc] init];
    }
    return toPotentialDropOff;
}

- (EGReferralCustomer *)toReferral {
    if (!toReferral) {
        toReferral = [[EGReferralCustomer alloc] init];
    }
    return toReferral;
}

@end
