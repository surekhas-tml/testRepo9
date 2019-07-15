//
//  Field.m
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "Field.h"
#import "NSString+NSStringCategory.h"

@implementation Field

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mValues = [[NSMutableArray alloc] init];
        self.mPredecessors = [[NSMutableArray alloc] init];
        self.mSuccessors = [[NSMutableArray alloc] init];
        self.mIsMandatory = true;
        self.mIsEnabled = true;
        self.mFieldType = SingleSelectList;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.mTitle = title;
    }
    return self;
}

- (void)addSuccessor:(Field *)successor {
    if (!successor) {
        return;
    }
    
    [self.mSuccessors addObject:successor];
}

- (void)removeSuccessor:(Field *)successor {
    if (!successor) {
        return;
    }
    
    if (self.mSuccessors) {
        [self.mSuccessors removeObject:successor];
    }
}

- (void)addPredecessor:(Field *)predecessor {
    if (!predecessor) {
        return;
    }
    
    [self.mPredecessors addObject:predecessor];
}

- (void)removePredecessor:(Field *)predecessor {
    if (!predecessor) {
        return;
    }
    
    if (self.mPredecessors) {
        [self.mPredecessors removeObject:predecessor];
    }
}

- (void)addValue:(NSString *)value {
    if (![value hasValue]) {
        return;
    }
    
    [self.mValues addObject:value];
}

@end

