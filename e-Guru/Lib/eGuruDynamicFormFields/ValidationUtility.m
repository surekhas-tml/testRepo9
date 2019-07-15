//
//  ValidationUtility.m
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ValidationUtility.h"
#import "Field.h"
#import "NSString+NSStringCategory.h"

#define LOB_NAME_BUSES              @"Buses"
#define LOB_NAME_HCV_CARGO          @"HCV Cargo"
#define LOB_NAME_ICV_TRUCKS         @"ICV Trucks"
#define LOB_NAME_MCV_TRUCKS         @"MCV Cargo"
#define LOB_NAME_LCV                @"LCV"
#define LOB_NAME_MHCV_CARGO         @"M&HCV Cargo"
#define LOB_NAME_MHCV_CONST         @"M&HCV Const"
#define LOB_NAME_NTML               @"NTML"
#define LOB_PICKUPS                 @"Pickups"
#define LOB_SCV_CARGO               @"SCV Cargo"
#define LOB_SCV_PASS                @"SCVPass"
#define LOB_SCPASS                  @"ScPass"
#define LOB_PCV_VENTURE             @"PCV - Venture"
#define LOB_SMALL_CAR               @"Small Cars"

#define FIELD_DISPLAY_TITLE_VC_NUMBER             @"VC Number"
#define FIELD_DISPLAY_TITLE_VEHICLE_APPLICATION   @"Vehicle Application"
#define FIELD_DISPLAY_TITLE_CUSTOMER_TYPE         @"Customer Type"
#define FIELD_DISPLAY_TITLE_SOURCE_OF_CONTACT     @"Source of Contact"
#define FIELD_DISPLAY_TITLE_QUANTITY              @"Quantity"
#define FIELD_DISPLAY_TITLE_MM_GEOGRAPHY          @"MM Geography"
#define FIELD_DISPLAY_TITLE_BODY_TYPE             @"Body Type"
#define FIELD_DISPLAY_TITLE_USAGE_CATEGORY        @"Usage Category"
#define FIELD_DISPLAY_TITLE_POTENTIAL_DROP_OFF    @"Potential Drop Off"

#define FIELD_DISPLAY_TITLE_TOTAL_FLEET_SIZE      @"Total Fleet Size"
#define FIELD_DISPLAY_TITLE_TML_FLEET_SIZE        @"TML Fleet Size"
#define FIELD_DISPLAY_TITLE_REFERRAL_TYPE         @"Referral Type"
#define FIELD_DISPLAY_TITLE_REFERRAL_CUSTOMER     @"Referral Customer"
#define FIELD_DISPLAY_TITLE_FINANCIER             @"Financier"
#define FIELD_DISPLAY_TITLE_CAMPAIGN              @"Campaign"
#define FIELD_DISPLAY_TITLE_INFLUENCER            @"Influencer"
#define FIELD_DISPLAY_TITLE_BROKER_NAME           @"Broker Name"
#define FIELD_DISPLAY_TITLE_TGM                   @"TGM"
#define FIELD_DISPLAY_TITLE_COMPETITOR            @"Competitor"
#define FIELD_DISPLAY_TITLE_PRODUCT_CATEGORY      @"Product Category"
#define FIELD_DISPLAY_TITLE_MODEL                 @"Model"
#define FIELD_DISPLAY_TITLE_DETAILED_REMARK       @"Detailed Remark"
#define FIELD_DISPLAY_TITLE_EVENT                 @"Event"
#define FIELD_DISPLAY_TITLE_INTERVENTION_SUPPORT  @"Intervention Support"
#define FIELD_DISPLAY_TITLE_STAKEHOLDER           @"Stakeholder"
#define FIELD_DISPLAY_TITLE_STAKEHOLDER_RESPONSE  @"Stakeholder Response"

#define FLEET_SIZE_MAX_LIMIT    2147483647

@implementation ValidationUtility

