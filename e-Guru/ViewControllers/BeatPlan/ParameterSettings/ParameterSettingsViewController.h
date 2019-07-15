//
//  ParameterSettingsViewController.h
//  e-guru
//
//  Created by Apple on 15/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGParameterSettingViewModel.h"
#import "NSDate+eGuruDate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParameterSettingsViewController : UIViewController<UITextFieldDelegate>
{
    UIDatePicker *fromDatePickerActivity;
    UITextField *activeField;


}
@property(nonatomic,copy)  EGParameterSettingViewModel * parameterSettingsViewModel;
@property (nonatomic, strong) UIDatePicker *tappedView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIView *view_meetingFrequency;
@property (weak, nonatomic) IBOutlet UIView *view_channelPriorityBackground;

@end

NS_ASSUME_NONNULL_END
