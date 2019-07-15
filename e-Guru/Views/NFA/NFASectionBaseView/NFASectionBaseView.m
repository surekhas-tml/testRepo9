//
//  NFASectionBaseView.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFASectionBaseView.h"

@implementation NFASectionBaseView

- (instancetype)init {

    return [self initWithMode:NFAModeCreate andModel:nil];
}

- (instancetype)initWithMode:(NFAMode)mode andModel:(id)model {
    
    self = [super init];
    if (self) {
        [self loadUIFromXib];
        if (mode == NFAModeDisplay) {
            [self setBorderToView];
        }
        [self adjustUIBasedOnMode:mode andModel:model];
    }
    return self;
}

#pragma mark - Private Methods
- (void)setBorderToView {
    CGFloat borderWidth = 1.0f;
    [self.layer setBorderWidth:borderWidth];
    [self.layer setBorderColor:[UIColor separatorColor].CGColor];
}

#pragma mark - To Be Overridden in Child
- (void)loadUIFromXib {
}

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
}

- (void)resetFields {
    
}

- (NFASectionType)getSectionType {
    return self.sectionType;
}

- (void)checkIfMandatoryFieldsAreFilled {
    
}

@end
