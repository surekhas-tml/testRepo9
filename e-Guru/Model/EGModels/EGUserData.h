//
//  UserData.h
//  e-guru
//
//  Created by MI iMac04 on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGUserData : NSObject

@property (strong, nonatomic) NSString *lob;
@property (strong, nonatomic) NSString *positionType;
@property (strong, nonatomic) NSString *primaryPositionID;
@property (strong, nonatomic) NSString *primaryEmployeeID;
@property (strong, nonatomic) NSString *positionID;
@property (strong, nonatomic) NSString *lobName;
@property (strong, nonatomic) NSString *lobRowID;
@property (strong, nonatomic) NSString *lobBUUnit;
//@property (strong, nonatomic) NSString *organization_name; //for later use
@property (strong, nonatomic) NSString *organizationID;
@property (strong, nonatomic) NSString *dsmName;
@property (strong, nonatomic) NSString *lobServiceTaxFlag;
@property (strong, nonatomic) NSString *positionName;
@property (strong, nonatomic) NSString *employeeRowID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *primaryEmployeeCellNum;
@property (strong, nonatomic) NSString *dealerCode;
@property (strong, nonatomic) NSString *organizationName;
@property (strong, nonatomic) NSString *userState;
@end
