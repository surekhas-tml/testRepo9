//
//  AAAAddressMO+CoreDataProperties.h
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAAddressMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAAddressMO (CoreDataProperties)

+ (NSFetchRequest<AAAAddressMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addressID;
@property (nullable, nonatomic, copy) NSString *addressLine1;
@property (nullable, nonatomic, copy) NSString *addressLine2;
@property (nullable, nonatomic, copy) NSString *area;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *district;
@property (nullable, nonatomic, copy) NSString *panchayat;
@property (nullable, nonatomic, copy) NSString *pin;
@property (nullable, nonatomic, retain) AAAAccountMO *toAccount;
@property (nullable, nonatomic, retain) AAAContactMO *toContact;
@property (nullable, nonatomic, retain) AAAStateMO *toState;
@property (nullable, nonatomic, retain) AAATalukaMO *toTaluka;

@end

NS_ASSUME_NONNULL_END
