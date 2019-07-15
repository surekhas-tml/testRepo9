//
//  AccessTokenManager.h
//  e-guru
//
//  Created by MI iMac04 on 09/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHelper.h"
#import "Constant.h"

@interface AccessTokenManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *queueDictionary;
@property (nonatomic, assign) BOOL isRenewing;

+ (instancetype)sharedManager;
- (void)renewAccessToken:(PostHelper *)post;

@end
