//
//  EGNotification.m
//  e-guru
//
//  Created by Admin on 31/01/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "EGNotification.h"

@implementation EGNotification

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.notificationID = @"";
        self.loginID = @"";
        self.activityID = @"";
        self.strSentDate = @"";
        self.strIsActiveFlag = @"";
        self.actionName = @"";
        self.action = @"";
        self.message = @"";
        self.optyID = @"";
    }
    return self;
}

@end
