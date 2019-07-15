//
//  AsyncLocationManager.h
//  e-guru
//
//  Created by Admin on 10/07/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncLocationManager : NSObject

+ (id)sharedInstance;

- (void)startAsyncLocationFetch;
- (void)stopAsyncLocationFetch;

@end
