//
//  AAAReferralCustomerMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAReferralCustomerMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAReferralCustomerMO (CoreDataProperties)

+ (NSFetchRequest<AAAReferralCustomerMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *refferalCellPhoneNumber;
@property (nullable, nonatomic, copy) NSString *refferalFirstName;
@property (nullable, nonatomic, copy) NSString *refferalLastName;
@property (nullable, nonatomic, copy) NSString *refferalrowID;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
