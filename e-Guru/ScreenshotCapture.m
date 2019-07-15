//
//  ScreenshotCapture.m
//  e-guru
//
//  Created by Admin on 19/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "ScreenshotCapture.h"

@implementation ScreenshotCapture

static ScreenshotCapture * _sharedSetup = nil;

+(ScreenshotCapture *)sharedSetup{
    
    @synchronized([ScreenshotCapture class])
    {
        if (!_sharedSetup)
            _sharedSetup=[[self alloc] init];
        
        return _sharedSetup;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([ScreenshotCapture class])
    {
        NSAssert(_sharedSetup == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedSetup = [super alloc];
        return _sharedSetup;
    }
    
    return nil;
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

+ (void) takeScreenshotOfView:(UIView *) view{
    
    CGSize size = CGSizeMake(view.frame.size.width, view.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rec = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [ScreenshotCapture sharedSetup].issueReportScreenshortImageData = imageData;
    
    if (imageData) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
        
        [imageData writeToFile:savedImagePath atomically:YES];
    } else {
        NSLog(@"error while taking screenshot");
    }
}

@end
