//
//  AAAFinancierSelectedDetailMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 04/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAAFinancierSelectedDetailMO+CoreDataClass.h"
#import "AAAFinancierOpportunityMO+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AAAFinancierSelectedDetailMO (CoreDataProperties)

+ (NSFetchRequest<AAAFinancierSelectedDetailMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *selectedFinancierID;
@property (nullable, nonatomic, copy) NSString *selectedFinancierName;
//new
@property (nullable, nonatomic, copy) NSString *branch_id;
@property (nullable, nonatomic, copy) NSString *branch_name;
@property (nullable, nonatomic, copy) NSString *bdm_id;
@property (nullable, nonatomic, copy) NSString *bdm_name;
@property (nullable, nonatomic, copy) NSString *bdm_mobile_no;


@property (nullable, nonatomic, retain) AAAFinancierOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
