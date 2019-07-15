//
//  PPLwiseChildTableViewCell.h
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLwiseChildTableViewCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *plNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *c0OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c0VehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c1OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c1VehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c1AOptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c1AVehicleCount;
@property (weak, nonatomic) IBOutlet UILabel *c2OptyCount;
@property (weak, nonatomic) IBOutlet UILabel *c2VehicleCount;
@property (strong, nonatomic) IBOutlet UILabel *currentStockpl;

@end
