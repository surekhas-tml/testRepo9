//
//  EGEvent.m
//  e-guru
//
//  Created by Admin on 19/12/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGEvent.h"

@implementation EGEvent

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.mEventID = @"";
        self.mEventName = @"";
    }
    return self;
}

@end
