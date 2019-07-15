//
//  NSString+NSStringCategory.m
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "NSString+NSStringCategory.h"

@implementation NSString (NSStringCategory)

- (BOOL)hasValue {
    if (self && ![self isKindOfClass:[NSNull class]]) {
        NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                                              [NSCharacterSet whitespaceCharacterSet]];
        if(![trimmedString isEqualToString:@""]) {
            return true;
        }
    }
    return false;
}

- (BOOL)isCaseInsesitiveEqualTo:(NSString *)inputString {
    return ([self caseInsensitiveCompare:inputString] == NSOrderedSame);
}

- (NSString *)encodeAmpersandInString {
    return [self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
}

- (NSString *)decodeToAmpersand {
    return [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger i = self.length;
    while (i > 0 && [characterSet characterIsMember:[self characterAtIndex:i - 1]]) {
        i--;
    }
    return [self substringToIndex:i];
}

- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger i = 0;
    while (i < self.length && [characterSet characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}


@end
