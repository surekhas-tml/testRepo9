//
//  AccessTokenManager.m
//  e-guru
//
//  Created by MI iMac04 on 09/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AccessTokenManager.h"
#import "UtilityMethods.h"
#import "AAATokenMO+CoreDataClass.h"
#import "AAATokenMO+CoreDataProperties.h"
#import "AppRepo.h"

@implementation AccessTokenManager

+ (instancetype)sharedManager {
    static AccessTokenManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queueDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)renewAccessToken:(PostHelper *)post {
    [self.queueDictionary setObject:post forKey:post.path];
    if (!self.isRenewing) {
        self.isRenewing = true;
        [self callGetAccessTokenAPI:post];
    }
}

- (void)callGetAccessTokenAPI:(PostHelper *)postHelper {
    
    NSDictionary *requestDictionary = @{@"refresh_token": [[AppRepo sharedRepo] getTokenDetails].refreshToken,
                                        @"device_id": [UtilityMethods getVendorID],
                                        @"app_name": [UtilityMethods getAppBundleID]};
    
    NSLog(@"Request:%@%@", BaseURL, GETACCESSTOKENURL);
    NSLog(@"Params:%@", requestDictionary);
    [[RKObjectManager sharedManager] postObject:[[EGToken alloc] init]
                                           path:GETACCESSTOKENURL
                                     parameters:requestDictionary
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            if ([mappingResult firstObject]) {
                                                EGToken *token = [mappingResult firstObject];
                                                [[AppRepo sharedRepo] saveTokenData:token];
                                                [self initiateAPICallsInQueue];
                                            }
                                            
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        self.isRenewing = false;
        [self.queueDictionary removeAllObjects];
        [UtilityMethods showAlertMessageOnWindowWithMessage:@"Session Expired" handler:^(UIAlertAction *action) {
            [[AppRepo sharedRepo] logoutUser];
        }];
        
        if(nil != postHelper.failureBlock) {
            postHelper.failureBlock(operation, error);
        }
    }];
}

- (void)initiateAPICallsInQueue {
    
    for (NSString *keys in [self.queueDictionary allKeys]) {
        PostHelper *postHelperObj = [self.queueDictionary objectForKey:keys];
        if (postHelperObj.postRequestType == PostRequestTypeMapped) {
            [self makeMappedPostAPICall:postHelperObj];
        }
        else if (postHelperObj.postRequestType == PostRequestTypeUnMapped) {
            [self makeUnMappedPostAPICall:postHelperObj];
        }
    }
}

- (void)makeMappedPostAPICall:(PostHelper *)postHelper {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[EGRKWebserviceRepository sharedRepository] setAccessToken:objectManager];
    [objectManager postObject:postHelper.object
                         path:postHelper.path
                   parameters:postHelper.parameters
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if(nil!=postHelper.successBlock) {
                              postHelper.successBlock(operation, mappingResult);
                          }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        postHelper.failureBlock(operation, error);
    }];
}

- (void)makeUnMappedPostAPICall:(PostHelper *)postHelper {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[EGRKWebserviceRepository sharedRepository] setAccessToken:objectManager];
    [objectManager.HTTPClient postPath:postHelper.path
                            parameters:postHelper.parameters
                               success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
                                   postHelper.afSuccessBlock(operation, responseObject);
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        postHelper.afFailureBlock(operation, error);
    }];
}

- (void)makeApiCall:(PostHelper*)postHelper{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[EGRKWebserviceRepository sharedRepository] setAccessToken:objectManager];
    [[EGRKWebserviceRepository sharedRepository] getMyInfluencerAPI:postHelper.parameters andSucessAction:^(AFRKHTTPRequestOperation *op, id responseObject) {
        if(nil!=postHelper.afSuccessBlock) {
            postHelper.afSuccessBlock(op, responseObject);
        }
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        postHelper.afFailureBlock(operation, error);
    }];
}
@end
