//
//  EGRKObjectMapping.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGRKObjectMapping.h"
#import "EGTaluka.h"
#import "EGLob.h"
#import "EGPpl.h"
#import "EGPl.h"
#import "EGMMGeography.h"
#import "EGFinancier.h"
#import "EGReferralCustomer.h"
#import "EGTGM.h"
#import "EGBroker.h"
#import "EGVCNumber.h"
#import "EGPagination.h"
#import "EGVCList.h"
#import "Login.h"
#import "EGToken.h"
#import "EGUserData.h"
#import "EGPin.h"
#import "EGReversePincode.h"
#import "PipelineModel.h"
#import "C0Model.h"
#import "C1Model.h"
#import "C1AModel.h"
#import "C2Model.h"
#import "PPLDataModel.h"
#import "PLDataModel.h"
#import "ResponseModel.h"
#import "EGLOBInfo.h"
#import "EGDse.h"
#import "EGActualVsTarget.h"
#import "EGNFA.h"
#import "NFAUserPositionModel.h"
#import "EGMisSummary.h"
#import "EGMISDetails.h"
#import "EGEvent.h"
#import "EGNotification.h"
#import "EGPotentialDropOff.h"

#import "ExchangeDetails.h"

#import "FinancierListDetails.h"
#import "FinancierContactDetails.h"
#import "FinancierAccountDetails.h"
#import "FinancierOptyDetails.h"
#import "FinancierListDetailModel.h"
#import "FinancierBranchDetailsModel.h"

#import "EGExclusionListModel.h"
#import "EGExclusionModel.h"
#import "EGParameterListModel.h"
#import "EGParameterMeetingFrequency.h"
#import "EGParameterRegularVisitsChannelPriority.h"
#import "EGParameteraBodyBuilderChannelPriority.h"
#import "EGParameterKeyCustomerChannelPriority.h"
#import "EGParameterFinancierChannelPriority.h"
#import "EGParameterChannelPriority.h"

static EGRKObjectMapping *_sharedMapping;
@implementation EGRKObjectMapping


@synthesize searchAccountURLPaginatedMapping,searchContactURLPaginatedMapping,searchOpportunityURLMappingForOpportunity,searchOpportunityURLMappingForPendingActivity,stateListURLMapping,districtListURLMapping,talukaListURLMapping, lobListURLMapping, pplListURLMapping, plListURLMapping, mmGeoListURLMapping, financierURLMapping, campaignURLMapping, referralCustomerURLMapping,searchOpportunityURLMappingFordoneActivity,campaignList, tgmURLMapping, brokerDetailsURLMapping, vcListURLMapping,locationByTalukaListURLMapping,searchActivityURLMapping,searchActivityMappingForOpportunity,loginURLMapping,accessTokenMapping,addressMapping,PINCODELISTURLMapping,talukaforpincode,pincodelistURLFROMGPSMapping, dashboardMapping, PPLwisePipelineURLMapping, opportunityMapping, opportunityResponseMapping,DSEList,DSEwisePipelineURLMapping,DSEMiswisePipelineURLMapping,ActualVsTargetURLMapping,userPositionURLMapping, nextAuthorityURLMapping,DSEMisDetailswisePipelineURLMapping, getQuoteDetailURLMapping, eventMapping, getNotificationListURLMapping,  searchOptyFinancierURLMapping, fetchFinancierQuotesURLMapping, financierInsertQuoteMapping,exclusionListURLMapping,parameterSettingListURLMapping;

+(EGRKObjectMapping *)sharedMapping{
    @synchronized([EGRKObjectMapping class])
    {
        if (!_sharedMapping)
            _sharedMapping=[[self alloc] init];
        
        return _sharedMapping;
    }
    return nil;
}
+(id)alloc
{
    @synchronized([EGRKObjectMapping class])
    {
        NSAssert(_sharedMapping == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedMapping = [super alloc];
        return _sharedMapping;
    }
    
    return nil;
}

- (instancetype )init
{
    self = [super init];
    if (self) {

    }
    return self;
}


//Done
- (RKObjectMapping *)searchContactURLPaginatedMapping
{
    if(searchContactURLPaginatedMapping){
        return searchContactURLPaginatedMapping;
    }else{
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        
        [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        
        RKObjectMapping* contactMapping = [RKObjectMapping mappingForClass:[EGContact class]];
        [contactMapping addAttributeMappingsFromDictionary:@{@"first_name": @"firstName",
                                                             @"last_name": @"lastName",
                                                             @"contact_id":@"contactID",
                                                             @"primary_account_id":@"primary_account_id",
                                                             @"mobile_number":@"contactNumber",
                                                             @"email":@"emailID",
                                                             @"pan":@"panNumber"}];
        
        addressMapping = [RKObjectMapping mappingForClass:[EGAddress class]];
        [addressMapping addAttributeMappingsFromDictionary:@{@"address_line_2": @"addressLine2",
                                                             @"city": @"city",
                                                             @"address_line_1":@"addressLine1",
                                                             @"district":@"district",
                                                             @"area":@"area",
                                                             @"pincode":@"pin",
                                                             @"panchayat":@"panchayat",
                                                             }];
        
        RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[EGState class]];
        [stateMapping addAttributeMappingsFromDictionary:@{@"code":@"code",
                                                           @"name":@"name"
                                                           }];
        RKObjectMapping *talukaMapping = [RKObjectMapping mappingForClass:[EGTaluka class]];
        [talukaMapping addAttributeMappingsFromDictionary:@{@"taluka":@"talukaName"}];
        
        [addressMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateMapping]];
        [addressMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"taluka" withMapping:talukaMapping]];
        [contactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"address" toKeyPath:@"toAddress" withMapping:addressMapping]];
        
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:contactMapping]];
        
        return mapping;
    }
}

- (RKObjectMapping *)searchAccountURLPaginatedMapping
{
    if(searchAccountURLPaginatedMapping){
        return searchAccountURLPaginatedMapping;
    }else{
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        
        [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        
        RKObjectMapping* contactMapping = [RKObjectMapping mappingForClass:[EGAccount class]];
        [contactMapping addAttributeMappingsFromDictionary:@{@"account_id": @"accountID",
                                                             @"account_name": @"accountName",
                                                             @"site_name":@"siteName",
                                                             @"main_phone_number":@"contactNumber",
                                                             @"PAN_number":@"mPAN"
                                                             }];
        
        addressMapping = [RKObjectMapping mappingForClass:[EGAddress class]];
        [addressMapping addAttributeMappingsFromDictionary:@{@"address_line_2": @"addressLine2",
                                                             @"city": @"city",
                                                             @"address_line_1":@"addressLine1",
                                                             @"district":@"district",
                                                             @"area":@"area",
                                                             @"pincode":@"pin",
                                                             @"panchayat":@"panchayat",
                                                             }];
        
        RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[EGState class]];
        [stateMapping addAttributeMappingsFromDictionary:@{@"code":@"code",
                                                           @"name":@"name"
                                                           }];
        RKObjectMapping *talukaMapping = [RKObjectMapping mappingForClass:[EGTaluka class]];
        [talukaMapping addAttributeMappingsFromDictionary:@{@"taluka":@"talukaName"}];
        
        [addressMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateMapping]];
        [addressMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"taluka" withMapping:talukaMapping]];
        [contactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"address" toKeyPath:@"toAddress" withMapping:addressMapping]];
        
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:contactMapping]];
        
        return mapping;
    }
}

-(RKObjectMapping *)stateListURLMapping{
    if(stateListURLMapping){
        return stateListURLMapping;
    }else{
        stateListURLMapping = [RKObjectMapping mappingForClass:[EGState class]];
        [stateListURLMapping addAttributeMappingsFromDictionary:@{
                                                           @"code":@"code",
                                                           @"name":@"name"
                                                           }];
        return stateListURLMapping;
    }
}

//Done
-(RKObjectMapping *)locationByTalukaListURLMapping{
    if(locationByTalukaListURLMapping){
        return locationByTalukaListURLMapping;
    }else{
        
        
        locationByTalukaListURLMapping = [RKObjectMapping mappingForClass:[EGTaluka class]];
        [locationByTalukaListURLMapping addAttributeMappingsFromDictionary:@{
                                                           @"city_name":@"city",
                                                           @"district_name":@"district",
                                                           @"taluka_name":@"talukaName"
                                                           }];
        [locationByTalukaListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateListURLMapping]];
        return locationByTalukaListURLMapping;
    }
}

-(RKObjectMapping *)talukaforpincode{
        RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[EGState class]];
        [stateMapping addAttributeMappingsFromDictionary:@{@"code":@"code",
                                                           @"name":@"name"
                                                           }];

        RKObjectMapping *talukaforpincodeL = [RKObjectMapping mappingForClass:[EGTaluka class]];
        [talukaforpincodeL addAttributeMappingsFromDictionary:@{
                                                            @"city":@"city",
                                                            @"taluka":@"talukaName",
                                                            @"district":@"district",
                                                                             }];
        [talukaforpincodeL addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateMapping]];
        return talukaforpincodeL;
}


-(RKObjectMapping *)PINCODELISTURLMapping{
    if(PINCODELISTURLMapping){
        return PINCODELISTURLMapping;
    }else{
        
        PINCODELISTURLMapping = [RKObjectMapping mappingForClass:[EGPin class]];
        [PINCODELISTURLMapping addAttributeMappingsFromDictionary:@{
                                                                    @"pincodes":@"pincode"
                                                                             }];
        [PINCODELISTURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"taluka" withMapping:self.talukaforpincode]];
        return PINCODELISTURLMapping;
    }
}

-(RKObjectMapping *)pincodelistURLFROMGPSMapping{
    if(pincodelistURLFROMGPSMapping){
        return pincodelistURLFROMGPSMapping;
    }else{
        
        // User Details Mapping
        pincodelistURLFROMGPSMapping = [RKObjectMapping mappingForClass:[EGReversePincode class]];
        [pincodelistURLFROMGPSMapping addAttributeMappingsFromDictionary:@{
                                                                 @"city":@"city",
                                                                 @"district":@"district",
                                                                 @"country":@"country",
                                                                 @"pincode":@"pincode",
                                                                 @"id":@"pinId"
                                                                 }];
        
        RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[EGState class]];
        [stateMapping addAttributeMappingsFromDictionary:@{@"code":@"code",
                                                           @"name":@"name"
                                                           }];
        
        [pincodelistURLFROMGPSMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateMapping]];

        
        return pincodelistURLFROMGPSMapping;
    }
}


//Done
-(RKObjectMapping *)talukaListURLMapping{
    if (talukaListURLMapping) {
        return talukaListURLMapping;
    }else{
        RKObjectMapping *talukaMapping = [RKObjectMapping mappingForClass:[EGTaluka class]];
        [talukaMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"talukaName"]];
        talukaListURLMapping = talukaMapping;
        return talukaListURLMapping;
    }
}
#pragma mark - Financier

