//
//  AddNewLocationViewController.m
//  e-guru
//
//  Created by Apple on 21/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "AddNewLocationViewController.h"
#import "UIColor+eGuruColorScheme.h"
#import "UtilityMethods.h"
#import "AppRepo.h"
#import "Constant.h"
#import "VCNumberDBHelper.h"
#import "DropDownView.h"
#import "DropDownViewController.h"
#import "DropDownTextField.h"
#import "PureLayout.h"
#import "EGLob.h"
#import "MMGEOLocationModel.h"
#import "EGRKWebserviceRepository.h"
#import "MMGeographyDBHelpers.h"
#import "MyTeamViewModel.h"


@interface AddNewLocationViewController ()
{
    UITextField *activeField;
    NSArray *actionList;
    EGLob *selectedLOBObj;
    NSString *selectedStateName;
    NSString *selectedStateCode;
    NSString *selectedDistrictName;
    NSString *selectedCityName;
    NSString *selectedTalukaName;

    NSString *selectedMicroMarketName;
    NSString *selectedLOBName;
    
    NSMutableArray *mStatesArray;
    NSArray *talukaArray;
    EGRKWebserviceRepository *currentTalukaOperation;
    BOOL fetchTaluka;
    NSMutableArray *sortedTalukaArray;
    NSArray *arrCurrentSearchTalukaData;
    NSArray *sortedModelArr;     //new changes
    
    MyTeamViewModel *teamViewModelObject;

    NSString *dsmIdStr;
    
    UITapGestureRecognizer *talukaTapRecognizer;
    UITapGestureRecognizer *tapRecognizer;
}

@property (strong,nonatomic)    UIActivityIndicatorView *actIndicator;
@property (weak, nonatomic) IBOutlet UIView *parentView;

@end

@implementation AddNewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageScrollView.userInteractionEnabled = true;

    // Do any additional setup after loading the view.
    self.backButton.backgroundColor = [UIColor buttonBackgroundBlueColor];
    self.saveButton.backgroundColor = [UIColor buttonBackgroundBlueColor];
    self.titleNameLAbel.textColor = [UIColor buttonBackgroundBlueColor];

    [self resetAllFields];
    [self addGestureToDropDownFields:self.districtDropDownTextField];
    [self addGestureToDropDownFields:self.city_TextField];
    [self addGestureToDropDownFields:self.microMarketTextField];

//    /[self bindLOBPPLPLData];
    fetchTaluka = YES;

    self.backButton.layer.cornerRadius = 3.0f;
    self.backButton.layer.masksToBounds = true;
    self.saveButton.layer.cornerRadius = 3.0f;
    self.saveButton.layer.masksToBounds = true;
    
    dsmIdStr = [[AppRepo sharedRepo] getLoggedInUser].employeeRowID;

    [self resetAllFields];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self addGestureRecogniserToView];
    
    NSString * lob = [[AppRepo sharedRepo] getLoggedInUser].lob;
    NSString * lobName = [[AppRepo sharedRepo] getLoggedInUser].lobName;
    NSLog(@"LOb Details : %@ %@",lob,lobName);
    self.lobDropDownTextField.text = lobName;
    selectedLOBName =  [[AppRepo sharedRepo] getLoggedInUser].lobName;
    selectedStateName =  [[AppRepo sharedRepo] getLoggedInUser].userState;
    self.stateTextField.text = selectedStateName;

    teamViewModelObject = [[MyTeamViewModel alloc]init];
}

#pragma mark - getStateCodeAPICall

-(void)getStateCodeAPICall{
    NSDictionary *requestDictionary = @{@"state_name": selectedStateName};
    
    [teamViewModelObject getStateCode:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSDictionary *stateDict = (NSDictionary*)response ;
        NSLog(@"stateDict :%@",stateDict);
        selectedStateCode = [stateDict objectForKey:@"state_code"];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
        [UtilityMethods showToastWithMessage:[error localizedDescription]];
    }];
}

//---

#pragma mark - getDistrictListAPICall

