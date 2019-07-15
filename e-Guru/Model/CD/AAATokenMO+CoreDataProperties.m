//
//  AAATokenMO+CoreDataProperties.m
//  e-guru
//
//  Created by local admin on 12/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AAATokenMO+CoreDataProperties.h"

@implementation AAATokenMO (CoreDataProperties)

+ (NSFetchRequest<AAATokenMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Token"];
}

@dynamic accessToken;
@dynamic expiresIn;
@dynamic refreshToken;
@dynamic scope;
@dynamic tokenType;

@end
