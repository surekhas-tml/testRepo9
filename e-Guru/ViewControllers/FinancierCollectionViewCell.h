//
//  FinancierCollectionViewCell.h
//  e-guru
//
//  Created by Admin on 13/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancierCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *optyID;
@property (weak, nonatomic) IBOutlet UILabel *financieName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNo;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *salesStage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
