//
//  AAADraftContactMO+CoreDataProperties.h
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAADraftContactMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAADraftContactMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftContactMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *draftIDContact;
@property (nullable, nonatomic, copy) NSString *userIDLink;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, retain) AAAContactMO *toContact;

@end

NS_ASSUME_NONNULL_END
