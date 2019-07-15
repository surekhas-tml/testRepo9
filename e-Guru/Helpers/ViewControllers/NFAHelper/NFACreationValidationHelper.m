//
//  NFACreationValidationHelper.m
//  e-guru
//
//  Created by MI iMac04 on 29/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFACreationValidationHelper.h"
#import "UtilityMethods.h"
#import "NSString+NSStringCategory.h"
#import "EGErrorTableViewCell.h"

@implementation NFACreationValidationHelper

+ (BOOL)checkPositionValidityAndShowErroMessage:(EGNFA *)nfaModel {
    
    NSString *errorMessage = @"NFA cannot be created because of incorrect position mapping or Inactive User in the system. Request you to contact support team at crmdms@tatamotors.com to correct it.";
    
    if (!nfaModel || ![nfaModel.userPosition hasValue] || ![nfaModel.tsmPosition hasValue] || ![nfaModel.tsmEmail hasValue]) {
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
        return false;
    }
    
    return true;
}

+ (BOOL)errorCellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[EGErrorTableViewCell class]]) {
        return true;
    }
    return false;
}

@end
