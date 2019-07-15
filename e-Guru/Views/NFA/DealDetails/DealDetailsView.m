//
//  DealDetailsView.m
//  e-guru
//
//  Created by MI iMac04 on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "DealDetailsView.h"
#import "DropDownViewController.h"
@implementation DealDetailsView{
    AppDelegate *appDelegate;
    NSMutableArray *mBillingArray;
}


- (void)loadUIFromXib {
    
    UIView *nib = [[[UINib nibWithNibName:@"DealDetailsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
    [nib autoPinEdgesToSuperviewEdges];
    [self addGestureToDropDownFields];
    self.sectionType = NFASectionDealDetails;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NFADealDetails *)nfaDealerAndCustomerDetails {
    if (!_nfaDealDetails) {
        _nfaDealDetails = [[NFADealDetails alloc] init];
    }
    return _nfaDealDetails;
}

- (DropDownTextField *)vehicleRegistrationStateDropDownTextField {
    if (!_billingTextField.field) {
        _billingTextField.field = [[Field alloc] init];
    }
    return _billingTextField;
}

- (void)adjustUIBasedOnMode:(NFAMode)mode andModel:(id)model {
    
    self.nfaDealDetails = model;
    [self bindDataToFieldsFromModel:model];
    
    switch (mode) {
        case NFAModeCreate:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeUpdate:
            [self setUserInteractionEnabled:true];
            break;
        case NFAModeDisplay:
            [self setUserInteractionEnabled:false];
            break;
    }
}

- (void)markMandatoryFields {
    [UtilityMethods setRedBoxBorder:self.lobTextField];
    [UtilityMethods setRedBoxBorder:self.pplTextField];
    [UtilityMethods setRedBoxBorder:self.modelTextField];
    [UtilityMethods setRedBoxBorder:self.dealSizeTextField];
    [UtilityMethods setRedBoxBorder:self.billingTextField];
}

- (void)bindDataToFieldsFromModel:(NFADealDetails *)dealDetails {
    if (!dealDetails) {
        return;
    }
    [self.lobTextField setText:dealDetails.lob];
    [self.pplTextField setText:dealDetails.ppl];
    [self.modelTextField setText:dealDetails.model];
    [self.dealSizeTextField setText:dealDetails.dealSize];
    [self.billingTextField setText:dealDetails.billing];
    [self.vcTextField setText:dealDetails.vc];
    [self.productDescriptionTextField setText:dealDetails.productDescription];
}

- (void)checkIfMandatoryFieldsAreFilled {
    
    BOOL mandatoryFieldsFilled = false;
    
    if ([self.lobTextField.text hasValue] &&
        [self.pplTextField.text hasValue] &&
        [self.modelTextField.text hasValue] &&
        [self.dealSizeTextField.text hasValue] &&
        [self.billingTextField.text hasValue]) {
        mandatoryFieldsFilled = true;
    }
    
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

- (void)resetFields {
    [self.billingTextField setText:@""];
    
    self.nfaDealDetails.billing = @"";
    [self checkIfMandatoryFieldsAreFilled];
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.lobTextField) {
        self.nfaDealDetails.lob = self.lobTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.pplTextField) {
        self.nfaDealDetails.ppl = self.pplTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.modelTextField) {
        self.nfaDealDetails.model = self.modelTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.vcTextField) {
        self.nfaDealDetails.vc = self.vcTextField.text;
    }
    else if (textField == self.productDescriptionTextField) {
        self.nfaDealDetails.productDescription = self.productDescriptionTextField.text;
    }
    else if (textField == self.dealSizeTextField) {
        self.nfaDealDetails.dealSize = self.dealSizeTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
    else if (textField == self.billingTextField) {
        self.nfaDealDetails.billing = self.billingTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.billingTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            DropDownTextField *textField = (DropDownTextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                
                if (textField == self.billingTextField) {
                    [self fetchBillingTypes:textField];
                }
            }
        }
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;
        
        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        self.billingTextField.text = selectedValue;
        self.nfaDealDetails.billing = self.billingTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }
}

#pragma mark - API Calls

- (void)fetchBillingTypes:(DropDownTextField *)textField {
    
    if (mBillingArray) {
        [self showPopOver:textField withDataArray:mBillingArray andModelData:mBillingArray];
    }
    else {
        [[EGRKWebserviceRepository sharedRepository] getBillingSuccessAction:^(NSArray *billingTypeArray) {
            if (billingTypeArray && [billingTypeArray count] > 0) {
                mBillingArray = [billingTypeArray mutableCopy];
                [self showPopOver:textField withDataArray:mBillingArray andModelData:mBillingArray];
            }
        } andFailuerAction:^(NSError *error) {
            
        }];
    }
}

@end
