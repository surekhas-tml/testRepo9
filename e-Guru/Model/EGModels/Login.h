//
//  Login.h
//  e-guru
//
//  Created by MI iMac04 on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGToken.h"
#import "EGUserData.h"

@interface Login : NSObject

@property (nonatomic, strong) EGToken *token;
@property (nonatomic, strong) NSMutableArray *usersArray;

@end
