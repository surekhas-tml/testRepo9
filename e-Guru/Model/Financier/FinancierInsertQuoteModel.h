//
//  FinancierInsertQuoteModel.h
//  e-guru
//
//  Created by Shashi on 09/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FinancierBranchDetailsModel.h"
#import "AAAFinancierInsertMO+CoreDataClass.h"
#import "FinancierListDetailModel.h"

@interface FinancierInsertQuoteModel : NSObject

@property (strong, nonatomic) NSString *financier_name;
@property (strong, nonatomic) NSString *financier_id;

@property (strong, nonatomic) NSString *branch_id;
@property (strong, nonatomic) NSString *branch_name;
@property (strong, nonatomic) NSString *bdm_id;
@property (strong, nonatomic) NSString *bdm_name;
@property (strong, nonatomic) NSString *bdm_mobile_no;

@property (strong, nonatomic) NSString *relation_type;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *father_mother_spouse_name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *mobile_no;
@property (strong, nonatomic) NSString *religion;
@property (strong, nonatomic) NSString *address_type;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *city_town_village;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *pincode;
@property (strong, nonatomic) NSString *date_of_birth;
@property (strong, nonatomic) NSString *customer_category;
@property (strong, nonatomic) NSString *customer_category_subcategory;
@property (strong, nonatomic) NSString *partydetails_maritalstatus;
@property (strong, nonatomic) NSString *intended_application;
@property (strong, nonatomic) NSString *cust_loan_type; //new
@property (strong, nonatomic) NSString *account_type;
@property (strong, nonatomic) NSString *account_name;
@property (strong, nonatomic) NSString *account_site;
@property (strong, nonatomic) NSString *account_number;
@property (strong, nonatomic) NSString *account_pan_no_company;
@property (strong, nonatomic) NSString *account_address1;
@property (strong, nonatomic) NSString *account_address2;
@property (strong, nonatomic) NSString *account_city_town_village;
@property (strong, nonatomic) NSString *account_state;
@property (strong, nonatomic) NSString *account_district;
@property (strong, nonatomic) NSString *account_pincode;
@property (strong, nonatomic) NSString *opty_id;
@property (strong, nonatomic) NSString *opty_created_date;
@property (strong, nonatomic) NSString *ex_showroom_price;
@property (strong, nonatomic) NSString *on_road_price_total_amt;
@property (strong, nonatomic) NSString *pan_no_company;
@property (strong, nonatomic) NSString *pan_no_indiviual;
@property (strong, nonatomic) NSString *id_type;
@property (strong, nonatomic) NSString *id_description;
@property (strong, nonatomic) NSString *id_issue_date;
@property (strong, nonatomic) NSString *id_expiry_date;
@property (strong, nonatomic) NSString *lob;
@property (strong, nonatomic) NSString *ppl;
@property (strong, nonatomic) NSString *pl;
@property (strong, nonatomic) NSString *usage;
@property (strong, nonatomic) NSString *vehicle_class;
@property (strong, nonatomic) NSString *vehicle_color;
@property (strong, nonatomic) NSString *emission_norms;
@property (strong, nonatomic) NSString *loandetails_repayable_in_months;
@property (strong, nonatomic) NSString *repayment_mode;

@property (strong, nonatomic) NSString *taluka;
@property (strong, nonatomic) NSString *vc_number;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *event_id;
@property (strong, nonatomic) NSString *event_name;
@property (strong, nonatomic) NSString *bu_id;
@property (strong, nonatomic) NSString *channel_type;
@property (strong, nonatomic) NSString *ref_type;
@property (strong, nonatomic) NSString *mmgeo;
@property (strong, nonatomic) NSString *camp_id;
@property (strong, nonatomic) NSString *camp_name;
@property (strong, nonatomic) NSString *body_type;
@property (strong, nonatomic) NSString *loan_tenor;
@property (strong, nonatomic) NSString *division_id;
@property (strong, nonatomic) NSString *organization_code;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *fin_occupation_in_years;
@property (strong, nonatomic) NSString *fin_occupation;
@property (strong, nonatomic) NSString *partydetails_annualincome;
@property (strong, nonatomic) NSString *indicative_loan_amt;
@property (strong, nonatomic) NSString *ltv;
@property (strong, nonatomic) NSString *account_tahsil_taluka;
@property (strong, nonatomic) NSString *type_of_property;
@property (strong, nonatomic) NSString *customer_type;
@property (strong, nonatomic) NSString *sales_stage_name;

@property (strong, nonatomic) NSString *coapplicant_first_name;
@property (strong, nonatomic) NSString *coapplicant_date_of_birth;
@property (strong, nonatomic) NSString *coapplicant_mobile_no;
@property (strong, nonatomic) NSString *coapplicant_address2;
@property (strong, nonatomic) NSString *coapplicant_address1;
@property (strong, nonatomic) NSString *coapplicant_city_town_village;
@property (strong, nonatomic) NSString *coapplicant_pan_no_indiviual;
@property (strong, nonatomic) NSString *coapplicant_pincode;
@property (strong, nonatomic) NSString *coapplicant_last_name;

@property (strong, nonatomic) NSString *toggleMode;

@property (strong,nonatomic) NSMutableArray *financierTMFBDMDetailsArray;

@property (nullable, nonatomic, retain) FinancierBranchDetailsModel *toFinancierBranch;

-(_Nullable instancetype)initWithObject:(AAAFinancierOpportunityMO * _Nullable)object;
-(instancetype)initWithFetchQuoteObject:(FinancierListDetailModel *)financierFetchQuoteobject;


@end
