//
//  AAALobInformation+CoreDataProperties.m
//  e-guru
//
//  Created by MI iMac04 on 20/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAALobInformation+CoreDataProperties.h"

@implementation AAALobInformation (CoreDataProperties)

+ (NSFetchRequest<AAALobInformation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LobInformation"];
}

@dynamic bodyType;
@dynamic customerType;
@dynamic mmGeography;
@dynamic speed_governer;
@dynamic tmlFleetSize;
@dynamic totalFleetSize;
@dynamic usageCategory;
@dynamic vehicleApplication;

@end
