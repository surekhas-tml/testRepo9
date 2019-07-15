//
//  AAANotification+CoreDataProperties.m
//  e-guru
//
//  Created by Admin on 05/02/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAANotification+CoreDataProperties.h"

@implementation AAANotification (CoreDataProperties)

+ (NSFetchRequest<AAANotification *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
}

@dynamic action;
@dynamic actionName;
@dynamic activityID;
@dynamic loginID;
@dynamic message;
@dynamic notificationID;
@dynamic optyID;
@dynamic sentDate;
@dynamic strIsActiveFlag;
@dynamic strSentDate;
@dynamic sentDateIST;

@end
