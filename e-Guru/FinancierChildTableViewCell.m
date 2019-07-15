//
//  FinancierChildTableViewCell.m
//  e-guru
//
//  Created by Admin on 20/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierChildTableViewCell.h"
#import "PureLayout.h"

@implementation FinancierChildTableViewCell

-(instancetype)init{
    self = [super init];
    if (self) {
         [self loadUIFromXib];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUIFromXib];
    }
    return self;
}

-(void)loadUIFromXib{
    UIView *nib = [[[UINib nibWithNibName:@"FinancierChildTableViewCell" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
}

@end
