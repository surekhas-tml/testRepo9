//
//  EGActualVsTarget.h
//  e-guru
//
//  Created by admin on 5/4/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOpportunity.h"
#import "C0Model.h"
#import "C1Model.h"
#import "C1AModel.h"
#import "C2Model.h"
@interface EGActualVsTarget : NSObject
@property(nonatomic,copy)  NSString * Stretch_target;
@property(nonatomic,copy)  NSString * Actual_target;
@property(nonatomic,copy)  NSString * Retail;
@property(nonatomic,copy)  NSString * DSEName;
@property(nonatomic,copy)  NSString * DSMName;
@property(nonatomic,copy)  NSString * leadid;
@property (strong, nonatomic) C0Model *c0Model;
@property (strong, nonatomic) C1Model *c1Model;
@property (strong, nonatomic) C1AModel *c1AModel;
@property (strong, nonatomic) C2Model *c2Model;
@property (nullable, nonatomic, retain) EGOpportunity *toOpportunity;

@end