-(void)getDistrictListAPICall{
    if (selectedStateName == nil ||[selectedStateName length] == 0 || [selectedStateName isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:@"Please select State" withTitle:APP_NAME andOKAction:^{
        }];
        return;
    }
    NSDictionary *requestDictionary = @{@"state": selectedStateName};
    
    NSLog(@"requestDictionary For getDistrictList :%@",requestDictionary);
    
    [teamViewModelObject getDistrictList:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSDictionary *districtDict = (NSDictionary*)response ;
        NSLog(@"districtList : %@",districtDict);
        [self setDistrictList:[districtDict objectForKey:@"districts"]];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
    }];
}


#pragma mark - getCityListAPICall

-(void)getCityListAPICall{
    if (selectedDistrictName == nil ||[selectedDistrictName length] == 0 || [selectedDistrictName isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:@"Please select District" withTitle:APP_NAME andOKAction:^{
        }];
        return;
    }
    NSDictionary *requestDictionary = @{
                                        @"state": selectedStateName,
                                        @"district": selectedDistrictName
                                        };
    
    NSLog(@"requestDictionary For getCityList :%@",requestDictionary);
    
    [teamViewModelObject getCityList:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSDictionary *cityDict = (NSDictionary*)response ;
        NSLog(@"getCityList : %@",cityDict);
        [self setCityList:[cityDict objectForKey:@"cities"]];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
    }];
}


//---

#pragma mark - getMMGEOListAPICall

-(void)getMMGEOListAPICall{
    NSString *stateName = [selectedStateName uppercaseString];
    if (selectedCityName == nil ||[selectedCityName length] == 0 || [selectedCityName isEqualToString:@""]||selectedDistrictName == nil ||[selectedDistrictName length] == 0 || [selectedDistrictName isEqualToString:@""]) {
        [UtilityMethods alert_ShowMessage:@"Please select District" withTitle:APP_NAME andOKAction:^{
        }];
        return;
    }
    NSDictionary *requestDictionary = @{
                                        @"state": selectedStateName,
                                        @"district": selectedDistrictName,
                                        @"city": selectedCityName,
                                        @"dsm_id":dsmIdStr
                                        };
    
    NSLog(@"requestDictionary For getMMGEOList :%@",requestDictionary);
    
    [teamViewModelObject getMMGEOList:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSArray *mmgeoList = (NSArray*)response ;
        NSLog(@"mmgeoList : %@",mmgeoList);
        [self setMMGEOList:mmgeoList];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
    }];
}

#pragma mark - assignLocationToDSEAPICall

-(void)assignLocationToDSEAPICall{
    NSDictionary *requestDictionary = @{
                                        @"state_name": selectedStateName,
                                        @"district": selectedDistrictName,
                                        @"city": selectedCityName,
                                        @"mm-geo": selectedMicroMarketName,
                                        @"dse_id":_dsedata.dseName,
                                        @"dsm_id":dsmIdStr
                                        };
    
    NSLog(@"Param Dict : %@",requestDictionary);
    [teamViewModelObject assignLocationToDSE:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSDictionary *dict = (NSDictionary*)response ;
        NSLog(@"successMsg : %@",[dict objectForKey:@"msg"]);
        [UtilityMethods showToastWithMessage:[dict objectForKey:@"msg"]];
        
        MMGEOLocationModel *loactionObject = [[MMGEOLocationModel alloc] init];
        loactionObject.stateName = selectedStateName;
        loactionObject.districtName = selectedDistrictName;
        loactionObject.cityName = selectedCityName;
        loactionObject.lobName = selectedLOBName;
        loactionObject.microMarketName = selectedMicroMarketName;
        
        [self resetData];

        [_delegate updateLocationListCallBack:loactionObject];

    } withFailureBlock:^(NSError * _Nonnull error) {
        [self resetData];
        [UtilityMethods showToastWithMessage:@"Location already assigned to DSE"];
    }];
}

#pragma mark - viewDidAppear

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self makeRedbox_mandatoryFields];
}

