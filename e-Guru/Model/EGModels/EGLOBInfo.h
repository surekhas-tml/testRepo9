//
//  EGLOBInfo.h
//  e-guru
//
//  Created by MI iMac04 on 19/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAALobInformation+CoreDataClass.h"
#import "AAALobInformation+CoreDataProperties.h"

@interface EGLOBInfo : NSObject

@property(nonatomic,copy)  NSString * customerType;
@property(nonatomic,copy)  NSString * vehicleApplication;
@property(nonatomic,copy)  NSString * bodyType;
@property(nonatomic,copy)  NSString * mmGeography;
@property(nonatomic,copy)  NSString * tmlFleetSize;
@property(nonatomic,copy)  NSString * totalFleetSize;
@property(nonatomic,copy)  NSString * usageCategory;

-(instancetype)initWithObject:(AAALobInformation *)object;

@end
