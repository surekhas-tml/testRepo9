//
//  VehicleDetails.m
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "VehicleDetails.h"
#import "FinancierRequestViewController.h"
#import "FinanciersDBHelpers.h"
#import "FinancierFieldDBHelper.h"
#import "CustomerTypeDBHelper.h"
#import "VehicleApplicationDBHelper.h"

@implementation VehicleDetails
{
    AppDelegate *appDelegate;
    NSMutableArray *mBillingArray;
}

- (void)loadUIFromXib {
    
    UIView *nib =[[[UINib nibWithNibName:@"VehicleDetails" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:nib];
   
    _onRoadPriceSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    
    self.sectionType = FinancierVehicleDetailsVw;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_EA_Vehicle_Details];
}

- (FinancierInsertQuoteModel *)financierInsertQuoteModel {
    if (!_financierInsertQuoteModel) {
        _financierInsertQuoteModel = [[FinancierInsertQuoteModel alloc] init];
    }
    return _financierInsertQuoteModel;
}

- (void)adjustUIBasedOnMode:(FinancierMode)mode andModel:(id)model andEntryPoint:(NSString *)entryPoint{
    
    [self bindDataToFieldsFromModel:model andEntryPoint:entryPoint];
    switch (mode) {
        case FinancierModeCreate:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:true];
            break;
        case FinancierModeDisplay:
            [self markMandatoryFields];
            [self setUserInteractionEnabled:false];
            break;
    }
}

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData andEntryPoint:(NSString *)entryPoint {
   self.financierInsertQuoteModel = fieldModelData;
    
    [self.exShowRommPriceTextField       setText:fieldModelData.ex_showroom_price];
    [self.intendedApplicationDropDown   setText:fieldModelData.intended_application];
    [self.typeOfPropertyDropDown        setText:fieldModelData.type_of_property];
    [self.customerTypeDropDown          setText:fieldModelData.customer_type];
    [self.onRoadPriceTextField          setText:fieldModelData.on_road_price_total_amt];  //new
   
    if ([self.onRoadPriceTextField.text hasValue]) {
        [_onRoadPriceSwitch setOn:YES];
        [self hideOrShowOnRoadPriceView:NO];
        [self checkIfMandatoryFieldsAreFilled];
    } else{
        [self hideOrShowOnRoadPriceView:YES];
        [_onRoadPriceSwitch setOn:NO];
    }
  
}

- (void)markMandatoryFields {

    [UtilityMethods setRedBoxBorder:self.exShowRommPriceTextField];
    [UtilityMethods setRedBoxBorder:self.intendedApplicationDropDown];
    [UtilityMethods setRedBoxBorder:self.typeOfPropertyDropDown];
    [UtilityMethods setRedBoxBorder:self.customerTypeDropDown];
    [UtilityMethods setRedBoxBorder:self.onRoadPriceTextField];
}

- (void)checkIfMandatoryFieldsAreFilled {
    BOOL mandatoryFieldsFilled = false;
    
    if (//[self.exShowRommPriceTextField.text hasValue] &&
//        [self.vehicleClassTextField.text hasValue] &&
//        [self.vehicleColorDropDown.text hasValue] &&
//        [self.emissionNormsDropDown.text hasValue] &&
        [self.intendedApplicationDropDown.text hasValue] &&
        [self.typeOfPropertyDropDown.text hasValue] &&
        [self.customerTypeDropDown.text hasValue]) {
        
        if ([_onRoadPriceSwitch isOn]) {
//            if ([_onRoadPriceTextField.text hasValue]) {
                if ([self isTextFieldDataValid]) {
                    mandatoryFieldsFilled = true;
                } else{
                    mandatoryFieldsFilled = false;
                }
//            } else{
//              mandatoryFieldsFilled = false;
//            }
        } else {
            mandatoryFieldsFilled = true;
        }
        
    }
    [self.delegate mandatoryFieldsFilled:mandatoryFieldsFilled inView:self];
}

-(BOOL)isTextFieldDataValid {
    NSString * warningMessage = @"";
    BOOL isValid;
    isValid = [self validateTextFields:&warningMessage];
    
    if (!isValid) {
        [UtilityMethods alert_ShowMessage:warningMessage withTitle:APP_NAME andOKAction:^{
        }];
    }
    return isValid;
}

- (BOOL)validateTextFields:(NSString **)warningMessage_p {

    if ([_onRoadPriceSwitch isOn]) {
        if ([self.onRoadPriceTextField.text intValue]  < 1 || [self.onRoadPriceTextField.text intValue]  == 0) {
            *warningMessage_p = @"Please Enter OnRoad Price";
            return NO;
        }
        else if ([self.onRoadPriceTextField.text intValue]  < [self.financierInsertQuoteModel.ex_showroom_price intValue]) {
            *warningMessage_p = @"OnRoad Price should be greater than Exshowroom price";
            return NO;
        }
    }
    
    return YES;
}


