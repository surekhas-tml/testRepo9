//
//  PushNotificationToken+CoreDataProperties.m
//  e-guru
//
//  Created by Ashish Barve on 9/27/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "PushNotificationToken+CoreDataProperties.h"

@implementation PushNotificationToken (CoreDataProperties)

+ (NSFetchRequest<PushNotificationToken *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PushNotificationToken"];
}

@dynamic regTokenFCM;

@end
