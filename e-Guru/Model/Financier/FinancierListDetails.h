//
//  FinancierListDetails.h
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAFinancierSelectedDetailMO+CoreDataClass.h"

@class EGFinancierOpportunity;
@interface FinancierListDetails : NSObject

@property (nullable, nonatomic, copy) NSString* selectedFinancierID;
@property (nullable, nonatomic, copy) NSString* selectedFinancierName;
//new
@property (nullable, nonatomic, copy) NSString *branch_id;
@property (nullable, nonatomic, copy) NSString *branch_name;
@property (nullable, nonatomic, copy) NSString *bdm_id;
@property (nullable, nonatomic, copy) NSString *bdm_name;
@property (nullable, nonatomic, copy) NSString *bdm_mobile_no;

@property (nullable, nonatomic, retain) NSSet<EGFinancierOpportunity *> *toFinancierOpportunity;

-(_Nullable instancetype)initWithObject:(AAAFinancierSelectedDetailMO * _Nullable)object;


@end
