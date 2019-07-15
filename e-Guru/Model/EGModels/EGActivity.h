//
//  EGActivity.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOpportunity.h"
#import "AAAActivityMO+CoreDataClass.h"

@interface EGActivity : NSObject
@property (nullable, nonatomic, copy) NSString *activityDescription;
@property (nullable, nonatomic, copy) NSString *activityID;
@property (nullable, nonatomic, copy) NSString *activityType;
@property (nullable, nonatomic, copy) NSString *creationDate;
@property (nullable, nonatomic, copy) NSString *creationTime;
@property (nullable, nonatomic, copy) NSString *endDate;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nullable, nonatomic, copy) NSString *planedDate;
@property (nullable, nonatomic, copy) NSString *planedTime;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *taluka;
@property (nullable, nonatomic, copy) NSString *stakeholder;
@property (nullable, nonatomic, copy) NSString *stakeholderResponse;
@property (nullable, nonatomic, copy) NSString *activitySubtype;
@property (nullable, nonatomic, copy) NSString *junk;


@property (nullable, nonatomic, retain) EGOpportunity *toOpportunity;

-(_Nullable instancetype)initWithObject:(AAAActivityMO * _Nullable)object;
-(NSString *_Nullable)planedTimeSystemTime;
-(NSString *_Nullable)planedDateSystemTime;
-(NSString *)planedDateSystemTimeInFormat:(NSString *_Nullable)format;
-(NSString *)planedDateTimeInFormat:(NSString *_Nullable)format;
@end
