//
//  EGTaluka.h
//  e-Guru
//
//  Created by local admin on 11/28/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAATalukaMO+CoreDataClass.h"
#import "EGTaluka.h"


@interface EGPin : NSObject
@property (nullable,nonatomic, copy) NSString * pinId;
@property (nullable, nonatomic, retain) EGTaluka *taluka;
@property (nullable, nonatomic, copy) NSString *pincode;
-(_Nonnull instancetype)initWithObject:(NSString *_Nonnull)object;

@end
