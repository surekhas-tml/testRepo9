//
//  DealerMarginAndRetentionView.h
//  e-guru
//
//  Created by admin on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface DealerMarginAndRetentionView : NFASectionBaseView

@property (weak, nonatomic) IBOutlet GreyBorderUITextField *dealerMarginTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *retentionTextField;

@property (strong, nonatomic) NFADealerMarginAndRetention *nfaDealerMarginAndRetention;

@end
