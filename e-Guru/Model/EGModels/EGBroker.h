//
//  EGBroker.h
//  e-Guru
//
//  Created by MI iMac04 on 05/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAABrokerMO+CoreDataClass.h"
@interface EGBroker : NSObject

@property (nullable, nonatomic, copy) NSString *accountID;
@property (nullable, nonatomic, copy) NSString *accountName;
@property (nullable, nonatomic, copy) NSString *mainPhoneNumber;
-(_Nullable instancetype)initWithObject:(AAABrokerMO * _Nullable)object;

@end
