//
//  FinancierListDetailModel.m
//  e-guru
//
//  Created by Shashi on 30/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierListDetailModel.h"

@implementation FinancierListDetailModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.comment                    = [NSString string];
        self.branchID                   = [NSString string];
        self.financierName              = [NSString string];
        self.optyID                     = [NSString string];
        self.caseStatus                 = [NSString string];
        self.integrationStatus    = [NSString string];
        self.lastUpdatedStatus    = [NSString string];
        self.eligibilityAmt       = [NSString string];
        self.irrPercent           = [NSString string];
        self.emiAmt               = [NSString string];
        self.schemeType           = [NSString string];
        self.contactName          = [NSString string];
        self.contactNo            = [NSString string];
        self.financierID          = [NSString string];
        self.financierQuoteTenor  = [NSString string];
        self.financierQuoteDate   = [NSString string];
        self.financierQuoteId      = [NSString string];
        self.quoteSubmissionTime        = [NSString string];

        //Financie Field Data
        self.organization           = [NSString string];
        self.relationship_type = [NSString string];
        self.indicative_loan_ammout = [NSString string];
        self.coapplicant_first_name = [NSString string];
        self.loandetails_repayable_in_months = [NSString string];
        self.coapplicant_date_of_birth = [NSString string];
        self.ltv= [NSString string];
        self.coapplicant_mobile_no= [NSString string];
        self.coapplicant_address2= [NSString string];
        self.coapplicant_address1= [NSString string];
        self.coapplicant_city_town_village= [NSString string];
        self.branch_name= [NSString string];
        self.bdm_id= [NSString string];
        self.customer_type= [NSString string];
        self.type_of_property= [NSString string];
        self.coapplicant_pan_no_indiviual= [NSString string];
        self.fin_occupation= [NSString string];
        self.coapplicant_last_name= [NSString string];
        self.indicative_loan_amt= [NSString string];
        self.coapplicant_pincode= [NSString string];

        self.opty_created_date          = [NSString string];
        self.emission_norms  = [NSString string];
        self.pan_no_indiviual   = [NSString string];
        self.vc_number      = [NSString string];
        self.ppl  = [NSString string];
        self.id_expiry_date          = [NSString string];
        self.body_type  = [NSString string];
        self.loandetails_repayableinmonths   = [NSString string];
        self.mobile_no      = [NSString string];
        self.last_name  = [NSString string];
        self.lob          = [NSString string];
        self.first_name  = [NSString string];
        self.intended_application   = [NSString string];
        self.district      = [NSString string];
        self.area  = [NSString string];
        self.account_state          = [NSString string];
        self.account_taluka = [NSString string];
        self.vehicle_color  = [NSString string];
        self.customer_subcategory   = [NSString string];
        self.account_pincode      = [NSString string];
        self.religion  = [NSString string];
        self.state          = [NSString string];
        self.taluka = [NSString string];
        self.date_of_birth  = [NSString string];
        self.account_site   = [NSString string];
        self.partydetails_occupation      = [NSString string];
        self.fin_occupation_in_years = [NSString string];
        self.usage  = [NSString string];
        self.address_type          = [NSString string];
        self.pl  = [NSString string];
        self.partydetails_maritalstatus   = [NSString string];
        self.vehicle_class      = [NSString string];
        self.repayment_mode  = [NSString string];
        self.loan_tenor          = [NSString string];
        self.account_type  = [NSString string];
        self.account_address1   = [NSString string];
        self.address1      = [NSString string];
        self.address2  = [NSString string];
        self.account_city_town_village          = [NSString string];
        self.account_address2  = [NSString string];
        self.account_district   = [NSString string];
        self.sales_person_dse      = [NSString string];
        self.sale_person_dsm  = [NSString string];
        self.id_issue_date          = [NSString string];
        self.id_type  = [NSString string];
        self.pan_no_company   = [NSString string];
        self.pincode      = [NSString string];
        self.ex_showroom_price  = [NSString string];
       
        self.optyID = [NSString string];
        self.sales_stage_name =[NSString string];
        
        self.inidcative_loan_amt          = [NSString string];
        self.id_description  = [NSString string];
        self.gender   = [NSString string];
        self.title      = [NSString string];
        self.account_name  = [NSString string];
        self.channel_type      = [NSString string];
        self.product_id  = [NSString string];
        self.partydetails_annualincome      = [NSString string];
        self.account_number  = [NSString string];
        self.on_road_price_total_amt      = [NSString string];
        self.cust_loan_type = [NSString string]; //new
        self.customer_category  = [NSString string];
        self.city_town_village      = [NSString string];
        self.father_mother_spouse_name  = [NSString string];

    }
    return self;
}

@end
