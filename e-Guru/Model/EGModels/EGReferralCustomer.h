//
//  ReferralCustomer.h
//  e-Guru
//
//  Created by Ashish Barve on 12/4/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAReferralCustomerMO+CoreDataClass.h"
@interface EGReferralCustomer : NSObject

@property (nullable, nonatomic, copy) NSString *rowID;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *cellPhoneNumber;
-(_Nullable instancetype)initWithObject:(AAAReferralCustomerMO * _Nullable)object;

@end
