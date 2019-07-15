//
//  MISalesDetailsTableViewCell.h
//  e-guru
//
//  Created by Admin on 26/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISalesDetailsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerCityLabel;
@property (strong, nonatomic) IBOutlet UILabel *lobLabel;
@property (strong, nonatomic) IBOutlet UILabel *pplLabel;
@property (strong, nonatomic) IBOutlet UILabel *financerLabel;
@property (strong, nonatomic) IBOutlet UILabel *invoiceNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *invoiceStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *invoiceDateLabel;

@end
