//
//  EGInfluencerDataModel.h
//  e-guru
//
//  Created by Apple on 06/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGInfluencerDSEModel;

NS_ASSUME_NONNULL_BEGIN

@interface EGInfluencerDataModel : NSObject

@property (nonatomic, copy) NSString *customerType;
@property (nonatomic, copy) NSArray<EGInfluencerDSEModel *> *data;

@end
NS_ASSUME_NONNULL_END
