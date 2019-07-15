//
//  DealerAndCustomerDetails.m
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "DealerAndCustomerDetailsView.h"
#import "DropDownViewController.h"
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#define DEAL_TYPE_GROUP @"Group"

@implementation DealerAndCustomerDetailsView{
    AppDelegate *appDelegate;
    NSMutableArray *mStatesArray;
    NSMutableArray *mDealsArray;
}

- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"DealerAndCustomerDetailsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    [self addGestureToDropDownFields];
    self.sectionType = NFASectionDealerAndCustomerDetails;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NFADealerAndCustomerDetails *)nfaDealerAndCustomerDetails {
    if (!_nfaDealerAndCustomerDetails) {
        _nfaDealerAndCustomerDetails = [[NFADealerAndCustomerDetails alloc] init];
    }
    return _nfaDealerAndCustomerDetails;
}

- (DropDownTextField *)vehicleRegistrationStateDropDownTextField {
    if (!_vehicleRegistrationStateTextField.field) {
        _vehicleRegistrationStateTextField.field = [[Field alloc] init];
    }
    return _vehicleRegistrationStateTextField;
}

- (DropDownTextField *)dealTypeDropDownTextField {
    if (!_dealTypeTextField.field) {
        _dealTypeTextField.field = [[Field alloc] init];
    }
    return _dealTypeTextField;
}

#pragma mark - Private Methods

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaModel = model;
    self.nfaDealerAndCustomerDetails = self.nfaModel.nfaDealerAndCustomerDetails;
    [self bindDataToFieldsFromModel:self.nfaDealerAndCustomerDetails];
    
    switch (mode) {
        case NFAModeCreate:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeUpdate:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeDisplay:
            [self setUserInteractionEnabled:false];
            break;
    }
    
    // To prevent red border on remark field
    // in display mode
    if (mode != NFAModeDisplay) {
        [self adjustUIBasedOnVehicleRegistrationState];
        [self adjustUIBasedOnDealType];
    }
}

// This method marks the mandatory fields as red
- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.opportunityIDTextField];
    [UtilityMethods setRedBoxBorder:self.dealerCodeTextField];
    [UtilityMethods setRedBoxBorder:self.dealerNameTextField];
    [UtilityMethods setRedBoxBorder:self.mmIntendedApplicationTextField];
    [UtilityMethods setRedBoxBorder:self.customerNameTextField];
    [UtilityMethods setRedBoxBorder:self.vehicleRegistrationStateTextField];
    if ([self.accountNameTextField.text hasValue]) {
        [UtilityMethods setRedBoxBorder:self.accountNameTextField];
    }
    else if ([self.contactTextField.text hasValue]) {
        [UtilityMethods setRedBoxBorder:self.contactTextField];
    }
}

// This method binds the data from the model
// to all the fields in this view
- (void)bindDataToFieldsFromModel:(NFADealerAndCustomerDetails *)dealerAndCustomerDetails {
    if (!dealerAndCustomerDetails) {
        return;
    }
    [self.opportunityIDTextField setText:dealerAndCustomerDetails.oppotunityID];
    [self.dealerCodeTextField setText:dealerAndCustomerDetails.dealerCode];
    [self.dealerNameTextField setText:dealerAndCustomerDetails.dealerName];
    [self.mmIntendedApplicationTextField setText:dealerAndCustomerDetails.mmIntendedApplication];
    [self.customerNameTextField setText:dealerAndCustomerDetails.customerName];
    [self.accountNameTextField setText:dealerAndCustomerDetails.accountName];
    [self.additionalCustomersTextField setText:dealerAndCustomerDetails.additionalCustomers];
    [self.vehicleRegistrationStateTextField setText:dealerAndCustomerDetails.vehicleRegistrationState];
    [self.remarkTextField setText:dealerAndCustomerDetails.remark];
    [self.contactTextField setText:dealerAndCustomerDetails.customerNumber];
    [self.commentsTextField setText:dealerAndCustomerDetails.customerComments];
    [self.tmlFleetSizeTextField setText:dealerAndCustomerDetails.tmlFleetSize];
    [self.overallFleetSizeTextField setText:dealerAndCustomerDetails.overAllFleetSize];
    [self.dealTypeTextField setText:dealerAndCustomerDetails.dealType];
    [self.locationTextField setText:dealerAndCustomerDetails.location];
    
    self.nfaDealerAndCustomerDetails = dealerAndCustomerDetails;
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.opportunityIDTextField.text hasValue] &&
        [self.dealerCodeTextField.text hasValue] &&
        [self.dealerNameTextField.text hasValue] &&
        [self.mmIntendedApplicationTextField.text hasValue] &&
        [self.customerNameTextField.text hasValue] &&
        [self.vehicleRegistrationStateTextField.text hasValue]) {
        
        if ([self.dealTypeTextField.text hasValue] && [self.dealTypeTextField.text isEqualToString:DEAL_TYPE_GROUP]) {
            
            if ([self.additionalCustomersTextField.text hasValue]) {
                mandatoryFieldsFilled = true;
            }
            else {
                mandatoryFieldsFilled = false;
            }
        }
        else if([self.vehicleRegistrationStateTextField.text hasValue] && ![self.vehicleRegistrationStateTextField.text isEqualToString:self.nfaModel.dealerState]) {
            
            if ([self.remarkTextField.text hasValue]) {
                mandatoryFieldsFilled = true;
            }
            else {
                mandatoryFieldsFilled = false;
            }
        }
        else {
            mandatoryFieldsFilled = true;
        }
    }
    
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

