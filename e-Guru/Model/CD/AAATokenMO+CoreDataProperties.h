//
//  AAATokenMO+CoreDataProperties.h
//  e-guru
//
//  Created by local admin on 12/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAATokenMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAATokenMO (CoreDataProperties)

+ (NSFetchRequest<AAATokenMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accessToken;
@property (nullable, nonatomic, copy) NSString *expiresIn;
@property (nullable, nonatomic, copy) NSString *refreshToken;
@property (nullable, nonatomic, copy) NSString *scope;
@property (nullable, nonatomic, copy) NSString *tokenType;

@end

NS_ASSUME_NONNULL_END
