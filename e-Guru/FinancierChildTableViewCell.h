//
//  FinancierChildTableViewCell.h
//  e-guru
//
//  Created by Admin on 20/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancierChildTableViewCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *eligibilityAmtLabel;
@property (weak, nonatomic) IBOutlet UILabel *irrPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiAmtLabel;
@property (weak, nonatomic) IBOutlet UILabel *financierSchemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *financierContactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *financierContactNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@end