+ (instancetype)sharedInstance
{
    static ValidationUtility *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ValidationUtility alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)isAccountMandatory:(NSString *)lobName {
    BOOL isRequired = false;
    if (lobName) {
        if ([lobName caseInsensitiveCompare:LOB_NAME_ICV_TRUCKS] == NSOrderedSame ||
            [lobName caseInsensitiveCompare:LOB_NAME_MCV_TRUCKS] == NSOrderedSame ||
            [lobName caseInsensitiveCompare:LOB_NAME_MHCV_CONST] == NSOrderedSame ||
            [lobName caseInsensitiveCompare:LOB_NAME_HCV_CARGO] == NSOrderedSame) {
            isRequired = true;
        }
    }
    return isRequired;
}

- (NSString *)validateFieldValue:(Field *)field inList:(NSMutableArray *)fieldsList {
    NSString *errorMessage;
    
    if ([field.mTitle caseInsensitiveCompare:FIELD_TML_FLEET_SIZE] == NSOrderedSame) {
        Field *totalFleetSizeField = [self getFieldByTitle:FIELD_TOTAL_FLEET_SIZE inArray:fieldsList];
        if (totalFleetSizeField) {
            NSString *totalFleetSize = totalFleetSizeField.mSelectedValue;
            if (totalFleetSize && ![totalFleetSize isEqualToString:@""]) {
                double fleetSize = totalFleetSize.doubleValue;
                double tmlFleetSize = field.mSelectedValue.doubleValue;
                if (fleetSize > FLEET_SIZE_MAX_LIMIT) {
                    errorMessage = [NSString stringWithFormat:@"Total Fleet Size cannot be greater than %d", FLEET_SIZE_MAX_LIMIT];
                }
                else if (tmlFleetSize > fleetSize) {
                    errorMessage = @"TML Fleet Size cannot be greater than Total Fleet Size";
                }
            }
        }
    }
    else if ([field.mTitle caseInsensitiveCompare:FIELD_TOTAL_FLEET_SIZE] == NSOrderedSame) {
        Field *tmlFleetSizeField = [self getFieldByTitle:FIELD_TML_FLEET_SIZE inArray:fieldsList];
        if (tmlFleetSizeField) {
            NSString *tmlFleetSize = tmlFleetSizeField.mSelectedValue;
            if (tmlFleetSize && ![tmlFleetSize isEqualToString:@""]) {
                double fleetSize = tmlFleetSize.doubleValue;
                double totalFleetSize = field.mSelectedValue.doubleValue;
                if (fleetSize > FLEET_SIZE_MAX_LIMIT) {
                    errorMessage = [NSString stringWithFormat:@"TML Fleet Size cannot be greater than %d", FLEET_SIZE_MAX_LIMIT];
                }
                else if (fleetSize > totalFleetSize) {
                    errorMessage = @"Total Fleet Size cannot be smaller than TML Fleet Size";
                }
            }
        }
    }
    return errorMessage;
}

- (NSMutableArray *)getMandatoryFields:(PrimaryField *)primaryField {
    if (!primaryField) {
        return nil;
    }
    
    Field *lobField = primaryField.mLOBField;
    if (lobField && [lobField.mTitle hasValue]) {
        if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_BUSES]) {
            return [self getBusesMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_HCV_CARGO]) {
            return [self getHCVCargoMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_ICV_TRUCKS]) {
            return [self getIMCVTrucksMandatoryFields:primaryField];
        }
        
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MCV_TRUCKS]) {
            return [self getIMCVTrucksMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_LCV]) {
            return [self getLCVMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MHCV_CARGO]) {
            return [self getMHCVCargoMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MHCV_CONST]) {
            return [self getMHCVConstMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_NTML]) {
            return [self getNTMLMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_PICKUPS]) {
            return [self getPickupsMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCV_CARGO]) {
            return [self getSCVCargoMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCV_PASS]) {
            return [self getSCVPassMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCPASS]) {
            return [self getScPassMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_PCV_VENTURE]) {
            return [self getPCVVentureMandatoryFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SMALL_CAR]) {
            return [self getSmallCarMandatoryFields:primaryField];
        }
        else {
            return [self getBasicMandatoryFields:primaryField];
        }
    }
    
    return nil;
}