#pragma mark - IBAction

- (IBAction)declarationClicked:(id)sender {
    UIButton *checkbox = (UIButton *)sender;
    [checkbox setSelected:![checkbox isSelected]];
}


#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.opportunityIDTextField) {
        self.nfaDealerAndCustomerDetails.oppotunityID = self.opportunityIDTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.dealerCodeTextField) {
        self.nfaDealerAndCustomerDetails.dealerCode = self.dealerCodeTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.dealerNameTextField) {
        self.nfaDealerAndCustomerDetails.dealerName = self.dealerNameTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.accountNameTextField) {
        self.nfaDealerAndCustomerDetails.accountName = self.accountNameTextField.text;
    }
    else if (textField == self.locationTextField) {
        self.nfaDealerAndCustomerDetails.location = self.locationTextField.text;
    }
    else if (textField == self.mmIntendedApplicationTextField) {
        self.nfaDealerAndCustomerDetails.mmIntendedApplication = self.mmIntendedApplicationTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.tmlFleetSizeTextField) {
        self.nfaDealerAndCustomerDetails.tmlFleetSize = self.tmlFleetSizeTextField.text;
    }
    else if (textField == self.overallFleetSizeTextField) {
        self.nfaDealerAndCustomerDetails.overAllFleetSize = self.overallFleetSizeTextField.text;
    }
    else if (textField == self.customerNameTextField) {
        self.nfaDealerAndCustomerDetails.customerName = self.customerNameTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.additionalCustomersTextField) {
        self.nfaDealerAndCustomerDetails.additionalCustomers = self.additionalCustomersTextField.text;
        if ([self.dealTypeTextField.text hasValue] && [self.dealTypeTextField.text isEqualToString:@"Group"]) {
            [self checkIfMandatoryFieldsAreFilled];
        }
    }
    else if (textField == self.commentsTextField) {
        self.nfaDealerAndCustomerDetails.customerComments = self.commentsTextField.text;
    }
    else if (textField == self.contactTextField) {
        self.nfaDealerAndCustomerDetails.customerNumber = self.contactTextField.text;
    }
    else if (textField == self.remarkTextField) {
        self.nfaDealerAndCustomerDetails.remark = self.remarkTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (self.additionalCustomersTextField == textField) {
        if (length > 800)
            return NO;
        return YES;
        
    }else if (self.commentsTextField == textField) {
        if (length > 800)
            return NO;
        return YES;
        
    }
    else if (self.remarkTextField == textField) {
        if (length > 100)
            return NO;
        return YES;
        
    }
    return true;
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.vehicleRegistrationStateTextField superview] addGestureRecognizer:tapGesture];
    [[self.dealTypeTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            DropDownTextField *textField = (DropDownTextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                
                if (textField == self.vehicleRegistrationStateTextField) {
                    [self fetchAllStates:textField];
                }
                else if (textField == self.dealTypeTextField) {
                    [self fetchAllDealTypes:textField];
                }
            }
        }
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {

    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)resetFields {
    [self.dealTypeTextField setText:@""];
    [self.additionalCustomersTextField setText:@""];
    [self.commentsTextField setText:@""];
    [self.vehicleRegistrationStateTextField setText:@""];
    [self.remarkTextField setText:@""];
    
    [UtilityMethods setGreyBoxBorder:self.additionalCustomersTextField];
    [UtilityMethods setRedBoxBorder:self.remarkTextField];
    [self.declarationLabel setHidden:true];
    [self.checkBoxButton setHidden:true];
    
    self.nfaDealerAndCustomerDetails.dealType = @"";
    self.nfaDealerAndCustomerDetails.additionalCustomers = @"";
    self.nfaDealerAndCustomerDetails.customerComments = @"";
    self.nfaDealerAndCustomerDetails.vehicleRegistrationState = @"";
    self.nfaDealerAndCustomerDetails.remark = @"";
    self.nfaModel.declaration = @"N";
    
    [self checkIfMandatoryFieldsAreFilled];
}

- (void)adjustUIBasedOnVehicleRegistrationState {
    
    if ([self.nfaModel.dealerState hasValue] &&
        [self.vehicleRegistrationStateTextField.text hasValue] &&
        ![self.nfaModel.dealerState isEqualToString:self.vehicleRegistrationStateTextField.text]) {
        
        [UtilityMethods setRedBoxBorder:self.remarkTextField];
        [self.remarkTextField setEnabled:true];
        [self.checkBoxButton setHidden:false];
        [self.declarationLabel setHidden:false];
        self.nfaModel.declaration = @"Y";
    }
    else {
        
        [UtilityMethods setGreyBoxBorder:self.remarkTextField];
        [self.remarkTextField setEnabled:false];
        [self.checkBoxButton setHidden:true];
        [self.declarationLabel setHidden:true];
        self.nfaModel.declaration = @"N";
        [self.remarkTextField setText:@""];
        self.nfaModel.nfaDealerAndCustomerDetails.remark = @"";
    }
    
    [self checkIfMandatoryFieldsAreFilled];
}

- (void)adjustUIBasedOnDealType {
    
    if ([self.dealTypeTextField.text isEqualToString:DEAL_TYPE_GROUP]) {
        
        [UtilityMethods setRedBoxBorder:self.additionalCustomersTextField];
    }
    else {
        [UtilityMethods setGreyBoxBorder:self.additionalCustomersTextField];
    }
    
    [self checkIfMandatoryFieldsAreFilled];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        if (textField == self.dealTypeTextField) {
            
            self.dealTypeTextField.text = selectedValue;
            self.nfaDealerAndCustomerDetails.dealType = self.dealTypeTextField.text;
            [self adjustUIBasedOnDealType];
        }
        else if (textField == self.vehicleRegistrationStateTextField) {
            
            self.vehicleRegistrationStateTextField.text = selectedValue;
            self.nfaDealerAndCustomerDetails.vehicleRegistrationState = self.vehicleRegistrationStateTextField.text;
            [self adjustUIBasedOnVehicleRegistrationState];
        }
    }
}

