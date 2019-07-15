//
//  AAAContactMO+CoreDataProperties.h
//  e-guru
//
//  Created by Ashish Barve on 12/28/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAContactMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAContactMO (CoreDataProperties)

+ (NSFetchRequest<AAAContactMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contactID;
@property (nullable, nonatomic, copy) NSString *contactNumber;
@property (nullable, nonatomic, copy) NSString *emailID;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *panNumber;
@property (nullable, nonatomic, copy) NSString *primary_account_id;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, retain) NSSet<AAAAccountMO *> *toAccount;
@property (nullable, nonatomic, retain) AAAAddressMO *toAddress;
@property (nullable, nonatomic, retain) NSSet<AAAOpportunityMO *> *toOpportunity;

@end

@interface AAAContactMO (CoreDataGeneratedAccessors)

- (void)addToAccountObject:(AAAAccountMO *)value;
- (void)removeToAccountObject:(AAAAccountMO *)value;
- (void)addToAccount:(NSSet<AAAAccountMO *> *)values;
- (void)removeToAccount:(NSSet<AAAAccountMO *> *)values;

- (void)addToOpportunityObject:(AAAOpportunityMO *)value;
- (void)removeToOpportunityObject:(AAAOpportunityMO *)value;
- (void)addToOpportunity:(NSSet<AAAOpportunityMO *> *)values;
- (void)removeToOpportunity:(NSSet<AAAOpportunityMO *> *)values;

@end

NS_ASSUME_NONNULL_END
