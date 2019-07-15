//
//  CompetitionDetails.h
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFASectionBaseView.h"

@interface CompetitionDetailsView : NFASectionBaseView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DropDownTextField *competitorTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *modelTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *exShowroomTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *discountTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *landingPriceTextField;

@property (strong, nonatomic) NFACompetitionDetails *nfaCompetitionDetails;
@end
