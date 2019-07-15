//
//  PipelineModel.h
//  e-guru
//
//  Created by MI iMac04 on 18/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C0Model.h"
#import "C1Model.h"
#import "C1AModel.h"
#import "C2Model.h"

@interface PipelineModel : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) C0Model *c0Model;
@property (strong, nonatomic) C1Model *c1Model;
@property (strong, nonatomic) C1AModel *c1AModel;
@property (strong, nonatomic) C2Model *c2Model;

@end
