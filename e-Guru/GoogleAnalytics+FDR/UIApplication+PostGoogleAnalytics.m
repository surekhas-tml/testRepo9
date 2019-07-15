//
//  UIApplication+PostGoogleAnalytics.m
//  e-Guru
//
//  Created by Juili on 11/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UIApplication+PostGoogleAnalytics.h"

@implementation UIApplication (PostGoogleAnalytics)

+ (void)load {
//    Class class = [self class];
//    SEL originalSelectorForAction = @selector(sendAction:to:from:forEvent:);
//    SEL replacementSelectorForAction = @selector(postGoogleAnalytics_sendAction:to:from:forEvent:);
//    Method originalMethodForAction = class_getInstanceMethod(class, originalSelectorForAction);
//    Method replacementMethodForAction = class_getInstanceMethod(class, replacementSelectorForAction);
//    method_exchangeImplementations(originalMethodForAction, replacementMethodForAction);
//    
//    SEL originalSelectorEvent = @selector(sendEvent:);
//    SEL replacementSelectorEvent = @selector(postGoogleAnalytics_sendEvent:);
//    Method originalMethodEvent = class_getInstanceMethod(class, originalSelectorEvent);
//    Method replacementMethodEvent = class_getInstanceMethod(class, replacementSelectorEvent);
//    method_exchangeImplementations(originalMethodEvent, replacementMethodEvent);
    
}

- (BOOL)postGoogleAnalytics_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    //-------------GoogleAnalytics---------------

//    UIEvent *eventObj = event;
//    NSSet* allTouches = [eventObj allTouches];
//    UITouch* touch = [allTouches anyObject];
//    UIView* touchView = [touch view];
//    
//    
//    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    NSString * Position = [NSString stringWithFormat:@"USER %@ : With Possition - %@ OnView : %@ ",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPosition"],NSStringFromClass([touchView class])];
//    [tracker set:kGAIScreenName value:Position];
//
//    if ([touchView isKindOfClass:[UIButton class]]) {
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Method Call"
//                                                              action:NSStringFromSelector(action)== nil ? @"":NSStringFromSelector(action)
//                                                               label:((UIButton *)touchView).titleLabel.text
//                                                               value:nil] build]];
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
//                                                              action:@"touch"
//                                                               label:((UIButton *)touchView).titleLabel.text
//                                                               value:nil] build]];
//    }
//    else{
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Method Call"
//                                                              action:NSStringFromSelector(action)== nil ? @"":NSStringFromSelector(action)
//                                                               label:NSStringFromClass([sender class])
//                                                               value:nil] build]];
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
//                                                              action:@"touch"
//                                                               label:NSStringFromClass([sender class])
//                                                               value:nil] build]];
//    }
//    [tracker set:kGAIScreenName value:nil];
//    //-------------GoogleAnalytics---------------
//
//    
//    return [self postGoogleAnalytics_sendAction:action to:target from:sender forEvent:event];
    
    return false;
}

- (void)postGoogleAnalytics_sendEvent:(UIEvent *)event{
    //-------------GoogleAnalytics---------------
//    UIEvent *eventObj = event;
//    NSSet* allTouches = [eventObj allTouches];
//    UITouch* touch = [allTouches anyObject];
//    UIView* touchView = [touch view];
//
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    NSString * Position = [NSString stringWithFormat:@"USER %@ : With Possition - %@ OnView : %@ ",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPosition"],NSStringFromClass([touchView class])];
//    [tracker set:kGAIScreenName value:Position];
//    if ([touchView isKindOfClass:[UIButton class]]) {
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
//                                                          action:@"touch"
//                                                           label:@""//((UIButton *)touchView).titleLabel.text
//                                                           value:nil] build]];
//    }else{
//        
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
//                                                              action:@"touch"
//                                                               label:NSStringFromClass([touchView class])
//                                                               value:nil] build]];
//    }
//    [tracker set:kGAIScreenName value:nil];
//    //-------------GoogleAnalytics---------------
//
//    
//    [self postGoogleAnalytics_sendEvent:event];
}
@end
