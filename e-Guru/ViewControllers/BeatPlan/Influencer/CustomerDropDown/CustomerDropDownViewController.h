//
//  CustomerDropDownViewController.h
//  e-guru
//
//  Created by Apple on 07/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTextField.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CustomerPopUpCloseDelegate <NSObject>
- (void)onBackButtonClicked;
- (void)onAddButtonClicked;
@end

@interface CustomerDropDownViewController : UIViewController
@property (nonatomic, weak) id <CustomerPopUpCloseDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldContactName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldAccountName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldChannelType;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldApplication;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMobileNumber;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldDistrict;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldCity;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldMMGeo;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldDSE;
@property (weak, nonatomic) IBOutlet DropDownTextField *txtFieldLOB;
@property (copy, nonatomic) NSString *selectedChannelType;
@property (copy, nonatomic) NSString *selectedDSE;
@property (copy, nonatomic) NSString *popUpTitle;
@property (copy, nonatomic) NSString *selectedCustomerID;
@property (copy, nonatomic) NSDictionary *selectedCustomerDict;
@property (nonatomic, assign) BOOL isInputedValues;

- (IBAction)btnCloseClicked:(id)sender;
- (IBAction)btnAddClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END