-(RKObjectMapping *)fetchFinancierQuotesURLMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
    
    fetchFinancierQuotesURLMapping = [RKObjectMapping mappingForClass:[FinancierListDetailModel class]];
    [fetchFinancierQuotesURLMapping addAttributeMappingsFromDictionary:
     @{
       
           @"comment"                   : @"comment",
           @"branch_id"                 : @"branchID",
           //parent
           @"financier_name"            : @"financierName",
           @"opty_id"                   : @"optyID",
           @"financier_case_status"     : @"caseStatus",
           @"financier_quote_id"        : @"financierQuoteId",  //used for caseID label
           @"financier_status"          : @"integrationStatus",
           @"quote_status_update_time"  : @"lastUpdatedStatus", //used for last Updated label
           
           //child
           @"financier_approved_amount" :@"eligibilityAmt",
           @"financier_quote_rate"      :@"irrPercent",
           @"financier_quote_emi"       :@"emiAmt",
           @"financier_quote_type"      :@"schemeType",
           @"bdm_name"                  :@"contactName",
           @"bdm_mobile_no"             :@"contactNo",
           //other
           @"financier_id"              :@"financierID",
           @"financier_quote_tenor"     :@"financierQuoteTenor",
           @"financier_quote_date"      :@"financierQuoteDate",
           @"quote_submission_time"     :@"quoteSubmissionTime",

           //Financier field Model Objects
           @"organization"          : @"organization",
           @"relationship_type": @"relationship_type",
           @"indicative_loan_ammout": @"indicative_loan_ammout",
           @"coapplicant_first_name": @"coapplicant_first_name",
           @"loandetails_repayable_in_months": @"loandetails_repayable_in_months",
           @"coapplicant_date_of_birth": @"coapplicant_date_of_birth",
           @"ltv": @"ltv",
           @"coapplicant_mobile_no": @"coapplicant_mobile_no",
           @"coapplicant_address2": @"coapplicant_address2",
           @"coapplicant_address1": @"coapplicant_address1",
           @"coapplicant_city_town_village": @"coapplicant_city_town_village",
           @"branch_name": @"branch_name",
           @"bdm_id": @"bdm_id",
           @"customer_type": @"customer_type",
           @"type_of_property": @"type_of_property",
           @"coapplicant_pan_no_indiviual": @"coapplicant_pan_no_indiviual",
           @"fin_occupation": @"fin_occupation",
           @"coapplicant_last_name": @"coapplicant_last_name",
           @"indicative_loan_amt": @"indicative_loan_amt",
           @"coapplicant_pincode": @"coapplicant_pincode",
           
           @"opty_created_date": @"opty_created_date",
           @"emission_norms": @"emission_norms",
           @"pan_no_indiviual": @"pan_no_indiviual",
           @"vc_number": @"vc_number",
           @"ppl": @"ppl",
           @"id_expiry_date": @"id_expiry_date",
           @"body_type": @"body_type",
           @"loandetails_repayableinmonths": @"loandetails_repayableinmonths",
           @"mobile_no": @"mobile_no",
           @"last_name": @"last_name",
           @"lob": @"lob",
           @"first_name": @"first_name",
           @"intended_application": @"intended_application",
           @"district": @"district",
           @"area": @"area",
           @"account_state": @"account_state",
           @"vehicle_color": @"vehicle_color",
           @"customer_subcategory": @"customer_subcategory",
           @"account_pincode": @"account_pincode",
           @"religion": @"religion",
           @"state": @"state",
           @"taluka"  : @"taluka",
           @"date_of_birth": @"date_of_birth",
           @"account_site": @"account_site",
           @"partydetails_occupation": @"partydetails_occupation",
           @"fin_occupation_in_years" : @"fin_occupation_in_years",
           @"usage": @"usage",
           @"address_type": @"address_type",
           @"pl": @"pl",
           @"partydetails_maritalstatus": @"partydetails_maritalstatus",
           @"vehicle_class": @"vehicle_class",
           @"repayment_mode": @"repayment_mode",
           @"loan_tenor": @"loan_tenor",
           @"account_type": @"account_type",
           @"account_address1": @"account_address1",
           @"address1": @"address1",
           @"address2": @"address2",
           @"account_city_town_village": @"account_city_town_village",
           @"account_address2": @"account_address2",
           @"account_district": @"account_district",
           @"account_tahsil_taluka" : @"account_taluka",
           @"sales_person_dse": @"sales_person_dse",
           @"sale_person_dsm": @"sale_person_dsm",
           @"id_issue_date": @"id_issue_date",
           @"id_type": @"id_type",
           @"pan_no_company": @"pan_no_company",
           @"pincode": @"pincode",
           @"ex_showroom_price": @"ex_showroom_price",
           @"inidcative_loan_amt": @"inidcative_loan_amt",
           @"id_description": @"id_description",
           @"gender": @"gender",
           @"title": @"title",
           @"account_name": @"account_name",
           @"channel_type": @"channel_type",
           @"product_id": @"product_id",
           @"partydetails_annualincome": @"partydetails_annualincome",
           @"account_number": @"account_number",
           @"on_road_price_total_amt": @"on_road_price_total_amt",
           @"cust_loan_type": @"cust_loan_type",
           @"customer_category": @"customer_category",
           @"city_town_village": @"city_town_village",
           @"father_mother_spouse_name": @"father_mother_spouse_name",
           @"sales_stage_name" : @"sales_stage_name"
           
       }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:fetchFinancierQuotesURLMapping]];
    
    return mapping;
}

-(RKObjectMapping *)searchOptyFinancierURLMapping
{
   
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
   
        searchOptyFinancierURLMapping = [RKObjectMapping mappingForClass:[EGFinancierOpportunity class]];
        [searchOptyFinancierURLMapping addAttributeMappingsFromDictionary:
       @{
         @"opty_id"                          : @"optyID",
         @"is_quote_submitted_to_financier"  : @"isQuoteSubmittedToFinancier",
         @"is_quote_submitted_to_crm"        : @"isQuoteSubmittedToCrm",
         @"is_time_before_48_hours"          : @"isTimeBefore48Hours",
         @"is_any_case_approved"             : @"isAnyCaseApproved",
         @"is_eligible_for_insert_quote"     : @"is_eligible_for_insert_quote",
         @"is_first_case_rejected"           : @"is_first_case_rejected"
        }];
    
        RKObjectMapping *financierListMapping = [RKObjectMapping mappingForClass:[FinancierListDetails class]];
        [financierListMapping addAttributeMappingsFromDictionary:
         @{
            @"selected_financier_id"         :@"selectedFinancierID",
            @"financier_name"       :@"selectedFinancierName",
           }];

         RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[FinancierContactDetails class]];
         [contactMapping addAttributeMappingsFromDictionary:
          @{
            @"relationship_type"      : @"relationship_type",
            @"taluka"                 : @"taluka",
            @"contact_id"             : @"contact_id",
            @"date_of_birth"          : @"date_of_birth",
            @"gender"                 : @"gender",
            
            @"first_name"             :@"firstName",
            @"last_name"              :@"lastName",
            @"district"               :@"district",
            @"area"                   :@"area",
            @"title"                  :@"title",
            @"pincode"                :@"pincode",
            @"state"                  :@"state",
            @"mobile_no"              :@"mobileno",
            @"city_town_village"      :@"citytownvillage",
            @"pan_number_individual"  :@"pan_number_individual",
            @"address1"               :@"address1",
            @"address2"               :@"address2",
            @"occupation"             :@"occupation"
            
            }];
    
        RKObjectMapping *accountMapping = [RKObjectMapping mappingForClass:[FinancierAccountDetails class]];
        [accountMapping addAttributeMappingsFromDictionary:
         @{
          
           @"account_id"                :@"account_id",
           @"pan_number_company"        :@"pan_number_company",
           @"account_address1"          :@"accountAddress1",
           @"account_address2"          :@"accountAddress2",
           @"account_type"              :@"accountType",
           @"account_state"             :@"accountState",
           @"account_taluka"            :@"account_taluka",
           @"account_district"          :@"accountDistrict",
           @"account_pincode"           :@"accountPinCode",
           @"account_number"            :@"accountNumber",
           @"account_city_town_village" :@"accountCityTownVillage",
           @"account_name"              :@"accountName",
           @"account_site"              :@"accountSite"
           }];
   
    //---------optyMapping------------------------------------------------------------------------------------
    
        RKObjectMapping *optyMapping = [RKObjectMapping mappingForClass:[FinancierOptyDetails class]];
        [optyMapping addAttributeMappingsFromDictionary:
         @{
          
           @"organization_name"             : @"organization_name",
           @"bu_id"                         : @"bu_id",
           @"date_of_birth"                 : @"date_of_birth",
           @"bdm_mobile_no"                 : @"bdm_mobile_no",
           @"pan_number_company"            : @"pan_number_company",
           @"ex_showroom_price"             : @"ex_showroom_price",
           @"bdm_name"                      : @"bdm_name",
           @"on_road_price_total_amt"       : @"on_road_price_total_amt",
           @"customer_type"                 : @"customer_type",
           @"gender"                        : @"gender",
           @"financier_status"              : @"financier_status",
           
           @"lob"                           :@"lob",
           @"opty_created_date"             :@"optyCreatedDate",
           @"intended_application"          :@"intendedApplication",
           @"ppl"                           :@"ppl",
           @"usage"                         :@"usage",
           @"financier_name"                :@"financierName",
           @"opty_id"                       :@"optyID",
           @"pl"                            :@"pl",
           @"product_id"                     :@"productID",
           @"vc_number"                      :@"vcNumber",
           @"channel_type"                   :@"channelType",
           @"body_type"                      :@"bodyType",
           @"organization_id"                :@"organizationID",
           @"div_id"                         :@"DivID",
           @"quantity"                       :@"quantity",
           @"sales_stage_name"               :@"sales_stage_name"
           }];
    
    
    [searchOptyFinancierURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CONTACT_DETAILS" toKeyPath:@"toFinancierContact" withMapping:contactMapping]];
    [searchOptyFinancierURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"OPTY_DETAILS" toKeyPath:@"toFinancierOpty" withMapping:optyMapping]];
    [searchOptyFinancierURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ACCOUNT_DETAILS" toKeyPath:@"toFinancierAccount" withMapping:accountMapping]];
    [searchOptyFinancierURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FINANCIER_DETAILS" toKeyPath:@"toFinancierSelectedFinancier" withMapping:financierListMapping]]; 
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:searchOptyFinancierURLMapping]];
    
    return mapping;
}


