//
//  EGRestKitSetupManager.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGRestKitSetupManager.h"

static EGRestKitSetupManager * _sharedSetup = nil;
@implementation EGRestKitSetupManager

+(EGRestKitSetupManager *)sharedSetup{
    @synchronized([EGRestKitSetupManager class])
    {
        if (!_sharedSetup)
            _sharedSetup=[[self alloc] init];
        
        return _sharedSetup;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([EGRestKitSetupManager class])
    {
        NSAssert(_sharedSetup == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedSetup = [super alloc];
        return _sharedSetup;
    }
    
    return nil;
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        [self configureRestKit];
    }
    
    return self;
}


//When `defaultSSLPinningMode` is defined on `AFHTTPClient` and the Security framework is linked, connections will be validated on all matching certificates with a `.cer` extension in the bundle root.

-(void)configureRestKit
{
    // initialize Base URL
    NSURL *baseURL = [NSURL URLWithString:BaseURL];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc]initWithHTTPClient:[[AFRKHTTPClient alloc] initWithBaseURL:baseURL]];
    [objectManager setRequestSerializationMIMEType:@"application/json"];
    [objectManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [objectManager.HTTPClient setParameterEncoding:AFRKJSONParameterEncoding];
#if SSL
    objectManager.HTTPClient.allowsInvalidSSLCertificate = NO;
    objectManager.HTTPClient.defaultSSLPinningMode = AFRKSSLPinningModeCertificate;
#else
    objectManager.HTTPClient.allowsInvalidSSLCertificate = YES;
#endif
    [RKObjectManager setSharedManager:objectManager];
}


// Move to new Class
@end
