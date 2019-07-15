//
//  ActivityTableHederView.m
//  e-Guru
//
//  Created by Juili on 05/11/16.
//  Copyright © 1016 TATA. All rights reserved.
//

#import "ActivityTableHederView.h"
#import "AppRepo.h"

@implementation ActivityTableHederView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withActivity:(NSString *)activity{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        if ([[AppRepo sharedRepo] isDSMUser]) {
            if ([activity isEqualToString:@"My_Activity"]) {
                [[NSBundle mainBundle] loadNibNamed:@"ActivityTableHeaderView" owner:self options:nil];
            }else{
                [[NSBundle mainBundle] loadNibNamed:@"ActivityTableHeaderViewDSM" owner:self options:nil];
            }
        }
        else {
            [[NSBundle mainBundle] loadNibNamed:@"ActivityTableHeaderView" owner:self options:nil];
        }

        [self.view setBackgroundColor:[UIColor tableTitleBarColor]];
        [self.view setFrame:frame];
        [self addSubview:self.view];


    }
    return self;
}
- (IBAction)activityFilterButtonClicked:(id)sender {
}

@end