- (NSMutableArray *)getOptionalFields:(PrimaryField *)primaryField {
    if (!primaryField) {
        return nil;
    }
    
    Field *lobField = primaryField.mLOBField;
    if (lobField && [lobField.mTitle hasValue]) {
        if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_BUSES]) {
            return [self getBusesOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_HCV_CARGO]) {
            return [self getHCVCargoOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_ICV_TRUCKS]) {
            return [self getIMCVTrucksOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MCV_TRUCKS]) {
            return [self getIMCVTrucksOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_LCV]) {
            return [self getLCVOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MHCV_CARGO]) {
            return [self getMHCVCargoOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MHCV_CONST]) {
            return [self getMHCVConstOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_NTML]) {
            return [self getNTMLOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_PICKUPS]) {
            return [self getPickupsOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCV_CARGO]) {
            return [self getSCVCargoOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCV_PASS]) {
            return [self getSCVPassOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SCPASS]) {
            return [self getScPassOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_PCV_VENTURE]) {
            return [self getPCVVentureOptionalFields:primaryField];
        }
        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_SMALL_CAR]) {
            return [self getSmallCarOptionalFields:primaryField];
        }
        else {
            return [self getBasicOptionalFields:primaryField];
        }
    }
    
    return nil;
}


//- (NSMutableArray *)getStakeHolderFieldsArray:(PrimaryField *)primaryField {
//    if (!primaryField) {
//        return nil;
//    }
//
//    Field *lobField = primaryField.mLOBField;
//    if (lobField && [lobField.mTitle hasValue]) {
//        if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_BUSES]) {
//            return [self gets:primaryField];
//        }
//        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_HCV_CARGO]) {
//            return [self getHCVCargoOptionalFields:primaryField];
//        }
//        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_ICV_TRUCKS]) {
//            return [self getIMCVTrucksOptionalFields:primaryField];
//        }
//        else if ([lobField.mSelectedValue isCaseInsesitiveEqualTo:LOB_NAME_MCV_TRUCKS]) {
//            return [self getIMCVTrucksOptionalFields:primaryField];
//        }
//    }
//    return [self getStakeHolderFields:primaryField];
//}

- (BOOL)getConditionalMandatoryFields:(NSMutableArray *)dynamicFieldsArray {
    BOOL hasChanges = false;
    if (!dynamicFieldsArray || [dynamicFieldsArray count] == 0) {
        return hasChanges;
    }
    
    Field *sourceOfContact;
    Field *referralType;
    Field *event;
    //Field *potentialDropOff;
    
    
    for (Field *field in dynamicFieldsArray) {
        if ([field.mTitle caseInsensitiveCompare:FIELD_SOURCE_OF_CONTACT] == NSOrderedSame) {
            sourceOfContact = field;
        }
        else if ([field.mTitle caseInsensitiveCompare:FIELD_REFERRAL_TYPE] == NSOrderedSame) {
            referralType = field;
        }
        else if ([field.mTitle caseInsensitiveCompare:FIELD_EVENT] == NSOrderedSame) {
            event = field;
        }
//        else if ([field.mTitle caseInsensitiveCompare:FIELD_POTENTIAL_DROP_OFF] == NSOrderedSame) {
//            potentialDropOff = field;
//        }

    }
    
    if (sourceOfContact && sourceOfContact.mSelectedValue) {
        
        // Source of Contact is Referral
        if ([sourceOfContact.mSelectedValue caseInsensitiveCompare:VALUE_REFERRAL] == NSOrderedSame || [sourceOfContact.mSelectedValue caseInsensitiveCompare:VALUE_BODY] == NSOrderedSame || [sourceOfContact.mSelectedValue caseInsensitiveCompare:VALUE_MECHANIC] == NSOrderedSame || [sourceOfContact.mSelectedValue caseInsensitiveCompare:VALUE_FINANCE] == NSOrderedSame) {
            if (![self getFieldByTitle:FIELD_REFERRAL_TYPE inArray:dynamicFieldsArray]) {
                // Add the referral type field
                Field *mReferralType = [self getReferralTypeField:sourceOfContact];
                [dynamicFieldsArray addObject:mReferralType];
                referralType = mReferralType;
                hasChanges = true;
            }
        }
        else {
            BOOL refTypeRemoved = [self removeFieldByTitle:FIELD_REFERRAL_TYPE inArray:dynamicFieldsArray];
            BOOL refCustomerRemoved = [self removeFieldByTitle:FIELD_REFERRAL_CUSTOMER inArray:dynamicFieldsArray];
            
            [sourceOfContact.mSuccessors removeObject:referralType];
            referralType = nil;
            
            hasChanges = hasChanges || refTypeRemoved || refCustomerRemoved;
        }
        
        // Source of Contact is Event
        if ([sourceOfContact.mSelectedValue caseInsensitiveCompare:VALUE_EVENT] == NSOrderedSame) {
            if (![self getFieldByTitle:FIELD_EVENT inArray:dynamicFieldsArray]) {
                // Add the event field
                Field *mEvent = [self getEventField:sourceOfContact];
                [dynamicFieldsArray addObject:mEvent];
                event = mEvent;
                hasChanges = true;
            }
        } else {
            BOOL eventFieldRemoved = [self removeFieldByTitle:FIELD_EVENT inArray:dynamicFieldsArray];
            
            [sourceOfContact.mSuccessors removeObject:event];
            event = nil;
            
            hasChanges = hasChanges || eventFieldRemoved;
        }
    }
    
    if (referralType && referralType.mSelectedValue) {
        //SUREKHA
        if ([referralType.mSelectedValue caseInsensitiveCompare:@"Existing Customer"] == NSOrderedSame || [referralType.mSelectedValue caseInsensitiveCompare:@"Influencer"] == NSOrderedSame) {
            if (![self getFieldByTitle:FIELD_REFERRAL_CUSTOMER inArray:dynamicFieldsArray]) {
                [dynamicFieldsArray addObject:[self getReferralCustomerField]];
                hasChanges = true;
            }
        }
        else {
            BOOL refCustomerRemoved = [self removeFieldByTitle:FIELD_REFERRAL_CUSTOMER inArray:dynamicFieldsArray];

            hasChanges = hasChanges || refCustomerRemoved;
        }
    }
    return hasChanges;
}

