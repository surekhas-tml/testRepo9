//
//  AAAFinancierOpportunityMO+CoreDataProperties.m
//  e-guru
//
//  Created by Shashi on 19/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierOpportunityMO+CoreDataProperties.h"

@implementation AAAFinancierOpportunityMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierOpportunityMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FinancierOpportunity"];
}

@dynamic isTimeBefore48Hours;
@dynamic optyID;
@dynamic isQuoteSubmitToCRm;
@dynamic isQuoteSubmitToFinancier;
@dynamic isAnyCaseApproved;
@dynamic is_eligible_for_insert_quote;
@dynamic is_first_case_rejected;

@dynamic toFinancierAccount;
@dynamic toFinancierContact;
@dynamic toFinancierOpty;
@dynamic toFinancierSelectedFinancier;

@end
