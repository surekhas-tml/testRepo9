//
//  MMGEOLocationModel.h
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMGEOLocationModel : NSObject

@property (nonatomic,retain)NSString *stateName;
@property (nonatomic,retain)NSString *stateId;

@property (nonatomic,retain)NSString *districtName;
@property (nonatomic,retain)NSString *talukaName;
@property (nonatomic,retain)NSString *cityName;
@property (nonatomic,retain)NSString *lobName;
@property (nonatomic,retain)NSString *microMarketName;

@end

NS_ASSUME_NONNULL_END
