//
//  EGContact.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAContactMO+CoreDataClass.h"
#import "EGAddress.h"
#import "EGAccount.h"
@class EGAccount,EGAddress,EGOpportunity;
@interface EGContact : NSObject

@property (nullable, nonatomic, copy) NSString *primaryAccountId;
@property (nullable, nonatomic, copy) NSString *area;

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
@property (nullable, nonatomic, retain) NSSet<EGAccount *> *toAccount;
@property (nullable, nonatomic, retain) EGAddress *toAddress;
@property (nullable, nonatomic, retain) NSSet<EGOpportunity *> *toOpportunity;

-(_Nullable instancetype)initWithObject:(AAAContactMO * _Nullable)object;

- (EGContact *)parseFromDictioanry:(NSDictionary *)dictContact;
@end
