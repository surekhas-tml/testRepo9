//
//  AAAFinancierOptyDetailsMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierOptyDetailsMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierOptyDetailsMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierOptyDetailsMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *organization_name;
@property (nullable, nonatomic, copy) NSString *bu_id;
@property (nullable, nonatomic, copy) NSString *date_of_birth;
@property (nullable, nonatomic, copy) NSString *bdm_mobile_no;
@property (nullable, nonatomic, copy) NSString *pan_number_company;
@property (nullable, nonatomic, copy) NSString *ex_showroom_price;
@property (nullable, nonatomic, copy) NSString *bdm_name;
@property (nullable, nonatomic, copy) NSString *on_road_price_total_amt;
@property (nullable, nonatomic, copy) NSString *cust_loan_type;  //new
@property (nullable, nonatomic, copy) NSString *customer_type;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *financier_status;
@property (nullable, nonatomic, copy) NSString *sales_stage_name;

@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *optyCreatedDate;
@property (nullable, nonatomic, copy) NSString *intendedApplication;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *usage;
@property (nullable, nonatomic, copy) NSString *financierName;
@property (nullable, nonatomic, copy) NSString *optyID;
@property (nullable, nonatomic, copy) NSString *pl;

@property (nullable, nonatomic, copy) NSString* productID;
@property (nullable, nonatomic, copy) NSString* vcNumber;
@property (nullable, nonatomic, copy) NSString* channelType;
@property (nullable, nonatomic, copy) NSString* bodyType;
@property (nullable, nonatomic, copy) NSString* quantity;
@property (nullable, nonatomic, copy) NSString* organizationID;
@property (nullable, nonatomic, copy) NSString* divID;

@property (nullable, nonatomic, retain) AAAFinancierOpportunityMO *toFinancierOpportunity;

@end

NS_ASSUME_NONNULL_END
