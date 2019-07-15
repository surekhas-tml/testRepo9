//
//  SearchOptyFilter.h
//  e-Guru
//
//  Created by Rajkishan on 19/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
//NOTE - The variable naming convention in this class is BY PURPOSE. This is to be able to directly convert the properties to dict keys as desired by the API. TODO - better way to implement it exists through RESTKIT, to be changed later all over the code.

@interface EGSearchOptyFilter : NSObject

@property(nonatomic) NSString * sales_stage_name;
@property(nonatomic) NSString * primary_employee_id;
@property(nonatomic) NSString * buid;
@property(nonatomic) NSString * pplname;
@property(nonatomic) NSString * tehsil_name;
@property(nonatomic) NSString * assign_name;
@property(nonatomic) NSString * customer_cellular_number;
@property(nonatomic) NSString * dse_position_id;
@property(nonatomic) NSString * contact_last_name;
@property(nonatomic) NSString * contact_first_name;
@property(nonatomic) NSString * campaign_name;
@property(nonatomic) NSString * live_deal_flag;
@property (assign, nonatomic) DSMDSEOPTY search_status;
@property(nonatomic) NSString * contact_id;
@property(nonatomic) NSString * from_date;
@property(nonatomic) NSString * to_date;
@property(nonatomic) NSString * account_id;
@property(nonatomic) NSString * opty_id;
@property(nonatomic) NSString * lob;
@property(nonatomic) NSString * nfa_available;
@property(nonatomic) NSString * financier_id;
@property(nonatomic) NSString * event_id;


//@property(nonatomic) NSString * offset;
//@property(nonatomic) NSString * size;

- (NSDictionary*) queryParamDict;
- (NSDictionary*) filterParamDict;

-(instancetype) initWithObject:(EGSearchOptyFilter *)optyFilter;
@end



