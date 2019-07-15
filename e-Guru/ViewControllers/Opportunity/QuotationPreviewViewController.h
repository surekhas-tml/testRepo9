//
//  QuotationPreviewViewController.h
//  e-guru
//
//  Created by Ashish Barve on 9/22/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderedView.h"
#import "EGQuotation.h"
#import "EGOpportunity.h"

@interface QuotationPreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *textFieldsContainer;
@property (weak, nonatomic) IBOutlet UIView *quotationView;
@property (weak, nonatomic) IBOutlet BorderedView *quotationDetailsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *termsAndConditions;

@property (strong, nonatomic) IBOutlet UILabel *mQuoteNumber;
@property (strong, nonatomic) IBOutlet UILabel *mQuoteCreationDate;
@property (strong, nonatomic) IBOutlet UILabel *mContactFullName;
@property (strong, nonatomic) IBOutlet UILabel *mStreetAddress;
@property (strong, nonatomic) IBOutlet UILabel *mStreetAddress2;
@property (strong, nonatomic) IBOutlet UILabel *mPostalCode;
@property (strong, nonatomic) IBOutlet UILabel *mTaluka;
@property (strong, nonatomic) IBOutlet UILabel *mDistrict;
@property (strong, nonatomic) IBOutlet UILabel *mStateCountry;
@property (strong, nonatomic) IBOutlet UILabel *mPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *mMobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *mDeliveryLocation;
@property (strong, nonatomic) IBOutlet UILabel *mFinancier;
@property (strong, nonatomic) IBOutlet UILabel *mCustomerGSTIN;
@property (strong, nonatomic) IBOutlet UILabel *mDealerGSTIN;
@property (strong, nonatomic) IBOutlet UILabel *mProductDescription;
@property (strong, nonatomic) IBOutlet UILabel *mQuantity;
@property (strong, nonatomic) IBOutlet UILabel *mUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *mAmount;
@property (strong, nonatomic) IBOutlet UILabel *mSpeedGovernorQty;
@property (strong, nonatomic) IBOutlet UILabel *mSpeedGovernorAmount;
@property (strong, nonatomic) IBOutlet UILabel *mGrandTotalAmount;
@property (strong, nonatomic) IBOutlet UILabel *mGrandTotalAmountInWords;
@property (strong, nonatomic) IBOutlet UILabel *mDealerName;
@property (strong, nonatomic) IBOutlet UILabel *mTermsAndConditions;


@property (strong, nonatomic) EGOpportunity *opportunityObj;
@property (strong, nonatomic) EGQuotation *quotationObj;

@end
