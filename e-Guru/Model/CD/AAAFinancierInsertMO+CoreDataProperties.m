//
//  AAAFinancierInsertMO+CoreDataProperties.m
//  e-guru
//
//  Created by Shashi on 11/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierInsertMO+CoreDataProperties.h"

@implementation AAAFinancierInsertMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierInsertMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierInsertQuotes"];
}

@dynamic financier_name;
@dynamic financier_id;
@dynamic branch_name;
@dynamic branch_id;
@dynamic bdm_name;
@dynamic bdm_id;
@dynamic bdm_mobile_no;

@dynamic financierTMFBDMDetailsArray; //new

@dynamic account_address1;
@dynamic account_address2;
@dynamic account_city_town_village;
@dynamic account_district;
@dynamic account_name;
@dynamic account_number;
@dynamic account_pincode;
@dynamic account_site;
@dynamic account_state;
@dynamic account_type;
@dynamic address1;
@dynamic address2;
@dynamic address_type;
@dynamic area;
@dynamic city_town_village;
@dynamic customer_category;
@dynamic customer_category_subcategory;
@dynamic date_of_birth;
@dynamic district;
@dynamic emission_norms;
@dynamic ex_showroom_price;
@dynamic father_mother_spouse_name;
@dynamic first_name;
@dynamic gender;
@dynamic id_description;
@dynamic id_expiry_date;
@dynamic id_issue_date;
@dynamic id_type;
@dynamic intended_application;
@dynamic last_name;
@dynamic loandetails_repayable_in_months;
@dynamic lob;
@dynamic mobile_no;
@dynamic on_road_price_total_amt;
@dynamic cust_loan_type;  //new
@dynamic opty_created_date;
@dynamic opty_id;
@dynamic organization;
@dynamic pan_no_company;
@dynamic pan_no_indiviual;
@dynamic partydetails_maritalstatus;
@dynamic pincode;
@dynamic pl;
@dynamic ppl;
@dynamic religion;
@dynamic repayment_mode;
@dynamic state;
@dynamic title;
@dynamic usage;
@dynamic vehicle_class;
@dynamic vehicle_color;

@dynamic relation_type;
@dynamic account_pan_no_company;
@dynamic taluka;
@dynamic vc_number;
@dynamic product_id;
@dynamic event_id;
@dynamic event_name;
@dynamic bu_id;
@dynamic channel_type;
@dynamic ref_type;
@dynamic mmgeo;
@dynamic camp_id;
@dynamic camp_name;
@dynamic body_type;
@dynamic loan_tenor;
@dynamic division_id;
@dynamic organization_code;
@dynamic quantity;
@dynamic fin_occupation_in_years;
@dynamic fin_occupation;
@dynamic partydetails_annualincome;
@dynamic indicative_loan_amt;
@dynamic ltv;
@dynamic account_tahsil_taluka;
@dynamic type_of_property;
@dynamic customer_type;
@dynamic sales_stage_name;

@dynamic coapplicant_first_name;
@dynamic coapplicant_last_name;
@dynamic coapplicant_date_of_birth;
@dynamic coapplicant_mobile_no;
@dynamic coapplicant_address1;
@dynamic coapplicant_address2;
@dynamic coapplicant_city_town_village;
@dynamic coapplicant_pan_no_indiviual;
@dynamic coapplicant_pincode;
@dynamic toggleMode;

@end
