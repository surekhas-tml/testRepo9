//
//  EGSearchNFAFilter.m
//  e-guru
//
//  Created by Juili on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "EGSearchNFAFilter.h"

@implementation EGSearchNFAFilter
-(instancetype) init
{
    self = [super init];
    if(self) {
        _nfa_request_number = @"";
        _status = 0;
        _nfa_from_date = @"";
        _nfa_to_date = @"";
        _lob = @"";
        _ppl = @"";
        _sales_stage = @"";
        _opty_from_date = @"";
        _opty_to_date = @"";
    }
    return self;
}

-(instancetype) initWithObject:(EGSearchNFAFilter *)nfaFilter;
{
    self = [super init];
    if(self) {
        _nfa_request_number = nfaFilter.nfa_request_number;
        _status = nfaFilter.status;
        _nfa_from_date = nfaFilter.nfa_from_date;
        _nfa_to_date = nfaFilter.nfa_to_date;
        _lob = nfaFilter.lob;
        _ppl = nfaFilter.ppl;
        _sales_stage = nfaFilter.sales_stage;
        _opty_from_date = nfaFilter.opty_from_date;
        _opty_to_date = nfaFilter.opty_to_date;
        
        }
    return self;
}

-(NSDictionary *) queryParamDict
{
    NSArray *keyArray =
    [NSArray arrayWithObjects:@"nfa_request_number", @"status",@"nfa_from_date", @"nfa_to_date",@"lob",@"ppl",@"sales_stage",@"opty_from_date",@"opty_to_date"
     , nil];
    return [self dictionaryWithValuesForKeys:keyArray];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if(![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        EGSearchNFAFilter *otherFilter = (EGSearchNFAFilter *)other;
        
        return (
                [self.nfa_request_number isEqualToString:otherFilter.nfa_request_number]
                &&  (self.status  == otherFilter.status)
                &&  [self.nfa_from_date  isEqualToString:otherFilter.nfa_from_date]
                &&  [self.nfa_to_date  isEqualToString:otherFilter.nfa_to_date]
                && [self.lob isEqualToString:otherFilter.lob]
                && [self.ppl isEqualToString:otherFilter.ppl]
                && [self.sales_stage isEqualToString:otherFilter.sales_stage]
                && [self.opty_from_date isEqualToString:otherFilter.opty_from_date]
                && [self.opty_to_date isEqualToString:otherFilter.opty_to_date]
            ) ;
    }
}

- (NSUInteger)hash
{
    NSString *toHashString = [NSString stringWithFormat:@"%@%@", self.nfa_from_date, self.nfa_to_date];
    return toHashString.hash ;
}
@end
