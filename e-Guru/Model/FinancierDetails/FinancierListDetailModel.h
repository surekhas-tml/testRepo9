//
//  FinancierListDetailModel.h
//  e-guru
//
//  Created by Shashi on 30/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancierListDetailModel : NSObject


@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *branchID;
@property (strong, nonatomic) NSString *financierName;  //parent
@property (strong, nonatomic) NSString *optyID;
@property (strong, nonatomic) NSString *caseStatus;
@property (strong, nonatomic) NSString *integrationStatus;
@property (strong, nonatomic) NSString *lastUpdatedStatus;
@property (strong, nonatomic) NSString *eligibilityAmt;
@property (strong, nonatomic) NSString *irrPercent;
@property (strong, nonatomic) NSString *emiAmt;
@property (strong, nonatomic) NSString *schemeType;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *contactNo;
@property (strong, nonatomic) NSString *financierID;  //other
@property (strong, nonatomic) NSString *financierQuoteTenor;
@property (strong, nonatomic) NSString *financierQuoteDate;
@property (strong, nonatomic) NSString *financierQuoteId;
@property (strong, nonatomic) NSString *quoteSubmissionTime;
//Financie Field Data

@property (strong, nonatomic) NSString *coapplicant_first_name;
@property (strong, nonatomic) NSString *coapplicant_date_of_birth;
@property (strong, nonatomic) NSString *coapplicant_mobile_no;
@property (strong, nonatomic) NSString *coapplicant_address2;
@property (strong, nonatomic) NSString *coapplicant_address1;
@property (strong, nonatomic) NSString *coapplicant_city_town_village;
@property (strong, nonatomic) NSString *coapplicant_pan_no_indiviual;
@property (strong, nonatomic) NSString *coapplicant_pincode;
@property (strong, nonatomic) NSString *coapplicant_last_name;

@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *relationship_type;
@property (strong, nonatomic) NSString *indicative_loan_ammout;
@property (strong, nonatomic) NSString *loandetails_repayable_in_months;
@property (strong, nonatomic) NSString *ltv;
@property (strong, nonatomic) NSString *branch_name;
@property (strong, nonatomic) NSString *bdm_id;
@property (strong, nonatomic) NSString *customer_type;
@property (strong, nonatomic) NSString *type_of_property;
@property (strong, nonatomic) NSString *fin_occupation;
@property (strong, nonatomic) NSString *indicative_loan_amt;
@property (strong, nonatomic) NSString *opty_created_date;
@property (strong, nonatomic) NSString *emission_norms;
@property (strong, nonatomic) NSString *pan_no_indiviual;
@property (strong, nonatomic) NSString *vc_number;
@property (strong, nonatomic) NSString *ppl;
@property (strong, nonatomic) NSString *id_expiry_date;
@property (strong, nonatomic) NSString *body_type;
@property (strong, nonatomic) NSString *loandetails_repayableinmonths;
@property (strong, nonatomic) NSString *mobile_no;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *lob;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *intended_application;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *account_state;
@property (strong, nonatomic) NSString *vehicle_color;
@property (strong, nonatomic) NSString *customer_subcategory;
@property (strong, nonatomic) NSString *account_pincode;
@property (strong, nonatomic) NSString *religion;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *taluka;
@property (strong, nonatomic) NSString *account_taluka;
@property (strong, nonatomic) NSString *date_of_birth;
@property (strong, nonatomic) NSString *account_site;
@property (strong, nonatomic) NSString *partydetails_occupation;
@property (strong, nonatomic) NSString *fin_occupation_in_years;
@property (strong, nonatomic) NSString *usage;
@property (strong, nonatomic) NSString *address_type;
@property (strong, nonatomic) NSString *pl;
@property (strong, nonatomic) NSString *partydetails_maritalstatus;
@property (strong, nonatomic) NSString *vehicle_class;
@property (strong, nonatomic) NSString *repayment_mode;
@property (strong, nonatomic) NSString *loan_tenor;
@property (strong, nonatomic) NSString *account_type;
@property (strong, nonatomic) NSString *account_address1;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *account_city_town_village;
@property (strong, nonatomic) NSString *account_address2;
@property (strong, nonatomic) NSString *account_district;
@property (strong, nonatomic) NSString *sales_person_dse;
@property (strong, nonatomic) NSString *sale_person_dsm;
@property (strong, nonatomic) NSString *id_issue_date;
@property (strong, nonatomic) NSString *id_type;
@property (strong, nonatomic) NSString *pan_no_company;
@property (strong, nonatomic) NSString *pincode;
@property (strong, nonatomic) NSString *ex_showroom_price;

@property (strong, nonatomic) NSString *sales_stage_name;

@property (strong, nonatomic) NSString *inidcative_loan_amt;
@property (strong, nonatomic) NSString *id_description;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *account_name;
@property (strong, nonatomic) NSString *channel_type;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *partydetails_annualincome;
@property (strong, nonatomic) NSString *account_number;
@property (strong, nonatomic) NSString *on_road_price_total_amt;
@property (strong, nonatomic) NSString *cust_loan_type; //new
@property (strong, nonatomic) NSString *customer_category;
@property (strong, nonatomic) NSString *city_town_village;
@property (strong, nonatomic) NSString *father_mother_spouse_name;

@property (strong, nonatomic) NSMutableArray *financierListDetailsArray;

@end
