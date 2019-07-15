//
//  EGVCNumber.h
//  e-Guru
//
//  Created by MI iMac04 on 06/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAVCNumberMO+CoreDataClass.h"
@interface EGVCNumber : NSObject

@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *pl;
@property (nullable, nonatomic, copy) NSString *vcNumber;
@property (nullable, nonatomic, copy) NSString *productCatagory;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSString *productName1;
@property (nullable, nonatomic, copy) NSString *productDescription;
@property (nullable, nonatomic, copy) NSString *productID;
@property (nullable, nonatomic, copy) NSString *productType;
-( _Nullable instancetype)initWithObject:( AAAVCNumberMO * _Nullable)object;

@end
