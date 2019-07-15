//
//  Token.h
//  e-guru
//
//  Created by MI iMac04 on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGToken : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *expiresIn;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *scope;

@end
