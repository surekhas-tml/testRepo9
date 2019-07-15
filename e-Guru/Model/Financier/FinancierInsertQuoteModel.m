//
//  FinancierInsertQuoteModel.m
//  e-guru
//
//  Created by Shashi on 09/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierInsertQuoteModel.h"

@implementation FinancierInsertQuoteModel

@synthesize financier_name;
@synthesize financier_id;
@synthesize branch_id;
@synthesize branch_name;
@synthesize bdm_id;
@synthesize bdm_name;
@synthesize bdm_mobile_no;

@synthesize organization;
@synthesize title;
@synthesize father_mother_spouse_name;
@synthesize gender;
@synthesize first_name;
@synthesize last_name;
@synthesize mobile_no;
@synthesize religion;
@synthesize address_type;
@synthesize address1;
@synthesize address2;
@synthesize area;
@synthesize city_town_village;
@synthesize state;
@synthesize district;
@synthesize pincode;
@synthesize date_of_birth;
@synthesize customer_category;
@synthesize customer_category_subcategory;
@synthesize partydetails_maritalstatus;
@synthesize intended_application;
@synthesize account_type;
@synthesize account_name;
@synthesize account_site;
@synthesize account_number;
@synthesize account_address1;
@synthesize account_address2;
@synthesize account_city_town_village;
@synthesize account_state;
@synthesize account_district;
@synthesize account_pincode;
@synthesize opty_id;
@synthesize opty_created_date;
@synthesize ex_showroom_price;
@synthesize on_road_price_total_amt;
@synthesize cust_loan_type;  
@synthesize pan_no_company;
@synthesize account_pan_no_company;
@synthesize pan_no_indiviual;
@synthesize id_type;
@synthesize id_description;
@synthesize id_issue_date;
@synthesize id_expiry_date;
@synthesize lob;
@synthesize ppl;
@synthesize pl;
@synthesize usage;
@synthesize vehicle_class;
@synthesize vehicle_color;
@synthesize emission_norms;
@synthesize loandetails_repayable_in_months;
@synthesize repayment_mode;

@synthesize taluka;
@synthesize vc_number;
@synthesize product_id;
@synthesize event_id;
@synthesize event_name;
@synthesize bu_id;
@synthesize channel_type;
@synthesize ref_type;
@synthesize mmgeo;
@synthesize camp_id;
@synthesize camp_name;
@synthesize body_type;
@synthesize loan_tenor;
@synthesize division_id;
@synthesize organization_code;
@synthesize quantity;
@synthesize fin_occupation_in_years;
@synthesize fin_occupation;
@synthesize partydetails_annualincome;
@synthesize indicative_loan_amt;
@synthesize ltv;
@synthesize account_tahsil_taluka;
@synthesize type_of_property;
@synthesize customer_type;
@synthesize sales_stage_name;

@synthesize coapplicant_first_name;
@synthesize coapplicant_date_of_birth;
@synthesize coapplicant_mobile_no;
@synthesize coapplicant_address2;
@synthesize coapplicant_address1;
@synthesize coapplicant_city_town_village;
@synthesize coapplicant_pan_no_indiviual;
@synthesize coapplicant_pincode;
@synthesize coapplicant_last_name;
@synthesize toggleMode;

