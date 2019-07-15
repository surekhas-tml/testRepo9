//
//  AAAActivityMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAActivityMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAActivityMO (CoreDataProperties)

+ (NSFetchRequest<AAAActivityMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *activityDescription;
@property (nullable, nonatomic, copy) NSString *activityID;
@property (nullable, nonatomic, copy) NSString *activityType;
@property (nullable, nonatomic, copy) NSString *creationDate;
@property (nullable, nonatomic, copy) NSString *creationTime;
@property (nullable, nonatomic, copy) NSString *endDate;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nullable, nonatomic, copy) NSString *planedDate;
@property (nullable, nonatomic, copy) NSString *planedTime;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *taluka;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
