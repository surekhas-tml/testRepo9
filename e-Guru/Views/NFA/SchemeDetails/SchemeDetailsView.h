//
//  SchemeDetailsView.h
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface SchemeDetailsView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *flatSchemeTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *priceHikeTextField;

@property (strong, nonatomic) NFASchemeDetails *nfaSchemeDetails;

@end
