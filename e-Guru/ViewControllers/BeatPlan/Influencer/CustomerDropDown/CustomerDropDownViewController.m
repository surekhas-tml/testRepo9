//
//  CustomerDropDownViewController.m
//  e-guru
//
//  Created by Apple on 07/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "CustomerDropDownViewController.h"
#import "UtilityMethods.h"
#import "VCNumberDBHelper.h"
#import "DropDownViewController.h"
#import "UtilityMethods+UtilityMethodsValidations.h"
#import "AppRepo.h"
#import "InfluencerViewModel.h"

@interface CustomerDropDownViewController ()<DropDownViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) InfluencerViewModel *influencerViewModel;

@end

@implementation CustomerDropDownViewController

@synthesize txtFieldDistrict,txtFieldCity,txtFieldMMGeo,txtFieldDSE,txtFieldLOB;
#pragma mark - VC Lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.influencerViewModel = [[InfluencerViewModel alloc]init];
    [self addGestureToDropDownFields];
}

- (void)setUpUIData {
    
    if (self.isInputedValues){
        return;
    }
    
    self.lblTitle.text = self.popUpTitle;
    self.selectedCustomerID = [self.selectedCustomerDict valueForKey:@"customer_id"];
    self.txtFieldContactName.text = [self.selectedCustomerDict valueForKey:@"customer_name"];
    self.txtFieldAccountName.text = [self.selectedCustomerDict valueForKey:@"account_name"];
    self.txtFieldChannelType.text = self.selectedChannelType;
    self.txtFieldApplication.text = [self.selectedCustomerDict valueForKey:@"application"];
    self.txtFieldMobileNumber.text = [self.selectedCustomerDict valueForKey:@"contact_number"];
    self.txtFieldDistrict.text = [self.selectedCustomerDict valueForKey:@"district"];
    self.txtFieldDistrict.field.mSelectedValue = [self.selectedCustomerDict valueForKey:@"district"];
    self.txtFieldCity.text = [self.selectedCustomerDict valueForKey:@"city"];
    self.txtFieldCity.field.mSelectedValue = [self.selectedCustomerDict valueForKey:@"city"];
    self.txtFieldMMGeo.text = [self.selectedCustomerDict valueForKey:@"mmgeo"];
    self.txtFieldMMGeo.field.mSelectedValue = [self.selectedCustomerDict valueForKey:@"mmgeo"];
    self.txtFieldDSE.text = self.selectedDSE;
    self.txtFieldDSE.field.mSelectedValue = self.selectedDSE;
    self.txtFieldLOB.text = [self.selectedCustomerDict valueForKey:@"lob"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUIData];

    [UtilityMethods setRedBoxBorder:self.txtFieldChannelType];
    [UtilityMethods setRedBoxBorder:self.txtFieldContactName];
    [UtilityMethods setRedBoxBorder:self.txtFieldMobileNumber];
    [UtilityMethods setRedBoxBorder:self.txtFieldDistrict];
    [UtilityMethods setRedBoxBorder:self.txtFieldCity];
    [UtilityMethods setRedBoxBorder:self.txtFieldMMGeo];
    [UtilityMethods setRedBoxBorder:self.txtFieldDSE];
    [UtilityMethods setBlackBoxBorder:self.txtFieldLOB];
    [UtilityMethods setBlackBoxBorder:self.txtFieldApplication];
    [UtilityMethods setBlackBoxBorder:self.txtFieldAccountName];

    [UtilityMethods setLeftPadding:self.txtFieldChannelType];
    [UtilityMethods setLeftPadding:self.txtFieldContactName];
    [UtilityMethods setLeftPadding:self.txtFieldMobileNumber];
    [UtilityMethods setLeftPadding:self.txtFieldAccountName];
    [UtilityMethods setLeftPadding:self.txtFieldApplication];
    [UtilityMethods setLeftPadding:self.txtFieldDSE];
    [UtilityMethods setLeftPadding:self.txtFieldLOB];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - Helper Methods
- (DropDownTextField *)txtFieldDistrict{
    if (!txtFieldDistrict.field){
        txtFieldDistrict.field = [[Field alloc] init];
    }
    return txtFieldDistrict;
}

- (DropDownTextField *)txtFieldCity{
    if (!txtFieldCity.field){
        txtFieldCity.field = [[Field alloc] init];
    }
    return txtFieldCity;
}

- (DropDownTextField *)txtFieldMMGeo{
    if (!txtFieldMMGeo.field){
        txtFieldMMGeo.field = [[Field alloc] init];
    }
    return txtFieldMMGeo;
}

- (DropDownTextField *)txtFieldDSE{
    if (!txtFieldDSE.field){
        txtFieldDSE.field = [[Field alloc] init];
    }
    return txtFieldDSE;
}

- (DropDownTextField *)txtFieldLOB{
    if (!txtFieldLOB.field){
        txtFieldLOB.field = [[Field alloc] init];
    }
    return txtFieldLOB;
}

- (void)addGestureToDropDownFields{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[self.txtFieldDistrict superview] addGestureRecognizer:tapGesture];
    [[self.txtFieldCity superview] addGestureRecognizer:tapGesture];
    [[self.txtFieldMMGeo superview] addGestureRecognizer:tapGesture];
    [[self.txtFieldDSE superview] addGestureRecognizer:tapGesture];
    [[self.txtFieldLOB superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    CGPoint point = [gesture locationInView:gesture.view];
    for (id view in [gesture.view subviews]){
        if ([view isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.txtFieldDistrict){
                    [UtilityMethods showProgressHUD:YES];
                    [self.influencerViewModel getDistrictListFromState:[[AppRepo sharedRepo] getLoggedInUser].userState withSuccessBlock:^(id  _Nonnull response) {
                        [UtilityMethods hideProgressHUD];
                        NSDictionary *responseDict = (NSDictionary*)response;
                        NSArray *arrayDistrictList = responseDict[@"districts"];
                        NSLog(@"arrayDistrictList %@",arrayDistrictList);
                        [UtilityMethods RunOnMainThread:^{
                            self.txtFieldDistrict.field.mValues = [arrayDistrictList mutableCopy];
                            self.txtFieldDistrict.field.mDataList = [arrayDistrictList mutableCopy];
                            [self showDropDownForView:self.txtFieldDistrict];
                        }];
                    } withFailureBlock:^(NSError * _Nonnull error){
                    }];
                }else if (textField == self.txtFieldCity){
                    if (self.txtFieldDistrict.text.length == 0){
                        [UtilityMethods alert_ShowMessage:@"Please select district" withTitle:APP_NAME andOKAction:nil];
                        return;
                    }
                    NSDictionary *params = @{
                                             @"state": [[AppRepo sharedRepo] getLoggedInUser].userState,
                                             @"district":self.txtFieldDistrict.text
                                             };
                    [UtilityMethods showProgressHUD:YES];
                    [self.influencerViewModel getCityListFromParams:params SuccessBlock:^(id  _Nonnull response) {
                        [UtilityMethods hideProgressHUD];
                        NSDictionary *responseDict = (NSDictionary*)response;
                        NSArray *arrayCityList = responseDict[@"cities"];
                        NSLog(@"arrayCityList %@",arrayCityList);
                        [UtilityMethods RunOnMainThread:^{
                            self.txtFieldCity.field.mValues = [arrayCityList mutableCopy];
                            self.txtFieldCity.field.mDataList = [arrayCityList mutableCopy];
                            [self showDropDownForView:self.txtFieldCity];
                        }];
                    } withFailureBlock:^(NSError * _Nonnull error){
                    }];
                }else if (textField == self.txtFieldMMGeo){
                    if (self.txtFieldDistrict.text.length == 0){
                        [UtilityMethods alert_ShowMessage:@"Please select district & city" withTitle:APP_NAME andOKAction:nil];
                        return;
                    }
                    if (self.txtFieldCity.text.length == 0){
                        [UtilityMethods alert_ShowMessage:@"Please select city" withTitle:APP_NAME andOKAction:nil];
                        return;
                    }
                    
                    NSDictionary *params = @{
                      @"state": [[AppRepo sharedRepo] getLoggedInUser].userState,
                      @"dsm_id":[[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID,
                      @"district": self.txtFieldDistrict.text,
                      @"city": self.txtFieldCity.text
//                      @"lob": selectedLOBName,
                      };
                    
                    [UtilityMethods showProgressHUD:YES];
                    [self.influencerViewModel getMMGEOListWithParams:params withSuccessBlock:^(id  _Nonnull response) {
                        [UtilityMethods hideProgressHUD];
                        NSLog(@"response : %@",response);
                        [UtilityMethods RunOnMainThread:^{
                            self.txtFieldMMGeo.field.mValues = [response mutableCopy];
                            self.txtFieldMMGeo.field.mDataList = [response mutableCopy];
                            [self showDropDownForView:self.txtFieldMMGeo];
                        }];
                    } withFailureBlock:^(NSError * _Nonnull error){
                    }];
                }else if (textField == self.txtFieldDSE) {
                    if (self.txtFieldMMGeo.text.length == 0){
                        [UtilityMethods alert_ShowMessage:@"Please select MM Geography" withTitle:APP_NAME andOKAction:nil];
                        return;
                    }
                    [UtilityMethods showProgressHUD:YES];
                    [self.influencerViewModel getDSEListFromMMGeo:self.txtFieldMMGeo.text withSuccessAction:^(id  _Nonnull response){
                        [UtilityMethods hideProgressHUD];
                        NSDictionary *responseDict = (NSDictionary*)response;
                        NSArray *lobList = responseDict[@"dse_list"];
                        NSLog(@"lobList %@",lobList);
                        [UtilityMethods RunOnMainThread:^{
                            self.txtFieldDSE.field.mValues = [lobList mutableCopy];
                            self.txtFieldDSE.field.mDataList = [lobList mutableCopy];
                            [self showDropDownForView:self.txtFieldDSE];
                        }];
                    } andFailuerAction:^(NSError * _Nonnull error){
                    }];
                }else if (textField == self.txtFieldLOB) {
                    [UtilityMethods showProgressHUD:YES];
                    [self.influencerViewModel getLOBListSuccessBlock:^(id  _Nonnull response) {
                        [UtilityMethods hideProgressHUD];
                        NSDictionary *responseDict = (NSDictionary*)response;
                        NSArray *mmgeoList = responseDict[@"lobs"];
                        NSLog(@"ResponseDict %@",responseDict);
                        [UtilityMethods RunOnMainThread:^{
                            self.txtFieldLOB.field.mValues = [mmgeoList mutableCopy];
                            self.txtFieldLOB.field.mDataList = [mmgeoList mutableCopy];
                            [self showDropDownForView:self.txtFieldLOB];
                        }];
                    } withFailureBlock:^(NSError * _Nonnull error) {
                    }];
                }
            }
        }
    }
}

/*
- (void)fetchLOBFromMaster {
    VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
    NSMutableArray *LOB = [[vcNumberDBHelper fetchAllLOB] mutableCopy];
    if (LOB != nil) {
        [UtilityMethods RunOnMainThread:^{
            [self showLOBDropDown:LOB];
        }];
    }
}

- (void)showLOBDropDown:(NSMutableArray *)arrLOB {
    NSArray *nameResponseArray = [arrLOB valueForKey:@"lobName"];
    self.txtFieldLOB.field.mValues = [nameResponseArray mutableCopy];
    self.txtFieldLOB.field.mDataList = [arrLOB mutableCopy];
    [self showDropDownForView:self.txtFieldLOB];
}
*/

- (void)showDropDownForView:(DropDownTextField *)textField{
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

- (BOOL)validate{
    if(self.txtFieldContactName.text.length == 0){
        [UtilityMethods alert_ShowMessage:@"Please enter contact name" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    
    if ([self.txtFieldContactName.text hasPrefix:@" "] || [self.txtFieldContactName.text hasSuffix:@" "]){
        [UtilityMethods alert_ShowMessage:@"Please remove extra spaces from contact name" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }

    if (![UtilityMethods validateMobileNumberNew:self.txtFieldMobileNumber.text] && ([self.txtFieldMobileNumber.text length] < 10)){
        [UtilityMethods alert_ShowMessage:@"Please enter valid mobile number" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    if ([UtilityMethods validateMobileNumber:self.txtFieldMobileNumber.text]) {
        NSString *str = [self.txtFieldMobileNumber.text substringToIndex:1];
        
        if ([str isEqualToString:@"0"] || [str isEqualToString:@"1"] || [str isEqualToString:@"2"] || [str isEqualToString:@"3"] || [str isEqualToString:@"4"] || [str isEqualToString:@"5"]) {
            [UtilityMethods alert_ShowMessage:@"Please enter valid mobile number" withTitle:APP_NAME andOKAction:nil];
            return NO;
            
        } else if ([self.txtFieldMobileNumber.text isEqualToString:@"6666666666"] || [self.txtFieldMobileNumber.text isEqualToString:@"7777777777"] || [self.txtFieldMobileNumber.text isEqualToString:@"8888888888"] || [self.txtFieldMobileNumber.text isEqualToString:@"9999999999"]) {
             [UtilityMethods alert_ShowMessage:@"Please enter valid mobile number" withTitle:APP_NAME andOKAction:nil];
            return NO;
        }
    }
    if (self.txtFieldDistrict.text.length == 0){
        [UtilityMethods alert_ShowMessage:@"Please select district" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    if (self.txtFieldCity.text.length == 0){
        [UtilityMethods alert_ShowMessage:@"Please select city" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    if (self.txtFieldMMGeo.text.length == 0){
        [UtilityMethods alert_ShowMessage:@"Please select MM Geography" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    if (self.txtFieldDSE.text.length == 0){
        [UtilityMethods alert_ShowMessage:@"Please select DSE ID" withTitle:APP_NAME andOKAction:nil];
        return NO;
    }
    return YES;
}

- (void)addCustomer:(BOOL)isUpdate{
    __block CustomerDropDownViewController *customerDropDown = self;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.txtFieldChannelType.text forKey:@"channel_type"];
    [params setValue:self.txtFieldMobileNumber.text forKey:@"contact_num"];
    [params setValue:self.txtFieldMMGeo.text forKey:@"mmgeo"];
    [params setValue:@"true" forKey:@"status"];
    [params setValue:self.txtFieldDSE.text forKey:@"dse_id"];
    [params setValue:self.txtFieldLOB.text forKey:@"lob"];
    [params setValue:self.txtFieldApplication.text forKey:@"application"];
    
    if (isUpdate){
        [params setValue:self.txtFieldContactName.text.uppercaseString forKey:@"customer_name"];
        [params setValue:self.txtFieldAccountName.text.uppercaseString forKey:@"account_name"];
        [params setValue:[[AppRepo sharedRepo] getLoggedInUser].dsmName.uppercaseString forKey:@"dsm_name"];
        [params setValue:[[AppRepo sharedRepo] getLoggedInUser].organisationName.uppercaseString forKey:@"organization_name"];

        [params setValue:self.selectedCustomerID forKey:@"customer_id"];
    }
    else
    {
        [params setValue:self.txtFieldContactName.text forKey:@"customer_name"];
        [params setValue:self.txtFieldAccountName.text forKey:@"account_name"];
        [params setValue:[[AppRepo sharedRepo] getLoggedInUser].dsmName forKey:@"dsm_name"];
        [params setValue:[[AppRepo sharedRepo] getLoggedInUser].organisationName forKey:@"organization_name"];
    }
    [self.influencerViewModel addCustomerWithParams:params isUpdate:isUpdate withCompletionBlock:^(id  _Nonnull response){
        NSDictionary *responseDic = (NSDictionary*)response;
        NSDictionary *responseData = responseDic[@"data"];
        if (responseData == nil){
            [UtilityMethods alert_ShowMessage:responseDic[@"msg"] withTitle:APP_NAME andOKAction:nil];
            return;
        }
        NSString *message = isUpdate ? [NSString stringWithFormat:@"Customer updated successfuly and can be viewed under %@ in %@",responseData[@"mmgeo"],responseData[@"dse_id"]]: [NSString stringWithFormat:@"Customer added successfuly and can be viewed under %@ in %@",responseData[@"mmgeo"],responseData[@"dse_id"]];
        [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
            if([customerDropDown.delegate respondsToSelector:@selector(onAddButtonClicked)]){
                [customerDropDown.view removeFromSuperview];
                [customerDropDown.delegate onAddButtonClicked];
            }
        }];
    } withFailureBlock:^(NSError * _Nonnull error){
        //[customerDropDown.view removeFromSuperview];
    }];
}

#pragma mark - UIButton Actions
- (IBAction)btnCloseClicked:(id)sender{
    self.isInputedValues = false;
    if([self.delegate respondsToSelector:@selector(onBackButtonClicked)]){
        [self.delegate onBackButtonClicked];
        [self.view removeFromSuperview];
    }
}

- (IBAction)btnAddClicked:(id)sender{
    if([self validate]){
        self.isInputedValues = false;
        if(self.selectedCustomerID == nil){
            [self addCustomer:NO];
        }else{
            [self addCustomer:YES];
        }
    }
}

#pragma mark - DropDownViewControllerDelegate Method
- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView{
    DropDownTextField *textField;
    textField = (DropDownTextField *)dropDownForView;
    textField.text = selectedValue;
    textField.field.mSelectedValue = selectedValue;
  
    if (textField == txtFieldDistrict){
        self.txtFieldCity.text = @"";
        self.txtFieldCity.field.mSelectedValue = @"";
        self.txtFieldMMGeo.text = @"";
        self.txtFieldMMGeo.field.mSelectedValue = @"";
        self.txtFieldDSE.text = @"";
        self.txtFieldDSE.field.mSelectedValue = @"";
    } else if (textField == txtFieldCity){
        self.txtFieldMMGeo.text = @"";
        self.txtFieldMMGeo.field.mSelectedValue = @"";
        self.txtFieldDSE.text = @"";
        self.txtFieldDSE.field.mSelectedValue = @"";
    } else if (textField == txtFieldMMGeo){
        self.txtFieldDSE.text = @"";
        self.txtFieldDSE.field.mSelectedValue = @"";
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.isInputedValues = true;
    
    if(textField == self.txtFieldMobileNumber){
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }else{
        [textField setKeyboardType:UIKeyboardTypeDefault];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.txtFieldContactName || textField == self.txtFieldAccountName || textField == self.txtFieldApplication){
        return [UtilityMethods isCharacterSetOnlyAlphaNumeric:string] || [string isEqualToString:@" "];
    }else if (textField == self.txtFieldMobileNumber){
        if (length > 10)
            return NO;
        return [UtilityMethods isCharacterSetOnlyNumber:string];
    }
    return YES;
}

@end
