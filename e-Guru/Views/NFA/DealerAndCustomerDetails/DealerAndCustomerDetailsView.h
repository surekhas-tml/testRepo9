//
//  DealerAndCustomerDetails.h
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"
#import "DropDownTextField.h"
@interface DealerAndCustomerDetailsView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *opportunityIDTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *dealerCodeTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *dealerNameTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *mmIntendedApplicationTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *additionalCustomersTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *vehicleRegistrationStateTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *contactTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *tmlFleetSizeTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *overallFleetSizeTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *dealTypeTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (strong, nonatomic) NFADealerAndCustomerDetails *nfaDealerAndCustomerDetails;
@property (strong, nonatomic) EGOpportunity *opportunity;
@end
