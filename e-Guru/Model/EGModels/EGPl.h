//
//  EGPl.h
//  e-Guru
//
//  Created by MI iMac04 on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGPl : NSObject

@property (nullable, nonatomic, copy) NSString *plName;
@property (nullable, nonatomic, copy) NSString *plId;

-(_Nonnull instancetype)initWithObject:(NSString *_Nonnull)object;

@end
