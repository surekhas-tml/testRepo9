//
//  EGParameterChannelPriority.h
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGParameterFinancierChannelPriority.h"
#import "EGParameterKeyCustomerChannelPriority.h"
#import "EGParameteraBodyBuilderChannelPriority.h"
#import "EGParameterRegularVisitsChannelPriority.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGParameterChannelPriority : NSObject
@property(nonatomic,strong)  EGParameterFinancierChannelPriority * financierChannelPriority;
@property(nonatomic,strong)  EGParameterKeyCustomerChannelPriority * keyCustomerChannelPriority;
@property(nonatomic,strong)  EGParameteraBodyBuilderChannelPriority * bodyBuilderChannelPriority;
@property(nonatomic,strong)  EGParameterRegularVisitsChannelPriority * regularVisitsChannelPriority;
@end

NS_ASSUME_NONNULL_END
