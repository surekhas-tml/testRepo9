//
//  FromToDatePopupViewController.h
//  e-guru
//
//  Created by MI iMac04 on 18/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+eGuruDate.h"

@protocol FromToDatePopupViewControllerDelegate <NSObject>

- (void)searchButtonClickedWithToDate:(NSString *)toDate andFromDate:(NSString *)fromDate;

@end

@interface FromToDatePopupViewController : UIViewController

@property (weak, nonatomic) id<FromToDatePopupViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *fromDateView;
@property (weak, nonatomic) IBOutlet UIView *toDateView;
@property (weak, nonatomic) IBOutlet UITextField *fromDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *toDateTextField;
@property (weak, nonatomic) IBOutlet NSString *currentfromDateString;
@property (weak, nonatomic) IBOutlet NSString *currentToDateString;

- (void)showDatePopupfromViewController:(id)controller;

@end
