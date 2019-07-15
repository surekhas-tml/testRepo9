//
//  NFACreationValidationHelper.h
//  e-guru
//
//  Created by MI iMac04 on 29/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGNFA.h"
#import <UIKit/UIKit.h>

@interface NFACreationValidationHelper : NSObject

+ (BOOL)checkPositionValidityAndShowErroMessage:(EGNFA *)nfaModel;
+ (BOOL)errorCellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;


@end
