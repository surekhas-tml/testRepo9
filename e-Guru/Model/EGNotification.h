//
//  EGNotification.h
//  e-guru
//
//  Created by Admin on 31/01/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGNotification : NSObject

@property (nonatomic, copy) NSString *notificationID;
@property (nonatomic, copy) NSString *loginID;
@property (nonatomic, copy) NSString *activityID;
@property (nonatomic, copy) NSString *strSentDate;
@property (nonatomic, copy) NSString *strIsActiveFlag;
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *optyID;

@end
