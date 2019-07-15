//
//  FinancierListDetails.m
//  e-guru
//
//  Created by Admin on 25/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierListDetails.h"

@implementation FinancierListDetails

@synthesize selectedFinancierID, selectedFinancierName;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectedFinancierID    = @"";
        self.selectedFinancierName  = @"";
        self.branch_id = @"";
        self.branch_name = @"";
        self.bdm_id = @"";
        self.bdm_name = @"";
        self.bdm_mobile_no = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancierSelectedDetailMO *)object{
    self = [super init];
    if (self) {
        self.selectedFinancierID           = object.selectedFinancierID? : @"";
        self.selectedFinancierName         = object.selectedFinancierName? : @"";
       
        self.branch_id = object.branch_id? : @"";
        self.branch_name = object.branch_name? : @"";
        self.bdm_id = object.bdm_id? : @"";
        self.bdm_name = object.bdm_name? : @"";
        self.bdm_mobile_no = object.bdm_mobile_no? : @"";
    }
    return self;
}



@end
