//
//  PostHelper.h
//  e-guru
//
//  Created by MI iMac04 on 09/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Constant.h"

@interface PostHelper : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) PostRequestType postRequestType;
@property (nonatomic, copy) void (^successBlock)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
@property (nonatomic, copy) void (^failureBlock)(RKObjectRequestOperation *operation, NSError *error);
@property (nonatomic, copy) void (^afSuccessBlock)(AFRKHTTPRequestOperation *operation, id responseObject);
@property (nonatomic, copy) void (^afFailureBlock)(AFRKHTTPRequestOperation *operation, NSError *error);
@end
