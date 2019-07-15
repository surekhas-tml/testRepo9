//
//  DealDetailsView.h
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface DealDetailsView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *lobTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *pplTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *modelTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *dealSizeTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *billingTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *vcTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *productDescriptionTextField;

@property (strong, nonatomic) NFADealDetails *nfaDealDetails;
@end
