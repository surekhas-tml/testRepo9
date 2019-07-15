//
//  ValidationUtility.h
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrimaryField.h"


#define FIELD_LOB                   @"LOB"
#define FIELD_PPL                   @"PPL"
#define FIELD_PL                    @"PL"
#define FIELD_VC_NUMBER             @"VCNo"
#define FIELD_VEHICLE_APPLICATION   @"VehicleApplication"
#define FIELD_CUSTOMER_TYPE         @"CustomerType"
#define FIELD_SOURCE_OF_CONTACT     @"SourceOfContact"
#define FIELD_QUANTITY              @"Quantity"
#define FIELD_MM_GEOGRAPHY          @"MMGeography"
#define FIELD_BODY_TYPE             @"BodyType"
#define FIELD_USAGE_CATEGORY        @"UsageCategory"
#define FIELD_TOTAL_FLEET_SIZE      @"TotalFleetSize"
#define FIELD_TML_FLEET_SIZE        @"TMLFleetSize"
#define FIELD_INTERVENTION_SUPPORT  @"InterventionSupport"
#define FIELD_STAKEHOLDER           @"Stakeholder"
#define FIELD_STAKEHOLDER_RESPONSE  @"Stakeholder Response"

#define FIELD_REFERRAL_TYPE         @"ReferralType"
#define FIELD_REFERRAL_CUSTOMER     @"ReferralCustomer"
#define FIELD_FINANCIER             @"Financier"
#define FIELD_CAMPAIGN              @"Campaign"
#define FIELD_INFLUENCER            @"Influencer"
#define FIELD_BROKER_NAME           @"BrokerName"
#define FIELD_TGM                   @"TGM"
#define FIELD_COMPETITOR            @"Competitor"
#define FIELD_PRODUCT_CATEGORY      @"ProductCategory"
#define FIELD_MODEL                 @"Model"
#define FIELD_DETAILED_REMARK       @"DetailedRemark"
#define FIELD_EVENT                 @"Event"
#define STATE_LIST                  @"StateList"
// *** NEWLY ADDED on 23/01/2019
#define FIELD_POTENTIAL_DROP_OFF    @"Potential Drop Off"
//---END ----
#define FIELD_REGISTRATION          @"Registration No."


#define VALUE_BROKER                @"Broker"
#define VALUE_TGM                   @"TGM"
#define VALUE_TATA_GRAMIN_MITRA     @"Tata Gramin Mitra"
#define VALUE_REFERRAL              @"Referral"
#define VALUE_BODY                  @"Body Builder Meet"
#define VALUE_FINANCE               @"Financier Meet"
#define VALUE_MECHANIC              @"Local Mechanic Tie-Up"
#define VALUE_NAKASPOKEPERSON       @"Naka Spokesperson"
#define EXISTING_CUST               @"Existing Customer"
#define INFLUENCER                  @"Influencer"




#define VALUE_EVENT                 @"Event"

// *** NEWLY ADDED on 23/01/2019
#define VALUE_POTENTIAL_DROP_OFF    @"Potential Drop Off"
//---END ----


@interface ValidationUtility : NSObject

+ (instancetype)sharedInstance;
- (BOOL)isAccountMandatory:(NSString *)lobName;
- (NSString *)validateFieldValue:(Field *)field inList:(NSMutableArray *)fieldsList;
- (NSMutableArray *)getMandatoryFields:(PrimaryField *)primaryField;
- (NSMutableArray *)getOptionalFields:(PrimaryField *)primaryField;
- (NSMutableArray *)getLiveDealFields;
- (BOOL)getConditionalMandatoryFields:(NSMutableArray *)dynamicFieldsArray;
- (BOOL)getConditionalOptionalFields:(NSMutableArray *)dynamicFieldsArray;
//- (NSMutableArray *)getStakeHolderFieldsArray:(PrimaryField *)primaryField;
- (NSMutableArray *)getStakeHolderFields:(PrimaryField *)primaryField;
//- (NSMutableArray *)getStakeHolderResponseField:(PrimaryField *)primaryField;

@end
