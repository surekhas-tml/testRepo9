//
//  AAAStateMO+CoreDataProperties.h
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAAStateMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAAStateMO (CoreDataProperties)

+ (NSFetchRequest<AAAStateMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) AAAAddressMO *toAddress;

@end

NS_ASSUME_NONNULL_END
