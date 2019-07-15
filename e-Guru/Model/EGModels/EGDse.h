//
//  EGDse.h
//  e-guru
//
//  Created by Juili on 16/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C0Model.h"
#import "C1Model.h"
#import "C1AModel.h"
#import "C2Model.h"
@class EGOpportunity;
@class EGActivity;
@interface EGDse : NSObject

@property(nonatomic,copy)  NSString * leadAssignedPositionName;
@property(nonatomic,copy)  NSString * leadAssignedPositionID;
@property(nonatomic,copy)  NSString * leadAssignedPositionType;
@property(nonatomic,copy)  NSString * FirstName;
@property(nonatomic,copy)  NSString * LastName;
@property(nonatomic,copy)  NSString * leadid;
@property(nonatomic,copy)  NSString * leadLogin;
@property(nonatomic,copy)  NSString * invoicecount;
@property(nonatomic,copy)  NSString *DSEName;
@property(nonatomic,copy)  NSString *DSMName;
@property(nonatomic,copy)  NSString * Stretch_target;
@property(nonatomic,copy)  NSString * Actual_target;
@property(nonatomic,copy)  NSString * Retail;
@property (strong, nonatomic) C0Model *c0Model;
@property (strong, nonatomic) C1Model *c1Model;
@property (strong, nonatomic) C1AModel *c1AModel;
@property (strong, nonatomic) C2Model *c2Model;
@property (nullable, nonatomic, retain) EGOpportunity *toOpportunity;
@property (nullable, nonatomic, retain) EGActivity *toActivity;

@end
