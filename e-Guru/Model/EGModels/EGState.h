//
//  EGState.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAStateMO+CoreDataClass.h"
@interface EGState : NSObject

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *name;
-(_Nullable instancetype)initWithObject:(AAAStateMO * _Nullable)object;
@end
