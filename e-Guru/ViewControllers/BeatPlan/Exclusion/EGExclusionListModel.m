//
//  EGExclusionListModel.m
//  e-guru
//
//  Created by Apple on 27/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGExclusionListModel.h"

@implementation EGExclusionListModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.startDate = @"";
        self.endDate = @"";
        self.exclusions = [NSMutableArray new];
       
    }
    return self;
}
@end
