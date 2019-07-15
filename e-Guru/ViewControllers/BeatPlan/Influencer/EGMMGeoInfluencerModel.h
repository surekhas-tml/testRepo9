//
//  EGMMGeoInfluencerModel.h
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGCustomerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGMMGeoInfluencerModel : NSObject
@property (nonatomic,copy) NSString *mmGeo;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *city;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic) BOOL isSelectedMMGeo;

@property (nonatomic,copy) NSArray<EGCustomerDetailModel*>*financier_executives;
@property (nonatomic,copy) NSArray<EGCustomerDetailModel*>*bodyBuilders;
@property (nonatomic,copy) NSArray<EGCustomerDetailModel*>*mechanics;

@end

NS_ASSUME_NONNULL_END
