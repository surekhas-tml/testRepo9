//
//  RootDetector.m
//  e-Guru
//
//  Created by Rajkishan on 04/01/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "RootDetector.h"
#import <UIKit/UIKit.h>

@implementation RootDetector

static inline int suspicious_files_count(void) __attribute__((always_inline));
int suspicious_files_count()
{
    int result = 0;
    
    const char *fname = [[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Cyd", @"ia.", @"app"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    fname = [[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    fname = [[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/a", @"pt/"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    fname = [[NSString stringWithFormat:@"/%@%@%@%@%@%@%@%@%@%@%@%@%@", @"Libr",@"ary/M",@"ob"@"ileSu",@"bst",@"rat",@"e/",@"Mo",@"bil",@"eSu",@"bst",@"rat",@"e.d",@"ylib"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    fname = [[NSString stringWithFormat:@"/%@%@%@",@"bi",@"n/b",@"ash"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    fname = [[NSString stringWithFormat:@"/%@%@%@",@"et",@"c/a",@"pt"] cStringUsingEncoding:NSASCIIStringEncoding];
    result += (file_exist(fname));
    
    return result;
}

static inline bool cydia_app_exist(void) __attribute__((always_inline));
bool cydia_app_exist()
{
    // if hacker has moved cydia to some other location than expected, try to invoke cydia app
    return ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",@"cy",@"dia",@":",@"//"]]]);
}

static inline int sandbox_broken(void) __attribute__((always_inline));
int sandbox_broken()
{
    int result = fork();
    if (!result)
        exit(0);
    if (result >= 0) return 1;
    return 0;
}

+(BOOL) isRooted
{
    
#if !TARGET_IPHONE_SIMULATOR
    
    BOOL is_detected =      (suspicious_files_count() > 0)
                        ||  (cydia_app_exist())
                        ||  (sandbox_broken()) ;
    
    return is_detected;
    
#endif
    
    return NO;
}

static inline int file_exist(const char *) __attribute__((always_inline));
int file_exist(const char *fname)
{
    if( access( fname, F_OK ) != -1 )
    {
        //file exist
        return 1;
    }
    else
    {
        //file does not exist
        return 0;
    }
}

@end
