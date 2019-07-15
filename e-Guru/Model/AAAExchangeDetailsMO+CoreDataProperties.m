//
//  AAAExchangeDetailsMO+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 05/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "AAAExchangeDetailsMO+CoreDataProperties.h"

@implementation AAAExchangeDetailsMO (CoreDataProperties)

+ (NSFetchRequest<AAAExchangeDetailsMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ExchangeDetails"];
}

@dynamic age_of_vehicle;
@dynamic tml_src_assset_id;
@dynamic ppl_for_exchange;
@dynamic tml_ref_pl_id;
@dynamic milage;
@dynamic tml_src_chassisnumber;
@dynamic pl_for_exchange;
@dynamic registration_no;
@dynamic interested_in_exchange;
@dynamic toOpportunity;

@end
