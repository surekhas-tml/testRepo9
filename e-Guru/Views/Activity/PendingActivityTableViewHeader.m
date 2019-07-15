//
//  PendingActivityTableViewHeader.m
//  e-Guru
//
//  Created by Juili on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "PendingActivityTableViewHeader.h"

@implementation PendingActivityTableViewHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        [[NSBundle mainBundle] loadNibNamed:@"PendingActivityTableViewHeader" owner:self options:nil];
        [self.view setFrame:frame];
        [self.view setBackgroundColor:[UIColor tableTitleBarColor]];

        [self.plannedTime setTextColor:[UIColor navBarColor]];
        [self.planedDate setTextColor:[UIColor navBarColor]];
        [self.comment setTextColor:[UIColor navBarColor]];
        [self.activityType setTextColor:[UIColor navBarColor]];
        [self.activityStatus setTextColor:[UIColor navBarColor]];;
        
        [self addSubview:self.view];
        
    }
    return self;
}
@end