#pragma mark - resetAllFields

-(void)resetAllFields{
    self.districtDropDownTextField.text = @"";
    self.city_TextField.text = @"";
    self.microMarketTextField.text = @"";
    selectedTalukaName = @"";
    selectedDistrictName = @"";
    selectedCityName = @"";
    selectedMicroMarketName = @"";
}

-(void)resetData{
    self.districtDropDownTextField.text = @"";
    self.city_TextField.text = @"";
    self.microMarketTextField.text = @"";
}

#pragma mark - addGestureToDropDownFields

- (void)addGestureToDropDownFields :(DropDownTextField*)dropDownTextF {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [[dropDownTextF superview] addGestureRecognizer:tapGesture];
//    [[self.dropDownTextField superview] addGestureRecognizer:tapGesture];
//    [[self.dropDownTextField superview] addGestureRecognizer:tapGesture];
}

#pragma mark - setuplobDropDownTextField

- (DropDownTextField *)lobDropDownTextField {
    if (!_lobDropDownTextField.field) {
        _lobDropDownTextField.field = [[Field alloc] init];
        _lobDropDownTextField.icongImageView.image = [UIImage imageNamed:@""];

    }
    return _lobDropDownTextField;
}

#pragma mark - setupstateDropDownTextField

- (DropDownTextField *)stateTextField {
    if (!_stateTextField.field) {
        _stateTextField.field = [[Field alloc] init];
//        [icon setImage:[UIImage imageNamed:@"temp_blueTriangle"]];
        _stateTextField.icongImageView.image = [UIImage imageNamed:@""];
    }
    return _stateTextField;
}

#pragma mark - setupmicroMarketDropDownTextField

- (DropDownTextField *)microMarketTextField {
    if (!_microMarketTextField.field) {
        _microMarketTextField.field = [[Field alloc] init];
    }
    return _microMarketTextField;
}

#pragma mark - setupdistrictDropDownTextField

- (DropDownTextField *)districtDropDownTextField {
    if (!_districtDropDownTextField.field) {
        _districtDropDownTextField.field = [[Field alloc] init];
    }
    return _districtDropDownTextField;
}

#pragma mark - setupCityDropDownTextField

- (DropDownTextField *)city_TextField {
    if (!_city_TextField.field) {
        _city_TextField.field = [[Field alloc] init];
    }
    return _city_TextField;
}
#pragma mark - dropDownFieldTapped

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                
                if (textField == self.districtDropDownTextField ) {
                    NSLog(@"Disticts tapped");
                    if ([self fieldInputValid:self.districtDropDownTextField]) {
                        _districtDropDownTextField.text = @"";
                        _city_TextField.text = @"";
                        _microMarketTextField.text = @"";
                        
                        //[self fetchAllDistricts:self.districtDropDownTextField];
                        //*** Temp Commented
                        [self getDistrictListAPICall];
                    }
                }
                else if (textField == self.city_TextField ) {
                    if ([self fieldInputValid:self.city_TextField]) {
                        _city_TextField.text = @"";
                        _microMarketTextField.text = @"";
                        
//                       [self fetchAllCities:self.districtDropDownTextField];
                        //*** Temp Commented
                        [self getCityListAPICall];
                    }
                }
                else if (textField == self.microMarketTextField ) {
                     if ([self fieldInputValid:self.microMarketTextField]) {
//                         [self fetchMicroMarket];
//                         [self getMMGEOList:selectedLOBName];
                         if (_districtDropDownTextField.text.length != 0 && _city_TextField.text.length != 0) {
                             [self getMMGEOListAPICall];
                         }
                     }
                }
            }
        }
    }
}


#pragma mark - fetchAllDistricts

