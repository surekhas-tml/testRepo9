//
//  EGAddress.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAAddressMO+CoreDataClass.h"
#import "EGState.h"
#import "EGTaluka.h"

@class EGAccount,EGContact,EGState;
@interface EGAddress : NSObject
@property (nullable, nonatomic, copy) NSString *addressID;
@property (nullable, nonatomic, copy) NSString *addressLine1;
@property (nullable, nonatomic, copy) NSString *addressLine2;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *district;
@property (nullable, nonatomic, copy) NSString *pin;
@property (nullable, nonatomic, retain) EGState *state;
@property (nullable, nonatomic, retain) EGTaluka *taluka;
@property (nullable, nonatomic, copy) NSString *area;
@property (nullable, nonatomic, copy) NSString *panchayat;
@property (nullable, nonatomic, copy) NSString *tehsil;
@property (nullable, nonatomic, retain) EGAccount *toAccount;
@property (nullable, nonatomic, retain) EGContact *toContact;


-(_Nullable instancetype)initWithObject:(AAAAddressMO * _Nullable)object;

+ (EGAddress *)parseFromDictionary:(NSDictionary *)dictAddress;

@end
