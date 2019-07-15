//
//  FinancierContactDetails.h
//  e-guru
//
//  Created by Admin on 25/09/18.
//  copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAFinancierContactMO+CoreDataClass.h"

@class EGFinancierOpportunity;

@interface FinancierContactDetails : NSObject

@property (nullable, nonatomic, copy) NSString *relationship_type;
@property (nullable, nonatomic, copy) NSString *taluka;
@property (nullable, nonatomic, copy) NSString *contact_id;
@property (nullable, nonatomic, copy) NSString *date_of_birth;
@property (nullable, nonatomic, copy) NSString *gender;

@property (nullable, nonatomic, copy) NSString *pan_number_individual;
@property (nullable, nonatomic, copy) NSString *address2;
@property (nullable, nonatomic, copy) NSString *address1;
@property (nullable, nonatomic, copy) NSString *occupation;

@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *district;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *area;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *pincode;
@property (nullable, nonatomic, copy) NSString *mobileno;
@property (nullable, nonatomic, copy) NSString *citytownvillage;

@property (nullable, nonatomic, retain) NSSet<EGFinancierOpportunity *> *toFinancierOpportunity;

-(_Nullable instancetype)initWithObject:(AAAFinancierContactMO * _Nullable)object;


@end


