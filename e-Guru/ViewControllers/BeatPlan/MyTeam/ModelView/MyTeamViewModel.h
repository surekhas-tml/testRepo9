//
//  MyTeamViewModel.h
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSEModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^successBlock)(id response);
typedef void(^errorBlock)(NSError *error);

@interface MyTeamViewModel : NSObject

@property (nonatomic,retain)DSEModel *dseCurrentObject;
@property (nonatomic,retain) NSMutableArray *dsewiseMMGEOLocationArray ;

-(NSString*)getDSEName:(NSInteger)tag;
-(NSMutableArray*)getLocationList:(NSInteger)tag;
-(NSString*)getMicroMarketName:(NSMutableArray*)locationListArray :(NSInteger)tag;
-(NSString*)getData;


- (instancetype)init:(DSEModel *)dseCurrentObject;
-(BOOL)isDSEAcivated:(NSInteger)tag;

//-(void)getMyTeamDetails:(NSDictionary*)authDetails : (NSString*)paramString;

//- (void)getMyTeamApiWithType:(NSString*)extension :(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)getMyTeamApiWithType:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)getMMGEOList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)getStateCode:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)assignLocationToDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)removeDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

- (void)removeMMGEOLocationDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;

//---
- (void)getDistrictList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;
- (void)getCityList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck;


@end

NS_ASSUME_NONNULL_END
