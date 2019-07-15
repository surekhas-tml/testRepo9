//
//  FinancierPreviewDetailsVC.h
//  e-guru
//
//  Created by Admin on 19/11/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancierListDetailModel.h"

@interface FinancierPreviewDetailsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *genderLabel;
@property (weak, nonatomic) IBOutlet UITextField *maritalLabel;

@property (weak, nonatomic) IBOutlet UITextField *addressTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *dobLabel;
@property (weak, nonatomic) IBOutlet UITextField *religionLabel;
@property (weak, nonatomic) IBOutlet UITextField *relationtypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *fatherLabel;
@property (weak, nonatomic) IBOutlet UITextField *idTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *idDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *issueDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *expiryDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *finOccupation;
@property (weak, nonatomic) IBOutlet UITextField *finYearsBusiness;
@property (weak, nonatomic) IBOutlet UITextField *anualIncomeLabel;


@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *panNo;
@property (weak, nonatomic) IBOutlet UITextField *statelabel;
@property (weak, nonatomic) IBOutlet UITextField *talukaLabel;
@property (weak, nonatomic) IBOutlet UITextField *districtLabel;
@property (weak, nonatomic) IBOutlet UITextField *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *address1Label;
@property (weak, nonatomic) IBOutlet UITextField *address2Label;
@property (weak, nonatomic) IBOutlet UITextField *areaLabel;
@property (weak, nonatomic) IBOutlet UITextField *pinCodeLabel;

@property (weak, nonatomic) IBOutlet UITextField *coApplicantFirstName;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantLastName;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantPanNo;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantDOB;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantCity;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantAdd1;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantAdd2;
@property (weak, nonatomic) IBOutlet UITextField *coApplicantPincode;

@property (weak, nonatomic) IBOutlet UITextField *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountSiteLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *panNoCompanyLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountType;
@property (weak, nonatomic) IBOutlet UITextField *accountStateLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTalukaLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountDistrict;
@property (weak, nonatomic) IBOutlet UITextField *accountAddress1Label;
@property (weak, nonatomic) IBOutlet UITextField *accountAddress2Label;
@property (weak, nonatomic) IBOutlet UITextField *accountCityLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountPinCodeLabel;

@property (weak, nonatomic) IBOutlet UITextField *exshowRoomPrice;
@property (weak, nonatomic) IBOutlet UITextField *intendedApplication;
@property (weak, nonatomic) IBOutlet UITextField *typeOfProperty;
@property (weak, nonatomic) IBOutlet UITextField *customerType;
@property (weak, nonatomic) IBOutlet UITextField *on_road_price_total_amt;
@property (weak, nonatomic) IBOutlet UITextField *optyID;
@property (weak, nonatomic) IBOutlet UITextField *salesStage;

@property (weak, nonatomic) IBOutlet UITextField *fin_CustomerCategory;
@property (weak, nonatomic) IBOutlet UITextField *fin_CustomerSubcategory;
@property (weak, nonatomic) IBOutlet UITextField *fin_RepymentMode;
@property (weak, nonatomic) IBOutlet UITextField *fin_IndicativeAmount;
@property (weak, nonatomic) IBOutlet UITextField *fin_LoanTenor;
@property (weak, nonatomic) IBOutlet UITextField *fin_LTV;

@property (weak, nonatomic) IBOutlet UIView *personalvw;
@property (weak, nonatomic) IBOutlet UIView *contactvw;
@property (weak, nonatomic) IBOutlet UIView *coapplicantvw;
@property (weak, nonatomic) IBOutlet UIView *accountvw;
@property (weak, nonatomic) IBOutlet UIView *vehiclevw;
@property (weak, nonatomic) IBOutlet UIView *retailvw;


@property (nonatomic, strong) FinancierListDetailModel *financierListModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