//Done
-(RKObjectMapping *)searchOpportunityURLMappingForOpportunity{

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];

    searchOpportunityURLMappingForOpportunity = [RKObjectMapping mappingForClass:[EGOpportunity class]];
    [searchOpportunityURLMappingForOpportunity addAttributeMappingsFromDictionary:
     @{
       @"is_quote_submitted_to_crm"         : @"is_quote_submitted_to_crm",
       @"is_quote_submitted_to_financier"   : @"is_quote_submitted_to_financier",
       @"is_time_before_48_hours"           : @"is_time_before_48_hours",
       @"is_any_case_approved"              : @"is_Any_Case_Approved",
       @"is_eligible_for_insert_quote"      : @"is_eligible_for_insert_quote",
       @"is_first_case_rejected"            : @"is_first_case_rejected",
       //new for exchange details
       @"ppl_for_exchange"                  : @"ppl_for_exchange",
       @"pl_for_exchange"                   : @"pl_for_exchange",
       @"registration_no"                   : @"registration_no",
       @"milage"                            : @"milage",
       @"age_of_vehicle"                    : @"age_of_vehicle",
       @"tml_src_chassisnumber"             : @"tml_src_chassisnumber",
       @"tml_ref_pl_id"                     : @"tml_ref_pl_id",
       @"tml_src_assset_id"                 : @"tml_src_assset_id",
       @"interested_in_exchange"            : @"interested_in_exchange",
       
       @"rev_prod_id":@"rev_productID",
       @"lead_assigned_position":@"leadAssignedPosition",
       @"live_deal":@"isLiveDeal",
       @"sales_stage_name":@"salesStageName",
       @"referral_type":@"reffralType",
       @"ppl":@"ppl",
       @"source_of_contact" : @"sourceOfContact",
       @"sales_stage_name_updated_date":@"saleStageUpdatedDate",
       @"prospect_type":@"prospectType",
       @"lob":@"lob",
       @"id_local":@"idLocal",
       @"detailed_remark": @"competitorRemark",
       @"competitor": @"competitor",
       @"product_category":@"productCatagory",
       @"influencer":@"influencer",
       @"opty_name":@"opportunityName",
       @"from_context":@"fromContext",
       @"lead_assigned_phone_number":@"leadAssignedPhoneNumber",
       @"competitor_model":@"competitorModel",
       @"business_unit":@"businessUnit",
       @"lost_make":@"lostMake",
       @"opportunity_id":@"optyID",
       @"opty_creation_date":@"opportunityCreatedDate",
       @"sales_stage_name_date":@"saletageDate",
       @"opportunity_status":@"opportunityStatus",
       @"lost_reason":@"lostReson",
       @"lead_assigned_name":@"leadAssignedName",
       @"license":@"license",
       @"lost_model":@"lostModel",
       @"pl":@"pl",
       @"lead_assigned_position_id":@"leadAssignedPositionID",
       @"quantity":@"quantity",
       @"nfa_status" : @"nfaStatus",
       @"nfa_number" : @"nfaNumber",
       @"invoice_count" : @"invoiceCount",
       @"event_id" : @"eventID",
       @"event_name" : @"eventName"
       }];
    // define relationship mapping
    //---------VC------------------------------------------------------------------------------------
    RKObjectMapping *potentialDropOffMapping = [RKObjectMapping mappingForClass:[EGPotentialDropOff class]];
    [potentialDropOffMapping addAttributeMappingsFromDictionary:@{
                                                                  @"potential_drop_of_reason" : @"potential_drop_of_reason",
                                                                  @"intervention_support" :@"intervention_support",
                                                                  @"stakeholder_responsible" : @"stakeholder_responsible",
                                                                  @"stakeholder_response" : @"stakeholder_response"
                                                                  }];

    RKObjectMapping *vcDetails = [RKObjectMapping mappingForClass:[EGVCNumber class]];
    [vcDetails addAttributeMappingsFromDictionary:
     @{
       @"vc_number": @"vcNumber",
       @"product_name": @"productName",
       @"product_name_1": @"productName1",
       @"vc_description": @"productDescription",
       @"product_category":@"productCatagory",
       @"qty":@"quantity",
       @"lob": @"lob",
       @"ppl": @"ppl",
       @"pl": @"pl",
       @"vc_id": @"productID"
       }];
    //-----------------------------------------------------------------------------------------------

    //--------TGM------------------------------------------------------------------------------------
    RKObjectMapping *tGMMapping = [RKObjectMapping mappingForClass:[EGTGM class]];
    [tGMMapping addAttributeMappingsFromDictionary:
     @{
       @"main_number": @"mainPhoneNumber",
       @"account_id": @"accountID",
       @"account_name": @"accountName"
       }];
    //-----------------------------------------------------------------------------------------------


    RKObjectMapping *lobInformation = [RKObjectMapping mappingForClass:[EGLOBInfo class]];
    [lobInformation addAttributeMappingsFromDictionary:@{
                                                         @"total_fleet_size": @"totalFleetSize",
                                                         @"tml_fleet_size": @"tmlFleetSize",
//                                                         @"speed_governer": @"speed_governer",
                                                         @"mm_geography": @"mmGeography",
                                                         @"vehicle_application": @"vehicleApplication",
                                                         @"customer_type": @"customerType",
                                                         @"body_type": @"bodyType",
                                                         @"usage_category": @"usageCategory"
                                                         }];
    

    
    //---------Broker-------------------------------------------------------------------------------
    RKObjectMapping *brokerMapping = [RKObjectMapping mappingForClass:[EGBroker class]];
    [brokerMapping addAttributeMappingsFromDictionary:
     @{
       @"main_number": @"mainPhoneNumber",
       @"account_id": @"accountID",
       @"account_name": @"accountName"
       }];
    //-----------------------------------------------------------------------------------------------
    
    //---------referral-------------------------------------------------------------------------------
    RKObjectMapping *referralMapping = [RKObjectMapping mappingForClass:[EGReferralCustomer class]];
    [referralMapping addAttributeMappingsFromDictionary:
     @{
       @"phone_number": @"cellPhoneNumber",
       @"first_name": @"firstName",
       @"last_name": @"lastName",
       @"cust_id": @"rowID"
       }];
    //------------------------------------------------------------------------------------------------
    
    //---------financer-------------------------------------------------------------------------------
    RKObjectMapping *financerMapping = [RKObjectMapping mappingForClass:[EGFinancier class]];
    [financerMapping addAttributeMappingsFromDictionary:
     @{
       @"account_name": @"financierName",
       @"account_id": @"financierID"
       }];
    //-------------------------------------------------------------------------------------------------

    
    //---------Campaign--------------------------------------------------------------------------------
    RKObjectMapping *campaignMapping = [RKObjectMapping mappingForClass:[EGCampaign class]];
    [campaignMapping addAttributeMappingsFromDictionary:
     @{
       @"name": @"campaignName",
       @"id": @"campaignID"
       }];
    //-------------------------------------------------------------------------------------------------

    
    //---------Contact---------------------------------------------------------------------------------

    RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[EGContact class]];
    [contactMapping addAttributeMappingsFromDictionary:
     @{
       @"contact_id": @"contactID",
       @"mobile_number": @"contactNumber",
       @"email": @"emailID",
       @"pan": @"panNumber",
       @"primary_account_id":@"primary_account_id",
       @"first_name":@"firstName",
       @"last_name":@"lastName"
       }];
    
    RKObjectMapping *address = [RKObjectMapping mappingForClass:[EGAddress class]];
    [address addAttributeMappingsFromDictionary:@{
                                                  @"address_line_2": @"addressLine2",
                                                  @"city": @"city",
                                                  @"address_line_1":@"addressLine1",
                                                  @"district":@"district",
                                                  @"area":@"area",
                                                  @"pincode":@"pin",
                                                  @"panchayat":@"panchayat",
                                                  @"tehsil":@"tehsil"
                                                  }];
    
    RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[EGState class]];
    [stateMapping addAttributeMappingsFromDictionary:@{@"code":@"code",
                                                       @"name":@"name"
                                                       }];
    RKObjectMapping *talukaMapping = [RKObjectMapping mappingForClass:[EGTaluka class]];
    [talukaMapping addAttributeMappingsFromDictionary:@{@"taluka":@"talukaName"}];
    
    [address addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state" toKeyPath:@"state" withMapping:stateMapping]];
    [address addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"taluka" withMapping:talukaMapping]];
    
    [contactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"address" toKeyPath:@"toAddress" withMapping:address]];
    //-------------------------------------------------------------------------------------------------

    
    //---------Account---------------------------------------------------------------------------------
    RKObjectMapping *accountMapping = [RKObjectMapping mappingForClass:[EGAccount class]];
    [accountMapping addAttributeMappingsFromDictionary:
     @{
       @"site_name":@"siteName",
       @"account_id":@"accountID",
       @"account_name":@"accountName",
       @"main_phone_number":@"contactNumber"
       }];
    [accountMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"primary_contact" toKeyPath:@"toContact" withMapping:contactMapping]];
    [accountMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"address" toKeyPath:@"toAddress" withMapping:addressMapping]];
    //--------------------------------------------------------------------------------------------------
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"potential_drop" toKeyPath:@"toPotentialDropOff" withMapping:potentialDropOffMapping]];

    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lob_information" toKeyPath:@"toLOBInfo" withMapping:lobInformation]];
    
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"account" toKeyPath:@"toAccount" withMapping:accountMapping]];
    
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"toContact" withMapping:contactMapping]];
    
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"campaign" toKeyPath:@"toCampaign" withMapping:campaignMapping]];
    
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"financier" toKeyPath:@"toFinancier" withMapping:financerMapping]];
    
    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"referral_customer" toKeyPath:@"toReferral" withMapping:referralMapping]];

    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"broker" toKeyPath:@"toBroker" withMapping:brokerMapping]];

    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tgm_data" toKeyPath:@"toTGM" withMapping:tGMMapping]];

    [searchOpportunityURLMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"vc_data" toKeyPath:@"toVCNumber" withMapping:vcDetails]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:searchOpportunityURLMappingForOpportunity]];
    return mapping;

}
//-------------------------------------------------------------------------------------------------------------------------------------------


//API Pending ------------------------------------------------------------------------------------------------------------------------------------------
-(RKObjectMapping *)campaignList{
    if(campaignList){
        return campaignList;
    }else{
        RKObjectMapping *campaignMapping = [RKObjectMapping mappingForClass:[EGCampaign class]];
        [campaignMapping addAttributeMappingsFromDictionary:
         @{
           @"name": @"campaignName",
           @"id": @"campaignID",
           @"description":@"campaignDescription"
           }];
        campaignList = campaignMapping;
        return campaignList;
    }
}

- (RKObjectMapping *)DSEList {
    if (DSEList) {
        return DSEList;
    }
    else {
        DSEList = [RKObjectMapping mappingForClass:[EGDse class]];
        [DSEList addAttributeMappingsFromDictionary:@{
                                                      @"position_name": @"leadAssignedPositionName",
                                                      @"position_id": @"leadAssignedPositionID",
                                                      @"position_type":@"leadAssignedPositionType",
                                                      @"first_name":@"FirstName",
                                                      @"last_name":@"LastName",
                                                      @"login":@"leadLogin",
                                                      @"id":@"leadid"

                                                                }];
        return DSEList;
    }
}

#pragma mark - Create Opportunity

