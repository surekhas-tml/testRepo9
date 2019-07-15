//
//  PipelineTableHederView.m
//  e-Guru
//
//  Created by Juili on 05/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "PipelineTableHederView.h"

@implementation PipelineTableHederView

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
        [[NSBundle mainBundle] loadNibNamed:@"PipelineTableHederView" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor tableTitleBarColor]];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        
    }
    return self;
}
- (IBAction)pipelineFilterButtonClicked:(id)sender {
}

@end
