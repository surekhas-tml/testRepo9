//
//  EGPotentialDropOff.h
//  e-guru
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPotentialDropOff : NSObject

@property (nullable, nonatomic, copy) NSString *potential_drop_of_reason;
@property (nullable, nonatomic, copy) NSString *intervention_support;
@property (nullable, nonatomic, copy) NSString *stakeholder_responsible;
@property (nullable, nonatomic, copy) NSString *stakeholder_response;
@property (nullable, nonatomic, copy) NSString *app_name;
@end

NS_ASSUME_NONNULL_END
