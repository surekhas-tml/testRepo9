//
//  AccountCollectionViewCell.h
//  e-Guru
//
//  Created by Apple on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *siteName;
@property (weak, nonatomic) IBOutlet UILabel *mainPhoneNumberData;
@property (weak, nonatomic) IBOutlet UILabel *fnamedata;
@property (weak, nonatomic) IBOutlet UILabel *lnamedata;
@property (weak, nonatomic) IBOutlet UILabel *mobilenumberdata;
@property (weak, nonatomic) IBOutlet UILabel *emaildata;
@property (weak, nonatomic) IBOutlet UILabel *pan_no_data;
@property (weak, nonatomic) IBOutlet UILabel *accoutnNameData;
@property (weak, nonatomic) IBOutlet UIButton *deleteAccount;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