- (BOOL)getConditionalOptionalFields:(NSMutableArray *)dynamicFieldsArray {
    BOOL hasChanges = false;
    if (!dynamicFieldsArray || [dynamicFieldsArray count] == 0) {
        return hasChanges;
    }
    
    Field *influencer;
    for (Field *field in dynamicFieldsArray) {
        if ([field.mTitle caseInsensitiveCompare:FIELD_INFLUENCER] == NSOrderedSame) {
            influencer = field;
        }
    }
    
    if (influencer && influencer.mSelectedValue){
        if ([influencer.mSelectedValue caseInsensitiveCompare:VALUE_BROKER] == NSOrderedSame) {
            BOOL tgmRemoved = [self removeFieldByTitle:FIELD_TGM inArray:dynamicFieldsArray];
            
            Field *brokerName = [self getFieldByTitle:FIELD_BROKER_NAME inArray:dynamicFieldsArray];
            if (!brokerName) {
                [dynamicFieldsArray addObject:[self getBrokerNameField]];
                hasChanges = true;
            }
            
            hasChanges = hasChanges || tgmRemoved;
        }
        else if (([influencer.mSelectedValue caseInsensitiveCompare:VALUE_TGM] == NSOrderedSame) || ([influencer.mSelectedValue caseInsensitiveCompare:VALUE_TATA_GRAMIN_MITRA] == NSOrderedSame)) {
            BOOL brokerNameRemoved = [self removeFieldByTitle:FIELD_BROKER_NAME inArray:dynamicFieldsArray];
            
            Field *tgm = [self getFieldByTitle:FIELD_TGM inArray:dynamicFieldsArray];
            if (!tgm) {
                [dynamicFieldsArray addObject:[self getTGMField]];
                hasChanges = true;
            }
            
            hasChanges = hasChanges || brokerNameRemoved;
        }
        else {
            BOOL tgmRemoved = [self removeFieldByTitle:FIELD_TGM inArray:dynamicFieldsArray];
            BOOL brokerNameRemoved = [self removeFieldByTitle:FIELD_BROKER_NAME inArray:dynamicFieldsArray];
            
            hasChanges = hasChanges || tgmRemoved || brokerNameRemoved;
        }
    }
    
    return hasChanges;
}

