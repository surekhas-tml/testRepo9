//
//  COSearchTextFieldView.m
//  e-Guru
//
//  Created by MI iMac04 on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "COSearchTextFieldView.h"

#define RIGHT_VIEW_DIMEN 30.0

@interface COSearchTextFieldView()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation COSearchTextFieldView

#pragma mark - Overridden Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSearchIcon];
    }
    return self;
}

- (void)addSearchIcon {
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RIGHT_VIEW_DIMEN, RIGHT_VIEW_DIMEN)];
    [self.searchButton setBackgroundColor:[UIColor grayColor]];
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = self.searchButton;
    [self.textField.layer setMasksToBounds:true];
}

@end
