//
//  FinancierPreviewDetailsVC.m
//  e-guru
//
//  Created by Admin on 19/11/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierPreviewDetailsVC.h"
#import "UtilityMethods.h"

@interface FinancierPreviewDetailsVC ()

@end

@implementation FinancierPreviewDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatingBorderToView];
    
//    if (_financierListModel) {
//    }
    [self bindDataToFieldsFromModel:_financierListModel];
    
}

-(void)creatingBorderToView{
    _personalvw.layer.borderWidth = 1;
    _personalvw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _contactvw.layer.borderWidth = 1;
    _contactvw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _coapplicantvw.layer.borderWidth = 1;
    _coapplicantvw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _accountvw.layer.borderWidth = 1;
    _accountvw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _vehiclevw.layer.borderWidth = 1;
    _vehiclevw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _retailvw.layer.borderWidth = 1;
    _retailvw.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self configureView];
}

- (void)configureView {
    self.navigationController.title = FINANCIER_PREVIEW;
    [UtilityMethods navigationBarSetupForController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindDataToFieldsFromModel:(FinancierListDetailModel *)fieldModelData {

    self.titleLabel.text = fieldModelData.title;
    [self.genderLabel setText:fieldModelData.gender];
    [self.maritalLabel setText:fieldModelData.partydetails_maritalstatus];
    [self.addressTypeLabel setText:fieldModelData.address_type];
    [self.dobLabel setText:fieldModelData.date_of_birth];
    [self.religionLabel setText:fieldModelData.religion];
    [self.relationtypeLabel setText:fieldModelData.relationship_type];
    [self.fatherLabel setText:fieldModelData.father_mother_spouse_name];
    [self.idTypeLabel setText:fieldModelData.id_type];
    [self.idDescriptionLabel setText:fieldModelData.id_description];
    [self.issueDateLabel setText:fieldModelData.id_issue_date];
    [self.expiryDateLabel setText:fieldModelData.id_expiry_date];
    [self.finOccupation setText:fieldModelData.fin_occupation];
    [self.finYearsBusiness setText:fieldModelData.fin_occupation_in_years];
    [self.anualIncomeLabel setText:fieldModelData.partydetails_annualincome];
    
    [self.firstName  setText:fieldModelData.first_name];
    [self.lastName setText:fieldModelData.last_name];
    [self.mobileNo setText:fieldModelData.mobile_no];
    [self.panNo setText:fieldModelData.pan_no_indiviual];
    [self.statelabel setText:fieldModelData.state];
    [self.talukaLabel setText:fieldModelData.taluka];
    [self.districtLabel setText:fieldModelData.district];
    [self.cityLabel setText:fieldModelData.city_town_village];
    [self.address1Label setText:fieldModelData.address1];
    [self.address2Label setText:fieldModelData.address2];
    [self.areaLabel setText:fieldModelData.area];
    [self.pinCodeLabel setText:fieldModelData.pincode];

    [self.coApplicantFirstName setText:fieldModelData.coapplicant_first_name];
    [self.coApplicantLastName setText:fieldModelData.coapplicant_last_name];
    [self.coApplicantMobileNo setText:fieldModelData.coapplicant_mobile_no];
    [self.coApplicantPanNo setText:fieldModelData.coapplicant_pan_no_indiviual];
    [self.coApplicantCity setText:fieldModelData.coapplicant_city_town_village];
    [self.coApplicantAdd1 setText:fieldModelData.coapplicant_address1];
    [self.coApplicantAdd2 setText:fieldModelData.coapplicant_address2];
    [self.coApplicantPincode setText:fieldModelData.coapplicant_pincode];
    [self.coApplicantDOB setText:fieldModelData.coapplicant_date_of_birth];
    
    [self.accountNameLabel      setText:fieldModelData.account_name];
    [self.accountSiteLabel      setText:fieldModelData.account_site];
    [self.accountPhoneNo        setText:fieldModelData.account_number];
    [self.panNoCompanyLabel            setText:fieldModelData.pan_no_company];
    [self.accountType               setText:fieldModelData.account_type];
    [self.accountStateLabel             setText:fieldModelData.account_state];
    [self.accountTalukaLabel           setText:fieldModelData.account_taluka];
    [self.accountDistrict         setText:fieldModelData.account_district];
    [self.accountCityLabel             setText:fieldModelData.account_city_town_village];
    [self.accountPinCodeLabel           setText:fieldModelData.account_pincode];
    [self.accountAddress1Label             setText:fieldModelData.account_address1];
    [self.accountAddress2Label             setText:fieldModelData.account_address2];

    [self.exshowRoomPrice       setText:fieldModelData.ex_showroom_price];
    [self.intendedApplication   setText:fieldModelData.intended_application];
    [self.typeOfProperty        setText:fieldModelData.type_of_property];
    [self.customerType          setText:fieldModelData.customer_type];
    self.on_road_price_total_amt.text = fieldModelData.on_road_price_total_amt; //new
    [self.optyID setText:fieldModelData.optyID];
    [self.salesStage setText:fieldModelData.sales_stage_name];
    
    [self.fin_CustomerCategory    setText:fieldModelData.customer_category];
    [self.fin_CustomerSubcategory setText:fieldModelData.customer_subcategory];
    [self.fin_RepymentMode   setText:fieldModelData.repayment_mode];
    [self.fin_IndicativeAmount     setText:fieldModelData.indicative_loan_amt];
    [self.fin_LoanTenor          setText:fieldModelData.loan_tenor];
    [self.fin_LTV          setText:fieldModelData.ltv];

}

@end
