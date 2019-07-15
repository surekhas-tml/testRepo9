//
//  EGFinancierOpportunity.h
//  e-guru
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AAAFinancierOptyMO+CoreDataClass.h"
#import "AAAFinancierOpportunityMO+CoreDataClass.h"
#import "FinancierListDetails.h"
#import "FinancierContactDetails.h"
#import "FinancierOptyDetails.h"
#import "FinancierAccountDetails.h"

@class FinancierContactDetails,FinancierAccountDetails,FinancierOptyDetails,FinancierListDetailModel;
@interface EGFinancierOpportunity : NSObject

@property (nullable, nonatomic, copy) NSString *optyID;
@property (nonatomic) BOOL     isQuoteSubmittedToFinancier;
@property (nonatomic) BOOL     isQuoteSubmittedToCrm;
@property (nonatomic) BOOL     isTimeBefore48Hours;
@property (nonatomic) BOOL     isAnyCaseApproved;
@property (nonatomic) BOOL     is_eligible_for_insert_quote;
@property (nonatomic) BOOL     is_first_case_rejected;

//mapping models
@property (nullable, nonatomic, retain) FinancierListDetails    *toFinancierSelectedFinancier;
@property (nullable, nonatomic, retain) FinancierOptyDetails    *toFinancierOpty;
@property (nullable, nonatomic, retain) FinancierContactDetails *toFinancierContact;
@property (nullable, nonatomic, retain) FinancierAccountDetails *toFinancierAccount;


-(_Nullable instancetype)initWithObject:(AAAFinancierOpportunityMO * _Nullable)object;

@end

