//
//  EGParameterSettingViewModel.h
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGParameterListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EGParameterSettingViewModel : NSObject
@property(nonatomic,strong)  EGParameterListModel * parameterSetting;
-(void)getParameterSettingForDate:(NSString*)date success:(void (^)(bool status))success;
-(NSString*)setMeetingFrequency;
-(NSString*)setStartDate;
-(NSString*)setParamsEndDate;
-(NSString*)setDivisionName;
-(NSString*)setDealerName;
-(NSString*)setMeetingFrequencyC0;
-(NSString*)setMeetingFrequencyC1;
-(NSString*)setMeetingFrequencyC1a;
-(NSString*)setMeetingFrequencyC2;
-(NSString*)setChannelFinancierMinimumAllocation;
-(NSString*)setChannelKeyCustMinimumAllocation;
-(NSString*)setChannelRegularVisitsMinimumAllocation;
-(NSString*)setChannelBodyBuilderMinimumAllocation;
-(NSString*)setChannelFinancierPriority;
-(NSString*)setChannelKeyCustPriority;
-(NSString*)setChannelRegularVisitsPriority;
-(NSString*)setChannelBodyBuilderPriority;

@end

NS_ASSUME_NONNULL_END
