//
//  EGPpl.h
//  e-Guru
//
//  Created by MI iMac04 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGPpl : NSObject

@property (nullable, nonatomic, copy) NSString *pplName;
@property (nullable, nonatomic, copy) NSString *pplId;

-(_Nonnull instancetype)initWithObject:(NSString * _Nullable)object;

@end
