//
//  SearchOptyFilter.m
//  e-Guru
//
//  Created by Rajkishan on 19/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGSearchOptyFilter.h"

@implementation EGSearchOptyFilter

-(instancetype) init
{
    self = [super init];
    if(self) {
        _sales_stage_name = @"";
        _primary_employee_id = @"";
        _buid = @"";
        _pplname = @"";
        _tehsil_name = @"";
        _assign_name = @"";
        _customer_cellular_number = @"";
        _dse_position_id = @"";
        _contact_last_name = @"";
        _contact_first_name = @"";
        _campaign_name = @"";
        _live_deal_flag = @"";
          _search_status= 1;
        _contact_id = @"";
        _from_date = @"";
        _to_date = @"";
        _account_id = @"";
        _opty_id = @"";
        _lob = @"";
        _nfa_available = @"";
        _financier_id = @"";
        _event_id = @"";
    }
    return self;
}

-(instancetype) initWithObject:(EGSearchOptyFilter *)optyFilter
{
    self = [super init];
    if(self) {
        _sales_stage_name = optyFilter.sales_stage_name;
        _primary_employee_id = optyFilter.primary_employee_id;
        _buid = optyFilter.buid;
        _pplname = optyFilter.pplname;
        _tehsil_name = optyFilter.tehsil_name;
        _assign_name = optyFilter.assign_name;
        _customer_cellular_number = optyFilter.customer_cellular_number;
        _dse_position_id = optyFilter.dse_position_id;
        _contact_last_name = optyFilter.contact_last_name;
        _contact_first_name = optyFilter.contact_first_name;
        _campaign_name = optyFilter.campaign_name;
        _live_deal_flag = optyFilter.live_deal_flag;
         _search_status = optyFilter.search_status;
        _contact_id = optyFilter.contact_id;
        _from_date = optyFilter.from_date;
        _to_date = optyFilter.to_date;
        _account_id = optyFilter.account_id;
        _opty_id = optyFilter.opty_id;
        _lob = optyFilter.lob;
        _nfa_available = optyFilter.nfa_available;
        _financier_id = optyFilter.financier_id;
        _event_id = optyFilter.event_id;
    }
    return self;
}

-(NSDictionary *) queryParamDict
{
    NSArray *keyArray =
        [NSArray arrayWithObjects:@"sales_stage_name", @"primary_employee_id",
    @"buid", @"pplname", @"tehsil_name", @"assign_name",
    @"customer_cellular_number", @"dse_position_id",
    @"contact_last_name", @"contact_first_name", @"campaign_name",
    @"live_deal_flag", @"contact_id",
    @"from_date", @"to_date", @"account_id",
    @"opty_id",@"search_status",@"lob",@"nfa_available"
    , @"financier_id",@"event_id", nil];
    
    return [self dictionaryWithValuesForKeys:keyArray];
}

-(NSDictionary *) filterParamDict
{
    NSArray *keyArray = [NSArray arrayWithObjects:@"sales_stage_name", @"from_date", @"to_date", nil];
//    NSArray *keyArray = [NSArray arrayWithObjects:@"sales_stage_name", nil];
    return [self dictionaryWithValuesForKeys:keyArray];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if(![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        EGSearchOptyFilter *otherFilter = (EGSearchOptyFilter *)other;
        
        return (
                    [self.primary_employee_id isEqualToString:otherFilter.primary_employee_id]
                &&  [self.buid  isEqualToString:otherFilter.buid]
                &&  [self.sales_stage_name isEqualToString:otherFilter.sales_stage_name]
                &&  [self.pplname  isEqualToString:otherFilter.pplname]
                &&  [self.tehsil_name  isEqualToString:otherFilter.tehsil_name]
                &&  [self.assign_name  isEqualToString:otherFilter.assign_name]
                &&  [self.customer_cellular_number  isEqualToString:otherFilter.customer_cellular_number]
                &&  [self.dse_position_id  isEqualToString:otherFilter.dse_position_id]
                &&  [self.contact_last_name  isEqualToString:otherFilter.contact_last_name]
                &&  [self.contact_first_name  isEqualToString:otherFilter.contact_first_name]
                &&  [self.campaign_name  isEqualToString:otherFilter.campaign_name]
                &&  [self.live_deal_flag  isEqualToString:otherFilter.live_deal_flag]
                && (self.search_status == otherFilter.search_status)
                &&  [self.contact_id  isEqualToString:otherFilter.contact_id]
                &&  [self.from_date  isEqualToString:otherFilter.from_date]
                &&  [self.from_date   isEqualToString:otherFilter.from_date]
                &&  [self.to_date  isEqualToString:otherFilter.to_date]
                &&  [self.account_id  isEqualToString:otherFilter.account_id]
                &&  [self.opty_id  isEqualToString:otherFilter.opty_id]
                &&  [self.lob isEqualToString:otherFilter.lob]
                &&  [self.nfa_available isEqualToString:otherFilter.nfa_available]
                &&  [self.financier_id isEqualToString:otherFilter.financier_id]
                &&  [self.event_id isEqualToString:otherFilter.event_id]
                )
        
        ;
    }
}

- (NSUInteger)hash
{
    NSString *toHashString = [NSString stringWithFormat:@"%@%@", self.from_date, self.to_date];
    return toHashString.hash ;
}

@end



