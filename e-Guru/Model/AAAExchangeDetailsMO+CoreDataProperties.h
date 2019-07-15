//
//  AAAExchangeDetailsMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 05/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "AAAExchangeDetailsMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAExchangeDetailsMO (CoreDataProperties)

+ (NSFetchRequest<AAAExchangeDetailsMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *age_of_vehicle;
@property (nullable, nonatomic, copy) NSString *tml_src_assset_id;
@property (nullable, nonatomic, copy) NSString *ppl_for_exchange;
@property (nullable, nonatomic, copy) NSString *tml_ref_pl_id;
@property (nullable, nonatomic, copy) NSString *milage;
@property (nullable, nonatomic, copy) NSString *tml_src_chassisnumber;
@property (nullable, nonatomic, copy) NSString *pl_for_exchange;
@property (nullable, nonatomic, copy) NSString *registration_no;
@property (nullable, nonatomic, copy) NSString *interested_in_exchange;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
