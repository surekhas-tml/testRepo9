//
//  AAADraftFinancierMO+CoreDataProperties.h
//  e-guru
//
//  Created by Shashi on 16/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAADraftFinancierMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAADraftFinancierMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftFinancierMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *draftID;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, copy) NSString *userIDLink;

@property (nullable, nonatomic, retain) AAAFinancierInsertMO *toInsertQuote;

@end

NS_ASSUME_NONNULL_END
