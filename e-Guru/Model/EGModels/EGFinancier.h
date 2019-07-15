//
//  EGFinancier.h
//  e-Guru
//
//  Created by MI iMac04 on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAFinancerMO+CoreDataClass.h"
@interface EGFinancier : NSObject

@property (nullable, nonatomic, copy) NSString *financierName;
@property (nullable, nonatomic, copy) NSString *financierID;
-(_Nullable instancetype)initWithObject:(AAAFinancerMO * _Nullable)object;

@end
