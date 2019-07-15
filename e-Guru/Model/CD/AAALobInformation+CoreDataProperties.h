//
//  AAALobInformation+CoreDataProperties.h
//  e-guru
//
//  Created by MI iMac04 on 20/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAALobInformation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAALobInformation (CoreDataProperties)

+ (NSFetchRequest<AAALobInformation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bodyType;
@property (nullable, nonatomic, copy) NSString *customerType;
@property (nullable, nonatomic, copy) NSString *mmGeography;
@property (nullable, nonatomic, copy) NSString *speed_governer;
@property (nullable, nonatomic, copy) NSString *tmlFleetSize;
@property (nullable, nonatomic, copy) NSString *totalFleetSize;
@property (nullable, nonatomic, copy) NSString *usageCategory;
@property (nullable, nonatomic, copy) NSString *vehicleApplication;

@end

NS_ASSUME_NONNULL_END
