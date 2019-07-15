//
//  FinancierRequestViewController+CreateFinancier.m
//  e-guru
//
//  Created by Shashi on 16/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierRequestViewController+CreateFinancier.h"
#import "AppDelegate.h"
#import "AAADraftFinancierMO+CoreDataClass.h"
#import "AAAFinancierInsertMO+CoreDataClass.h"
#import "FinancierInsertQuoteModel.h"
#import "Constant.h"
#import "ReachabilityManager.h"
#import "DraftsViewController.h"
#import "NSString+NSStringCategory.h"
#import "EGDraftStatus.h"

@implementation FinancierRequestViewController (CreateFinancier)


//- (void) showContactDraftSaveConfirmation {
//    NSString *message = @"You are currently Offline. Contact will be created automatically once we get the Internet Connection.";
//    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
//      
//        if (self.draftFinancier && [self.draftFinancier.draftID hasValue]) {
//            [self updateFinancier:EGDraftStatusQueuedToSync];
//        } else {
//            [self saveFinancier:EGDraftStatusQueuedToSync];
//        }
//        
//        // Go to home screen
//        [[AppRepo sharedRepo] showHomeScreen];
//    }];
//}

- (void)saveFinancier:(EGDraftStatus) draftStatus {
    
    AAADraftFinancierMO *draftFinancierMO = [NSEntityDescription insertNewObjectForEntityForName:E_DRAFTFINANCIER inManagedObjectContext:appdelegate.managedObjectContext];
    draftFinancierMO.draftID = [UtilityMethods uuid];
    draftFinancierMO.userIDLink = [[AppRepo sharedRepo] getLoggedInUser].userName;
    draftFinancierMO.status = draftStatus;

    AAAFinancierInsertMO *financierInsertInfo = [NSEntityDescription insertNewObjectForEntityForName:E_FINANCERINSERTQUOTES inManagedObjectContext:appdelegate.managedObjectContext];
    financierInsertInfo.financier_name = self.insertQuoteModel.financier_name;
    financierInsertInfo.financier_id = self.insertQuoteModel.financier_id;
    financierInsertInfo.branch_name = self.insertQuoteModel.branch_name;
    financierInsertInfo.branch_id = self.insertQuoteModel.branch_id;
    financierInsertInfo.bdm_name = self.insertQuoteModel.bdm_name;
    financierInsertInfo.bdm_id = self.insertQuoteModel.bdm_id;
    financierInsertInfo.bdm_mobile_no = self.insertQuoteModel.bdm_mobile_no;
    
    financierInsertInfo.financierTMFBDMDetailsArray = self.insertQuoteModel.financierTMFBDMDetailsArray;
    
    financierInsertInfo.relation_type                   = self.insertQuoteModel.relation_type;
    financierInsertInfo.account_name                    = self.insertQuoteModel.account_name;
    financierInsertInfo.account_number                  = self.insertQuoteModel.account_number;
    financierInsertInfo.account_pan_no_company          = self.insertQuoteModel.account_pan_no_company;
    financierInsertInfo.account_type                    = self.insertQuoteModel.account_type;
    financierInsertInfo.account_tahsil_taluka           = self.insertQuoteModel.account_tahsil_taluka;
    financierInsertInfo.account_state                   = self.insertQuoteModel.account_state;
    financierInsertInfo.account_city_town_village       = self.insertQuoteModel.account_city_town_village;
    financierInsertInfo.account_district                = self.insertQuoteModel.account_district;
    financierInsertInfo.account_address1                = self.insertQuoteModel.account_address1;
    financierInsertInfo.account_address2                = self.insertQuoteModel.account_address2;
    financierInsertInfo.account_pincode                 = self.insertQuoteModel.account_pincode;
    financierInsertInfo.account_site                    = self.insertQuoteModel.account_site;
    financierInsertInfo.address1                        = self.insertQuoteModel.address1;
    financierInsertInfo.address2                        = self.insertQuoteModel.address2;
    financierInsertInfo.address_type                    = self.insertQuoteModel.address_type;
    financierInsertInfo.cust_loan_type                  = self.insertQuoteModel.cust_loan_type;  //new for individual
    financierInsertInfo.area                            = self.insertQuoteModel.area;
    financierInsertInfo.city_town_village               = self.insertQuoteModel.city_town_village;
    financierInsertInfo.customer_category               = self.insertQuoteModel.customer_category;
    financierInsertInfo.customer_category_subcategory   = self.insertQuoteModel.customer_category_subcategory;
    financierInsertInfo.date_of_birth                   = self.insertQuoteModel.date_of_birth;
    financierInsertInfo.district                        = self.insertQuoteModel.district;
    financierInsertInfo.emission_norms                  = self.insertQuoteModel.emission_norms;
    financierInsertInfo.ex_showroom_price               = self.insertQuoteModel.ex_showroom_price;
    financierInsertInfo.father_mother_spouse_name       = self.insertQuoteModel.father_mother_spouse_name;
    financierInsertInfo.first_name                      = self.insertQuoteModel.first_name;
    financierInsertInfo.gender                          = self.insertQuoteModel.gender;
    financierInsertInfo.id_description                  = self.insertQuoteModel.id_description;
    financierInsertInfo.id_expiry_date                  = self.insertQuoteModel.id_expiry_date;
    financierInsertInfo.id_issue_date                   = self.insertQuoteModel.id_issue_date;
    financierInsertInfo.id_type                         = self.insertQuoteModel.id_type;
    financierInsertInfo.intended_application            = self.insertQuoteModel.intended_application;
    financierInsertInfo.last_name                       = self.insertQuoteModel.last_name;
    financierInsertInfo.loandetails_repayable_in_months = self.insertQuoteModel.loandetails_repayable_in_months;
    financierInsertInfo.lob                             = self.insertQuoteModel.lob;
    financierInsertInfo.mobile_no                       = self.insertQuoteModel.mobile_no;
    financierInsertInfo.on_road_price_total_amt         = self.insertQuoteModel.on_road_price_total_amt;
    financierInsertInfo.opty_created_date               = self.insertQuoteModel.opty_created_date;
    financierInsertInfo.opty_id                         = self.insertQuoteModel.opty_id;
    financierInsertInfo.organization                    = self.insertQuoteModel.organization;
    financierInsertInfo.pan_no_company                  = self.insertQuoteModel.pan_no_company;
    financierInsertInfo.pan_no_indiviual                = self.insertQuoteModel.pan_no_indiviual;
    financierInsertInfo.partydetails_maritalstatus      = self.insertQuoteModel.partydetails_maritalstatus;
    financierInsertInfo.pincode                         = self.insertQuoteModel.pincode;
    financierInsertInfo.pl                              = self.insertQuoteModel.pl;
    financierInsertInfo.ppl                             = self.insertQuoteModel.ppl;
    financierInsertInfo.religion                        = self.insertQuoteModel.religion;
    financierInsertInfo.repayment_mode                  = self.insertQuoteModel.repayment_mode;
    financierInsertInfo.state                           = self.insertQuoteModel.state;
    financierInsertInfo.title                           = self.insertQuoteModel.title;
    financierInsertInfo.usage                           = self.insertQuoteModel.usage;
    financierInsertInfo.vehicle_class                   = self.insertQuoteModel.vehicle_class;
    financierInsertInfo.vehicle_color                   = self.insertQuoteModel.vehicle_color;
    financierInsertInfo.taluka                          = self.insertQuoteModel.taluka;
    financierInsertInfo.vc_number                       = self.insertQuoteModel.vc_number;
    financierInsertInfo.product_id                      = self.insertQuoteModel.product_id;
    financierInsertInfo.event_id                        = self.insertQuoteModel.event_id;
    financierInsertInfo.event_name                      = self.insertQuoteModel.event_name;
    financierInsertInfo.bu_id                           = self.insertQuoteModel.bu_id;
    financierInsertInfo.channel_type                    = self.insertQuoteModel.channel_type;
    financierInsertInfo.ref_type                        = self.insertQuoteModel.ref_type;
    financierInsertInfo.mmgeo                           = self.insertQuoteModel.mmgeo;
    financierInsertInfo.camp_id                         = self.insertQuoteModel.camp_id;
    financierInsertInfo.camp_name                       = self.insertQuoteModel.camp_name;
    financierInsertInfo.body_type                       = self.insertQuoteModel.body_type;
    financierInsertInfo.loan_tenor                      = self.insertQuoteModel.loan_tenor;
    financierInsertInfo.division_id                     = self.insertQuoteModel.division_id;
    financierInsertInfo.organization_code               = self.insertQuoteModel.organization_code;
    financierInsertInfo.quantity                        = self.insertQuoteModel.quantity;
    financierInsertInfo.fin_occupation_in_years         = self.insertQuoteModel.fin_occupation_in_years;
    financierInsertInfo.fin_occupation                  = self.insertQuoteModel.fin_occupation;
    financierInsertInfo.partydetails_annualincome       = self.insertQuoteModel.partydetails_annualincome;
    financierInsertInfo.indicative_loan_amt             = self.insertQuoteModel.indicative_loan_amt;
    financierInsertInfo.ltv                             = self.insertQuoteModel.ltv;
    financierInsertInfo.type_of_property                = self.insertQuoteModel.type_of_property;
    financierInsertInfo.customer_type                   = self.insertQuoteModel.customer_type;
    financierInsertInfo.sales_stage_name                = self.insertQuoteModel.sales_stage_name;  //new
    
    financierInsertInfo.coapplicant_first_name          = self.insertQuoteModel.coapplicant_first_name;
    financierInsertInfo.coapplicant_last_name           = self.insertQuoteModel.coapplicant_last_name;
    financierInsertInfo.coapplicant_date_of_birth       = self.insertQuoteModel.coapplicant_date_of_birth;
    financierInsertInfo.coapplicant_mobile_no           = self.insertQuoteModel.coapplicant_mobile_no;
    financierInsertInfo.coapplicant_address1            = self.insertQuoteModel.coapplicant_address1;
    financierInsertInfo.coapplicant_address2            = self.insertQuoteModel.coapplicant_address2;
    financierInsertInfo.coapplicant_city_town_village   = self.insertQuoteModel.coapplicant_city_town_village;
    financierInsertInfo.coapplicant_pan_no_indiviual    = self.insertQuoteModel.coapplicant_pan_no_indiviual;
    financierInsertInfo.coapplicant_pincode             = self.insertQuoteModel.coapplicant_pincode;
    financierInsertInfo.toggleMode                      = self.insertQuoteModel.toggleMode;
    
    draftFinancierMO.toInsertQuote =  financierInsertInfo;
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        self.currentDraftID = draftFinancierMO.draftID;
//        NSLog(@"%@ == %@",self.currentDraftID ,[[AppRepo sharedRepo] getLoggedInUser].userName);
        [self.draftButton  setTitle:UPDATE_DRAFT forState:UIControlStateNormal];
        [UtilityMethods alert_ShowMessage:@"Retail Financier saved as Draft successfully..." withTitle:APP_NAME andOKAction:^{
            [self.navigationController popViewControllerAnimated:true];
        }];
    }
}

