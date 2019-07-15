//
//  AAADraftAccountMO+CoreDataProperties.h
//  e-guru
//
//  Created by MI iMac04 on 31/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAADraftAccountMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAADraftAccountMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftAccountMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *draftIDAccount;
@property (nullable, nonatomic, copy) NSString *userIDLink;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, retain) AAAAccountMO *toAccount;

@end

NS_ASSUME_NONNULL_END