#pragma mark-Button Events
-(void)textFieldButtonClicked:(id)sender {
    
    switch ([sender tag]) {
        case 21:
//            [self fetchAccountType:_accountTypeDropDownField];
            break;
        case 22:
//            [self fetchVehicleColor:_vehicleColorDropDown];
            break;
        case 23:
//            [self fetchEmmission:_emissionNormsDropDown];
            break;
        case 24:
            [self fetchPropertyType:_typeOfPropertyDropDown];
            break;
        case 25:
//            [self fetchCustomerType:_customerTypeDropDown];
            break;
        case 26:
            [self fetchIntendedApplication:_intendedApplicationDropDown];
            break;
        default:
            break;
    }
}

- (IBAction)toggleButtonClicked:(UISwitch *)sender {
    
    if ([sender isOn]) {
        [self hideOrShowOnRoadPriceView:NO];
    } else {
        [self hideOrShowOnRoadPriceView:YES];
    }
}

-(void)hideOrShowOnRoadPriceView:(BOOL)hideOnRoadView{
    
    if (hideOnRoadView) {
        [_onRoadPriceSwitch setOn:NO];
        self.onRoadPriceVw.hidden = hideOnRoadView;
        [self clearTextFiledsInView:self.onRoadPriceVw];     //new function to clear all model data
        [self checkIfMandatoryFieldsAreFilled];
    }else{
        
        [_onRoadPriceSwitch setOn:YES];
        self.onRoadPriceVw.hidden = hideOnRoadView;
        [self fillOnRoadTextFiledsInModel:self.onRoadPriceVw];     //new function to fill all model data from textfields
        [self checkIfMandatoryFieldsAreFilled];
    }
}

-(void)fillOnRoadTextFiledsInModel:(UIView *)fromView
{
    self.financierInsertQuoteModel.on_road_price_total_amt = self.onRoadPriceTextField.text;
}

-(void)clearTextFiledsInView:(UIView *)fromView
{
    self.financierInsertQuoteModel.on_road_price_total_amt = @"";
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    
    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;

        textField.text = selectedValue;
        textField.field.mSelectedValue = selectedValue;
        
//        if (textField ==self.accountTypeDropDownField) {
//            self.accountTypeDropDownField.text = selectedValue;
//            self.financierInsertQuoteModel.account_type = self.accountTypeDropDownField.text;
//            [self checkIfMandatoryFieldsAreFilled];
//        } else if (textField ==self.vehicleColorDropDown){
//            self.vehicleColorDropDown.text = selectedValue;
//            self.financierInsertQuoteModel.vehicle_color = self.vehicleColorDropDown.text;
//            [self checkIfMandatoryFieldsAreFilled];
//        } else if (textField ==self.emissionNormsDropDown){
//            self.emissionNormsDropDown.text = selectedValue;
//            self.financierInsertQuoteModel.emission_norms = self.emissionNormsDropDown.text;
//            [self checkIfMandatoryFieldsAreFilled];
//        }
        if (textField ==self.intendedApplicationDropDown){
            self.intendedApplicationDropDown.text = selectedValue;
            self.financierInsertQuoteModel.intended_application = self.intendedApplicationDropDown.text;
            [self checkIfMandatoryFieldsAreFilled];
        }else if (textField ==self.typeOfPropertyDropDown){
            self.typeOfPropertyDropDown.text = selectedValue;
            self.financierInsertQuoteModel.type_of_property = self.typeOfPropertyDropDown.text;
            [self checkIfMandatoryFieldsAreFilled];
        }
//        else if (textField ==self.customerTypeDropDown){
//            self.customerTypeDropDown.text = selectedValue;
//            self.financierInsertQuoteModel.customer_type = self.customerTypeDropDown.text;
//            [self checkIfMandatoryFieldsAreFilled];
//        }
    }
}