#pragma mark - API Calls

- (void)fetchAllStates:(DropDownTextField *)textField {
    
    if (mStatesArray) {
        NSMutableArray *stateNamesArray = [mStatesArray valueForKeyPath:@"name"];
        [self showPopOver:textField withDataArray:stateNamesArray andModelData:mStatesArray];
    }
    else {
        [[EGRKWebserviceRepository sharedRepository] getStates:nil andSucessAction:^(NSArray *statesArray) {
            
            if (statesArray && [statesArray count] > 0) {
                mStatesArray = [statesArray mutableCopy];
                NSMutableArray *stateNamesArray = [mStatesArray valueForKeyPath:@"name"];
                [self showPopOver:textField withDataArray:stateNamesArray andModelData:mStatesArray];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

- (void)fetchAllDealTypes:(DropDownTextField *)textField {
    
    if (mDealsArray) {
        [self showPopOver:textField withDataArray:mDealsArray andModelData:mDealsArray];
    }
    else {
        [[EGRKWebserviceRepository sharedRepository] getDealTypeSuccessAction:^(NSArray *dealsArray) {
            if (dealsArray && [dealsArray count] > 0) {
                mDealsArray = [dealsArray mutableCopy];
                [self showPopOver:textField withDataArray:mDealsArray andModelData:mDealsArray];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

@end
