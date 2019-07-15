//
//  FinancierBranchDetailsModel.m
//  e-guru
//
//  Created by Shashi on 09/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierBranchDetailsModel.h"

@implementation FinancierBranchDetailsModel

@synthesize financier_name;
@synthesize financier_id;
@synthesize branch_id;

-(instancetype)init{
    self =  [super init];
    if (self) {
    }
    return self;
}

-(instancetype)initWithObject:(NSString *)object{
    self = [super init];
    if (self) {
        self.financier_name = object;
        self.financier_id = object;
        self.branch_id = object;
    }
    return self;
}

@end
