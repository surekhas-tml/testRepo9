//
//  TMLProposedLandingPriceView.h
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface TMLProposedLandingPriceView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *exShowRoomTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *discountTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *landingPriceTextField;

@property (strong, nonatomic) NFATMLProposedLandingPrice *nfaTMLProposedLandingPrice;

@end