- (void)fetchAllDistricts:(DropDownTextField *)textField  {
    self.districtDropDownTextField.field.mValues = nil;
    self.districtDropDownTextField.text = nil;
    [self clearSelectedTalukadata];
    
    NSMutableArray *districtsArray = [[NSMutableArray alloc] initWithArray:@[@"d1",@"d2"]];
    if (districtsArray != nil) {
        [UtilityMethods RunOnMainThread:^{
            [self showDistrictDropDown:[districtsArray mutableCopy]];
        }];
    }

}
- (void)fetchAllCities:(DropDownTextField *)textField {
    self.city_TextField.field.mValues = nil;
    self.city_TextField.text = nil;
    
    NSMutableArray *districtsArray = [[NSMutableArray alloc] initWithArray:@[@"c1",@"c2"]];
    if (districtsArray != nil) {
        [UtilityMethods RunOnMainThread:^{
            [self showCityDropDown:[districtsArray mutableCopy]];
        }];
    }
}



#pragma mark - fetchAllStates

- (void)fetchAllStates:(DropDownTextField *)textField  {
    [self clearSelectedTalukadata];
    [[EGRKWebserviceRepository sharedRepository] getStates:nil andSucessAction:^(NSArray *statesArray) {
        if (statesArray && [statesArray count] > 0) {
            NSLog(@"StateList :%@",statesArray);
            [self showStateDropDown:[statesArray mutableCopy]];
        }
        
    } andFailuerAction:^(NSError *error) {
    }];
    NSMutableArray *microMarket = [[NSMutableArray alloc] initWithArray:@[@"m1",@"m2"]];

}
#pragma mark - fetchLOBFromMaster

-(void)fetchLOBFromMaster {
    VCNumberDBHelper *vcNumberDBHelper = [VCNumberDBHelper new];
    NSMutableArray *LOB = [[vcNumberDBHelper fetchAllLOB] mutableCopy];
    if (LOB != nil) {
        [UtilityMethods RunOnMainThread:^{
            [self showLOBDropDown:LOB];
        }];
    }
}

#pragma mark - fetchMicroMarket

-(void)fetchMicroMarket {
    NSMutableArray *microMarket = [[NSMutableArray alloc] initWithArray:@[@"m1",@"m2"]];
    if (microMarket != nil) {
        [UtilityMethods RunOnMainThread:^{
            [self showMicroMarketDropDown:microMarket];
        }];
    }
}

#pragma mark - showLOBDropDown

- (void)showLOBDropDown:(NSMutableArray *)arrLOB {
    NSArray *nameResponseArray = [arrLOB valueForKey:@"lobName"];
    self.lobDropDownTextField.field.mValues = [nameResponseArray mutableCopy];
    self.lobDropDownTextField.field.mDataList = [nameResponseArray mutableCopy];//[arrLOB mutableCopy];
    self.lobDropDownTextField.field.mTitle = @"BeatPlanLob";
    [self showDropDownForView:self.lobDropDownTextField];
}

#pragma mark - showLOBDropDown

- (void)showStateDropDown:(NSMutableArray *)arrLOB {
    NSArray *nameResponseArray = [arrLOB valueForKey:@"name"];
    self.stateTextField.field.mValues = [nameResponseArray mutableCopy];
    self.stateTextField.field.mDataList = [arrLOB mutableCopy];
    self.stateTextField.field.mTitle = @"BeatPlanState";

    [self showDropDownForView:self.stateTextField];
}

#pragma mark - showMicroMarketDropDown

- (void)showMicroMarketDropDown:(NSMutableArray *)arrLOB {
    self.microMarketTextField.field.mValues = [arrLOB mutableCopy];
    self.microMarketTextField.field.mDataList = [arrLOB mutableCopy];//[arrLOB mutableCopy];
    self.microMarketTextField.field.mTitle = @"BeatPlanMicroMarket";
    [self showDropDownForView:self.microMarketTextField];
}

#pragma mark - showdistrictDropDown

- (void)showDistrictDropDown:(NSMutableArray *)arrDistrict {
    self.districtDropDownTextField.field.mValues = [arrDistrict mutableCopy];
    self.districtDropDownTextField.field.mDataList = [arrDistrict mutableCopy];//[arrLOB mutableCopy];
    self.districtDropDownTextField.field.mTitle = @"BeatPlanDistrict";
    [self showDropDownForView:self.districtDropDownTextField];
}

