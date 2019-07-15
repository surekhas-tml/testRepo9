//
//  UIViewController+PostGoogleAnalytics.m
//  e-Guru
//
//  Created by Juili on 10/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UIViewController+PostGoogleAnalytics.h"

@implementation UIViewController (PostGoogleAnalytics)

+ (void)load {
//    Class class = [self class];
//    
//    //View did Load
//    SEL originalSelectorForDidLoad = @selector(viewDidLoad);
//    SEL replacementSelectorForDidLoad = @selector(postGoogleAnalytics_viewDidLoad);
//    Method originalMethodForDidLoad = class_getInstanceMethod(class, originalSelectorForDidLoad);
//    Method replacementMethodForDidLoad = class_getInstanceMethod(class, replacementSelectorForDidLoad);
//    method_exchangeImplementations(originalMethodForDidLoad, replacementMethodForDidLoad);
//    
//    //View did disappear
//    SEL originalSelectorWillDisappear = @selector(viewDidDisappear:);
//    SEL replacementSelectorWillDisappear = @selector(postGoogleAnalytics_viewDidDisappear:);
//    Method originalMethodWillDisappear = class_getInstanceMethod(class, originalSelectorWillDisappear);
//    Method replacementMethodWillDisappear = class_getInstanceMethod(class, replacementSelectorWillDisappear);
//    method_exchangeImplementations(originalMethodWillDisappear, replacementMethodWillDisappear);
//    
//    //view did appear
//    SEL originalSelectorDidAppear = @selector(viewDidAppear:);
//    SEL replacementSelectorDidAppear = @selector(postGoogleAnalytics_viewDidAppear:);
//    Method originalMethodDidAppear = class_getInstanceMethod(class, originalSelectorDidAppear);
//    Method replacementMethodDidAppear = class_getInstanceMethod(class, replacementSelectorDidAppear);
//    method_exchangeImplementations(originalMethodDidAppear, replacementMethodDidAppear);

}


-(void)postGoogleAnalytics_viewDidLoad{
//    if (![self isKindOfClass:[UINavigationController class]]) {
//        [self trackGoogleAnalytics];
//    }
//    [self postGoogleAnalytics_viewDidLoad];

}
-(void)postGoogleAnalytics_viewDidAppear:(BOOL)animated{
//    
//    if (![self isKindOfClass:[UINavigationController class]]) {
//        [self trackGoogleAnalytics];
//    }
//    [self postGoogleAnalytics_viewDidAppear:animated];
//    
}
-(void)postGoogleAnalytics_viewDidDisappear:(BOOL)animated{
//    if (![self isKindOfClass:[UINavigationController class]]) {
//        [self trackGoogleAnalytics];
//    }    [self postGoogleAnalytics_viewDidDisappear:animated];
}

-(void)trackGoogleAnalytics{
//    //-------------GoogleAnalytics---------------
//
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    NSString * Position;
//    if(![self isKindOfClass:[UINavigationController class]]){
//        Position = [NSString stringWithFormat:@"%@ - %@",self.navigationController.title.length > 0 ? self.navigationController.title : NSStringFromClass([self class]) ,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPosition"]];
//    }else{
//    Position = [NSString stringWithFormat:@"%@ - %@",NSStringFromClass([self class]),[[NSUserDefaults standardUserDefaults] objectForKey:@"userPosition"]];
//
//    }
//    [tracker set:kGAIScreenName value:Position];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//    [tracker set:kGAIScreenName value:nil];
//    //-------------GoogleAnalytics---------------

}
@end
