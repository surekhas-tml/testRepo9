//
//  InfluencerViewModel.h
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGInfluencerDataModel.h"
#import "EGInfluencerDSEModel.h"
#import "EGMMGeoInfluencerModel.h"
#import "EGInfluencerModel.h"
#import "EGCustomerDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(id response);
typedef void(^errorBlock)(NSError *error);

typedef enum : NSUInteger{
    Financier,
    Bodybuilder,
    Mechanic,
} SourceOfContact;

@interface InfluencerViewModel : NSObject

- (void)getInfluencerApiWithType:(NSString*)type withid:(NSString *)dsmID withLOB:(NSString *)lob withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (NSString*)getTitleOfDSEAtIndex:(NSInteger)index;

- (void)getHeaderListWithType:(NSString*)type;
- (NSString*)getTitleOfHeaderAtIndex:(NSInteger)index;
- (void)setHeaderSelectedAtIndex:(NSInteger)index;
- (BOOL)getValueOfHeaderAtIndex:(NSInteger)index;
- (NSMutableArray *)getAllDataDSEID;
- (void)getDSEListFromMMGeo:(NSString*)mmGeo withSuccessAction:(successBlock)successBlock andFailuerAction:(errorBlock)failuerBlock;
- (void)getMMGEOListWithParams:(NSDictionary*)params withSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (void)addCustomerWithParams:(NSDictionary*)params isUpdate:(BOOL)isUpdate withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (void)getDistrictListFromState:(NSString*)state withSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (void)getCityListFromParams:(NSDictionary*)params SuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (void)getLOBListSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

@property (nonatomic, strong) NSMutableArray *arrayHeaderList;
@property (nonatomic, strong) EGInfluencerDataModel *egInfluencerDataModel;

@end

NS_ASSUME_NONNULL_END