-(instancetype)init{
    self =  [super init];
    if (self) {
        
        self.financierTMFBDMDetailsArray = [NSMutableArray new]; //new
        
        self.financier_name = @"";
        self.financier_id = @"";
        self.branch_id =@"";
        self.branch_name=@"";
        self.bdm_id=@"";
        self.bdm_name=@"";
        self.bdm_mobile_no=@"";
        
        self.organization = @"";
        self.title = @"";
        self.father_mother_spouse_name = @"";
        self.gender = @"";
        self.first_name = @"";
        self.last_name = @"";
        self.mobile_no = @"";
        self.religion = @"";
        self.address_type = @"";
        self.address1 = @"";
        self.address2 = @"";
        self.area = @"";
        self.city_town_village = @"";
        self.state = @"";
        self.district = @"";
        self.pincode = @"";
        self.date_of_birth = @"";
        self.customer_category = @"";
        self.customer_category_subcategory = @"";
        self.partydetails_maritalstatus = @"";
        self.intended_application = @"";
        self.account_type =@"";
        self.account_name = @"";
        self.account_site = @"";
        self.account_number = @"";
        self.account_address1 = @"";
        self.account_address2 = @"";
        self.account_city_town_village = @"";
        self.account_state = @"";
        self.account_district = @"";
        self.account_pincode = @"";
        self.opty_id = @"";
        self.opty_created_date = @"";
        self.ex_showroom_price = @"";
        self.on_road_price_total_amt = @"";
        self.cust_loan_type          = @"";   //new
        self.pan_no_company = @"";
        self.pan_no_indiviual = @"";
        self.id_type = @"";
        self.id_description = @"";
        self.id_issue_date = @"";
        self.id_expiry_date = @"";
        self.lob = @"";
        self.ppl = @"";
        self.pl = @"";
        self.usage = @"";
        self.vehicle_color = @"";
        self.vehicle_color = @"";
        self.emission_norms = @"";
        self.loandetails_repayable_in_months = @"";
        self.repayment_mode = @"";
        
        self.taluka= @"";
        self.vc_number= @"";
        self.product_id= @"";
        self.event_id= @"";
        self.event_name= @"";
        self.bu_id = @"";
        self.channel_type = @"";
        self.ref_type = @"";
        self.mmgeo = @"";
        self.camp_id = @"";
        self.camp_name = @"";
        self.body_type = @"";
        self.loan_tenor = @"";
        self.division_id = @"";
        self.organization_code = @"";
        self.quantity = @"";
        self.fin_occupation_in_years = @"";
        self.fin_occupation = @"";
        self.partydetails_annualincome = @"";
        self.indicative_loan_amt = @"";
        self.ltv = @"";
        self.account_tahsil_taluka = @"";
        self.type_of_property = @"";
        self.customer_type = @"";
        self.sales_stage_name = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancierOpportunityMO * _Nullable)object{
    self = [super init];
    
    if (self) {
        
        self.financierTMFBDMDetailsArray = [NSMutableArray new]; //new
        
        self.financier_name = object.toFinancierSelectedFinancier.selectedFinancierName;//new
        self.financier_id = object.toFinancierSelectedFinancier.selectedFinancierID;//new
      
        self.branch_id = object.toFinancierSelectedFinancier.branch_id;//new
        self.branch_name= object.toFinancierSelectedFinancier.branch_name;//new
        self.bdm_id= object.toFinancierSelectedFinancier.bdm_id;//new
        self.bdm_name= object.toFinancierSelectedFinancier.bdm_name;//new
        self.bdm_mobile_no= object.toFinancierSelectedFinancier.bdm_mobile_no;//new
        
        self.organization = object.toFinancierOpty.organization_name? : @"";
        self.title = object.toFinancierContact.title? : @"";
        self.father_mother_spouse_name =  @"";
        self.relation_type = @""; 
        self.gender = object.toFinancierContact.gender? : @"";
        self.first_name = object.toFinancierContact.firstName? : @"";
        self.last_name = object.toFinancierContact.lastName? : @"";
        self.mobile_no = object.toFinancierContact.mobileno? : @"";
        self.religion =  @"";
        self.address_type = @"";
        self.address1 = object.toFinancierContact.address1? : @"";
        self.address2 = object.toFinancierContact.address2? : @"";
        self.area = object.toFinancierContact.area? : @"";
        self.city_town_village = object.toFinancierContact.citytownvillage? : @"";
        self.state = object.toFinancierContact.state? : @"";
        self.district = object.toFinancierContact.district? : @"";
        self.pincode = object.toFinancierContact.pincode? : @"";
        self.date_of_birth = object.toFinancierContact.date_of_birth? : @"";
        self.customer_category = @"";
        self.customer_category_subcategory = @"";
        self.partydetails_maritalstatus = @"";
        self.intended_application = object.toFinancierOpty.intendedApplication? : @"";
        self.account_type =object.toFinancierAccount.accountType? : @"";
        self.account_name = object.toFinancierAccount.accountName? : @"";
        self.account_site = object.toFinancierAccount.accountSite? : @"";
        self.account_number = object.toFinancierAccount.accountNumber? : @"";
        self.account_pan_no_company = object.toFinancierAccount.pan_number_company ? : @"";
        self.account_state = object.toFinancierAccount.accountState? : @"";
        self.account_tahsil_taluka = object.toFinancierAccount.account_taluka;
        self.account_city_town_village = object.toFinancierAccount.accountCityTownVillage? : @"";
        self.account_district = object.toFinancierAccount.accountDistrict? : @"";
        self.account_address1 = object.toFinancierAccount.accountAddress1? : @"";
        self.account_address2 = object.toFinancierAccount.accountAddress2 ? : @"";
        self.account_pincode = object.toFinancierAccount.accountPinCode? : @"";
        self.opty_id = object.toFinancierOpty.optyID? : @"";
        self.opty_created_date = object.toFinancierOpty.optyCreatedDate? : @"";
        self.ex_showroom_price = object.toFinancierOpty.ex_showroom_price? : @"";
        self.on_road_price_total_amt = object.toFinancierOpty.on_road_price_total_amt ? : @"";
        self.cust_loan_type         = object.toFinancierOpty.cust_loan_type ? : @""; //new
        self.pan_no_company = object.toFinancierOpty.pan_number_company ? : @"";
        self.pan_no_indiviual = object.toFinancierContact.pan_number_individual? : @"";
        self.id_type =  @"";
        self.id_description =  @"";
        self.id_issue_date =  @"";
        self.id_expiry_date =  @"";
        self.lob = object.toFinancierOpty.lob ? : @"";
        self.ppl = object.toFinancierOpty.ppl? : @"";
        self.pl = object.toFinancierOpty.pl? : @"";
        self.usage = object.toFinancierOpty.usage? : @"";
        self.vehicle_class =  @"";
        self.vehicle_color = @"";
        self.emission_norms =  @"";
        self.loandetails_repayable_in_months =  @"";
        self.repayment_mode =  @"";
        self.taluka= object.toFinancierContact.taluka ? : @"" ;
        self.vc_number= object.toFinancierOpty.vcNumber? :@"";
        self.product_id= object.toFinancierOpty.productID ? :@"";
        self.event_id= @"";
        self.event_name= @"";
        self.bu_id = object.toFinancierOpty.bu_id ? :@"";
        self.channel_type = object.toFinancierOpty.channelType ? :@"";
        self.ref_type = @"";
        self.mmgeo = @"";
        self.camp_id = @"";
        self.camp_name = @"";
        self.body_type = object.toFinancierOpty.bodyType ? :@"";
        self.loan_tenor = @"";
        self.division_id = object.toFinancierOpty.divID ? :@"";
        self.organization_code = object.toFinancierOpty.organizationID ? :@"";
        self.quantity = object.toFinancierOpty.quantity ? :@"";
        self.fin_occupation_in_years = @"";
        self.fin_occupation = object.toFinancierContact.occupation ? :@"";
        self.partydetails_annualincome = @"";
        self.indicative_loan_amt = @"";
        self.ltv = @"";
        self.type_of_property = @"";
        self.customer_type = object.toFinancierOpty.customer_type ;
        self.sales_stage_name = object.toFinancierOpty.sales_stage_name;
    }
    return self;
}

-(instancetype)initWithFetchQuoteObject:(FinancierListDetailModel *)financierFetchQuoteobject{
    
    self = [super init];
    
    if (self) {
        
        self.organization = financierFetchQuoteobject.organization ? : @"";
        self.title = financierFetchQuoteobject.title;
        self.father_mother_spouse_name = financierFetchQuoteobject.father_mother_spouse_name ? : @"";
        self.relation_type = financierFetchQuoteobject.relationship_type? : @"";
        self.gender = financierFetchQuoteobject.gender? : @"";
        self.first_name = financierFetchQuoteobject.first_name? : @"";
        self.last_name = financierFetchQuoteobject.last_name? : @"";
        self.mobile_no = financierFetchQuoteobject.mobile_no? : @"";
        self.religion =  financierFetchQuoteobject.religion? : @"";
        self.address_type = financierFetchQuoteobject.address_type? : @"";
        self.address1 = financierFetchQuoteobject.address1? : @"";
        self.address2 = financierFetchQuoteobject.address2? : @"";
        self.area = financierFetchQuoteobject.area? : @"";
        self.city_town_village = financierFetchQuoteobject.city_town_village? : @"";
        self.state = financierFetchQuoteobject.state? : @"";
        self.district = financierFetchQuoteobject.district? : @"";
        self.pincode = financierFetchQuoteobject.pincode? : @"";
        self.date_of_birth = financierFetchQuoteobject.date_of_birth? : @"";
        self.customer_category = financierFetchQuoteobject.customer_category;
        self.customer_category_subcategory = financierFetchQuoteobject.customer_subcategory? : @"";
        self.partydetails_maritalstatus = financierFetchQuoteobject.partydetails_maritalstatus? : @"";
        self.intended_application = financierFetchQuoteobject.intended_application? : @"";
        self.account_type =financierFetchQuoteobject.account_type? : @"";
        self.account_name = financierFetchQuoteobject.account_name? : @"";
        self.account_site = financierFetchQuoteobject.account_site? : @"";
        self.account_number = financierFetchQuoteobject.account_number? : @"";
        self.account_pan_no_company = financierFetchQuoteobject.pan_no_company ? : @"";
        self.account_address1 = financierFetchQuoteobject.account_address1? : @"";
        self.account_address2 = financierFetchQuoteobject.account_address2 ? : @"";
        self.account_city_town_village = financierFetchQuoteobject.account_city_town_village? : @"";
        self.account_state = financierFetchQuoteobject.account_state? : @"";
        self.account_district = financierFetchQuoteobject.account_district? : @"";
        self.account_pincode = financierFetchQuoteobject.account_pincode? : @"";
        self.opty_id = financierFetchQuoteobject.optyID? : @"";
        self.opty_created_date = financierFetchQuoteobject.opty_created_date? : @"";
        self.ex_showroom_price = financierFetchQuoteobject.ex_showroom_price? : @"";
        self.on_road_price_total_amt = financierFetchQuoteobject.on_road_price_total_amt? : @"";
        self.cust_loan_type = financierFetchQuoteobject.cust_loan_type ? : @"";     //new
        self.pan_no_company = financierFetchQuoteobject.pan_no_company ? : @"";
        self.pan_no_indiviual = financierFetchQuoteobject.pan_no_indiviual? : @"";
        self.id_type =  financierFetchQuoteobject.id_type? : @"";
        self.id_description =  financierFetchQuoteobject.id_description? : @"";
        self.id_issue_date =  financierFetchQuoteobject.id_issue_date? : @"";
        self.id_expiry_date =  financierFetchQuoteobject.id_expiry_date? : @"";
        self.lob = financierFetchQuoteobject.lob ? : @"";
        self.ppl = financierFetchQuoteobject.ppl? : @"";
        self.pl = financierFetchQuoteobject.pl? : @"";
        self.usage = financierFetchQuoteobject.usage? : @"";
        self.vehicle_class =  financierFetchQuoteobject.vehicle_class? : @"";
        self.vehicle_color = financierFetchQuoteobject.vehicle_color? : @"";
        self.emission_norms =  financierFetchQuoteobject.emission_norms? : @"";
        self.loandetails_repayable_in_months =  financierFetchQuoteobject.loandetails_repayable_in_months? : @"";
        self.repayment_mode =  financierFetchQuoteobject.repayment_mode? : @"";
        self.taluka= financierFetchQuoteobject.taluka ? : @"" ;
        self.vc_number= financierFetchQuoteobject.vc_number? :@"";
        self.product_id= financierFetchQuoteobject.product_id ? :@"";
        self.event_id= @"";
        self.event_name= @"";
        self.bu_id = @"";
        self.channel_type = financierFetchQuoteobject.channel_type ? :@"";
        self.ref_type =  @"";
        self.mmgeo =  @"";
        self.camp_id = @"";
        self.camp_name = @"";
        self.body_type = financierFetchQuoteobject.body_type ? :@"";
        self.loan_tenor = financierFetchQuoteobject.loan_tenor? : @"";
        self.ltv = financierFetchQuoteobject.ltv ? : @"";
        self.division_id = @"";
        self.organization_code = @"";
        self.quantity = @"";
        self.fin_occupation_in_years = financierFetchQuoteobject.fin_occupation_in_years? : @"";
        self.fin_occupation = financierFetchQuoteobject.fin_occupation ? :@"";
        self.partydetails_annualincome = financierFetchQuoteobject.partydetails_annualincome ? : @"";
        self.indicative_loan_amt = financierFetchQuoteobject.indicative_loan_amt? : @"";
        self.account_tahsil_taluka = financierFetchQuoteobject.account_taluka? : @"";
        self.type_of_property = financierFetchQuoteobject.type_of_property? : @"";
        self.customer_type = financierFetchQuoteobject.customer_type? : @"";
        self.sales_stage_name = financierFetchQuoteobject.sales_stage_name? : @"";
        
        self.coapplicant_first_name = financierFetchQuoteobject.coapplicant_first_name ? :@"";
        coapplicant_last_name = financierFetchQuoteobject.coapplicant_last_name ? :@"";
        self.coapplicant_mobile_no= financierFetchQuoteobject.coapplicant_mobile_no ? :@"";
        self.coapplicant_address2 = financierFetchQuoteobject.coapplicant_address2 ? :@"";
        self.coapplicant_address1 = financierFetchQuoteobject.coapplicant_address1 ? :@"";
        coapplicant_city_town_village = financierFetchQuoteobject.coapplicant_city_town_village ? :@"";
        coapplicant_pan_no_indiviual = financierFetchQuoteobject.coapplicant_pan_no_indiviual ? :@"";
        coapplicant_pincode = financierFetchQuoteobject.coapplicant_pincode ? :@"";
        self.coapplicant_date_of_birth = financierFetchQuoteobject.coapplicant_date_of_birth ? :@"";
    }
    return self;
    
}
@end
