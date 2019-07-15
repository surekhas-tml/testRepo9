//
//  EGSearchFinancierOptyFilterModel.m
//  e-guru
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "EGSearchFinancierOptyFilterModel.h"

@implementation EGSearchFinancierOptyFilterModel


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.sales_stage_name = [NSMutableArray new];
        self.is_quote_submitted_to_financier = false;
        self.search_status = 1;
        self.financier_id = @"";
        self.financier_case_status = @"";
        self.quote_submitted_to_financier_from_dt = @"";
        self.quote_submitted_to_financier_to_dt = @"";
        self.last_name = @"";
        self.mobile_number = @"";
        self.opty_id = @"";
        self.offset = @"";
        self.limit = @"";
        self.isSerchApplied =false;
    }
    return self;
}

-(instancetype) initWithObject:(EGSearchFinancierOptyFilterModel *)optyFilter
{
    self = [super init];
    if(self) {
        
        self.sales_stage_name = optyFilter.sales_stage_name;
        self.is_quote_submitted_to_financier = optyFilter.is_quote_submitted_to_financier;
        self.search_status = optyFilter.search_status;
        self.financier_id = optyFilter.financier_id;
        self.financier_case_status = optyFilter.financier_case_status;
        self.quote_submitted_to_financier_from_dt = optyFilter.quote_submitted_to_financier_from_dt;
        self.quote_submitted_to_financier_to_dt = optyFilter.quote_submitted_to_financier_to_dt;
        self.last_name = optyFilter.last_name;
        self.mobile_number = optyFilter.mobile_number;
        self.opty_id = optyFilter.opty_id;
        self.offset = optyFilter.offset;
        self.limit = optyFilter.limit;
        self.isSerchApplied = false;
    }
    return self;
}

-(NSDictionary *) queryParamDict
{
    NSArray *keyArray =
    [NSArray arrayWithObjects:@"sales_stage_name",
     @"is_quote_submitted_to_financier",
     @"search_status",
     @"financier_id",
     @"financier_case_status",
     @"quote_submitted_to_financier_from_dt",
     @"quote_submitted_to_financier_to_dt",
     @"last_name",
     @"mobile_number",
     @"opty_id", nil];
    
    return [self dictionaryWithValuesForKeys:keyArray];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if(![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        EGSearchFinancierOptyFilterModel *otherFilter = (EGSearchFinancierOptyFilterModel *)other;
        
        return (
                  self.is_quote_submitted_to_financier == otherFilter.is_quote_submitted_to_financier
                &&  self.search_status == otherFilter.search_status
                &&  [self.financier_id  isEqualToString:otherFilter.financier_id]
                &&  [self.financier_case_status  isEqualToString:otherFilter.financier_case_status]
                &&  [self.quote_submitted_to_financier_from_dt  isEqualToString:otherFilter.quote_submitted_to_financier_from_dt]
                &&  [self.quote_submitted_to_financier_to_dt  isEqualToString:otherFilter.quote_submitted_to_financier_to_dt]
                &&  [self.last_name  isEqualToString:otherFilter.last_name]
                &&  [self.mobile_number  isEqualToString:otherFilter.mobile_number]
                &&  [self.opty_id  isEqualToString:otherFilter.opty_id]
                
                )
        ;
    }
}

@end