- (BOOL)removeFieldByTitle:(NSString *)title inArray:(NSMutableArray *)fieldsArray {
    BOOL isRemoved = false;
    for (Field *field in fieldsArray) {
        if ([field.mTitle caseInsensitiveCompare:title] == NSOrderedSame) {
            [fieldsArray removeObject:field];
            isRemoved = true;
            break;
        }
    }
    return isRemoved;
}

- (Field *)getFieldByTitle:(NSString *)title inArray:(NSMutableArray *)fieldsArray {
    Field *requiredField;
    for (Field *field in fieldsArray) {
        if ([field.mTitle caseInsensitiveCompare:title] == NSOrderedSame) {
            requiredField = field;
            break;
        }
    }
    return requiredField;
}

- (NSMutableArray *)getBasicMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *basicMandatoryfieldsList = [[NSMutableArray alloc] init];
    // Maintain the sequence
    [basicMandatoryfieldsList addObject:[self getVehicleApplicationField:primaryField.mLOBField]]; // 1
    [basicMandatoryfieldsList addObject:[self getCustomerTypeField]]; // 2
    [basicMandatoryfieldsList addObject:[self getSourceOfContactField]]; // 3
    [basicMandatoryfieldsList addObject:[self getQuantityField]]; // 4
   // [basicMandatoryfieldsList addObject:[self getPotentialDropOffField]];

    
    
    return basicMandatoryfieldsList;
}

- (NSMutableArray *)getBasicOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *basicOptionalfieldsList = [[NSMutableArray alloc] init];
    [basicOptionalfieldsList addObject:[self getFinancierField]];
    [basicOptionalfieldsList addObject:[self getCampaignField]];
    [basicOptionalfieldsList addObject:[self getInfluencerField]];
//    [basicOptionalfieldsList addObject:[self getInterventionSupportField]];
//    [basicOptionalfieldsList addObject:[self getStakeholderField]];
//    [basicOptionalfieldsList addObject:[self getStakeholderResponseField]];
    
    return basicOptionalfieldsList;
}

- (NSMutableArray *)getLiveDealFields {
    NSMutableArray *liveDealFieldsList = [[NSMutableArray alloc] init];
    
    Field *competitor = [self getCompetitorField];
    Field *productCategory = [self getProductCategoryField:competitor];
    
    [liveDealFieldsList addObject:competitor];
    [liveDealFieldsList addObject:productCategory];
    [liveDealFieldsList addObject:[self getModelField]];
    [liveDealFieldsList addObject:[self getDetailedRemarkField]];
    return liveDealFieldsList;
}


- (NSMutableArray *)getBusesMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    
    return fieldsList;
}

- (NSMutableArray *)getBusesOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    return fieldsList;
}

- (NSMutableArray *)getStakeHolderFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getPotentialDropOffField]];
    [fieldsList addObject:[self getInterventionSupportField]];
    [fieldsList addObject:[self getStakeholderField]];
    [fieldsList addObject:[self getStakeholderResponseField]];
    return fieldsList;
}

//- (NSMutableArray *)getStakeHolderResponseField:(PrimaryField *)primaryField {
//    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
//    [fieldsList addObject:[self getStakeholderResponseField]];
//    return fieldsList;
//}

- (NSMutableArray *)getHCVCargoMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    
    return fieldsList;
}

- (NSMutableArray *)getHCVCargoOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getIMCVTrucksMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    
    return fieldsList;
}

- (NSMutableArray *)getIMCVTrucksOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getLCVMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    
    return fieldsList;
}

- (NSMutableArray *)getLCVOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getMHCVCargoMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    
    return fieldsList;
}

- (NSMutableArray *)getMHCVCargoOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    return fieldsList;
}

- (NSMutableArray *)getMHCVConstMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    
    return fieldsList;
}

- (NSMutableArray *)getMHCVConstOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getNTMLMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    
    return fieldsList;
}

