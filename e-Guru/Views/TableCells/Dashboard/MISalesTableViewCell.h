//
//  MISalesTableViewCell.h
//  e-guru
//
//  Created by MI iMac04 on 15/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISalesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *pplLabel;
@property (strong, nonatomic) IBOutlet UILabel *dseLabel;
@property (strong, nonatomic) IBOutlet UILabel *nnewInvoiceLabel;

@property (strong, nonatomic) IBOutlet UILabel *cancelInvoiceLabel;
@property (strong, nonatomic) IBOutlet UILabel *netInvoiceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dealerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lobLabel;

@end
