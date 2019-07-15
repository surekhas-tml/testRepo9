//
//  EGRKObjectMapping.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "AppDelegate.h"
#import "EGOpportunity.h"

#import "EGFinancierOpportunity.h"
#import "FinancierInsertQuoteModel.h"

#import "EGState.h"
#import "EGQuotation.h"

@interface EGRKObjectMapping : NSObject
+(EGRKObjectMapping *)sharedMapping;

@property (readonly)RKObjectMapping *searchAccountURLPaginatedMapping;
@property (readonly)RKObjectMapping *searchContactURLPaginatedMapping;
@property (readonly)RKObjectMapping *searchOpportunityURLMappingForOpportunity;
@property (readonly)RKObjectMapping *searchOpportunityURLMappingForPendingActivity;
@property (readonly)RKObjectMapping *searchOpportunityURLMappingFordoneActivity;
@property (readonly)RKObjectMapping *searchActivityMappingForOpportunity;
@property (readonly)RKObjectMapping *stateListURLMapping;

#pragma mark - Financier

@property (readonly)RKObjectMapping *searchOptyFinancierURLMapping;
@property (readonly)RKObjectMapping *fetchFinancierQuotesURLMapping;
@property (readonly)RKObjectMapping *financierInsertQuoteMapping;

@property (readonly)RKObjectMapping *districtListURLMapping;
@property (readonly)RKObjectMapping *talukaListURLMapping;
@property (readonly)RKObjectMapping *PINCODELISTURLMapping;
@property (readonly)RKObjectMapping *talukaforpincode;
@property (readonly)RKObjectMapping *pincodelistURLFROMGPSMapping;
@property (readonly)RKObjectMapping *DSEList;
@property (readonly)RKObjectMapping *DSEwisePipelineURLMapping;
@property (readonly)RKObjectMapping *DSEMiswisePipelineURLMapping;
@property (readonly)RKObjectMapping *DSEMisDetailswisePipelineURLMapping;
@property (readonly)RKObjectMapping *locationByTalukaListURLMapping;
@property (readonly)RKObjectMapping *campaignList;
@property (readonly)RKObjectMapping *addressMapping;

#pragma mark - Create Opportunity

@property (readonly)RKObjectMapping *lobListURLMapping;
@property (readonly)RKObjectMapping *pplListURLMapping;
@property (readonly)RKObjectMapping *plListURLMapping;
@property (readonly)RKObjectMapping *mmGeoListURLMapping;
@property (readonly)RKObjectMapping *financierURLMapping;
@property (readonly)RKObjectMapping *campaignURLMapping;
@property (readonly)RKObjectMapping *referralCustomerURLMapping;
//@property (readonly)RKObjectMapping *exchangeDetailsKeyMapping;   //new

@property (readonly)RKObjectMapping *tgmURLMapping;
@property (readonly)RKObjectMapping *brokerDetailsURLMapping;
@property (readonly)RKObjectMapping *vcListURLMapping;
@property (readonly)RKObjectMapping *loginURLMapping;
@property (readonly)RKObjectMapping *accessTokenMapping;
@property (readonly)RKObjectMapping *ActualVsTargetURLMapping;
@property (readonly)RKObjectMapping *searchActivityURLMapping;

@property (readonly)RKObjectMapping *dashboardMapping;
@property (readonly)RKObjectMapping *PPLwisePipelineURLMapping;

@property (readonly)RKObjectMapping *opportunityMapping;

@property (readonly)RKObjectMapping *opportunityResponseMapping;
@property (readonly)RKObjectMapping *eventMapping;

#pragma mark - NFA
@property (readonly)RKObjectMapping *searchNFAURLMapping;
@property (readonly)RKObjectMapping *getCreateNFAModelMapping;
@property (readonly)RKObjectMapping *userPositionURLMapping;
@property (readonly)RKObjectMapping *nextAuthorityURLMapping;

#pragma mark - Email Quotation

@property (readonly)RKObjectMapping *getQuoteDetailURLMapping;

#pragma mark - Notifications
@property (readonly)RKObjectMapping *getNotificationListURLMapping;

#pragma mark - Exclusions
@property (readonly)RKObjectMapping *exclusionListURLMapping;


#pragma mark - Parameter
@property (readonly)RKObjectMapping *parameterSettingListURLMapping;

@end
