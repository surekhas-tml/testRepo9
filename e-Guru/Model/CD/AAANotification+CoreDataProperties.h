//
//  AAANotification+CoreDataProperties.h
//  e-guru
//
//  Created by Admin on 05/02/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AAANotification+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AAANotification (CoreDataProperties)

+ (NSFetchRequest<AAANotification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *action;
@property (nullable, nonatomic, copy) NSString *actionName;
@property (nullable, nonatomic, copy) NSString *activityID;
@property (nullable, nonatomic, copy) NSString *loginID;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *notificationID;
@property (nullable, nonatomic, copy) NSString *optyID;
@property (nullable, nonatomic, copy) NSDate *sentDate;
@property (nullable, nonatomic, copy) NSString *strIsActiveFlag;
@property (nullable, nonatomic, copy) NSString *strSentDate;
@property (nullable, nonatomic, copy) NSDate *sentDateIST;

@end

NS_ASSUME_NONNULL_END
