//
//  EGAccount.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAAccountMO+CoreDataClass.h"


@class EGAddress,EGContact,EGOpportunity;
@interface EGAccount : NSObject
@property (nullable, nonatomic, copy) NSString *accountID;
@property (nullable, nonatomic, copy) NSString *accountName;
@property (nullable, nonatomic, copy) NSString *accountType;
@property (nullable, nonatomic, copy) NSString *contactNumber;
@property (nullable, nonatomic, copy) NSString *siteName;
@property (nullable, nonatomic, copy) NSString *mPAN;
@property (nullable, nonatomic, copy) NSString *contactID;
@property (nullable, nonatomic, retain) EGAddress *toAddress;
@property (nullable, nonatomic, retain) NSMutableSet<EGContact *> *toContact;
@property (nullable, nonatomic, retain) NSMutableSet<EGOpportunity *> *toOpportunity;
-(_Nonnull instancetype)initWithObject:(AAAAccountMO * _Nullable)object;

@end
