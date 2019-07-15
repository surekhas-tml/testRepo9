//
//  OpportunityDetailsTableViewCell.h
//  e-Guru
//
//  Created by Juili on 04/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpportunityDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@property (weak, nonatomic) IBOutlet UILabel *col1Title;
@property (weak, nonatomic) IBOutlet UILabel *col2Title;
@property (weak, nonatomic) IBOutlet UILabel *col3Title;
@property (weak, nonatomic) IBOutlet UILabel *col4Title;
@property (weak, nonatomic) IBOutlet UILabel *col5Title;
@property (weak, nonatomic) IBOutlet UILabel *col6Title;

@property (weak, nonatomic) IBOutlet UILabel *col1Val;
@property (weak, nonatomic) IBOutlet UILabel *col2Val;
@property (weak, nonatomic) IBOutlet UILabel *col3Val;
@property (weak, nonatomic) IBOutlet UILabel *col4Val;
@property (weak, nonatomic) IBOutlet UILabel *col5Val;
@property (weak, nonatomic) IBOutlet UILabel *col6Val;
@end
