//
//  DSEModel.h
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMGEOLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSEModel : NSObject

@property (nonatomic,retain)NSString *dseId;
@property (nonatomic,retain)NSString *dseName;
@property BOOL isActive;

//@property (nonatomic,retain)MMGEOLocationModel *locationListForDSE;
@property (nonatomic,retain)NSMutableArray *locationListForDSE;

- (instancetype)initWithDSEName:(NSString *)dseName dseId:(NSInteger)dseCode locationList:(NSMutableArray*)dseLocationArray:(BOOL)isActive;


@end

NS_ASSUME_NONNULL_END
