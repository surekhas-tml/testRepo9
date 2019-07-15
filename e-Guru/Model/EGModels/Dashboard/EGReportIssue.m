//
//  EGReportIssue.m
//  e-guru
//
//  Created by admin on 4/18/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGReportIssue.h"

@implementation EGReportIssue
@synthesize appName,appVersion,platform,userId,userName,userEmailId,userMobileNo,issueDescription,errorDescription,fileImg;

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
        self.appName = object;
        self.appVersion = object;
        self.userMobileNo = object;
        self.userEmailId = object;
        self.userName = object;
        self.userId = object;
        self.platform = object;
        self.issueDescription = object;
        self.errorDescription = object;
    }
    return self;
}

-(instancetype)initWithObjectNSdata:(NSData *)object{
    self = [super init];
    if (self) {
        
        self.fileImg = object;
    }
    return self;
}

@end
