//
//  FFCalendarViewController.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 12/02/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>

@protocol FFCalendarViewControllerProtocol <NSObject>
@required
- (void)arrayUpdatedWithAllEvents:(NSMutableArray *)arrayUpdated;
@end

@interface ExclusionViewController : UIViewController
{
    UIButton *button_AddLeave;
    UIButton *button_CancelLeave;

}
@property (nonatomic, strong) id <FFCalendarViewControllerProtocol> protocol;
@property (weak, nonatomic) IBOutlet UIButton *button_AddLeavePopup;

- (IBAction)showAddLeavePopUp:(UIButton *)sender;
- (IBAction)showAddLeavePopUp:(NSIndexPath*)sender forEventList:(BOOL)showEventList;

@end
