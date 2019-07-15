//
//  EGLob.h
//  e-Guru
//
//  Created by MI iMac04 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGLob : NSObject

@property (nullable, nonatomic, copy) NSString *lobName;
@property (nullable, nonatomic, copy) NSString *lobId;


-(_Nonnull instancetype)initWithObject:(NSString * _Nullable)object;

@end
