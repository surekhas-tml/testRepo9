//
//  PPLDataModel.h
//  e-guru
//
//  Created by MI iMac04 on 14/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C0Model.h"
#import "C1Model.h"
#import "C1AModel.h"
#import "C2Model.h"

@interface PPLDataModel : NSObject

@property (strong, nonatomic) NSString      *pplName;
@property (strong, nonatomic) NSString      *pplID;

@property (strong, nonatomic) C0Model       *c0Model;
@property (strong, nonatomic) C1Model       *c1Model;
@property (strong, nonatomic) C1AModel      *c1AModel;
@property (strong, nonatomic) C2Model       *c2Model;
@property (strong, nonatomic) NSString      *currentStock;
@property (strong, nonatomic) NSMutableArray *plDetailsArray;

@end