- (NSMutableArray *)getNTMLOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    return fieldsList;
}

- (NSMutableArray *)getPickupsMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getPickupsOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getSCVCargoMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:[fieldsList objectAtIndex:0]]];
    [fieldsList addObject:[self getUsageCategoryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getSCVCargoOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getSCVPassMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getSCVPassOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getScPassMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    
    return fieldsList;
}

- (NSMutableArray *)getScPassOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    return fieldsList;
}

- (NSMutableArray *)getPCVVentureMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getPCVVentureOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    
    return fieldsList;
}

- (NSMutableArray *)getSmallCarMandatoryFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [self getBasicMandatoryFields:primaryField];
    
    return fieldsList;
}

- (NSMutableArray *)getSmallCarOptionalFields:(PrimaryField *)primaryField {
    NSMutableArray *fieldsList = [[NSMutableArray alloc] init];
    [fieldsList addObject:[self getMMGeographyField]];
    [fieldsList addObject:[self getBodyTypeField:primaryField.mLOBField]];
    [fieldsList addObject:[self getUsageCategoryField]];
    [fieldsList addObject:[self getTotalFleetSizeField]];
    [fieldsList addObject:[self getTMLFleetSizeField]];
    [fieldsList addObjectsFromArray:[self getBasicOptionalFields:primaryField]];
    return fieldsList;
}

- (Field *)getVCNumberField {
    Field *vcNumber = [[Field alloc] initWithTitle:FIELD_VC_NUMBER];
    [vcNumber setMDisplayTitle:FIELD_DISPLAY_TITLE_VC_NUMBER];
    [vcNumber setMFieldType:AutoCompleteText];
    [vcNumber setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_VC_NUMBER]];
    return vcNumber;
}

- (Field *)getVehicleApplicationField:(Field *)predecessor {
    Field *vehicleApplication = [[Field alloc] initWithTitle:FIELD_VEHICLE_APPLICATION];
    [vehicleApplication setMDisplayTitle:FIELD_DISPLAY_TITLE_VEHICLE_APPLICATION];
    [vehicleApplication setMFieldType:SingleSelectList];
    [vehicleApplication setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_VEHICLE_APPLICATION]];
    
    [vehicleApplication addPredecessor:predecessor];
    [predecessor addSuccessor:vehicleApplication];
    
    return vehicleApplication;
}

- (Field *)getCustomerTypeField {
    Field *customerType = [[Field alloc] initWithTitle:FIELD_CUSTOMER_TYPE];
    [customerType setMDisplayTitle:FIELD_DISPLAY_TITLE_CUSTOMER_TYPE];
    [customerType setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_CUSTOMER_TYPE]];
    return customerType;
}

- (Field *)getSourceOfContactField {
    Field *sourceOfContact = [[Field alloc] initWithTitle:FIELD_SOURCE_OF_CONTACT];
    [sourceOfContact setMDisplayTitle:FIELD_DISPLAY_TITLE_SOURCE_OF_CONTACT];
    [sourceOfContact setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_SOURCE_OF_CONTACT]];
    return sourceOfContact;
}

- (Field *)getQuantityField {
    Field *quantity = [[Field alloc] initWithTitle:FIELD_QUANTITY];
    [quantity setMDisplayTitle:FIELD_DISPLAY_TITLE_QUANTITY];
    [quantity setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_QUANTITY]];
    [quantity setMFieldType:Number];
    return quantity;
}

- (Field *)getMMGeographyField {
    Field *mmGeography = [[Field alloc] initWithTitle:FIELD_MM_GEOGRAPHY];
    [mmGeography setMDisplayTitle:FIELD_DISPLAY_TITLE_MM_GEOGRAPHY];
    [mmGeography setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_MM_GEOGRAPHY]];
    [mmGeography setMFieldType:AutoCompleteText];
    return mmGeography;
}

- (Field *)getBodyTypeField:(Field *)predecessor {
    Field *bodyType = [[Field alloc] initWithTitle:FIELD_BODY_TYPE];
    [bodyType setMDisplayTitle:FIELD_DISPLAY_TITLE_BODY_TYPE];
    [bodyType setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_BODY_TYPE]];
    
    [bodyType addPredecessor:predecessor];
    [predecessor addSuccessor:bodyType];
    
    return bodyType;
}

