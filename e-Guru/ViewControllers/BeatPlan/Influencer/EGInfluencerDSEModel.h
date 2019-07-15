//
//  EGInfluencerDSEModel.h
//  e-guru
//
//  Created by Apple on 06/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGMMGeoInfluencerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGInfluencerDSEModel : NSObject

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *dseID;
@property (nonatomic) BOOL isSelectedDSE;
@property (nonatomic,copy) NSArray<EGMMGeoInfluencerModel*>*dseMMGeoArray;

@end

NS_ASSUME_NONNULL_END
