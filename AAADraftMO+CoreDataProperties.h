//
//  AAADraftMO+CoreDataProperties.h
//  e-guru
//
//  Created by Ganesh Patro on 26/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAADraftMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAADraftMO (CoreDataProperties)

+ (NSFetchRequest<AAADraftMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *draftID;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, copy) NSString *userIDLink;
@property (nullable, nonatomic, retain) AAAOpportunityMO *toOpportunity;

@end

NS_ASSUME_NONNULL_END