- (Field *)getUsageCategoryField {
    Field *usageCategory = [[Field alloc] initWithTitle:FIELD_USAGE_CATEGORY];
    [usageCategory setMDisplayTitle:FIELD_DISPLAY_TITLE_USAGE_CATEGORY];
    [usageCategory setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_USAGE_CATEGORY]];
    return usageCategory;
}

- (Field *)getPotentialDropOffField {
    Field *potentialDropOffCategory = [[Field alloc] initWithTitle:FIELD_POTENTIAL_DROP_OFF];
    [potentialDropOffCategory setMDisplayTitle:FIELD_DISPLAY_TITLE_POTENTIAL_DROP_OFF];
    [potentialDropOffCategory setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_POTENTIAL_DROP_OFF]];
    return potentialDropOffCategory;
}

- (Field *)getTotalFleetSizeField {
    Field *totalFleetSize = [[Field alloc] initWithTitle:FIELD_TOTAL_FLEET_SIZE];
    [totalFleetSize setMDisplayTitle:FIELD_DISPLAY_TITLE_TOTAL_FLEET_SIZE];
    [totalFleetSize setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_TOTAL_FLEET_SIZE]];
    [totalFleetSize setMFieldType:Number];
    return totalFleetSize;
}

- (Field *)getTMLFleetSizeField {
    Field *tmlFleetSize = [[Field alloc] initWithTitle:FIELD_TML_FLEET_SIZE];
    [tmlFleetSize setMDisplayTitle:FIELD_DISPLAY_TITLE_TML_FLEET_SIZE];
    [tmlFleetSize setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_TML_FLEET_SIZE]];
    [tmlFleetSize setMFieldType:Number];
    return tmlFleetSize;
}

- (Field *)getInterventionSupportField {
    Field *interventionSupport = [[Field alloc] initWithTitle:FIELD_INTERVENTION_SUPPORT];
    [interventionSupport setMDisplayTitle:FIELD_DISPLAY_TITLE_INTERVENTION_SUPPORT];
    [interventionSupport setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_INTERVENTION_SUPPORT]];
    [interventionSupport setMFieldType:Number];
    return interventionSupport;
}

- (Field *)getStakeholderField {
    Field *stakeholder = [[Field alloc] initWithTitle:FIELD_STAKEHOLDER];
    [stakeholder setMDisplayTitle:FIELD_DISPLAY_TITLE_STAKEHOLDER];
    [stakeholder setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_STAKEHOLDER]];
    [stakeholder setMFieldType:Number];
    return stakeholder;
}

- (Field *)getStakeholderResponseField {
    Field *stakeholderResponse = [[Field alloc] initWithTitle:FIELD_STAKEHOLDER_RESPONSE];
    [stakeholderResponse setMDisplayTitle:FIELD_DISPLAY_TITLE_STAKEHOLDER_RESPONSE];
    [stakeholderResponse setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_STAKEHOLDER_RESPONSE]];
    [stakeholderResponse setMFieldType:Number];
    [stakeholderResponse setMIsEnabled:NO];
    return stakeholderResponse;
}

- (Field *)getReferralTypeField:(Field *)predecessor {
    Field *referralType = [[Field alloc] initWithTitle:FIELD_REFERRAL_TYPE];
    [referralType setMDisplayTitle:FIELD_DISPLAY_TITLE_REFERRAL_TYPE];
    [referralType setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_REFERRAL_TYPE]];
//    [referralType setMSelectedValue:@"Existing Customer"];
    [referralType addPredecessor:predecessor];
    [predecessor addSuccessor:referralType];
    
    return referralType;
}

- (Field *)getReferralCustomerField {
    Field *referralType = [[Field alloc] initWithTitle:FIELD_REFERRAL_CUSTOMER];
    [referralType setMDisplayTitle:FIELD_DISPLAY_TITLE_REFERRAL_CUSTOMER];
    [referralType setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_REFERRAL_CUSTOMER]];
    [referralType setMFieldType:Search];
    return referralType;
}

