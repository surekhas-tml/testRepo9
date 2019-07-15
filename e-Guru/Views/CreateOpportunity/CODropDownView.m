//
//  CoDropDownView.m
//  e-Guru
//
//  Created by MI iMac04 on 25/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "CODropDownView.h"
#import "PureLayout.h"

@interface CODropDownView()

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation CODropDownView

#pragma mark - Overridden Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadChildElements];
    }
    return self;
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        [self.contentView autoPinEdgesToSuperviewEdges];
        [self addConstraintToFieldNameLabel];
        [self addConstraintToTextField];
        
        self.didSetupConstraints = true;
    }
    
    [super updateConstraints];
}

#pragma mark - UI Initialization

- (void)loadChildElements {
    [self addSubview:self.fieldNameLabel];
    [self addSubview:self.textField];
}

- (UILabel *)fieldNameLabel {
    if (!_fieldNameLabel) {
        _fieldNameLabel = [[UILabel alloc] initForAutoLayout];
        _fieldNameLabel.text = @"Field Name";
        _fieldNameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    }
    return _fieldNameLabel;
}

- (DropDownTextField *)textField {
    if (!_textField) {
        _textField = [[DropDownTextField alloc] initForAutoLayout];
        _textField.placeholder = @"Field Value";
        _textField.enabled = false;
        _textField.userInteractionEnabled = true;
    }
    return _textField;
}

#pragma mark - UI Constraints

- (void)addConstraintToFieldNameLabel {
    [self.fieldNameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.fieldNameLabel autoSetDimension:ALDimensionHeight toSize:21.0f];
}

- (void)addConstraintToTextField {
    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.textField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fieldNameLabel];
    [self.textField autoSetDimension:ALDimensionHeight toSize:30.0f];
}


@end
