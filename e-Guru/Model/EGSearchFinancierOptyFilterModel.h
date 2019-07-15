//
//  EGSearchFinancierOptyFilterModel.h
//  e-guru
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface EGSearchFinancierOptyFilterModel : NSObject

@property(nonatomic, strong) NSMutableArray * sales_stage_name;
@property(nonatomic, assign) BOOL is_quote_submitted_to_financier;
@property (assign, nonatomic) DSMDSEOPTY search_status;
@property(nonatomic, strong) NSString * financier_id;

@property(nonatomic, strong) NSString * financier_case_status;
@property(nonatomic, strong) NSString * quote_submitted_to_financier_from_dt;
@property(nonatomic, strong) NSString * quote_submitted_to_financier_to_dt;
@property(nonatomic, strong) NSString * last_name;
@property(nonatomic, strong) NSString * mobile_number;
@property(nonatomic, strong) NSString * opty_id;
@property(nonatomic, strong) NSString * offset;
@property(nonatomic, strong) NSString * limit;
@property(assign, nonatomic) BOOL isSerchApplied;

-(NSDictionary *) queryParamDict;
-(instancetype) initWithObject:(EGSearchFinancierOptyFilterModel *)optyFilter;


@end

