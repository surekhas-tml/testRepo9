//
//  AAAFinancierAccountDetailMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 04/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierAccountDetailMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierAccountDetailMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierAccountDetailMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *account_id;
@property (nullable, nonatomic, copy) NSString *pan_number_company;
@property (nullable, nonatomic, copy) NSString *accountAddress1;
@property (nullable, nonatomic, copy) NSString *accountAddress2;
@property (nullable, nonatomic, copy) NSString *accountType;
@property (nullable, nonatomic, copy) NSString *accountState;
@property (nullable, nonatomic, copy) NSString *account_taluka;
@property (nullable, nonatomic, copy) NSString *accountDistrict;
@property (nullable, nonatomic, copy) NSString *accountPinCode;
@property (nullable, nonatomic, copy) NSString *accountNumber;
@property (nullable, nonatomic, copy) NSString *accountCityTownVillage;
@property (nullable, nonatomic, copy) NSString *accountName;
@property (nullable, nonatomic, copy) NSString *accountSite;
@property (nullable, nonatomic, retain) AAAFinancierOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
