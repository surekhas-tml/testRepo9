//
//  EGParameterSettingViewModel.m
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGParameterSettingViewModel.h"
#import "EGRKWebserviceRepository.h"
#import "AppRepo.h"
#import "EGParameterChannelPriority.h"
#import "EGParameterFinancierChannelPriority.h"
#import "EGParameterKeyCustomerChannelPriority.h"
#import "EGParameteraBodyBuilderChannelPriority.h"
#import "EGParameterRegularVisitsChannelPriority.h"
#import "EGParameterMeetingFrequency.h"

@implementation EGParameterSettingViewModel
-(void)getParameterSettingForDate:(NSString*)date success:(void (^)(bool status))success{
//    self.parameterSetting.start_date = date;
    self.parameterSetting = [[EGParameterListModel alloc]init];
    [[EGRKWebserviceRepository sharedRepository]getParameterSettings:@{
                                                            @"dsm_name":[[AppRepo sharedRepo] getLoggedInUser].userName,
                                                            @"dealer_code":[[AppRepo sharedRepo] getLoggedInUser].dealerCode,@"lob":
                                                                [[AppRepo sharedRepo] getLoggedInUser].lobName,@"organization_name" :[[AppRepo sharedRepo] getLoggedInUser].organizationID  } andSucessAction:^(NSDictionary* parameters) {
                                                                    if(parameters[@"start_date"] != nil){
                                                                       self.parameterSetting.start_date = parameters[@"start_date"];
                                                                    }
                                                                    if(parameters[@"end_date"] != nil){
                                                                        self.parameterSetting.end_date = parameters[@"end_date"];
                                                                    }
                                                                    if(parameters[@"dealer_code"] != nil){
                                                                        self.parameterSetting.dealer_code = parameters[@"dealer_code"];
                                                                    }
                                                                    if(parameters[@"dealer_name"] != nil){
                                                                        self.parameterSetting.dealer_name = parameters[@"dealer_name"];
                                                                    }
                                                                    if(parameters[@"division_name"] != nil){
                                                                        self.parameterSetting.division_name = parameters[@"division_name"];
                                                                    }
                                                                    if(parameters[@"max_meetings"] != nil){
                                                                        self.parameterSetting.max_meetings = [NSString stringWithFormat:@"%@",parameters[@"max_meetings"]];
                                                                    }
                                                                    if(parameters[@"channel_priority"] != nil){
                                                                        self.parameterSetting.channelPriority = [[EGParameterChannelPriority alloc]init];
                                                                        NSDictionary *channelPrioDict = parameters[@"channel_priority"] ;
                                                                        if(channelPrioDict[@"body_builders"] != nil){
                                                                            self.parameterSetting.channelPriority.bodyBuilderChannelPriority = [[EGParameteraBodyBuilderChannelPriority alloc]init];
                                                                            NSDictionary *bodybuilders = channelPrioDict[@"body_builders"] ;
                                                                            if(bodybuilders[@"priority"] != nil){
                                                                                self.parameterSetting.channelPriority.bodyBuilderChannelPriority.priority =     [NSString stringWithFormat:@"%@",bodybuilders[@"priority"]] ;                                                                        }
                                                                            
                                                                            if(bodybuilders[@"minimum_allocation"] != nil){
                                                                                self.parameterSetting.channelPriority.bodyBuilderChannelPriority.minimum_allocation =   [NSString stringWithFormat:@"%@",bodybuilders[@"minimum_allocation"]]  ;                                                                        }
                                                                        }
                                                                        if(channelPrioDict[@"regular_visits"] != nil){
                                                                            self.parameterSetting.channelPriority.regularVisitsChannelPriority = [[EGParameterRegularVisitsChannelPriority alloc]init];
                                                                            NSDictionary *regular_visits = channelPrioDict[@"regular_visits"] ;
                                                                            if(regular_visits[@"priority"] != nil){
                                                                                self.parameterSetting.channelPriority.regularVisitsChannelPriority.priority =     [NSString stringWithFormat:@"%@",regular_visits[@"priority"]];                                                                        }
                                                                            if(regular_visits[@"minimum_allocation"] != nil){
                                                                                self.parameterSetting.channelPriority.regularVisitsChannelPriority.minimum_allocation =     [NSString stringWithFormat:@"%@",regular_visits[@"minimum_allocation"]];                                                                        }
                                                                        }
                                                                        
                                                                        if(channelPrioDict[@"key_customers"] != nil){
                                                                            self.parameterSetting.channelPriority.keyCustomerChannelPriority = [[EGParameterKeyCustomerChannelPriority alloc]init];
                                                                            NSDictionary *key_customers = channelPrioDict[@"key_customers"] ;
                                                                            if(key_customers[@"priority"] != nil){
                                                                                self.parameterSetting.channelPriority.keyCustomerChannelPriority.priority =     [NSString stringWithFormat:@"%@",key_customers[@"priority"]];                                                                        }
                                                                            if(key_customers[@"minimum_allocation"] != nil){
                                                                                self.parameterSetting.channelPriority.keyCustomerChannelPriority.minimum_allocation =    [NSString stringWithFormat:@"%@",key_customers[@"minimum_allocation"]] ;                                                                        }
                                                                        }
                                                                        
                                                                        if(channelPrioDict[@"financier_executives"] != nil){
                                                                            self.parameterSetting.channelPriority.financierChannelPriority = [[EGParameterFinancierChannelPriority alloc]init];
                                                                            NSDictionary *financier_executives = channelPrioDict[@"financier_executives"] ;
                                                                            if(financier_executives[@"priority"] != nil){
                                                                                self.parameterSetting.channelPriority.financierChannelPriority.priority =     [NSString stringWithFormat:@"%@",financier_executives[@"priority"]];                                                                        }
                                                                            if(financier_executives[@"minimum_allocation"] != nil){
                                                                                self.parameterSetting.channelPriority.financierChannelPriority.minimum_allocation =     [NSString stringWithFormat:@"%@",financier_executives[@"minimum_allocation"]];                                                                        }
                                                                        }
                                                                    }
                                                                    if(parameters[@"metting_frequency"] != nil){
                                                                        self.parameterSetting.mettingfrequency = [[EGParameterMeetingFrequency alloc]init];
                                                                        NSDictionary *metting_frequency = parameters[@"metting_frequency"] ;
                                                                        if(metting_frequency[@"c0"] != nil){
                                                                            self.parameterSetting.mettingfrequency.c0 = [NSString stringWithFormat:@"%@",metting_frequency[@"c0"]];
                                                                        }
                                                                        
                                                                        if(metting_frequency[@"c1"] != nil){
                                                                            self.parameterSetting.mettingfrequency.c1 = [NSString stringWithFormat:@"%@",metting_frequency[@"c1"]];
                                                                        }
                                                                        if(metting_frequency[@"c1A"] != nil){
                                                                            self.parameterSetting.mettingfrequency.c1A = [NSString stringWithFormat:@"%@",metting_frequency[@"c1A"]];
                                                                        }
                                                                        if(metting_frequency[@"c2"] != nil){
                                                                            self.parameterSetting.mettingfrequency.c2 = [NSString stringWithFormat:@"%@",metting_frequency[@"c2"]];
                                                                        }
                                                                    }
//                                                                    self.parameterSetting = (EGParameterListModel*)parameters;
        success(true);
    } andFailuerAction:^(NSError *error) {
        success(false);
    } showLoader:true];
}


