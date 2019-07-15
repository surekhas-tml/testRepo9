//
//  LOBCollectionViewCell.m
//  e-Guru
//
//  Created by MI iMac04 on 17/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LOBCollectionViewCell.h"

#define CIRCLE_DIAMETER 6.0
#define CIRCLE_RADIUS (CIRCLE_DIAMETER/2)
#define CIRCLE_COLOR [UIColor colorWithRed:34/255.0 green:115/255.0 blue:181/255.0 alpha:1].CGColor

@implementation LOBCollectionViewCell

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *rombusPath = [UIBezierPath bezierPath];
    UIColor *strokeColor = [UIColor grayColor];
    [strokeColor setStroke];
    
    [rombusPath moveToPoint:CGPointMake(self.frame.size.width / 2, 0.0)];
    [rombusPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height / 2)];
    [rombusPath addLineToPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height)];
    [rombusPath addLineToPoint:CGPointMake(0, self.frame.size.height / 2)];
    [rombusPath addLineToPoint:CGPointMake(self.frame.size.width / 2, 0)];
    
    [rombusPath closePath];
    [rombusPath stroke];
    
    // Adding the circles on vertices
    [self createAndAddTopCircle];
    [self createAndAddLeftCircle];
    [self createAndAddBottomCircle];
    [self createAndAddRightCircle];
}

- (void)createAndAddTopCircle {
    CAShapeLayer *topCircle = [CAShapeLayer layer];
    topCircle.fillColor = CIRCLE_COLOR;
    [topCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.frame.size.width / 2) - CIRCLE_RADIUS, 0 - CIRCLE_RADIUS, CIRCLE_DIAMETER, CIRCLE_DIAMETER)] CGPath]];
    
    // Hide the Top Circle for each cell in first row
    if (self.currentIndex >= self.totalColumnCount) {
        [self.layer addSublayer:topCircle];
    }
}

- (void)createAndAddLeftCircle {
    CAShapeLayer *leftCircle = [CAShapeLayer layer];
    leftCircle.fillColor = CIRCLE_COLOR;
    [leftCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0 - CIRCLE_RADIUS, (self.frame.size.height / 2) - CIRCLE_RADIUS, CIRCLE_DIAMETER, CIRCLE_DIAMETER)] CGPath]];
    
    // Hide the Left Circle for each cell in first column
    if ((self.currentIndex % self.totalColumnCount) != 0) {
        [self.layer addSublayer:leftCircle];
    }
}

- (void)createAndAddBottomCircle {
    CAShapeLayer *bottomCircle = [CAShapeLayer layer];
    bottomCircle.fillColor = CIRCLE_COLOR;
    [bottomCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.frame.size.width / 2) - CIRCLE_RADIUS, self.frame.size.height - CIRCLE_RADIUS, CIRCLE_DIAMETER, CIRCLE_DIAMETER)] CGPath]];
    
    // Hide the Bottom Circle for each cell in last row
    // and also for the last cell in second last row
    // if reminder is greater than 0
//    NSInteger remainder = self.totalCellCount % self.totalColumnCount;
//    NSInteger lastRowStartIndex;
//    if (remainder > 0) {
//        lastRowStartIndex = self.totalCellCount - remainder;
//    }
//    else {
//        lastRowStartIndex = self.totalCellCount - self.totalColumnCount;
//    }
//    
//    if (self.currentIndex < lastRowStartIndex && !(remainder > 0 && self.currentIndex == (lastRowStartIndex - 1))) {
//        [self.layer addSublayer:bottomCircle];
//    }
    
    if ((self.currentIndex + self.totalColumnCount) < self.totalCellCount) {
        [self.layer addSublayer:bottomCircle];
    }
    
}

- (void)createAndAddRightCircle {
    CAShapeLayer *rightCircle = [CAShapeLayer layer];
    rightCircle.fillColor = CIRCLE_COLOR;
    [rightCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width - CIRCLE_RADIUS, (self.frame.size.height / 2) - CIRCLE_RADIUS, CIRCLE_DIAMETER, CIRCLE_DIAMETER)] CGPath]];
    
    // Hide the Right Circle for each cell in last column
    // and also for the last cell
    if (((self.currentIndex + 1) % 5) != 0 && self.currentIndex != (self.totalCellCount - 1)) {
        [self.layer addSublayer:rightCircle];
    }
}

@end
