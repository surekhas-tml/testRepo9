//
//  EGReportIssue.h
//  e-guru
//
//  Created by admin on 4/18/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGReportIssue : NSObject
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmailId;
@property (nonatomic, strong) NSString *userMobileNo;
@property (nonatomic, strong) NSString *issueDescription;
@property (nonatomic, strong) NSString *errorDescription;
@property (nonatomic, strong) NSData *fileImg;

-(_Nonnull instancetype)initWithObject:(NSString * _Nullable)object;

-(_Nonnull instancetype)initWithObjectNSdata:(NSData * _Nullable)object;

@end
