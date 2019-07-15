//
//  EGTaluka.h
//  e-Guru
//
//  Created by local admin on 11/28/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAATalukaMO+CoreDataClass.h"
#import "EGState.h"


@interface EGTaluka : NSObject

@property (nullable, nonatomic, copy) NSString *talukaName;
@property (nullable, nonatomic, retain) EGState *state;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *district;

-(_Nullable instancetype)initWithObject:(AAATalukaMO *_Nullable)object;

@end