- (Field *)getFinancierField {
    Field *financier = [[Field alloc] initWithTitle:FIELD_FINANCIER];
    [financier setMDisplayTitle:FIELD_DISPLAY_TITLE_FINANCIER];
    [financier setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_FINANCIER]];
    [financier setMFieldType:AutoCompleteText];
    [financier setMIsMandatory:false];
    return financier;
}

- (Field *)getCampaignField {
    Field *campaign = [[Field alloc] initWithTitle:FIELD_CAMPAIGN];
    [campaign setMDisplayTitle:FIELD_DISPLAY_TITLE_CAMPAIGN];
    [campaign setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_CAMPAIGN]];
    [campaign setMIsMandatory:false];
    return campaign;
}

- (Field *)getInfluencerField {
    Field *influencer = [[Field alloc] initWithTitle:FIELD_INFLUENCER];
    [influencer setMDisplayTitle:FIELD_DISPLAY_TITLE_INFLUENCER];
    [influencer setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_INFLUENCER]];
    [influencer setMIsMandatory:false];
    return influencer;
}

- (Field *)getBrokerNameField {
    Field *brokerName = [[Field alloc] initWithTitle:FIELD_BROKER_NAME];
    [brokerName setMDisplayTitle:FIELD_DISPLAY_TITLE_BROKER_NAME];
    [brokerName setMErrorMessage:@"Please select broker"];
    [brokerName setMIsMandatory:false];
    [brokerName setMFieldType:Search];
    return brokerName;
}

- (Field *)getTGMField {
    Field *tgm = [[Field alloc] initWithTitle:FIELD_TGM];
    [tgm setMDisplayTitle:FIELD_DISPLAY_TITLE_TGM];
    [tgm setMErrorMessage:@"Please select TGM"];
    [tgm setMIsMandatory:false];
    [tgm setMFieldType:Search];
    return tgm;
}

- (Field *)getCompetitorField {
    Field *competitor = [[Field alloc] initWithTitle:FIELD_COMPETITOR];
    [competitor setMDisplayTitle:FIELD_DISPLAY_TITLE_COMPETITOR];
    [competitor setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_COMPETITOR]];
    [competitor setMIsMandatory:false];
    return competitor;
}

- (Field *)getProductCategoryField:(Field *)predecessor {
    Field *productCategory = [[Field alloc] initWithTitle:FIELD_PRODUCT_CATEGORY];
    [productCategory setMDisplayTitle:FIELD_DISPLAY_TITLE_PRODUCT_CATEGORY];
    [productCategory setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_PRODUCT_CATEGORY]];
    [productCategory setMIsMandatory:false];
    
    [productCategory addPredecessor:predecessor];
    [predecessor addSuccessor:productCategory];
    
    return productCategory;
}

- (Field *)getModelField {
    Field *model = [[Field alloc] initWithTitle:FIELD_MODEL];
    [model setMDisplayTitle:FIELD_DISPLAY_TITLE_MODEL];
    [model setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_MODEL]];
    [model setMIsMandatory:false];
    [model setMFieldType:Text];
    return model;
}

- (Field *)getDetailedRemarkField {
    Field *model = [[Field alloc] initWithTitle:FIELD_DETAILED_REMARK];
    [model setMDisplayTitle:FIELD_DISPLAY_TITLE_DETAILED_REMARK];
    [model setMErrorMessage:[NSString stringWithFormat:@"Please enter %@", FIELD_DISPLAY_TITLE_DETAILED_REMARK]];
    [model setMIsMandatory:false];
    [model setMFieldType:Text];
    return model;
}

- (Field *)getEventField:(Field *)predecessor {
    Field *event = [[Field alloc] initWithTitle:FIELD_EVENT];
    [event setMDisplayTitle:FIELD_DISPLAY_TITLE_EVENT];
    [event setMErrorMessage:[NSString stringWithFormat:@"Please select %@", FIELD_DISPLAY_TITLE_EVENT]];
    [event addPredecessor:predecessor];
    [event setMFieldType:AutoCompleteText];
    [predecessor addSuccessor:event];
    
    return event;
}

@end
