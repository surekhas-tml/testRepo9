//
//  EGReversePincode.h
//  e-guru
//
//  Created by MI iMac01 on 18/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGState.h"
@interface EGReversePincode : NSObject
@property (strong, nonatomic) NSString * city;
@property (strong, nonatomic) NSString * district;
@property (strong, nonatomic) NSString * country;
@property (strong, nonatomic) NSString * pincode;
@property (strong, nonatomic) EGState * state;
@property (strong, nonatomic) NSString * pinId;
@end
