//
//  AAAAccountMO+CoreDataProperties.h
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAAccountMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAAccountMO (CoreDataProperties)

+ (NSFetchRequest<AAAAccountMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountID;
@property (nullable, nonatomic, copy) NSString *accountName;
@property (nullable, nonatomic, copy) NSString *accountPAN;
@property (nullable, nonatomic, copy) NSString *accountType;
@property (nullable, nonatomic, copy) NSString *contactNumber;
@property (nullable, nonatomic, copy) NSString *site;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, retain) AAAAddressMO *toAddress;
@property (nullable, nonatomic, retain) NSSet<AAAContactMO *> *toContact;
@property (nullable, nonatomic, retain) NSSet<AAAOpportunityMO *> *toOpportunity;

@end

@interface AAAAccountMO (CoreDataGeneratedAccessors)

- (void)addToContactObject:(AAAContactMO *)value;
- (void)removeToContactObject:(AAAContactMO *)value;
- (void)addToContact:(NSSet<AAAContactMO *> *)values;
- (void)removeToContact:(NSSet<AAAContactMO *> *)values;

- (void)addToOpportunityObject:(AAAOpportunityMO *)value;
- (void)removeToOpportunityObject:(AAAOpportunityMO *)value;
- (void)addToOpportunity:(NSSet<AAAOpportunityMO *> *)values;
- (void)removeToOpportunity:(NSSet<AAAOpportunityMO *> *)values;

@end

NS_ASSUME_NONNULL_END
