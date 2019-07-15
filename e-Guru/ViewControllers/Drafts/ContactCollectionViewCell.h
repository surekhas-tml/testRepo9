//
//  ContactCollectionViewCell.h
//  e-Guru
//
//  Created by Apple on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstNameData;
@property (weak, nonatomic) IBOutlet UILabel *lastNameData;
@property (weak, nonatomic) IBOutlet UILabel *emailData;
@property (weak, nonatomic) IBOutlet UILabel *panNoData;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberdraftContact;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
