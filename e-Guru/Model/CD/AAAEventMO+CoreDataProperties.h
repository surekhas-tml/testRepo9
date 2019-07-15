//
//  AAAEventMO+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "AAAEventMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAEventMO (CoreDataProperties)

+ (NSFetchRequest<AAAEventMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *eventName;
@property (nullable, nonatomic, copy) NSString *eventID;

@end

NS_ASSUME_NONNULL_END