//Done
- (RKObjectMapping *)lobListURLMapping {
    if (lobListURLMapping) {
        return lobListURLMapping;
    }
    else {
        lobListURLMapping = [RKObjectMapping mappingForClass:[EGLob class]];
        [lobListURLMapping addAttributeMappingsFromDictionary:@{
                                                           @"name":@"lobName",
                                                           @"id":@"lobId"
                                                           }];
        return lobListURLMapping;
    }
}

// No Data Comming From API
- (RKObjectMapping *)pplListURLMapping {
    if (pplListURLMapping) {
        return pplListURLMapping;
    }
    else {
        pplListURLMapping = [RKObjectMapping mappingForClass:[EGPpl class]];
        [pplListURLMapping addAttributeMappingsFromDictionary:@{
                                                         @"name":@"pplName",
                                                         @"id":@"pplId"
                                                         }];
        return pplListURLMapping;
    }
}

- (RKObjectMapping *)plListURLMapping {
    if (plListURLMapping) {
        return plListURLMapping;
    }
    else {
        plListURLMapping = [RKObjectMapping mappingForClass:[EGPl class]];
        [plListURLMapping addAttributeMappingsFromDictionary:@{
                                                         @"name":@"plName",
                                                         @"id":@"plId"
                                                         }];
        return plListURLMapping;
    }
}

- (RKObjectMapping *)financierURLMapping {
    if (financierURLMapping) {
        return financierURLMapping;
    }
    else {
        financierURLMapping = [RKObjectMapping mappingForClass:[EGFinancier class]];
        [financierURLMapping addAttributeMappingsFromDictionary:@{
                                                        @"account_name":@"financierName",
                                                        @"account_id":@"financierID"
                                                        }];
        return financierURLMapping;
    }
}

- (RKObjectMapping *)campaignURLMapping {
    if (campaignURLMapping) {
        return campaignURLMapping;
    }
    else {
        campaignURLMapping = [RKObjectMapping mappingForClass:[EGCampaign class]];
        [campaignURLMapping addAttributeMappingsFromDictionary:@{
                                                        @"name":@"campaignName",
                                                        @"description":@"campaignDescription",
                                                        @"id":@"campaignID"
                                                        }];
        return campaignURLMapping;
    }
}

- (RKObjectMapping *)referralCustomerURLMapping {
    if (referralCustomerURLMapping) {
        return referralCustomerURLMapping;
    }
    else {
        referralCustomerURLMapping = [RKObjectMapping mappingForClass:[EGReferralCustomer class]];
        [referralCustomerURLMapping addAttributeMappingsFromDictionary:@{
                                                        @"cust_id":@"rowID",
                                                        @"last_name":@"lastName",
                                                        @"phone_number":@"cellPhoneNumber",
                                                        @"first_name":@"firstName"
                                                        }];
        return referralCustomerURLMapping;
    }
}

- (RKObjectMapping *)tgmURLMapping {
    if (tgmURLMapping) {
        return tgmURLMapping;
    }
    else {
        tgmURLMapping = [RKObjectMapping mappingForClass:[EGTGM class]];
        [tgmURLMapping addAttributeMappingsFromDictionary:@{
                                                                      @"main_number":@"mainPhoneNumber",
                                                                      @"account_name":@"accountName",
                                                                      @"account_id":@"accountID"                                                                      }];
        return tgmURLMapping;
    }
}

- (RKObjectMapping *)brokerDetailsURLMapping {
    if (brokerDetailsURLMapping) {
        return brokerDetailsURLMapping;
    }
    else {
        brokerDetailsURLMapping = [RKObjectMapping mappingForClass:[EGBroker class]];
        [brokerDetailsURLMapping addAttributeMappingsFromDictionary:@{
                                                                      @"main_number":@"mainPhoneNumber",
                                                                      @"account_id":@"accountID",
                                                                      @"account_name":@"accountName"
                                                                      }];
        return brokerDetailsURLMapping;
    }
}

- (RKObjectMapping *)vcListURLMapping {
    if (vcListURLMapping) {
        return vcListURLMapping;
    }
    else {
        RKObjectMapping *vcObjMapping = [RKObjectMapping mappingForClass:[EGVCNumber class]];
        [vcObjMapping addAttributeMappingsFromDictionary:@{
                                                                   @"lob":@"lob",
                                                                   @"description":@"productDescription",
                                                                   @"pl":@"pl",
                                                                   @"ppl":@"ppl",
                                                                   @"vc_number":@"vcNumber"
                                                                   }];
        
        vcListURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [vcListURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [vcListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:vcObjMapping]];
        
        return vcListURLMapping;
    }
}

- (RKObjectMapping *)searchActivityURLMapping {
    if (searchActivityURLMapping) {
        return searchActivityURLMapping;
    }
    else {
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[EGActivity class]];
        
        [objectMapping addAttributeMappingsFromDictionary:@{
                                                               @"status":@"status",
                                                               @"activity_id":@"activityID",
                                                               @"Comments_long_s":@"activityDescription",
                                                               @"todo_plan_end_dt_dt":@"endDate",
                                                               @"todo_cd_s":@"activityType",
                                                               @"todo_plan_start_dt_dt":@"planedDate",
                                                               @"account_owner_login" : @"stakeholder",
                                                               @"response" : @"stakeholderResponse",
                                                               @"sub_type" : @"activitySubtype",
                                                               @"is_junk" : @"junk"
                                                               }];
        


        
        [objectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"opts_metadata" toKeyPath:@"toOpportunity" withMapping:[self searchActivityMappingForOpportunity]]];
        
        searchActivityURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [searchActivityURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [searchActivityURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:objectMapping]];
        
        return searchActivityURLMapping;
    }
}

- (RKObjectMapping *)searchActivityMappingForOpportunity {
    if (searchActivityMappingForOpportunity) {
        return searchActivityMappingForOpportunity;
    }
    else {
        searchActivityMappingForOpportunity = [RKObjectMapping mappingForClass:[EGOpportunity class]];
        [searchActivityMappingForOpportunity addAttributeMappingsFromDictionary:@{
                                                                       @"opty_id_s":@"optyID",
                                                                       @"curr_stg_name":@"salesStageName",
                                                                       @"pplname":@"ppl",
                                                                       @"dse_first_name":@"leadAssignedName",
                                                                       @"dse_last_name":@"leadAssignedLastName"
                                                                       }];
        //---------Contact---------------------------------------------------------------------------------
        
        RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[EGContact class]];
        [contactMapping addAttributeMappingsFromDictionary:
         @{
           @"cell_ph_num_s": @"contactNumber",
           @"fst_name_s":@"firstName",
           @"last_name_s":@"lastName",
           @"contact_id" : @"contactID"
           }];
        
        [searchActivityMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"toContact" withMapping:contactMapping]];
        //-------------------------------------------------------------------------------------------------
        RKObjectMapping *vcMapping = [RKObjectMapping mappingForClass:[EGVCNumber class]];
        [vcMapping addAttributeMappingsFromDictionary:@{
                                                        @"pplname" : @"ppl"
                                                        }];
        [searchActivityMappingForOpportunity addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"toVCNumber" withMapping:vcMapping]];

        return searchActivityMappingForOpportunity;
    }
}

- (RKObjectMapping *)eventMapping {
    if (eventMapping) {
        return eventMapping;
    }
    else {
        eventMapping = [RKObjectMapping mappingForClass:[EGEvent class]];
        [eventMapping addAttributeMappingsFromDictionary:@{
                                                           @"event_id":@"mEventID",
                                                           @"event_name":@"mEventName"
                                                           }];
        
        return eventMapping;
    }
}

#pragma mark - LOGIN

- (RKObjectMapping *)loginURLMapping {
    if (loginURLMapping) {
        return loginURLMapping;
    }
    else {
        
        // Token Mapping
        RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[EGToken class]];
        [tokenMapping addAttributeMappingsFromDictionary:@{
                                                           @"access_token":@"accessToken",
                                                           @"token_type":@"tokenType",
                                                           @"expires_in":@"expiresIn",
                                                           @"refresh_token":@"refreshToken",
                                                           @"scope":@"scope"
                                                           }];
        
        // User Details Mapping
        RKObjectMapping *userDetailsMapping = [RKObjectMapping mappingForClass:[EGUserData class]];
        [userDetailsMapping addAttributeMappingsFromDictionary:@{
                                                                 @"lob":@"lob",
                                                                 @"postn_type_cd":@"positionType",
                                                                 @"primary_postnid":@"primaryPositionID",
                                                                 @"primary_emp":@"primaryEmployeeID",
                                                                 @"dealer_code" :@"dealerCode",
                                                                 @"organization_name" : @"organizationName",      @"position_id":@"positionID",
                                                                 @"lob_name_s":@"lobName",
                                                                 @"lob_row_id_s":@"lobRowID",
                                                                 @"lob_x_bu_unit_s":@"lobBUUnit",
//                                                                 @"organization_name":@"organization_name",  for later use
                                                                 @"organization_id":@"organizationID",
                                                                 @"dsm_name":@"dsmName",
                                                                 @"lob_x_service_tax_flg_s":@"lobServiceTaxFlag",
                                                                 @"position_name":@"positionName",
                                                                 @"emp_row_id":@"employeeRowID",
                                                                 @"user_login_s":@"userName",
                                                                 @"postn_pr_emp_cell_ph_num_s":@"primaryEmployeeCellNum",
                                                                 @"user_state":@"userState"
                                                                 }];
        
        
        loginURLMapping = [RKObjectMapping mappingForClass:[Login class]];
        
        [loginURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"token" toKeyPath:@"token" withMapping:tokenMapping]];
        [loginURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"usersArray" withMapping:userDetailsMapping]];
        
        return loginURLMapping;
    }
}







- (RKObjectMapping *)accessTokenMapping {
    if (accessTokenMapping) {
        return accessTokenMapping;
    }
    else {
        accessTokenMapping = [RKObjectMapping mappingForClass:[EGToken class]];
        [accessTokenMapping addAttributeMappingsFromDictionary:@{
                                                                 @"access_token":@"accessToken",
                                                                 @"token_type":@"tokenType",
                                                                 @"expires_in":@"expiresIn",
                                                                 @"refresh_token":@"refreshToken",
                                                                 @"scope":@"scope"
                                                                 }];
        return accessTokenMapping;
    }
}

- (RKObjectMapping *)c0Mapping {
    RKObjectMapping *c0Mapping = [RKObjectMapping mappingForClass:[C0Model class]];
    [c0Mapping addAttributeMappingsFromDictionary:@{
                                                    @"C0" : @"optyCount",
                                                    @"C0_Qty" : @"vehicleCount"
                                                    }];
    return c0Mapping;
}

- (RKObjectMapping *)c1Mapping {
    RKObjectMapping *c1Mapping = [RKObjectMapping mappingForClass:[C1Model class]];
    [c1Mapping addAttributeMappingsFromDictionary:@{
                                                    @"C1" : @"optyCount",
                                                    @"C1_Qty" : @"vehicleCount"
                                                    }];
    return c1Mapping;
}

