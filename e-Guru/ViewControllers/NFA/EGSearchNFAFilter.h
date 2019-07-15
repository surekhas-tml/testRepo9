//
//  EGSearchNFAFilter.h
//  e-guru
//
//  Created by Juili on 01/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface EGSearchNFAFilter : NSObject
@property(nonatomic) NSString * nfa_request_number;
@property(nonatomic) NFAStatusValue status;
@property(nonatomic) NSString * nfa_from_date;
@property(nonatomic) NSString * nfa_to_date;

@property(nonatomic) NSString * lob;
@property(nonatomic) NSString * ppl;
@property(nonatomic) NSString * sales_stage;
@property(nonatomic) NSString * opty_from_date;
@property(nonatomic) NSString * opty_to_date;

- (NSDictionary*) queryParamDict;
-(instancetype) initWithObject:(EGSearchNFAFilter *)nfaFilter;
@end
