//
//  NSString+NSStringCategory.h
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STR_DISPLAYABLE_VALUE(X)	(nil == X)?@"":X


@interface NSString (NSStringCategory)

- (BOOL) hasValue;
- (BOOL) isCaseInsesitiveEqualTo:(NSString *)inputString;
- (NSString *)encodeAmpersandInString;
- (NSString *)decodeToAmpersand;
- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)characterSet;

@end
