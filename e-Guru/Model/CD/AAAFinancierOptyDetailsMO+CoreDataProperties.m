//
//  AAAFinancierOptyDetailsMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierOptyDetailsMO+CoreDataProperties.h"

@implementation AAAFinancierOptyDetailsMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierOptyDetailsMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierOptyDetails"];
}

@dynamic organization_name;
@dynamic bu_id;
@dynamic date_of_birth;
@dynamic bdm_mobile_no;
@dynamic pan_number_company;
@dynamic ex_showroom_price;
@dynamic bdm_name;
@dynamic on_road_price_total_amt;
@dynamic cust_loan_type;
@dynamic customer_type;
@dynamic gender;
@dynamic financier_status;
@dynamic sales_stage_name;

@dynamic lob;
@dynamic optyCreatedDate;
@dynamic intendedApplication;
@dynamic ppl;
@dynamic usage;
@dynamic financierName;
@dynamic optyID;
@dynamic pl;
@dynamic productID;
@dynamic vcNumber;
@dynamic channelType;
@dynamic bodyType;
@dynamic quantity;
@dynamic organizationID;
@dynamic divID;


@dynamic toFinancierOpportunity;

@end
