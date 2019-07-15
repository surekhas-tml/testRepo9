//
//  EGParameterListModel.h
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGParameterMeetingFrequency.h"
#import "EGParameterChannelPriority.h"
NS_ASSUME_NONNULL_BEGIN

@interface EGParameterListModel : NSObject
@property(nonatomic,strong)  NSString * start_date;
@property(nonatomic,strong)  NSString * end_date;
@property(nonatomic,strong)  NSString * max_meetings;
@property(nonatomic,strong)  NSString * dealer_name;
@property(nonatomic,strong)  NSString * division_name;
@property(nonatomic,strong)  NSString * dealer_code;
@property(nonatomic,strong)  EGParameterMeetingFrequency * mettingfrequency;
@property(nonatomic,strong)  EGParameterChannelPriority * channelPriority;
@end

NS_ASSUME_NONNULL_END


/*
 {
 "start_date": "",
 "end_date": "",
 "max_meetings": 5,
 "dealer_name": "",
 "division_name": "",
 "metting_frequency": {
 "c0": 2,
 "c1": 1,
 "c1A": 1,
 "c2": 2
 
 },
 "channel_priority": {
 "Financier Exe": {
 "priority": 3,
 "minimum_allocation": 2
 },
 "Body Builder": {
 "priority": 2,
 "minimum_allocation": 3
 
 },
 "Key Cust": {
 "priority": 4,
 "minimum_allocation": "1"
 
 },
 "Reqular Visit": {
 "priority": 1,
 "minimum_allocation": 5
 }}
 }*/