#pragma mark - showdistrictDropDown

- (void)showCityDropDown:(NSMutableArray *)arrDistrict {
    self.city_TextField.field.mValues = [arrDistrict mutableCopy];
    self.city_TextField.field.mDataList = [arrDistrict mutableCopy];//[arrLOB mutableCopy];
    self.city_TextField.field.mTitle = @"BeatPlanCity";
    [self showDropDownForView:self.city_TextField];
}


#pragma mark - showDropDownForView

- (void)showDropDownForView:(DropDownTextField *)textField {
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:self withData:textField.field.mValues andModelData:textField.field.mDataList forView:textField withDelegate:self];
}

#pragma mark - textFieldDelegates

- (void)textFieldDidEndEditing:(UITextField*)textField{
    [textField resignFirstResponder];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    DropDownTextField *textField;
    textField = (DropDownTextField *)dropDownForView;
    textField.text = selectedValue;
    textField.field.mSelectedValue = selectedValue;

    if ([textField.field.mTitle isEqualToString:@"BeatPlanState"]) {
        _state = (EGState *)selectedObject;
        NSLog(@"Selected State : %@ %@",_state.name,_state.code);
        selectedStateName = textField.text;
        self.stateTextField.text = selectedStateName;
        [UtilityMethods resetDynamicField:self.lobDropDownTextField];
    }
    else if ([textField.field.mTitle isEqualToString:@"BeatPlanDistrict"]) {
        selectedDistrictName = textField.text;
        self.districtDropDownTextField.text = selectedDistrictName;
        [UtilityMethods resetDynamicField:self.city_TextField];
    }
    else if ([textField.field.mTitle isEqualToString:@"BeatPlanCity"]) {
        selectedCityName = textField.text;
        self.city_TextField.text = selectedCityName;
        [UtilityMethods resetDynamicField:self.microMarketTextField];
    }
    else if ([textField.field.mTitle isEqualToString:@"BeatPlanMicroMarket"]) {
        selectedMicroMarketName = textField.text;
        self.microMarketTextField.text = selectedMicroMarketName;
    }
}

#pragma mark - backButtonMethod

- (IBAction)backButtonMethod:(id)sender {
    [self resetAllFields];
    [self.view removeFromSuperview];
}

#pragma mark - AssignNewLocationToDSE

- (IBAction)assignLocationToDSE:(id)sender {
    NSString *errorMessage;

    if (_stateTextField.text.length != 0  &&
         _city_TextField.text.length != 0 && _districtDropDownTextField.text.length != 0 && _microMarketTextField.text.length != 0) {
        NSLog(@"Add New Data : %@ %@ %@ %@ %@",self.dsedata.dseId,selectedLOBName,selectedStateName,selectedDistrictName,selectedMicroMarketName);
            [self assignLocationToDSEAPICall];
            [self.view removeFromSuperview];
    }
    else
    {
        if (self.stateTextField.text.length == 0 ) {
            errorMessage = @"Please select State.";
        }
        else if (self.districtDropDownTextField.text.length == 0 ) {
            errorMessage = @"Please select District.";
        }
        else if (self.city_TextField.text.length == 0 ) {
            errorMessage = @"Please select City.";
        }
        else if (self.microMarketTextField.text.length == 0){
            errorMessage = @"Please select Micromarket.";
        }
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{}];
    }
}


- (IBAction)addNewLocationMethod:(id)sender {
    NSString *errorMessage;

    if (_stateTextField.text.length != 0 && _districtDropDownTextField.text.length != 0
        && _city_TextField.text.length != 0 && _city_TextField.text.length != 0 && _microMarketTextField.text.length != 0) {
        NSLog(@"Data :%@ %@ %@ %@",selectedLOBName,selectedStateName,selectedDistrictName,selectedMicroMarketName);
        [self resetAllFields];

    }
    else
    {
        if (self.stateTextField.text.length == 0 ) {
            errorMessage = @"Please select State.";
        }
        else if (self.microMarketTextField.text.length == 0){
            errorMessage = @"Please select Micromarket.";
        }
        //errorMessage = @"Make sure all textfields are selected.";
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{}];
    }
}


