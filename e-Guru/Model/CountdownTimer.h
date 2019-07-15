//
//  CountdownTimer.h
//  e-guru
//
//  Created by Admin on 08/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@protocol CountdownTimerDelegate;

@interface CountdownTimer : NSObject


//@property (assign) id <CountdownTimerDelegate> delegate;
- (void)startCountdownTimerFordemo:(NSString *)startDate andEndDate:(NSString *)endDate withUpdatingLable:(UILabel *)label;
 
//@end

//@protocol CountdownTimerDelegate <NSObject>
//- (void)countdownTimer:(CountdownTimer *)ct didFinishTimerFordemo:(NSNumber *)demoId;


@end


