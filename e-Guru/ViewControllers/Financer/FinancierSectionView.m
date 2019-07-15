//
//  FinancierSectionView.m
//  e-guru
//
//  Created by Shashi on 28/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierSectionView.h"

@implementation FinancierSectionView

- (instancetype)init {
    
    return [self initWithMode:FinancierModeCreate andModel:nil andEntryPoint:nil];
}

- (instancetype)initWithMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint{
    self = [super init];
    if (self) {
        [self loadUIFromXib];
        
        if (mode == FinancierModeCreate) {
            [self setBorderToView];
        }
        [self adjustUIBasedOnMode:mode andModel:model andEntryPoint:entryPoint];
//        [self adjustUIBasedOnMode:mode andModel:model];
    }
    return self;
}

#pragma mark - Private Methods
- (void)setBorderToView {
//    CGFloat borderWidth = 1.0f;
//    [self.layer setBorderWidth:borderWidth];
//    [self.layer setBorderColor:[UIColor separatorColor].CGColor];
}

#pragma mark - To Be Overridden in Child
- (void)loadUIFromXib {
}

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint {
}

- (void)resetFields {
    
}

- (FinancierSectionType)getSectionType {
    return self.sectionType;
}

- (void)checkIfMandatoryFieldsAreFilled {
    
}

@end
