//
//  PrimaryField.h
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"

@interface PrimaryField : NSObject

@property (nonatomic, strong) Field *mLOBField;
@property (nonatomic, strong) Field *mPPLField;
@property (nonatomic, strong) Field *mPLField;
@property (nonatomic, strong) Field *mVehicleApplication;

@end
