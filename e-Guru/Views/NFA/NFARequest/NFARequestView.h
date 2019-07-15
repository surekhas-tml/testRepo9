//
//  NFARequest.h
//  e-guru
//
//  Created by admin on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"
#import "EGNFA.h"

@interface NFARequestView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *netSupportPerVehicleTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *totalSupportSoughtTextField;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (strong, nonatomic) NFARequestModel *nfaRequestModel;

- (void)calculateNetSupportPreVehicle;

@end
