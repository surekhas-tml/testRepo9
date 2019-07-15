//
//  EGExclusionTypeModel.m
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGExclusionModel.h"

@implementation EGExclusionModel
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.date = @"";
        self.type = @"";
        self.exclusionName = @"";
        self.dseId = @"";
        self.dseName = @"";
        self.isExcluded = @"";
        self.leaveID = [NSNumber numberWithInteger:0];
    }
    return self;
}
@end
