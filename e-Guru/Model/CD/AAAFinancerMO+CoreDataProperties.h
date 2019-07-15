//
//  AAAFinancerMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAFinancerMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancerMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancerMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *financierID;
@property (nullable, nonatomic, copy) NSString *financierName;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
