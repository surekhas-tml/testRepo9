//
//  FinancierDetailsView.h
//  e-guru
//
//  Created by MI iMac04 on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface FinancierDetailsView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *financierTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *ltvField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *finSubvnTextField;

@property (strong, nonatomic) NFAFinancierDetails *nfaFinancierDetails;
@end