//- (void)fetchAccountType:(DropDownTextField *)textField {
//    
//    if (accountTypeArray && [accountTypeArray count] > 0) {
//        [self showPopOver:textField withDataArray:accountTypeArray andModelData:accountTypeArray];
//        return;
//    }
//    [UtilityMethods showProgressHUD:YES];
//    [UtilityMethods RunOnOfflineDBThread:^{
//        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
//        NSMutableArray *arr = [[dbHelper fetchAccountType] mutableCopy];
//        if (arr != nil) {
//            [UtilityMethods RunOnMainThread:^{
//                [UtilityMethods hideProgressHUD];
//                accountTypeArray = [arr mutableCopy];
//                [self showPopOver:textField withDataArray:accountTypeArray andModelData:accountTypeArray];
//            }];
//        }
//    }];
//}
//
//- (void)fetchVehicleColor:(DropDownTextField *)textField {
//    
//    if (vehicleColorArray && [vehicleColorArray count] > 0) {
//        [self showPopOver:textField withDataArray:vehicleColorArray andModelData:vehicleColorArray];
//        return;
//    }
//    [UtilityMethods showProgressHUD:YES];
//    [UtilityMethods RunOnOfflineDBThread:^{
//        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
//        NSMutableArray *arr = [[dbHelper fetchVehicleColor] mutableCopy];
//        if (arr != nil) {
//            [UtilityMethods RunOnMainThread:^{
//                [UtilityMethods hideProgressHUD];
//                vehicleColorArray = [arr mutableCopy];
//                [self showPopOver:textField withDataArray:vehicleColorArray andModelData:vehicleColorArray];
//            }];
//        }
//    }];
//}
//
//- (void)fetchEmmission:(DropDownTextField *)textField {
//    
//    if (emissionNormsArray && [emissionNormsArray count] > 0) {
//        [self showPopOver:textField withDataArray:emissionNormsArray andModelData:emissionNormsArray];
//        return;
//    }
//    [UtilityMethods showProgressHUD:YES];
//    [UtilityMethods RunOnOfflineDBThread:^{
//        FinancierFieldDBHelper *dbHelper = [FinancierFieldDBHelper new];
//        NSMutableArray *arr = [[dbHelper fetchEmmisionNorms] mutableCopy];
//        if (arr != nil) {
//            [UtilityMethods RunOnMainThread:^{
//                [UtilityMethods hideProgressHUD];
//                emissionNormsArray = [arr mutableCopy];
//                [self showPopOver:textField withDataArray:emissionNormsArray andModelData:emissionNormsArray];
//            }];
//        }
//    }];
//}

- (void)fetchIntendedApplication:(DropDownTextField *)textField {
    
    if (intendedApplicationArray && [intendedApplicationArray count] > 0) {
        [self showPopOver:textField withDataArray:intendedApplicationArray andModelData:intendedApplicationArray];
        return;
    }
    [UtilityMethods showProgressHUD:YES];
    [UtilityMethods RunOnOfflineDBThread:^{
        VehicleApplicationDBHelper *dbHelper = [VehicleApplicationDBHelper new];
        NSMutableArray *arr = [[dbHelper fetchAllVehicleApplication:@"LCV"] mutableCopy];
        if (arr != nil) {
            [UtilityMethods RunOnMainThread:^{
                [UtilityMethods hideProgressHUD];
                intendedApplicationArray = [arr mutableCopy];
                [self showPopOver:textField withDataArray:intendedApplicationArray andModelData:intendedApplicationArray];
            }];
        }
    }];
}

-(void)fetchPropertyType:(DropDownTextField *)textField {
    if (typeOfPropertyArray && [typeOfPropertyArray count] > 0) {
        [self showPopOver:textField withDataArray:typeOfPropertyArray andModelData:typeOfPropertyArray];
        return;
    }
          NSArray * arr ;
          arr = [NSMutableArray arrayWithObjects: @"OWNED", @"RENTED", @"PARENT", nil];
            [UtilityMethods hideProgressHUD];
            typeOfPropertyArray = [arr mutableCopy];
            [self showPopOver:textField withDataArray:typeOfPropertyArray andModelData:typeOfPropertyArray];
}

//-(void)fetchCustomerType:(DropDownTextField *)textField {
//    if (customerTypeArray && [customerTypeArray count] > 0) {
//        [self showPopOver:textField withDataArray:customerTypeArray andModelData:customerTypeArray];
//        return;
//    }
//
//    [UtilityMethods RunOnOfflineDBThread:^{
//        CustomerTypeDBHelper *customerType = [CustomerTypeDBHelper new];
//        NSMutableArray * arr = [[customerType fetchCustomerTypesFromLob:@"LCV"] mutableCopy];
//        [UtilityMethods RunOnMainThread:^{
//            [UtilityMethods hideProgressHUD];
//            customerTypeArray = [arr mutableCopy];
//            [self showPopOver:textField withDataArray:customerTypeArray andModelData:customerTypeArray];
//            
//        }];
//    }];
//    
//}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}


#pragma mark - textFiled delegate methods

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField == self.onRoadPriceTextField) {
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
//    NSDictionary *userInfo = @{@"Value_Changed": @"1"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil userInfo:userInfo];
    
    if (textField == self.exShowRommPriceTextField) {
        self.financierInsertQuoteModel.ex_showroom_price = self.exShowRommPriceTextField.text;
        
    }

    else if (textField == self.intendedApplicationDropDown) {
        self.financierInsertQuoteModel.intended_application = self.intendedApplicationDropDown.text;
        
    } else if (textField == self.typeOfPropertyDropDown) {
        self.financierInsertQuoteModel.type_of_property = self.typeOfPropertyDropDown.text;
        
    }
    //new
    else if (textField == self.onRoadPriceTextField) {
        self.financierInsertQuoteModel.on_road_price_total_amt = self.onRoadPriceTextField.text;
        [self checkIfMandatoryFieldsAreFilled];
    }

}


@end
