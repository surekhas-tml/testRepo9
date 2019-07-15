//
//  EGReportIssue.m
//  e-guru
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGReportIssue.h"

@implementation EGReportIssue

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(instancetype)initWithObject:(NSString *)object{
    self = [super init];
    if (self) {
        self.msg = object;
        self.error_code = object;
    }
    return self;
}

@end
