//
//  AAAFinancierInsertMO+CoreDataProperties.h
//  e-guru
//
//  Created by Shashi on 11/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierInsertMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierInsertMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierInsertMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *financier_name;
@property (nullable, nonatomic, copy) NSString *financier_id;

@property (nullable, nonatomic, copy) NSString *branch_name;
@property (nullable, nonatomic, copy) NSString *branch_id;
@property (nullable, nonatomic, copy) NSString *bdm_name;
@property (nullable, nonatomic, copy) NSString *bdm_id;
@property (nullable, nonatomic, copy) NSString *bdm_mobile_no;

@property (nullable, nonatomic, copy) NSString *account_address1;
@property (nullable, nonatomic, copy) NSString *account_address2;
@property (nullable, nonatomic, copy) NSString *account_city_town_village;
@property (nullable, nonatomic, copy) NSString *account_district;
@property (nullable, nonatomic, copy) NSString *account_name;
@property (nullable, nonatomic, copy) NSString *account_number;
@property (nullable, nonatomic, copy) NSString *account_pincode;
@property (nullable, nonatomic, copy) NSString *account_site;
@property (nullable, nonatomic, copy) NSString *account_state;
@property (nullable, nonatomic, copy) NSString *account_type;
@property (nullable, nonatomic, copy) NSString *address1;
@property (nullable, nonatomic, copy) NSString *address2;
@property (nullable, nonatomic, copy) NSString *address_type;
@property (nullable, nonatomic, copy) NSString *area;
@property (nullable, nonatomic, copy) NSString *city_town_village;
@property (nullable, nonatomic, copy) NSString *customer_category;
@property (nullable, nonatomic, copy) NSString *customer_category_subcategory;
@property (nullable, nonatomic, copy) NSString *date_of_birth;
@property (nullable, nonatomic, copy) NSString *district;
@property (nullable, nonatomic, copy) NSString *emission_norms;
@property (nullable, nonatomic, copy) NSString *ex_showroom_price;
@property (nullable, nonatomic, copy) NSString *father_mother_spouse_name;
@property (nullable, nonatomic, copy) NSString *first_name;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *id_description;
@property (nullable, nonatomic, copy) NSString *id_expiry_date;
@property (nullable, nonatomic, copy) NSString *id_issue_date;
@property (nullable, nonatomic, copy) NSString *id_type;
@property (nullable, nonatomic, copy) NSString *intended_application;
@property (nullable, nonatomic, copy) NSString *last_name;
@property (nullable, nonatomic, copy) NSString *loandetails_repayable_in_months;
@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *mobile_no;
@property (nullable, nonatomic, copy) NSString *on_road_price_total_amt;
@property (nullable, nonatomic, copy) NSString *cust_loan_type;   //new
@property (nullable, nonatomic, copy) NSString *opty_created_date;
@property (nullable, nonatomic, copy) NSString *opty_id;
@property (nullable, nonatomic, copy) NSString *organization;
@property (nullable, nonatomic, copy) NSString *pan_no_company;
@property (nullable, nonatomic, copy) NSString *pan_no_indiviual;
@property (nullable, nonatomic, copy) NSString *partydetails_maritalstatus;
@property (nullable, nonatomic, copy) NSString *pincode;
@property (nullable, nonatomic, copy) NSString *pl;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *religion;
@property (nullable, nonatomic, copy) NSString *repayment_mode;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *usage;
@property (nullable, nonatomic, copy) NSString *vehicle_class;
@property (nullable, nonatomic, copy) NSString *vehicle_color;

@property (nullable, nonatomic, copy) NSString *relation_type;
@property (nullable, nonatomic, copy) NSString *account_pan_no_company;
@property (nullable, nonatomic, copy) NSString *taluka;
@property (nullable, nonatomic, copy) NSString *vc_number;
@property (nullable, nonatomic, copy) NSString *product_id;
@property (nullable, nonatomic, copy) NSString *event_id;
@property (nullable, nonatomic, copy) NSString *event_name;
@property (nullable, nonatomic, copy) NSString *bu_id;
@property (nullable, nonatomic, copy) NSString *channel_type;
@property (nullable, nonatomic, copy) NSString *ref_type;
@property (nullable, nonatomic, copy) NSString *mmgeo;
@property (nullable, nonatomic, copy) NSString *camp_id;
@property (nullable, nonatomic, copy) NSString *camp_name;
@property (nullable, nonatomic, copy) NSString *body_type;
@property (nullable, nonatomic, copy) NSString *loan_tenor;
@property (nullable, nonatomic, copy) NSString *division_id;
@property (nullable, nonatomic, copy) NSString *organization_code;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *fin_occupation_in_years;
@property (nullable, nonatomic, copy) NSString *fin_occupation;
@property (nullable, nonatomic, copy) NSString *partydetails_annualincome;
@property (nullable, nonatomic, copy) NSString *indicative_loan_amt;
@property (nullable, nonatomic, copy) NSString *ltv;
@property (nullable, nonatomic, copy) NSString *account_tahsil_taluka;
@property (nullable, nonatomic, copy) NSString *type_of_property;
@property (nullable, nonatomic, copy) NSString *customer_type;
@property (nullable, nonatomic, copy) NSString *sales_stage_name;

@property (nullable, nonatomic, copy) NSString *coapplicant_first_name;
@property (nullable, nonatomic, copy) NSString *coapplicant_last_name;
@property (nullable, nonatomic, copy) NSString *coapplicant_date_of_birth;
@property (nullable, nonatomic, copy) NSString *coapplicant_mobile_no;
@property (nullable, nonatomic, copy) NSString *coapplicant_address1;
@property (nullable, nonatomic, copy) NSString *coapplicant_address2;
@property (nullable, nonatomic, copy) NSString *coapplicant_city_town_village;
@property (nullable, nonatomic, copy) NSString *coapplicant_pan_no_indiviual;
@property (nullable, nonatomic, copy) NSString *coapplicant_pincode;
@property (nullable, nonatomic, copy) NSString *toggleMode;

@property (nullable, nonatomic,copy) NSMutableArray *financierTMFBDMDetailsArray;

@end

NS_ASSUME_NONNULL_END
