//
//  AAAFinancierAccountDetailMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 04/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierAccountDetailMO+CoreDataProperties.h"

@implementation AAAFinancierAccountDetailMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierAccountDetailMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierAccountDetails"];
}

@dynamic account_id;
@dynamic pan_number_company;
@dynamic accountAddress1;
@dynamic accountAddress2;
@dynamic accountType;
@dynamic accountState;
@dynamic account_taluka;
@dynamic accountDistrict;
@dynamic accountPinCode;
@dynamic accountNumber;
@dynamic accountCityTownVillage;
@dynamic accountName;
@dynamic accountSite;
@dynamic toOpportunity;

@end