- (void)updateFinancier:(EGDraftStatus) draftStatus {
   
    NSFetchRequest *fetchRequest = [AAADraftFinancierMO fetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.draftID == %@ && SELF.userIDLink == %@",  self.draftFinancier.draftID ,[[AppRepo sharedRepo] getLoggedInUser].userName]];
    
    AAADraftFinancierMO * draftFinancierInfo = [[appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    draftFinancierInfo.status = draftStatus;

    [draftFinancierInfo setValue: self.insertQuoteModel.financier_name.length > 0 ? self.insertQuoteModel.financier_name : @"" forKeyPath:@"toInsertQuote.financier_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.financier_id.length > 0 ? self.insertQuoteModel.financier_id : @"" forKeyPath:@"toInsertQuote.financier_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.branch_name.length > 0 ? self.insertQuoteModel.branch_name : @"" forKeyPath:@"toInsertQuote.branch_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.branch_id.length > 0 ? self.insertQuoteModel.branch_id : @"" forKeyPath:@"toInsertQuote.branch_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.bdm_name.length > 0 ? self.insertQuoteModel.bdm_name : @"" forKeyPath:@"toInsertQuote.bdm_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.bdm_id.length > 0 ? self.insertQuoteModel.bdm_id : @"" forKeyPath:@"toInsertQuote.bdm_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.bdm_mobile_no.length > 0 ? self.insertQuoteModel.bdm_mobile_no : @"" forKeyPath:@"toInsertQuote.bdm_mobile_no"];
    
    [draftFinancierInfo setValue: self.insertQuoteModel.financierTMFBDMDetailsArray > 0 ? self.insertQuoteModel.financierTMFBDMDetailsArray : @"" forKeyPath:@"toInsertQuote.financierTMFBDMDetailsArray"]; //array
    
    [draftFinancierInfo setValue: self.insertQuoteModel.relation_type.length > 0 ? self.insertQuoteModel.relation_type : @"" forKeyPath:@"toInsertQuote.relation_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.organization.length > 0 ? self.insertQuoteModel.organization : @"" forKeyPath:@"toInsertQuote.organization"];
    [draftFinancierInfo setValue: self.insertQuoteModel.title.length > 0 ? self.insertQuoteModel.title : @"" forKeyPath:@"toInsertQuote.title"];
    [draftFinancierInfo setValue: self.insertQuoteModel.father_mother_spouse_name.length > 0 ? self.insertQuoteModel.father_mother_spouse_name : @"" forKeyPath:@"toInsertQuote.father_mother_spouse_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.gender.length > 0 ? self.insertQuoteModel.gender : @"" forKeyPath:@"toInsertQuote.gender"];
    [draftFinancierInfo setValue: self.insertQuoteModel.first_name.length > 0 ? self.insertQuoteModel.first_name : @"" forKeyPath:@"toInsertQuote.first_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.last_name.length > 0 ? self.insertQuoteModel.last_name : @"" forKeyPath:@"toInsertQuote.last_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.mobile_no.length > 0 ? self.insertQuoteModel.mobile_no : @"" forKeyPath:@"toInsertQuote.mobile_no"];
    [draftFinancierInfo setValue: self.insertQuoteModel.religion.length > 0 ? self.insertQuoteModel.religion : @"" forKeyPath:@"toInsertQuote.religion"];
    [draftFinancierInfo setValue: self.insertQuoteModel.address_type.length > 0 ? self.insertQuoteModel.address_type : @"" forKeyPath:@"toInsertQuote.address_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.address1.length > 0 ? self.insertQuoteModel.address1 : @"" forKeyPath:@"toInsertQuote.address1"];
    [draftFinancierInfo setValue: self.insertQuoteModel.address2.length > 0 ? self.insertQuoteModel.address2 : @"" forKeyPath:@"toInsertQuote.address2"];
    [draftFinancierInfo setValue: self.insertQuoteModel.area.length > 0 ? self.insertQuoteModel.area : @"" forKeyPath:@"toInsertQuote.area"];
    [draftFinancierInfo setValue: self.insertQuoteModel.city_town_village.length > 0 ? self.insertQuoteModel.city_town_village : @"" forKeyPath:@"toInsertQuote.city_town_village"];
    [draftFinancierInfo setValue: self.insertQuoteModel.state.length > 0 ? self.insertQuoteModel.state : @"" forKeyPath:@"toInsertQuote.state"];
    [draftFinancierInfo setValue: self.insertQuoteModel.district.length > 0 ? self.insertQuoteModel.district : @"" forKeyPath:@"toInsertQuote.district"];
    [draftFinancierInfo setValue: self.insertQuoteModel.pincode.length > 0 ? self.insertQuoteModel.pincode : @"" forKeyPath:@"toInsertQuote.pincode"];
    [draftFinancierInfo setValue: self.insertQuoteModel.date_of_birth.length > 0 ? self.insertQuoteModel.date_of_birth : @"" forKeyPath:@"toInsertQuote.date_of_birth"];
    [draftFinancierInfo setValue: self.insertQuoteModel.customer_category.length > 0 ? self.insertQuoteModel.customer_category : @"" forKeyPath:@"toInsertQuote.customer_category"];
    [draftFinancierInfo setValue: self.insertQuoteModel.customer_category_subcategory.length > 0 ? self.insertQuoteModel.customer_category_subcategory : @"" forKeyPath:@"toInsertQuote.customer_category_subcategory"];
    [draftFinancierInfo setValue: self.insertQuoteModel.partydetails_maritalstatus.length > 0 ? self.insertQuoteModel.partydetails_maritalstatus : @"" forKeyPath:@"toInsertQuote.partydetails_maritalstatus"];
    [draftFinancierInfo setValue: self.insertQuoteModel.intended_application.length > 0 ? self.insertQuoteModel.intended_application : @"" forKeyPath:@"toInsertQuote.intended_application"];
    
    [draftFinancierInfo setValue: self.insertQuoteModel.cust_loan_type.length > 0 ? self.insertQuoteModel.cust_loan_type : @"" forKeyPath:@"toInsertQuote.cust_loan_type"];  //new for individual
                                                                                                                                                
    [draftFinancierInfo setValue: self.insertQuoteModel.account_name.length > 0 ? self.insertQuoteModel.account_name : @"" forKeyPath:@"toInsertQuote.account_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_site.length > 0 ? self.insertQuoteModel.account_site : @"" forKeyPath:@"toInsertQuote.account_site"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_number.length > 0 ? self.insertQuoteModel.account_number : @"" forKeyPath:@"toInsertQuote.account_number"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_pan_no_company.length > 0 ? self.insertQuoteModel.account_pan_no_company : @"" forKeyPath:@"toInsertQuote.account_pan_no_company"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_type.length > 0 ? self.insertQuoteModel.account_type : @"" forKeyPath:@"toInsertQuote.account_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_state.length > 0 ? self.insertQuoteModel.account_state : @"" forKeyPath:@"toInsertQuote.account_state"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_tahsil_taluka.length > 0 ? self.insertQuoteModel.account_tahsil_taluka : @"" forKeyPath:@"toInsertQuote.account_tahsil_taluka"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_district.length > 0 ? self.insertQuoteModel.account_district : @"" forKeyPath:@"toInsertQuote.account_district"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_city_town_village.length > 0 ? self.insertQuoteModel.account_city_town_village : @"" forKeyPath:@"toInsertQuote.account_city_town_village"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_address1.length > 0 ? self.insertQuoteModel.account_address1 : @"" forKeyPath:@"toInsertQuote.account_address1"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_address2.length > 0 ? self.insertQuoteModel.account_address2 : @"" forKeyPath:@"toInsertQuote.account_address2"];
    [draftFinancierInfo setValue: self.insertQuoteModel.account_pincode.length > 0 ? self.insertQuoteModel.account_pincode : @"" forKeyPath:@"toInsertQuote.account_pincode"];
    [draftFinancierInfo setValue: self.insertQuoteModel.opty_id.length > 0 ? self.insertQuoteModel.opty_id : @"" forKeyPath:@"toInsertQuote.opty_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.opty_created_date.length > 0 ? self.insertQuoteModel.opty_created_date : @"" forKeyPath:@"toInsertQuote.opty_created_date"];
    [draftFinancierInfo setValue: self.insertQuoteModel.ex_showroom_price.length > 0 ? self.insertQuoteModel.ex_showroom_price : @"" forKeyPath:@"toInsertQuote.ex_showroom_price"];
    [draftFinancierInfo setValue: self.insertQuoteModel.on_road_price_total_amt.length > 0 ? self.insertQuoteModel.on_road_price_total_amt : @"" forKeyPath:@"toInsertQuote.on_road_price_total_amt"];
    [draftFinancierInfo setValue: self.insertQuoteModel.pan_no_company.length > 0 ? self.insertQuoteModel.pan_no_company : @"" forKeyPath:@"toInsertQuote.pan_no_company"];
    [draftFinancierInfo setValue: self.insertQuoteModel.pan_no_indiviual.length > 0 ? self.insertQuoteModel.pan_no_indiviual : @"" forKeyPath:@"toInsertQuote.pan_no_indiviual"];
    [draftFinancierInfo setValue: self.insertQuoteModel.id_type.length > 0 ? self.insertQuoteModel.id_type : @"" forKeyPath:@"toInsertQuote.id_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.id_description.length > 0 ? self.insertQuoteModel.id_description : @"" forKeyPath:@"toInsertQuote.id_description"];
    [draftFinancierInfo setValue: self.insertQuoteModel.id_issue_date.length > 0 ? self.insertQuoteModel.id_issue_date : @"" forKeyPath:@"toInsertQuote.id_issue_date"];
    [draftFinancierInfo setValue: self.insertQuoteModel.id_expiry_date.length > 0 ? self.insertQuoteModel.id_expiry_date : @"" forKeyPath:@"toInsertQuote.id_expiry_date"];
    [draftFinancierInfo setValue: self.insertQuoteModel.lob.length > 0 ? self.insertQuoteModel.lob : @"" forKeyPath:@"toInsertQuote.lob"];
    [draftFinancierInfo setValue: self.insertQuoteModel.ppl.length > 0 ? self.insertQuoteModel.ppl : @"" forKeyPath:@"toInsertQuote.ppl"];
    [draftFinancierInfo setValue: self.insertQuoteModel.pl.length > 0 ? self.insertQuoteModel.pl : @"" forKeyPath:@"toInsertQuote.pl"];
    [draftFinancierInfo setValue: self.insertQuoteModel.usage.length > 0 ? self.insertQuoteModel.usage : @"" forKeyPath:@"toInsertQuote.usage"];
    [draftFinancierInfo setValue: self.insertQuoteModel.vehicle_class.length > 0 ? self.insertQuoteModel.vehicle_class : @"" forKeyPath:@"toInsertQuote.vehicle_class"];
    [draftFinancierInfo setValue: self.insertQuoteModel.vehicle_color.length > 0 ? self.insertQuoteModel.vehicle_color : @"" forKeyPath:@"toInsertQuote.vehicle_color"];
    [draftFinancierInfo setValue: self.insertQuoteModel.emission_norms.length > 0 ? self.insertQuoteModel.emission_norms : @"" forKeyPath:@"toInsertQuote.emission_norms"];
    [draftFinancierInfo setValue: self.insertQuoteModel.loandetails_repayable_in_months.length > 0 ? self.insertQuoteModel.loandetails_repayable_in_months : @"" forKeyPath:@"toInsertQuote.loandetails_repayable_in_months"];
    [draftFinancierInfo setValue: self.insertQuoteModel.repayment_mode.length > 0 ? self.insertQuoteModel.repayment_mode : @"" forKeyPath:@"toInsertQuote.repayment_mode"];
    [draftFinancierInfo setValue: self.insertQuoteModel.taluka.length > 0 ? self.insertQuoteModel.taluka : @"" forKeyPath:@"toInsertQuote.taluka"];
    [draftFinancierInfo setValue: self.insertQuoteModel.vc_number.length > 0 ? self.insertQuoteModel.vc_number : @"" forKeyPath:@"toInsertQuote.vc_number"];
    [draftFinancierInfo setValue: self.insertQuoteModel.product_id.length > 0 ? self.insertQuoteModel.product_id : @"" forKeyPath:@"toInsertQuote.product_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.event_id.length > 0 ? self.insertQuoteModel.event_id : @"" forKeyPath:@"toInsertQuote.event_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.event_name.length > 0 ? self.insertQuoteModel.event_name : @"" forKeyPath:@"toInsertQuote.event_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.bu_id.length > 0 ? self.insertQuoteModel.bu_id : @"" forKeyPath:@"toInsertQuote.bu_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.channel_type.length > 0 ? self.insertQuoteModel.channel_type : @"" forKeyPath:@"toInsertQuote.channel_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.ref_type.length > 0 ? self.insertQuoteModel.ref_type : @"" forKeyPath:@"toInsertQuote.ref_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.mmgeo.length > 0 ? self.insertQuoteModel.mmgeo : @"" forKeyPath:@"toInsertQuote.mmgeo"];
    [draftFinancierInfo setValue: self.insertQuoteModel.camp_id.length > 0 ? self.insertQuoteModel.camp_id : @"" forKeyPath:@"toInsertQuote.camp_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.camp_name.length > 0 ? self.insertQuoteModel.camp_name : @"" forKeyPath:@"toInsertQuote.camp_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.body_type.length > 0 ? self.insertQuoteModel.body_type : @"" forKeyPath:@"toInsertQuote.body_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.loan_tenor.length > 0 ? self.insertQuoteModel.loan_tenor : @"" forKeyPath:@"toInsertQuote.loan_tenor"];
    [draftFinancierInfo setValue: self.insertQuoteModel.division_id.length > 0 ? self.insertQuoteModel.division_id : @"" forKeyPath:@"toInsertQuote.division_id"];
    [draftFinancierInfo setValue: self.insertQuoteModel.organization_code.length > 0 ? self.insertQuoteModel.organization_code : @"" forKeyPath:@"toInsertQuote.organization_code"];
    [draftFinancierInfo setValue: self.insertQuoteModel.quantity.length > 0 ? self.insertQuoteModel.quantity : @"" forKeyPath:@"toInsertQuote.quantity"];
    [draftFinancierInfo setValue: self.insertQuoteModel.fin_occupation_in_years.length > 0 ? self.insertQuoteModel.fin_occupation_in_years : @"" forKeyPath:@"toInsertQuote.fin_occupation_in_years"];
    [draftFinancierInfo setValue: self.insertQuoteModel.fin_occupation.length > 0 ? self.insertQuoteModel.fin_occupation : @"" forKeyPath:@"toInsertQuote.fin_occupation"];
    [draftFinancierInfo setValue: self.insertQuoteModel.partydetails_annualincome.length > 0 ? self.insertQuoteModel.partydetails_annualincome : @"" forKeyPath:@"toInsertQuote.partydetails_annualincome"];
    [draftFinancierInfo setValue: self.insertQuoteModel.indicative_loan_amt.length > 0 ? self.insertQuoteModel.indicative_loan_amt : @"" forKeyPath:@"toInsertQuote.indicative_loan_amt"];
    [draftFinancierInfo setValue: self.insertQuoteModel.ltv.length > 0 ? self.insertQuoteModel.ltv : @"" forKeyPath:@"toInsertQuote.ltv"];
    [draftFinancierInfo setValue: self.insertQuoteModel.type_of_property.length > 0 ? self.insertQuoteModel.type_of_property : @"" forKeyPath:@"toInsertQuote.type_of_property"];
    [draftFinancierInfo setValue: self.insertQuoteModel.customer_type.length > 0 ? self.insertQuoteModel.customer_type : @"" forKeyPath:@"toInsertQuote.customer_type"];
    [draftFinancierInfo setValue: self.insertQuoteModel.sales_stage_name.length > 0 ? self.insertQuoteModel.sales_stage_name : @"" forKeyPath:@"toInsertQuote.sales_stage_name"];  //new key
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_first_name.length > 0 ? self.insertQuoteModel.coapplicant_first_name : @"" forKeyPath:@"toInsertQuote.coapplicant_first_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_last_name.length > 0 ? self.insertQuoteModel.coapplicant_last_name : @"" forKeyPath:@"toInsertQuote.coapplicant_last_name"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_date_of_birth.length > 0 ? self.insertQuoteModel.coapplicant_date_of_birth : @"" forKeyPath:@"toInsertQuote.coapplicant_date_of_birth"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_mobile_no.length > 0 ? self.insertQuoteModel.coapplicant_mobile_no : @"" forKeyPath:@"toInsertQuote.coapplicant_mobile_no"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_address1.length > 0 ? self.insertQuoteModel.coapplicant_address1 : @"" forKeyPath:@"toInsertQuote.coapplicant_address1"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_address2.length > 0 ? self.insertQuoteModel.coapplicant_address2 : @"" forKeyPath:@"toInsertQuote.coapplicant_address2"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_city_town_village.length > 0 ? self.insertQuoteModel.coapplicant_city_town_village : @"" forKeyPath:@"toInsertQuote.coapplicant_city_town_village"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_pan_no_indiviual.length > 0 ? self.insertQuoteModel.coapplicant_pan_no_indiviual : @"" forKeyPath:@"toInsertQuote.coapplicant_pan_no_indiviual"];
    [draftFinancierInfo setValue: self.insertQuoteModel.coapplicant_pincode.length > 0 ? self.insertQuoteModel.coapplicant_pincode : @"" forKeyPath:@"toInsertQuote.coapplicant_pincode"];
    [draftFinancierInfo setValue: self.insertQuoteModel.toggleMode forKeyPath:@"toInsertQuote.toggleMode"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
            [UtilityMethods alert_ShowMessage:@"Retail Financier Draft updated successfully!!" withTitle:APP_NAME andOKAction:^{
                [[AppRepo sharedRepo] showHomeScreen];
            }];
    }
    
}


@end
