//
//  ScreenshotCapture.h
//  e-guru
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenshotCapture : NSObject

@property (nonatomic, strong) NSData *_Nullable issueReportScreenshortImageData;

+(void) takeScreenshotOfView:(UIView * _Nullable) view;

+(ScreenshotCapture *)sharedSetup;
@end