- (RKObjectMapping *)c1AMapping {
    RKObjectMapping *c1AMapping = [RKObjectMapping mappingForClass:[C1AModel class]];
    [c1AMapping addAttributeMappingsFromDictionary:@{
                                                     @"C1A" : @"optyCount",
                                                     @"C1A_Qty" : @"vehicleCount"
                                                    }];
    return c1AMapping;
}

- (RKObjectMapping *)c2Mapping {
    RKObjectMapping *c2Mapping = [RKObjectMapping mappingForClass:[C2Model class]];
    [c2Mapping addAttributeMappingsFromDictionary:@{
                                                    @"C2" : @"optyCount",
                                                    @"C2_Qty" : @"vehicleCount"
                                                     }];
    return c2Mapping;
}

- (RKObjectMapping *)pipeLineMapping {
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[PipelineModel class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"name" : @"name"
                                                        }];
    
    [objectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c0Model" withMapping:[self c0Mapping]]];
    [objectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1Model" withMapping:[self c1Mapping]]];
    [objectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1AModel" withMapping:[self c1AMapping]]];
    [objectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c2Model" withMapping:[self c2Mapping]]];
    
    return objectMapping;
}

- (RKObjectMapping *)dashboardMapping {
    if (dashboardMapping) {
        return dashboardMapping;
    }
    else {
        
        dashboardMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [dashboardMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [dashboardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:[self pipeLineMapping]]];
        
        return dashboardMapping;
    }
}

- (RKObjectMapping *)PPLwisePipelineURLMapping {
    if (PPLwisePipelineURLMapping) {
        return PPLwisePipelineURLMapping;
    }
    else {
        
        RKObjectMapping *plobjectMapping = [RKObjectMapping mappingForClass:[PLDataModel class]];
        [plobjectMapping addAttributeMappingsFromDictionary:@{
                                                              @"name" : @"plName"
                                                              }];
        [plobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c0Model" withMapping:[self c0Mapping]]];
        [plobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1Model" withMapping:[self c1Mapping]]];
        [plobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1AModel" withMapping:[self c1AMapping]]];
        [plobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c2Model" withMapping:[self c2Mapping]]];
        [plobjectMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.stock" toKeyPath:@"currentStockpl"]];
        RKObjectMapping *pplobjectMapping = [RKObjectMapping mappingForClass:[PPLDataModel class]];
        [pplobjectMapping addAttributeMappingsFromDictionary:@{
                                                              @"name" : @"pplName"
                                                              }];
        [pplobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values.pl_details" toKeyPath:@"plDetailsArray" withMapping:plobjectMapping]];
        [pplobjectMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.stock" toKeyPath:@"currentStock"]];
        [pplobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c0Model" withMapping:[self c0Mapping]]];
        [pplobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1Model" withMapping:[self c1Mapping]]];
        [pplobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c1AModel" withMapping:[self c1AMapping]]];
        [pplobjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"c2Model" withMapping:[self c2Mapping]]];
        
        PPLwisePipelineURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [PPLwisePipelineURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [PPLwisePipelineURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:pplobjectMapping]];
        
        return PPLwisePipelineURLMapping;
    }
}



- (RKObjectMapping *)DSEwisePipelineURLMapping {
    if (DSEwisePipelineURLMapping) {
        return DSEwisePipelineURLMapping;
    }
    else {
        
        RKObjectMapping *dseMapping = [RKObjectMapping mappingForClass:[EGDse class]];
        [dseMapping addAttributeMappingsFromDictionary:@{
                                                         @"dse_name" : @"DSEName",
                                                         @"id":    @"leadid",
                                                         @"dsm_name": @"DSMName"
                                                              }];
        [dseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C0Model" withMapping:[self c0Mapping]]];
        [dseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C1Model" withMapping:[self c1Mapping]]];
        [dseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C1AModel" withMapping:[self c1AMapping]]];
        [dseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C2Model" withMapping:[self c2Mapping]]];
        [dseMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.stretch_target" toKeyPath:@"Stretch_target"]];
        [dseMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.actual_target" toKeyPath:@"Actual_target"]];
        [dseMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.retail" toKeyPath:@"Retail"]];
        
        DSEwisePipelineURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [DSEwisePipelineURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [DSEwisePipelineURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:dseMapping]];
        
        return DSEwisePipelineURLMapping;
    }
}

//- (RKObjectMapping *)ActualVsTargetURLMapping {
//    if (ActualVsTargetURLMapping) {
//        return ActualVsTargetURLMapping;
//    }
//    else {
//        
//        RKObjectMapping *actualvstargetMapping = [RKObjectMapping mappingForClass:[EGActualVsTarget class]];
//        [actualvstargetMapping addAttributeMappingsFromDictionary:@{
//                                                         @"dse_name" : @"DSEName",
//                                                         @"id":    @"leadid",
//                                                         @"dsm_name":    @"DSMName"
//                                                         }];
//        [actualvstargetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C0Model" withMapping:[self c0Mapping]]];
//        [actualvstargetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C1Model" withMapping:[self c1Mapping]]];
//        [actualvstargetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C1AModel" withMapping:[self c1AMapping]]];
//        [actualvstargetMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"values" toKeyPath:@"C2Model" withMapping:[self c2Mapping]]];
//        [actualvstargetMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.stretch_target" toKeyPath:@"Stretch_target"]];
//        [actualvstargetMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.actual_target" toKeyPath:@"Actual_target"]];
//        [actualvstargetMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"values.retail" toKeyPath:@"Retail"]];
//        
//        ActualVsTargetURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
//        [ActualVsTargetURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
//        [ActualVsTargetURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:actualvstargetMapping]];
//        
//        return ActualVsTargetURLMapping;
//    }
//}
//

- (RKObjectMapping *)DSEMiswisePipelineURLMapping {
    if (DSEMiswisePipelineURLMapping) {
        return DSEMiswisePipelineURLMapping;
    }
    else {
        
        RKObjectMapping *dseMapping = [RKObjectMapping mappingForClass:[EGMisSummary class]];
        [dseMapping addAttributeMappingsFromDictionary:@{
                                                          @"lob" : @"LOB",
                                                          @"dealer_name": @"DealerName",
                                                          @"new_invoice_count": @"NewInvoiceCount",
                                                          @"cancelled_count": @"CancelledCount",
                                                          @"net_invoice": @"NetInvoice",
                                                          @"year": @"Year",
                                                          @"month": @"Month",
                                                          @"dsename": @"dseUserID",
                                                          @"dse_full_name": @"dseName",
                                                          @"ppl": @"PPL"}];
        
        DSEMiswisePipelineURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [DSEMiswisePipelineURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [DSEMiswisePipelineURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:dseMapping]];
        
        return DSEMiswisePipelineURLMapping;
    }
}


- (RKObjectMapping *)DSEMisDetailswisePipelineURLMapping {
    if (DSEMisDetailswisePipelineURLMapping) {
        return DSEMisDetailswisePipelineURLMapping;
    }
    else {
        
        RKObjectMapping *MisDetailsMapping = [RKObjectMapping mappingForClass:[EGMISDetails class]];
        [MisDetailsMapping addAttributeMappingsFromDictionary:@{
                                                         @"lob" : @"LOB",
                                                         @"customer_name": @"CustomerName",
                                                         @"customer_city": @"CustomerCity",
                                                         @"customer_taluka": @"CustomerTaluka",
                                                         @"ppl": @"PPL",
                                                         @"financier_name": @"FinancierName",
                                                         @"fiscal_year": @"FiscalYear",
                                                         @"month_name": @"MonthName",
                                                         @"employee_login": @"EmployeeLogin",
                                                         @"invoice_no": @"InvoiceNumber",
                                                         @"invoice_status": @"InvoiceStatus",
                                                         @"invoice_date": @"InvoiceDate",
                                                         @"year": @"Year"}];
        
        DSEMisDetailswisePipelineURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [DSEMisDetailswisePipelineURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [DSEMisDetailswisePipelineURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:MisDetailsMapping]];
        
        return DSEMisDetailswisePipelineURLMapping;
    }
}




- (RKObjectMapping *)opportunityMapping {
    if (opportunityMapping) {
        return opportunityMapping;
    }
    else {
        
        RKObjectMapping *lobInfoMapping = [RKObjectMapping mappingForClass:[EGLOBInfo class]];
        [lobInfoMapping addAttributeMappingsFromDictionary:@{
                                                             @"customer_type" : @"customerType",
                                                             @"vehicle_application" : @"vehicleApplication",
                                                             @"body_type" : @"bodyType",
                                                             @"mm_geography" : @"mmGeography",
                                                             @"tml_fleet_size" : @"tmlFleetSize",
                                                             @"total_fleet_size" : @"totalFleetSize",
                                                             @"usage_category" : @"usageCategory"
                                                             }];
        
        RKObjectMapping *accountMapping = [RKObjectMapping mappingForClass:[EGAccount class]];
        [accountMapping addAttributeMappingsFromDictionary:@{
                                                             @"account_id" : @"accountID",
                                                             @"account_name" : @"accountName",
                                                             @"site" : @"siteName",
                                                             @"contact_id" : @"contactID"
                                                             }];
        
        RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[EGContact class]];
        [contactMapping addAttributeMappingsFromDictionary:@{
                                                             @"contact_id" : @"contactID",
                                                             @"mobile_number" : @"contactNumber",
                                                             @"email" : @"emailID",
                                                             @"first_name" : @"firstName",
                                                             @"last_name" : @"lastName",
                                                             @"pan" : @"panNumber"
                                                             }];
        
        RKObjectMapping *vcMapping = [RKObjectMapping mappingForClass:[EGVCNumber class]];
        [vcMapping addAttributeMappingsFromDictionary:@{
                                                        @"lob" : @"lob",
                                                        @"ppl" : @"ppl",
                                                        @"pl" : @"pl",
                                                        @"vc_number" : @"vcNumber",
                                                        @"vc_id" : @"productID",
                                                        @"vc_description" : @"productDescription",
                                                        @"product_name" : @"productName",
                                                        @"product_name_1" : @"productName1"
                                                        }];
        
        RKObjectMapping *brokerMapping = [RKObjectMapping mappingForClass:[EGBroker class]];
        [brokerMapping addAttributeMappingsFromDictionary:@{
                                                            @"account_id" : @"accountID",
                                                            @"account_name" : @"accountName",
                                                            @"main_number" : @"mainPhoneNumber"
                                                            }];
        
        RKObjectMapping *tgmMapping = [RKObjectMapping mappingForClass:[EGTGM class]];
        [tgmMapping addAttributeMappingsFromDictionary:@{
                                                         @"account_id" : @"accountID",
                                                         @"account_name" : @"accountName",
                                                         @"main_number" : @"mainPhoneNumber"
                                                         }];
        
        RKObjectMapping *campaignMapping = [RKObjectMapping mappingForClass:[EGCampaign class]];
        [campaignMapping addAttributeMappingsFromDictionary:@{
                                                              @"id" : @"campaignID",
                                                              @"name" : @"campaignName"
                                                              }];
        
        RKObjectMapping *financierMapping = [RKObjectMapping mappingForClass:[EGFinancier class]];
        [financierMapping addAttributeMappingsFromDictionary:@{
                                                               @"account_name" : @"financierName",
                                                               @"account_id" : @"financierID"
                                                               }];
        
        RKObjectMapping *referralCustomerMapping = [RKObjectMapping mappingForClass:[EGReferralCustomer class]];
        [referralCustomerMapping addAttributeMappingsFromDictionary:@{
                                                                      @"cust_id" : @"rowID",
                                                                      @"first_name" :@"firstName",
                                                                      @"last_name" : @"lastName",
                                                                      @"phone_number" : @"cellPhoneNumber"
                                                                      }];
       
        RKObjectMapping *exchangeDetailsMapping = [RKObjectMapping mappingForClass:[ExchangeDetails class]];
        [exchangeDetailsMapping addAttributeMappingsFromDictionary:@{
                                                                      @"age_of_vehicle"         : @"age_of_vehicle",
                                                                      @"tml_src_assset_id"      : @"tml_src_assset_id",
                                                                      @"ppl_for_exchange"       : @"ppl_for_exchange",
                                                                      @"tml_ref_pl_id"          : @"tml_ref_pl_id",
                                                                      @"milage"                 : @"milage",
                                                                      @"tml_src_chassisnumber"  : @"tml_src_chassisnumber",
                                                                      @"pl_for_exchange"        : @"pl_for_exchange",
                                                                      @"registration_no"        : @"registration_no",
                                                                      @"interested_in_exchange" : @"interested_in_exchange"
                                                                      }];
        
        RKObjectMapping *potentialDropOffMapping = [RKObjectMapping mappingForClass:[EGPotentialDropOff class]];
        [potentialDropOffMapping addAttributeMappingsFromDictionary:@{
                                                                      @"app_name":@"app_name",
                                                                      @"potential_drop_of_reason" : @"potential_drop_of_reason",
                                                                      @"intervention_support" :@"intervention_support",
                                                                      @"stakeholder_responsible" : @"stakeholder_responsible",
                                                                      @"stakeholder_response" : @"stakeholder_response"
                                                                      }];

        opportunityMapping = [RKObjectMapping mappingForClass:[EGOpportunity class]];
        [opportunityMapping addAttributeMappingsFromDictionary:@{
                                                                 @"opportunity_id" : @"optyID",
                                                                 @"quantity" : @"quantity",
                                                                 @"source_of_contact" : @"sourceOfContact",
                                                                 @"from_context" : @"fromContext",
                                                                 @"id_local" : @"idLocal",
                                                                 @"prospect_type" : @"prospectType",
                                                                 @"lead_assigned_name" : @"leadAssignedName",
                                                                 @"lead_assigned_phone_number" : @"leadAssignedPhoneNumber",
                                                                 @"lead_assigned_position_id" : @"leadAssignedPositionID",
                                                                 @"lead_assigned_position" : @"leadAssignedPosition",
                                                                 @"license" : @"license",
                                                                 @"lost_make" : @"lostMake",
                                                                 @"lost_reason" : @"lostReson",
                                                                 @"lost_model" : @"lostModel",
                                                                 @"opty_creation_date" : @"opportunityCreatedDate",
                                                                 @"opty_name" : @"opportunityName",
                                                                 @"rev_prod_id" : @"rev_productID",
                                                                 @"sales_stage_name" : @"salesStageName",
                                                                 @"sales_stage_name_updated_date" : @"saleStageUpdatedDate",
                                                                 @"live_deal" : @"liveDeal",
                                                                 @"referral_type" : @"reffralType",
                                                                 @"competitor" : @"competitor",
                                                                 @"product_category" : @"productCatagory",
                                                                 @"product_id" : @"productID",
                                                                 @"competitor_model" : @"competitorModel",
                                                                 @"detailed_remark" : @"competitorRemark",
                                                                 @"influencer" : @"influencer",
                                                                 @"business_unit" : @"businessUnit",
                                                                 @"opportunity_status" : @"opportunityStatus",
                                                                 @"product_integration_id" : @"productIntegrationID",
                                                                 @"nfa_status" : @"nfaStatus",
                                                                 @"nfa_number" : @"nfaNumber",
                                                                 @"invoice_count" : @"invoiceCount",
                                                                 @"event_id" : @"eventID",
                                                                 @"event_name" : @"eventName"
                                                                 }];
        
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lob_information" toKeyPath:@"toLOBInfo" withMapping:lobInfoMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"toContact" withMapping:contactMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"account" toKeyPath:@"toAccount" withMapping:accountMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"vc_data" toKeyPath:@"toVCNumber" withMapping:vcMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"broker" toKeyPath:@"toBroker" withMapping:brokerMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tgm_data" toKeyPath:@"toTGM" withMapping:tgmMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"campaign" toKeyPath:@"toCampaign" withMapping:campaignMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"financier" toKeyPath:@"toFinancier" withMapping:financierMapping]];
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"referral_customer" toKeyPath:@"toReferral" withMapping:referralCustomerMapping]];
       
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"potential_drop" toKeyPath:@"toPotentialDropOff" withMapping:potentialDropOffMapping]];
       
        [opportunityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"exchange_details" toKeyPath:@"toExchange" withMapping:exchangeDetailsMapping]];

        
        opportunityMapping.assignsDefaultValueForMissingAttributes = NO;
        return opportunityMapping;
    }
}

- (RKObjectMapping *)financierInsertQuoteMapping {
//    if (financierInsertQuoteMapping) {
//        return financierInsertQuoteMapping;
//    }
//    else {
//        RKObjectMapping *financierBranchMapping = [RKObjectMapping mappingForClass:[FinancierBranchDetailsModel class]];
//        [financierBranchMapping addAttributeMappingsFromDictionary:@{
//                                                                      @"financier_id"   : @"financier_id",
//                                                                      @"financier_name" :@"financier_name",
//                                                                      }];

        financierInsertQuoteMapping = [RKObjectMapping mappingForClass:[FinancierInsertQuoteModel class]];
        [financierInsertQuoteMapping addAttributeMappingsFromDictionary:@{
                                                                     
                                                 @"organization"                    : @"organization",
                                                 @"title"                           : @"title",
                                                 @"father_mother_spouse_name"       : @"father_mother_spouse_name",
                                                 @"gender"                          : @"gender",
                                                 @"first_name"                      : @"first_name",
                                                 @"last_name"                       : @"last_name",
                                                 @"mobile_no"                       : @"mobile_no",
                                                 @"religion"                        : @"religion",
                                                 @"address_type"                    : @"address_type",
                                                 @"address1"                        : @"address1",
                                                 @"address2"                        : @"address2",
                                                 @"area"                            : @"area",
                                                 @"city_town_village"               : @"city_town_village",
                                                 @"state"                           : @"state",
                                                 @"district"                        : @"district",
                                                 @"pincode"                         : @"pincode",
                                                 @"date_of_birth"                   : @"date_of_birth",
                                                 @"customer_category_subcategory"   :@"customer_category_subcategory",
                                                 @"partydetails_maritalstatus"      : @"partydetails_maritalstatus",
                                                 @"intended_application"            : @"intended_application",
                                                 @"account_type"                    : @"account_type",
                                                 @"account_name"                    : @"account_name",
                                                 @"account_site"                    : @"account_site",
                                                 @"account_number"                  : @"account_number",
                                                 @"account_address1"                : @"account_address1",
                                                 @"account_address2"                : @"account_address2",
                                                 @"account_city_town_village"       : @"account_city_town_village",
                                                 @"account_state"                   : @"account_state",
                                                 @"account_district"                : @"account_district",
                                                 @"account_pincode"                 : @"account_pincode",
                                                 @"opty_id"                         : @"opty_id",
                                                 @"opty_created_date"               : @"opty_created_date",
                                                 @"ex_showroom_price"               : @"ex_showroom_price",
                                                 @"on_road_price_total_amt"         : @"on_road_price_total_amt",
                                                 @"pan_no_company"                  : @"pan_no_company",
                                                 @"pan_no_indiviual"                : @"pan_no_indiviual",
                                                 @"id_type"                         : @"id_type",
                                                 @"id_description"                  : @"id_description",
                                                 @"id_issue_date"                   : @"id_issue_date",
                                                 @"id_expiry_date"                  : @"id_expiry_date",
                                                 @"lob"                             : @"lob",
                                                 @"ppl"                             : @"ppl",
                                                 @"pl"                              : @"pl",
                                                 @"usage"                           : @"usage",
                                                 @"vehicle_class"                   : @"vehicle_class",
                                                 @"vehicle_color"                   : @"vehicle_color",
                                                 @"emission_norms"                  : @"emission_norms",
                                                 @"loandetails_repayable_in_months" : @"loandetails_repayable_in_months",
                                                 @"repayment_mode": @"repayment_mode"
                                                 }];
//        [financierInsertQuoteMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"financier_branch_details" toKeyPath:@"toFinancieBranch" withMapping:financierBranchMapping]];
        
        financierInsertQuoteMapping.assignsDefaultValueForMissingAttributes = NO;
        return financierInsertQuoteMapping;
//    }
}


- (RKObjectMapping *)opportunityResponseMapping {
    if (opportunityResponseMapping) {
        return opportunityResponseMapping;
    }
    else {
        opportunityResponseMapping = [RKObjectMapping mappingForClass:[ResponseModel class]];
        [opportunityResponseMapping addAttributeMappingsFromDictionary:@{
                                                                         @"id" : @"ID"
                                                                         }];
        return opportunityResponseMapping;
    }
}

#pragma mark - NFA


- (RKObjectMapping *)getNFAModelMapping {
    
    RKObjectMapping* nfaMapping = [RKObjectMapping mappingForClass:[EGNFA class]];
    [nfaMapping addAttributeMappingsFromDictionary:@{
                                                     @"activity type":@"activity_type",
                                                     @"rsm_position":@"rsmPosition",
                                                     @"spend_category":@"spendCategory",
                                                     @"tsm_position":@"tsmPosition",
                                                     @"user_position":@"userPosition",
                                                     @"tsm_last_name":@"tsmLastName",
                                                     @"tsm_login":@"tsmLogin",
                                                     @"id":@"nfaID",
                                                     @"bu":@"BU",
                                                     @"nfa_ype":@"nfaType",
                                                     @"tsm_first_name":@"tsmFirstName",
                                                     @"tsm_email":  @"tsmEmail",
                                                     @"month_date":  @"monthDate",
                                                     @"spend":@"spend",
                                                     @"support_vehicle":@"supportVehicle",
                                                     @"last_updated_date":@"lastUpdatedDate",
                                                     @"tsm_comment":@"tsmComment",
                                                     @"category_sub_type":@"categorySubType",
                                                     @"created_by":@"createdBy",
                                                     @"instance_id": @"instanceID",
                                                     @"tsm_mobile": @"tsmMobile",
                                                     @"region":@"region",
                                                     @"last_approver":@"lastApprover",
                                                     @"nfa_request_number": @"nfaRequestNumber",
                                                     @"rsm_login":@"rsmLogin",
                                                     @"created_date": @"createdDate",
                                                     @"rsm_email":@"rsmEmail",
                                                     @"opty_sales_stage" : @"optySalesStage",
                                                     @"rsm_comment" : @"rsmComment",
                                                     @"lob_head_comment" : @"lobHeadComment",
                                                     @"marketing_head_comment" : @"marketingHeadComment",
                                                     @"rm_comment" : @"rmComment",
                                                     @"opty_created_date":@"optyCreatedDate",
                                                     @"quantity":@"quantity",
                                                     @"dsm_requested_amt":@"dsmRequestedAmount",
                                                     @"dsm_deal_size":@"dsmDealSize",
                                                     @"req_amt_per_vehicle":@"reqAmountPerVehicle",
                                                     @"total_req_amt":@"totalReqAmount",
                                                     @"req_deal_size":@"reqDealSize",
                                                     @"competitor_fleet_size":@"competitorFleetSize",
                                                     @"declaration":@"declaration",
                                                     @"final_status":@"finalStatus",
                                                     @"status":@"status",
                                                     @"next_authority":@"nextAuthority"
                                                     }];
    
    // ---------------------------------------- nfaDealerAndCustomerDetails ---------------------------------------------
    
    RKObjectMapping *nfaDealerAndCustomerDetails = [RKObjectMapping mappingForClass:[NFADealerAndCustomerDetails class]];
    [nfaDealerAndCustomerDetails addAttributeMappingsFromDictionary:
     @{
       @"opty_id": @"oppotunityID",
       @"dealer_code": @"dealerCode",
       @"dealer_name": @"dealerName",
       @"account_name": @"accountName",
       @"location":@"location",
       @"application":@"mmIntendedApplication",
       @"tml_fleet_size": @"tmlFleetSize",
       @"overall_fleet_size": @"overAllFleetSize",
       @"deal_type": @"dealType",
       @"customer_name_actual": @"customerName",
       @"additional_customer": @"additionalCustomers",
       @"dsm_comment": @"customerComments",
       @"vehicle_reg_state": @"vehicleRegistrationState",
       @"contact_no": @"customerNumber",
       @"remark": @"remark"
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaDealerAndCustomerDetails" withMapping:nfaDealerAndCustomerDetails]];
    
    
    // ----------------------------------------------- nfaDealDetails --------------------------------------------------
    
    RKObjectMapping *nfaDealDetails = [RKObjectMapping mappingForClass:[NFADealDetails class]];
    [nfaDealDetails addAttributeMappingsFromDictionary:
     @{
       @"lob": @"lob",
       @"ppl": @"ppl",
       @"model": @"model",
       @"vc":@"vc",
       @"product_description": @"productDescription",
       @"deal_size": @"dealSize",
       @"billing":@"billing"
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaDealDetails" withMapping:nfaDealDetails]];
    
    
    // ------------------------------------------- nfaTMLProposedLandingPrice ------------------------------------------
    
    RKObjectMapping *nfaTMLProposedLandingPrice = [RKObjectMapping mappingForClass:[NFATMLProposedLandingPrice class]];
    [nfaTMLProposedLandingPrice addAttributeMappingsFromDictionary:
     @{
       @"ex_showroom_tml": @"exShowRoom",
       @"discount_tml": @"discount",
       @"landing_price_tml": @"landingPrice"
       
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaTMLProposedLandingPrice" withMapping:nfaTMLProposedLandingPrice]];
    
    
    // -------------------------------------------- nfaSchemeDetails ------------------------------------------
    
    RKObjectMapping *nfaSchemeDetails = [RKObjectMapping mappingForClass:[NFASchemeDetails class]];
    [nfaSchemeDetails addAttributeMappingsFromDictionary:
     @{
       @"flat_scheme": @"flatScheme",
       @"price_hike": @"priceHike"
       
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaSchemeDetails" withMapping:nfaSchemeDetails]];
    
    
    // ---------------------------------------------- NFAFinancierDetails -----------------------------------------------
    
    RKObjectMapping *nfaFinancierDetails = [RKObjectMapping mappingForClass:[NFAFinancierDetails class]];
    [nfaFinancierDetails addAttributeMappingsFromDictionary:
     @{
       @"financier": @"financier",
       @"ltv": @"ltvField",
       @"fin_subvn": @"finSubvn"
       
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaFinancierDetails" withMapping:nfaFinancierDetails]];
    
    // ------------------------------------------- NFADealerMarginAndRetention ------------------------------------------
    
    RKObjectMapping *nfaDealerMarginAndRetention = [RKObjectMapping mappingForClass:[NFADealerMarginAndRetention class]];
    [nfaDealerMarginAndRetention addAttributeMappingsFromDictionary:
     @{
       @"dealer_margin": @"dealerMargin",
       @"retention": @"retention"
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaDealerMarginAndRetention" withMapping:nfaDealerMarginAndRetention]];
    
    // ------------------------------------------------ NFACompetitionDetails --------------------------------------------
    
    RKObjectMapping *nfaCompetitionDetails = [RKObjectMapping mappingForClass:[NFACompetitionDetails class]];
    [nfaCompetitionDetails addAttributeMappingsFromDictionary:
     @{
       @"competitor": @"competitor",
       @"model_comp": @"model",
       @"ex_showroom_comp":@"exShowroom",
       @"discount_comp":@"discount",
       @"landing_price_comp":@"landingPrice"
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaCompetitionDetails" withMapping:nfaCompetitionDetails]];
    
    // -------------------------------------------------- NFARequestModel ----------------------------------------------
    
    RKObjectMapping *nfaRequestModel = [RKObjectMapping mappingForClass:[NFARequestModel class]];
    [nfaRequestModel addAttributeMappingsFromDictionary:
     @{
       @"net_support_per_vehicle": @"netSupportPerVehicle",
       @"total_support_sought": @"totalSupportSought"
       }];
    [nfaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"nfaRequestModel" withMapping:nfaRequestModel]];
    
    return nfaMapping;
}

- (RKObjectMapping *)getCreateNFAModelMapping {
    
    /**
     This mapping is with respect to NFAAPIModel class properties
     **/
    RKObjectMapping* nfaMapping = [RKObjectMapping mappingForClass:[NFAAPIModel class]];
    [nfaMapping addAttributeMappingsFromDictionary:@{
                                                     @"rsm_position":@"rsmPosition",
                                                     @"spend_category":@"spendCategory",
                                                     @"tsm_position":@"tsmPosition",
                                                     @"user_position":@"userPosition",
                                                     @"tsm_last_name":@"tsmLastName",
                                                     @"tsm_login":@"tsmLogin",
                                                     @"id":@"nfaID",
                                                     @"bu":@"BU",
                                                     @"nfa_ype":@"nfaType",
                                                     @"tsm_first_name":@"tsmFirstName",
                                                     @"tsm_email":  @"tsmEmail",
                                                     @"month_date":  @"monthDate",
                                                     @"spend":@"spend",
                                                     @"support_vehicle":@"supportVehicle",
                                                     @"last_updated_date":@"lastUpdatedDate",
                                                     @"tsm_comment":@"tsmComment",
                                                     @"category_sub_type":@"categorySubType",
                                                     @"created_by":@"createdBy",
                                                     @"instance_id": @"instanceID",
                                                     @"tsm_mobile": @"tsmMobile",
                                                     @"region":@"region",
                                                     @"last_approver":@"lastApprover",
                                                     @"nfa_request_number": @"nfaRequestNumber",
                                                     @"rsm_login":@"rsmLogin",
                                                     @"created_date": @"createdDate",
                                                     @"rsm_email":@"rsmEmail",
                                                     @"opty_sales_stage" : @"optySalesStage",
                                                     @"rsm_comment" : @"rsmComment",
                                                     @"lob_head_comment" : @"lobHeadComment",
                                                     @"marketing_head_comment" : @"marketingHeadComment",
                                                     @"rm_comment" : @"rmComment",
                                                     @"opty_created_date":@"optyCreatedDate",
                                                     @"quantity":@"quantity",
                                                     @"dsm_requested_amt":@"dsmRequestedAmount",
                                                     @"dsm_deal_size":@"dsmDealSize",
                                                     @"req_amt_per_vehicle":@"reqAmountPerVehicle",
                                                     @"total_req_amt":@"totalReqAmount",
                                                     @"req_deal_size":@"reqDealSize",
                                                     @"competitor_fleet_size":@"competitorFleetSize",
                                                     @"declaration":@"declaration",
                                                     @"final_status":@"finalStatus",
                                                     @"opty_id": @"optyID",
                                                     @"dealer_code": @"dealerCode",
                                                     @"dealer_name": @"dealerName",
                                                     @"account_name": @"accountName",
                                                     @"location":@"location",
                                                     @"application":@"application",
                                                     @"tml_fleet_size": @"tmlFleetSize",
                                                     @"overall_fleet_size": @"overallFleetSize",
                                                     @"deal_type": @"dealType",
                                                     @"customer_name_actual": @"customerNameActual",
                                                     @"additional_customer": @"additionalCustomer",
                                                     @"dsm_comment": @"dsmComment",
                                                     @"vehicle_reg_state": @"vehicleRegistrationState",
                                                     @"contact_no": @"contactNumber",
                                                     @"remark": @"remark",
                                                     @"lob": @"lob",
                                                     @"ppl": @"ppl",
                                                     @"model": @"model",
                                                     @"vc":@"vc",
                                                     @"product_description": @"productDescription",
                                                     @"deal_size": @"dealSize",
                                                     @"billing":@"billing",
                                                     @"ex_showroom_tml": @"exShowRoomTML",
                                                     @"discount_tml": @"discountTML",
                                                     @"landing_price_tml": @"landingPriceTML",
                                                     @"flat_scheme": @"flatScheme",
                                                     @"price_hike": @"priceHike",
                                                     @"financier": @"financier",
                                                     @"ltv": @"ltv",
                                                     @"fin_subvn": @"finSubvn",
                                                     @"dealer_margin": @"dealerMargin",
                                                     @"retention": @"retention",
                                                     @"competitor": @"competitor",
                                                     @"model_comp": @"modelCompetitor",
                                                     @"ex_showroom_comp":@"exShowRoomCompetitor",
                                                     @"discount_comp":@"discountCompetitor",
                                                     @"landing_price_comp":@"landingPriceCompetitor",
                                                     @"net_support_per_vehicle": @"netSupportPerVehicle",
                                                     @"total_support_sought": @"totalSupportSought",
                                                     @"next_authority" : @"nextAuthority"
                                                     }];
    return nfaMapping;
}

-(RKObjectMapping *)searchNFAURLMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
    
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
    
    RKObjectMapping* nfaMapping = [self getNFAModelMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:nfaMapping]];
    
    return mapping;
}

- (RKObjectMapping *)userPositionURLMapping {
    
    userPositionURLMapping = [RKObjectMapping mappingForClass:[NFAUserPositionModel class]];
    [userPositionURLMapping addAttributeMappingsFromDictionary:@{
                                                     @"dealer_code":@"dealerCode",
                                                     @"position_id":@"positionID",
                                                     @"dealer_state":@"dealerState",
                                                     @"dealer_name":@"dealerName",
                                                     @"position_name":@"positionName",
                                                     @"dealer_region":@"dealerRegion",
                                                     @"lob_name":@"lobName"
                                                     }];
    return userPositionURLMapping;
}

- (RKObjectMapping *)nextAuthorityURLMapping {
    
    nextAuthorityURLMapping = [RKObjectMapping mappingForClass:[NFANextAuthorityModel class]];
    [nextAuthorityURLMapping addAttributeMappingsFromDictionary:@{
                                                                 @"next_authority_position":@"nextAuthorityPosition",
                                                                 @"next_authority_email_id":@"nextAuthorityEmaiID",
                                                                 @"next_authority_first_name":@"nextAuthorityFirstName",
                                                                 @"next_authority_last_name":@"nextAuthorityLastName",
                                                                 @"next_authority":@"nextAuthority"
                                                                 }];
    return nextAuthorityURLMapping;
}

- (RKObjectMapping *)getQuoteDetailURLMapping {
    getQuoteDetailURLMapping = [RKObjectMapping mappingForClass:[EGQuotation class]];
    [getQuoteDetailURLMapping addAttributeMappingsFromDictionary:@{
                                                                   @"TM_Jurisdiction_City" : @"mTMJurisdictionCity",
                                                                   @"Cell_number" : @"mCellNumber",
                                                                   @"Price_type" : @"mPriceType",
                                                                   @"Acc_main_contact_num" : @"mAccMainContactNum",
                                                                   @"Discount_percent" : @"mDiscountPercentage",
                                                                   @"Discount_amount" : @"mDiscountAmount",
                                                                   @"Tm_Org_Term_Condition" : @"mTMOrgTermCondition",
                                                                   @"QTY" : @"mQty",
                                                                   @"Home_ph_number" : @"mHomePhoneNumber",
                                                                   @"TM_pay_at" : @"mTMPayAt",
                                                                   @"Acc_name" : @"mAccName",
                                                                   @"TM_financier" : @"mTMFinancier",
                                                                   @"Work_ph_number" : @"mWorkPhoneNumber",
                                                                   @"Contact_full_name" : @"mContactFullName",
                                                                   @"Rollup_Amount" : @"mRollupAmount",
                                                                   @"TM_dealer_GST" : @"mTMDealerGST",
                                                                   @"Customer_gst_in" : @"mCustomerGSTIN",
                                                                   @"TM_contact" : @"mTMContact",
                                                                   @"Root_quote_item_id" : @"mRootQuoteItemID",
                                                                   @"Unit_price" : @"mUnitPrice",
                                                                   @"Adjusted_List_Price " : @"mAdjustedListPrice",
                                                                   @"Tm_Product_Description" : @"mTMProductDescription",
                                                                   @"Prod_type" : @"mProdType",
                                                                   @"created" : @"mCreated",
                                                                   @"TM_display_name" : @"mTMDisplayName",
                                                                   @"Quote_num" : @"mQuoteNum",
                                                                   @"Quote_type" : @"mQuoteType",
                                                                   @"Parent_quote_item_id" : @"mParentQuoteItemID",
                                                                   @"Speed_gov" : @"mSpeedQovernorPrice",
                                                                   @"Tax_category" : @"mTaxCategory",
                                                                   @"Delivery_location" : @"mDeliveryLocation",
                                                                   @"Account_address.acc_street_address1" : @"mAccountStreetAddress1",
                                                                   @"Account_address.city" : @"mAcccountCity",
                                                                   @"Account_address.taluka" : @"mAcccountTaluka",
                                                                   @"Account_address.acc_street_address2" : @"mAcccountStreetAddress2",
                                                                   @"Account_address.district" : @"mAcccountDistrict",
                                                                   @"Account_address.state.code" : @"mAcccountStateCode",
                                                                   @"Account_address.state.name" : @"mAcccountStateName",
                                                                   @"Account_address.zipcode" : @"mAcccountZipcode",
                                                                   @"Account_address.country" : @"mAcccountCountry",
                                                                   @"Address.street_address1" : @"mStreetAddress1",
                                                                   @"Address.city" : @"mCity",
                                                                   @"Address.taluka" : @"mTaluka",
                                                                   @"Address.street_address2" : @"mStreetAddress2",
                                                                   @"Address.district" : @"mDistrict",
                                                                   @"Address.state.code" : @"mStateCode",
                                                                   @"Address.state.name" : @"mStateName",
                                                                   @"Address.zipcode" : @"mZipcode",
                                                                   @"Address.country" : @"mCountry"
                                                                   }];
    
    return getQuoteDetailURLMapping;
}

#pragma mark - GET NOTIFICATION LIST

- (RKObjectMapping *)getNotificationListURLMapping {
    if (getNotificationListURLMapping) {
        return getNotificationListURLMapping;
    }
    else {
        
        RKObjectMapping *notificationMapping = [RKObjectMapping mappingForClass:[EGNotification class]];
        [notificationMapping addAttributeMappingsFromDictionary:@{
                                                         @"notification_id" : @"notificationID",
                                                         @"login_id" : @"loginID",
                                                         @"activity_id" : @"activityID",
                                                         @"sent_date" : @"strSentDate",
                                                         @"is_active" : @"strIsActiveFlag",
                                                         @"action_name" : @"actionName",
                                                         @"action" : @"action",
                                                         @"message" : @"message",
                                                         @"opty_id" : @"optyID"
                                                         }];
        
        getNotificationListURLMapping = [RKObjectMapping mappingForClass:[EGPagination class]];
        [getNotificationListURLMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
        [getNotificationListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"items" withMapping:notificationMapping]];
        
        return getNotificationListURLMapping;
    }
}

#pragma mark - EXCLUSION
- (RKObjectMapping *)exclusionListURLMapping {
    if (exclusionListURLMapping){
        return exclusionListURLMapping;
    }else{
        
        RKObjectMapping *exclusionModelMapping = [RKObjectMapping mappingForClass:[EGExclusionModel class]];
        [exclusionModelMapping addAttributeMappingsFromDictionary:@{   @"date":@"date",
                                                                       @"is_excluded":@"isExcluded",
                                                                       @"exclusion_name":@"exclusionName",
                                                                       @"type":@"type",
                                                                       @"dse_id":@"dseId",
                                                                       @"dse_name":@"dseName",
                                                                       @"event_name":@"eventName"  ,                                                                      @"remark":@"remark" ,
                                                                       @"id" : @"leaveID"
                                                                       }];
        //        @"last_name" : @"lastName",@"first_name":@"firstName" ,@"dse_emp_id" : @"dseEmpId"
        
        exclusionListURLMapping = [RKObjectMapping mappingForClass:[EGExclusionListModel class]];
//  [exclusionListURLMapping addAttributeMappingsFromDictionary:@{   @"start_date":@"startDate",
//                                                                         @"end_date":@"endDate"
//                                                                         }];
        [exclusionListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"exclusions" toKeyPath:@"exclusions" withMapping:exclusionModelMapping]];
        return exclusionListURLMapping;
        
    }
}

#pragma mark - PARAMETER SETTINGS
- (RKObjectMapping *)parameterSettingListURLMapping {
    if (parameterSettingListURLMapping){
        return parameterSettingListURLMapping;
    }else{
        parameterSettingListURLMapping = [RKObjectMapping mappingForClass:[EGParameterListModel
                                                                           class]];
        [parameterSettingListURLMapping addAttributeMappingsFromDictionary:@{   @"start_date":@"start_date",
                                                                                @"end_date":@"end_date",
                                                                                @"max_meetings":@"max_meetings",
                                                                                @"dealer_name":@"dealer_name",
                                                                                @"dealer_code":@"dealer_code",
                                                                                @"division_name":@"division_name",
                                                                                }];
        
        //Meeting Frequency Mapping
        RKObjectMapping *parameterMeetingFrequencyMapping = [RKObjectMapping mappingForClass:[EGParameterMeetingFrequency class]];
        [parameterMeetingFrequencyMapping addAttributeMappingsFromDictionary:@{   @"c0":@"c0",
                                                                                  @"c1":@"c1",
                                                                                  @"c1A":@"c1A",
                                                                                  @"c2":@"c2"                                                                                                                              }];
        
        [parameterSettingListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"metting_frequency" toKeyPath:@"mettingfrequency" withMapping:parameterMeetingFrequencyMapping]];
        
        
//        //Financier Mapping
//        RKObjectMapping *parameterFinancierMapping = [RKObjectMapping mappingForClass:[EGParameterFinancierChannelPriority class]];
//        [parameterMeetingFrequencyMapping addAttributeMappingsFromDictionary:@{   @"priority":@"priority",
//                                                                                  @"minimum_allocation":@"minimum_allocation"                                                                                                                          }];
//        //Key Cust Mapping
//        RKObjectMapping *parameterKeyCustMapping = [RKObjectMapping mappingForClass:[EGParameterKeyCustomerChannelPriority class]];
//        [parameterKeyCustMapping addAttributeMappingsFromDictionary:@{   @"priority":@"priority",
//                                                                         @"minimum_allocation":@"minimum_allocation"                                                                                                                          }];
//        //Body Builder Mapping
//        RKObjectMapping *parameterBodyBuilderMapping = [RKObjectMapping mappingForClass:[EGParameteraBodyBuilderChannelPriority class]];
//        [parameterBodyBuilderMapping addAttributeMappingsFromDictionary:@{   @"priority":@"priority",
//                                                                             @"minimum_allocation":@"minimum_allocation"                                                                                                                          }];
//        //Regular Visit Mapping
//        RKObjectMapping *parameterRegularVisitsMapping = [RKObjectMapping mappingForClass:[EGParameterRegularVisitsChannelPriority class]];
//        [parameterRegularVisitsMapping addAttributeMappingsFromDictionary:@{   @"priority":@"priority",
//                                                                               @"minimum_allocation":@"minimum_allocation"                                                                                                                          }];
//
//        //Channel Priority
//
//        RKObjectMapping *channelMapping = [RKObjectMapping mappingForClass:[EGParameterChannelPriority class]];
//        [channelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"financier_executives" toKeyPath:@"financierChannelPriority" withMapping:parameterFinancierMapping]];
//        [channelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"key_customers" toKeyPath:@"keyCustomerChannelPriority" withMapping:parameterKeyCustMapping]];
//        [channelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"body_builders" toKeyPath:@"bodyBuilderChannelPriority" withMapping:parameterBodyBuilderMapping]];
//        [channelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"regular_visits" toKeyPath:@"regularVisitsChannelPriority" withMapping:parameterRegularVisitsMapping]];
//
//        [parameterSettingListURLMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel_priority" toKeyPath:@"channelPriority" withMapping:channelMapping]];
        return parameterSettingListURLMapping;
        
    }
}

@end

