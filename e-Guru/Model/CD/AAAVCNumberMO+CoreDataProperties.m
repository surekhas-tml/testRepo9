//
//  AAAVCNumberMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAVCNumberMO+CoreDataProperties.h"

@implementation AAAVCNumberMO (CoreDataProperties)

+ (NSFetchRequest<AAAVCNumberMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VCNumber"];
}

@dynamic lob;
@dynamic ppl;
@dynamic pl;
@dynamic vcNumber;
@dynamic productName;
@dynamic productName1;
@dynamic productDescription;
@dynamic productID;
@dynamic productType;
@dynamic toOpportunity;

@end
