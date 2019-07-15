//
//  AAABrokerMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAABrokerMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAABrokerMO (CoreDataProperties)

+ (NSFetchRequest<AAABrokerMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountID;
@property (nullable, nonatomic, copy) NSString *mainPhoneNumber;
@property (nullable, nonatomic, copy) NSString *accountName;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
