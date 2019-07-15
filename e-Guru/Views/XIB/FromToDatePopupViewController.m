//
//  FromToDatePopupViewController.m
//  e-guru
//
//  Created by MI iMac04 on 18/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "FromToDatePopupViewController.h"
#import "NSString+NSStringCategory.h"
#import "UtilityMethods.h"
#import "PureLayout.h"

#define PICKER_HEIGHT   300
#define ANIMATION_TIME  0.3

@interface FromToDatePopupViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomEdgeConstratint;
@property (nonatomic, strong) UIView *tappedView;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation FromToDatePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapGestureToFromDateView];
    [self addTapGestureToToDateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapGestureToFromDateView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture addTarget:self action:@selector(fromDateViewTapped:)];
    [self.fromDateView addGestureRecognizer:tapGesture];
}

- (void)addTapGestureToToDateView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture addTarget:self action:@selector(toDateViewTapped:)];
    [self.toDateView addGestureRecognizer:tapGesture];
}

#pragma mark - Private Methods

- (void)showDatePopupfromViewController:(id)controller {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController addChildViewController:self];
    self.view.frame = topRootViewController.view.frame;
    [topRootViewController.view addSubview:self.view];
    [self didMoveToParentViewController:topRootViewController];
    
    if (self.currentfromDateString && self.currentToDateString) {
        [self.fromDateTextField setText:self.currentfromDateString];
        [self.toDateTextField setText:self.currentToDateString];
    }
}

- (BOOL)fieldsValid {
    BOOL valid = true;
    
    if (![self.fromDateTextField.text hasValue]) {
        valid = false;
        [self showAlertWithMessage:@"Please select from date"];
    }
    else if (![self.toDateTextField.text hasValue]) {
        valid = false;
        [self showAlertWithMessage:@"Please select to date"];
    }
    return valid;
}

- (void)showAlertWithMessage:(NSString *)message {
    [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
        
    }];
}

- (BOOL)isDatePickerVisible {
    if ([self.datePicker isDescendantOfView:self.view]) {
        return true;
    }
    return false;
}

- (void)showDatePickerWithSelectedDate:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate andCancelButtonHidden:(BOOL)hideCancelButton {
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.datePicker];
    self.pickerBottomEdgeConstratint = [self.datePicker autoPinEdge:ALEdgeBottom
                                                     toEdge:ALEdgeBottom
                                                     ofView:self.view
                                                 withOffset:PICKER_HEIGHT];
    [self.datePicker autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.datePicker autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    // Set selcted date
    if (selectedDate) {
        self.datePicker.date = selectedDate;
    }
    // Set minimum date
    if (minDate) {
        self.datePicker.minimumDate = minDate;
    }
    // Set maximum date
    if (maxDate) {
        self.datePicker.maximumDate = maxDate;
    }
    
    // Toolbar
    self.toolbar = [[UIToolbar alloc] initForAutoLayout];
    [self.toolbar setBarTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(datePickerCancelButtonTapped)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:self
                                                                                   action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(datePickerDoneButtonTapped)];
    [doneButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 16;
    
    
    if (hideCancelButton) {
        [self.toolbar setItems:@[flexibleSpace, doneButton]];
    }
    else {
        [self.toolbar setItems:@[space, cancelButton, flexibleSpace, doneButton, space]];
    }

    [self.view addSubview:self.toolbar];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.toolbar autoPinEdge:ALEdgeBottom
                  toEdge:ALEdgeTop
                  ofView:self.datePicker];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:ANIMATION_TIME
                     animations: ^{
                         self.pickerBottomEdgeConstratint.constant = 0;
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - IBActions

- (IBAction)cancelButtonTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)searchButtonTapped:(id)sender {
    if ([self fieldsValid]) {
        if ([self.delegate respondsToSelector:@selector(searchButtonClickedWithToDate:andFromDate:)]) {
            [self.delegate searchButtonClickedWithToDate:self.toDateTextField.text andFromDate:self.fromDateTextField.text];
            [self.view removeFromSuperview];
        }
    }
}

- (void)fromDateViewTapped:(UIGestureRecognizer *)gesture {
    
    if ([self isDatePickerVisible]) {
        return;
    }
    
    self.tappedView = self.fromDateView;
    
    NSDate *selectedDate;
    if ([self.fromDateTextField.text hasValue]) {
        selectedDate = [NSDate getNSDateFromString:self.fromDateTextField.text havingFormat:dateFormatddMMyyyy];
    }
    [self showDatePickerWithSelectedDate:selectedDate minDate:nil maxDate:nil andCancelButtonHidden:false];
}

- (void)toDateViewTapped:(UIGestureRecognizer *)gesture {
    
    if ([self isDatePickerVisible]) {
        return;
    }
    
    if ([self.fromDateTextField.text hasValue]) {
        
        NSDate *selectedDate;
        if ([self.toDateTextField.text hasValue]) {
            selectedDate = [NSDate getNSDateFromString:self.toDateTextField.text havingFormat:dateFormatddMMyyyy];
        }
        [self showDatePickerWithSelectedDate:selectedDate
                                     minDate:[NSDate getNSDateFromString:self.fromDateTextField.text havingFormat:dateFormatddMMyyyy]
                                     maxDate:nil
                       andCancelButtonHidden:false];
    }
    else {
        [self showAlertWithMessage:@"Please select from date"];
    }
    
    self.tappedView = self.toDateView;
}

- (void)datePickerCancelButtonTapped {
    
    [UIView animateWithDuration:ANIMATION_TIME
                     animations: ^{
                         self.pickerBottomEdgeConstratint.constant = PICKER_HEIGHT;
                         [self.view layoutIfNeeded];
                     }
                     completion: ^(BOOL finished) {
                         [self.datePicker removeFromSuperview];
                         [self.toolbar removeFromSuperview];
                     }];
}

- (void)datePickerDoneButtonTapped {
    [self datePickerCancelButtonTapped];
    if (self.tappedView == self.fromDateView) {
        [self.fromDateTextField setText:[NSDate getDate:self.datePicker.date InFormat:dateFormatddMMyyyy]];
        [self.toDateTextField setText:@""];
    }
    else if (self.tappedView == self.toDateView) {
        [self.toDateTextField setText:[NSDate getDate:self.datePicker.date InFormat:dateFormatddMMyyyy]];
    }
}

@end
