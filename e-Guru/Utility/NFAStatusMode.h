//
//  NFAStatusMode.h
//  e-guru
//
//  Created by Juili on 22/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface NFAStatusMode : NSObject
@property int status;
@property NFAStatusValue *nfaStatusValue;

+(NSString *)toString:(NFAStatusValue)modeString;
+(int)fromString:(NSString*)stringValue;
+ (NSMutableArray *) getLisOfEnum;
+(NSDictionary *)map;
@end
