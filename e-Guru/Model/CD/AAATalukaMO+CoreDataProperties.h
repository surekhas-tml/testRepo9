//
//  AAATalukaMO+CoreDataProperties.h
//  e-guru
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAATalukaMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAATalukaMO (CoreDataProperties)

+ (NSFetchRequest<AAATalukaMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *district;
@property (nullable, nonatomic, copy) NSString *talukaName;
@property (nullable, nonatomic, retain) AAAStateMO *toState;

@end

NS_ASSUME_NONNULL_END
