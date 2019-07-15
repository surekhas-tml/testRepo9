//
//  AAADraftFinancierMO+CoreDataProperties.m
//  e-guru
//
//  Created by Shashi on 16/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAADraftFinancierMO+CoreDataProperties.h"

@implementation AAADraftFinancierMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftFinancierMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DraftFinancier"];
}

@dynamic draftID;
@dynamic userIDLink;
@dynamic status;
@dynamic toInsertQuote;

@end
