//
//  UtilityMethods+UtilityMethodsValidations.m
//  e-Guru
//
//  Created by Juili on 22/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UtilityMethods+UtilityMethodsValidations.h"

@implementation UtilityMethods (UtilityMethodsValidations)

+(NSString *)serviceInputConversionFor:(NSString *)inputString{
    
    return inputString.length > 0 ? inputString : @"";
}


+(BOOL)validateMobileNumber:(NSString*)number{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    return [predicate evaluateWithObject:number] ? TRUE : FALSE;
}

+(BOOL)validateMobileNumberNew:(NSString*)number{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPatternNew];
    return [predicate evaluateWithObject:number] ? TRUE : FALSE;
}

+(BOOL)validatePanNumber:(NSString *)panNumber{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panCardRegex];
    return [predicate evaluateWithObject:panNumber] ? TRUE : FALSE;
}

+(BOOL)validateEmail:(NSString *)email{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [predicate evaluateWithObject:email] ? TRUE : FALSE;
}

+(BOOL)validatePincode:(NSString *)pincode{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pincodeRegx];
    return [predicate evaluateWithObject:pincode] ? TRUE : FALSE;
    
}
+(BOOL)isCharacterSetOnlyNumber:(NSString *)string{
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}

+ (BOOL)isCharacterSetOnlyAlphaNumeric:(NSString *)string {
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}

+(BOOL) isAllDigits:(NSString *)string
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [string rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && string.length > 0;
}

+(BOOL)validateOnRoadPrice:(NSString*)number{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", onRoadPricePattern];
    return [predicate evaluateWithObject:number] ? TRUE : FALSE;
}

#pragma mark - Miscellaneous

+ (NSString *)getErrorForInValidatePANOrPhoneNumber:(NSString *)inputString {
    
    if ([self isAllDigits:inputString]) {
        if ([self validateMobileNumber:inputString]) {
            return nil;
        }
        else {
            return @"Please enter valid Phone Number";
        }
    }
    else {
        if ([self validatePanNumber:inputString]) {
            return nil;
        }
        else {
            return @"Please enter valid Pan Number";
        }
    }
}

@end
