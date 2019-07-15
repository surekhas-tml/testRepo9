//
//  AAAVCNumberMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/9/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAVCNumberMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAVCNumberMO (CoreDataProperties)

+ (NSFetchRequest<AAAVCNumberMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *lob;
@property (nullable, nonatomic, copy) NSString *ppl;
@property (nullable, nonatomic, copy) NSString *pl;
@property (nullable, nonatomic, copy) NSString *vcNumber;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSString *productName1;
@property (nullable, nonatomic, copy) NSString *productDescription;
@property (nullable, nonatomic, copy) NSString *productID;
@property (nullable, nonatomic, copy) NSString *productType;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