//actIndicatorForView
-(UIActivityIndicatorView *)actIndicatorForView:(UIView *)view{
    if(self.actIndicator) {
        return self.actIndicator;
    }else{
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.actIndicator setHidesWhenStopped:YES];
        CGFloat halfButtonHeight = view.bounds.size.height / 2;
        CGFloat buttonWidth = view.bounds.size.width;
        self.actIndicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    }
    return self.actIndicator;
}

//clearSelectedTalukadata
-(void)clearSelectedTalukadata{
    // self.taluka_Textfield.field.mValues = nil;
//    self.taluka_Textfield.text = nil;
   // self.district_TextField.text = nil;
    self.city_TextField.text = nil;
    selectedTalukaName = @"";
    selectedDistrictName = @"";
    selectedCityName = @"";

//    [self.taluka_Textfield hideDropDownFromView];
}

#pragma mark - Autocomplitionfunctinality of taluka text field End ***/

#pragma mark - FieldValidation


//TODO :
 - (BOOL)fieldInputValid:(UITextField *)currentTextField {
     BOOL hasValidInput = true;
     NSString *errorMessage;
 
    if (currentTextField == self.districtDropDownTextField && (self.stateTextField.text.length == 0 || self.stateTextField.text == nil ||[self.stateTextField.text  isEqual: @""]))//![self.lobDropDownTextField.text hasValue]
    {
         errorMessage = @"Please select State";
         hasValidInput = false;
    }
     else if (currentTextField == self.city_TextField && ( self.districtDropDownTextField.text.length == 0 || self.districtDropDownTextField.text.length == 0 || self.districtDropDownTextField.text.length == 0))
     {
         errorMessage = @"Please select District";
         hasValidInput = false;
     }
     else if (currentTextField == self.microMarketTextField &&  ( self.city_TextField.text.length == 0 || self.city_TextField.text.length == 0 || self.city_TextField.text.length == 0)) {
         errorMessage = @"Please select City";
         hasValidInput = false;
     }
 
 if (!hasValidInput && errorMessage) {
     [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{
 }];
 }
 
 return hasValidInput;
 }


//Set list setDistrictList
-(void)setDistrictList:(NSArray*)locationList{
    [UtilityMethods RunOnBackgroundThread:^{
        _districtDropDownTextField.field.mValues = [[locationList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        [UtilityMethods RunOnMainThread:^{
            [self showDistrictDropDown:_districtDropDownTextField.field.mValues];
        }];
    }];
}

//Set list setCityList
-(void)setCityList:(NSArray*)locationList{
    [UtilityMethods RunOnBackgroundThread:^{
        _city_TextField.field.mValues = [[locationList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        [UtilityMethods RunOnMainThread:^{
            [self showCityDropDown:_city_TextField.field.mValues];
        }];
    }];
}


//Set list setMMGEOList
-(void)setMMGEOList:(NSArray*)locationList{
    [UtilityMethods RunOnBackgroundThread:^{
        _microMarketTextField.field.mValues = [[locationList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        [UtilityMethods RunOnMainThread:^{
            //            [self showPopOver:_microMarketTextField];
            [self showMicroMarketDropDown: _microMarketTextField.field.mValues];
        }];
    }];
}

-(void)makeRedbox_mandatoryFields
{
    [UtilityMethods setRedBoxBorder:self.microMarketTextField];
    [UtilityMethods setRedBoxBorder:self.districtDropDownTextField];
    [UtilityMethods setRedBoxBorder:self.city_TextField];
}


-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.parentView addGestureRecognizer:tapRecognizer];
}

-(void)gestureHandlerMethod:(id)sender{
    [self.microMarketTextField resignFirstResponder];
    [self.districtDropDownTextField resignFirstResponder];
    [self.city_TextField resignFirstResponder];
}


@end
