//
//  FinancierAccountDetails.h
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAFinancierAccountDetailMO+CoreDataClass.h"

@class EGFinancierOpportunity;
@interface FinancierAccountDetails : NSObject

@property (nullable, nonatomic, copy) NSString* account_id;
@property (nullable, nonatomic, copy) NSString* pan_number_company;
@property (nullable, nonatomic, copy) NSString* accountAddress1;
@property (nullable, nonatomic, copy) NSString* accountAddress2;
@property (nullable, nonatomic, copy) NSString* accountType;
@property (nullable, nonatomic, copy) NSString* account_taluka;
@property (nullable, nonatomic, copy) NSString* accountState;
@property (nullable, nonatomic, copy) NSString* accountDistrict;
@property (nullable, nonatomic, copy) NSString* accountPinCode;
@property (nullable, nonatomic, copy) NSString* accountNumber;
@property (nullable, nonatomic, copy) NSString* accountCityTownVillage;
@property (nullable, nonatomic, copy) NSString* accountName;
@property (nullable, nonatomic, copy) NSString* accountSite;

@property (nullable, nonatomic, retain) NSSet<EGFinancierOpportunity *> *toFinancierOpportunity;

-(_Nullable instancetype)initWithObject:(AAAFinancierAccountDetailMO * _Nullable)object;


@end
