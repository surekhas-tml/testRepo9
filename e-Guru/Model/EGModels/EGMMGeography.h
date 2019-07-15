//
//  EGMMGeography.h
//  e-Guru
//
//  Created by MI iMac04 on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAMMGeographyMO+CoreDataClass.h"
@interface EGMMGeography : NSObject

@property (nullable, nonatomic, copy) NSString *lobName;
@property (nullable, nonatomic, copy) NSString *geographyName;

-( _Nullable instancetype)initWithObject:(AAAMMGeographyMO * _Nullable)object;

@end
