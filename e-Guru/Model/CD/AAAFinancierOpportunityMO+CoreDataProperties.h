//
//  AAAFinancierOpportunityMO+CoreDataProperties.h
//  e-guru
//
//  Created by Shashi on 19/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierOpportunityMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierOpportunityMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierOpportunityMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *isTimeBefore48Hours;
@property (nullable, nonatomic, copy) NSString *optyID;
@property (nullable, nonatomic, copy) NSString *isQuoteSubmitToCRm;
@property (nullable, nonatomic, copy) NSString *isQuoteSubmitToFinancier;
@property (nullable, nonatomic, copy) NSString *isAnyCaseApproved;
@property (nullable, nonatomic, copy) NSString *is_eligible_for_insert_quote;
@property (nullable, nonatomic, copy) NSString *is_first_case_rejected;

@property (nullable, nonatomic, retain) AAAFinancierAccountDetailMO  *toFinancierAccount;
@property (nullable, nonatomic, retain) AAAFinancierContactMO        *toFinancierContact;
@property (nullable, nonatomic, retain) AAAFinancierOptyDetailsMO    *toFinancierOpty;
@property (nullable, nonatomic, retain) AAAFinancierSelectedDetailMO *toFinancierSelectedFinancier; 

@end

NS_ASSUME_NONNULL_END