-(NSString*)setMeetingFrequency{
    return self.parameterSetting.max_meetings;
}
-(NSString*)setStartDate{
    return self.parameterSetting.start_date;
}

-(NSString*)setParamsEndDate{
    return self.parameterSetting.end_date;
}

-(NSString*)setDivisionName{
    return self.parameterSetting.division_name;
}

-(NSString*)setDealerName{
    return self.parameterSetting.dealer_name;
}

-(NSString*)setMeetingFrequencyC0{
    if (self.parameterSetting.mettingfrequency.c0 != nil){
        return self.parameterSetting.mettingfrequency.c0;
    }
    return @"";
}
-(NSString*)setMeetingFrequencyC1{
    if (self.parameterSetting.mettingfrequency.c1 != nil){
        return self.parameterSetting.mettingfrequency.c1;
    }
    return @"";
}
-(NSString*)setMeetingFrequencyC1a{
    if (self.parameterSetting.mettingfrequency.c1A != nil){
        return self.parameterSetting.mettingfrequency.c1A;
    }
    return @"";
}
-(NSString*)setMeetingFrequencyC2{
    if (self.parameterSetting.mettingfrequency.c2 != nil){
        return self.parameterSetting.mettingfrequency.c2;
    }
    return @"";
}

-(NSString*)setChannelFinancierMinimumAllocation{
    return self.parameterSetting.channelPriority.financierChannelPriority.minimum_allocation;
}
-(NSString*)setChannelKeyCustMinimumAllocation{
    return self.parameterSetting.channelPriority.keyCustomerChannelPriority.minimum_allocation;
}
-(NSString*)setChannelRegularVisitsMinimumAllocation{
    return self.parameterSetting.channelPriority.regularVisitsChannelPriority.minimum_allocation;
}
-(NSString*)setChannelBodyBuilderMinimumAllocation{
    return self.parameterSetting.channelPriority.bodyBuilderChannelPriority.minimum_allocation;
}
-(NSString*)setChannelFinancierPriority{
    return self.parameterSetting.channelPriority.financierChannelPriority.priority;
}
-(NSString*)setChannelKeyCustPriority{
    return self.parameterSetting.channelPriority.keyCustomerChannelPriority.priority;
}
-(NSString*)setChannelRegularVisitsPriority{
    return self.parameterSetting.channelPriority.regularVisitsChannelPriority.priority;
}
-(NSString*)setChannelBodyBuilderPriority{
    return self.parameterSetting.channelPriority.bodyBuilderChannelPriority.priority;
}
@end
