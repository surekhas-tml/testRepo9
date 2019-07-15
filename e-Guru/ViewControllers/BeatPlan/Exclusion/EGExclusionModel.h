//
//  EGExclusionTypeModel.h
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EGExclusionModel : NSObject
@property(nonatomic,copy)  NSString * date;
//@property(nonatomic,copy)  NSDate * eventDate;
@property(nonatomic,copy)  NSString * type;
@property(nonatomic,copy)  NSString * eventName;
@property(nonatomic,copy)  NSString * dseId;
@property(nonatomic,copy)  NSString * dseName;
@property(nonatomic,assign)  NSString*  isExcluded;
@property(nonatomic,copy)  NSString * exclusionName;
@property(nonatomic,copy)  NSString * remark;
@property(nonatomic,copy)  NSNumber * leaveID;
@property(nonatomic,copy)  NSNumber * lastName;
@property(nonatomic,copy)  NSNumber * firstName;
@property(nonatomic,copy)  NSNumber * dseEmpId;


//        @"last_name" : @"lastName",@"first_name":@"firstName" ,@"dse_emp_id" : @"dseEmpId"

@end

