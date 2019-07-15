//
//  UtilityMethods+UtilityMethodsValidations.h
//  e-Guru
//
//  Created by Juili on 22/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UtilityMethods.h"

@interface UtilityMethods (UtilityMethodsValidations)

+(NSString *)serviceInputConversionFor:(NSString *)inputString;
+(BOOL)validateMobileNumber:(NSString *)number;
+(BOOL)validateMobileNumberNew:(NSString *)number;
+(BOOL)validatePanNumber:(NSString *)panNumber;
+(BOOL)validateEmail:(NSString *)email;
+(BOOL)validatePincode:(NSString *)pincode;
+(BOOL)isCharacterSetOnlyNumber:(NSString *)string;
+ (BOOL)isCharacterSetOnlyAlphaNumeric:(NSString *)string;
+(BOOL) isAllDigits:(NSString *)string;
+ (NSString *)getErrorForInValidatePANOrPhoneNumber:(NSString *)inputString;

+(BOOL)validateOnRoadPrice:(NSString *)number;

@end
