//
//  AAAMMGeographyMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAMMGeographyMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAMMGeographyMO (CoreDataProperties)

+ (NSFetchRequest<AAAMMGeographyMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *lobName;
@property (nullable, nonatomic, copy) NSString *geographyName;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
