//
//  AAAFinancierSelectedDetailMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 04/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierSelectedDetailMO+CoreDataProperties.h"

@implementation AAAFinancierSelectedDetailMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierSelectedDetailMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierSelectedDetails"];
}

@dynamic selectedFinancierID;
@dynamic selectedFinancierName;
//new
@dynamic branch_id;
@dynamic branch_name;
@dynamic bdm_id;
@dynamic bdm_name;
@dynamic bdm_mobile_no;

@dynamic toOpportunity;

@end
