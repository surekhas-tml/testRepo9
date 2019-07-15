//
//  PushNotificationToken+CoreDataProperties.h
//  e-guru
//
//  Created by Ashish Barve on 9/27/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "PushNotificationToken+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PushNotificationToken (CoreDataProperties)

+ (NSFetchRequest<PushNotificationToken *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *regTokenFCM;

@end

NS_ASSUME_NONNULL_END
