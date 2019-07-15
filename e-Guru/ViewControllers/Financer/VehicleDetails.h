//
//  VehicleDetails.h
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierSectionView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface VehicleDetails : FinancierSectionView<UITextFieldDelegate>
{
    NSMutableArray* accountTypeArray;
    NSMutableArray* vehicleColorArray;
    NSMutableArray* emissionNormsArray;
    NSMutableArray* intendedApplicationArray;
    NSMutableArray* typeOfPropertyArray;
    NSMutableArray* customerTypeArray;
}

//@property (weak, nonatomic) IBOutlet GreyBorderUITextField *onRoadPriceTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *exShowRommPriceTextField;
//@property (weak, nonatomic) IBOutlet GreyBorderUITextField *vehicleClassTextField;
//@property (weak, nonatomic) IBOutlet DropDownTextField *accountTypeDropDownField;
//@property (weak, nonatomic) IBOutlet DropDownTextField *vehicleColorDropDown;
//@property (weak, nonatomic) IBOutlet DropDownTextField *emissionNormsDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *intendedApplicationDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *typeOfPropertyDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *customerTypeDropDown;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *onRoadPriceTextField;

@property (weak, nonatomic) IBOutlet UISwitch *onRoadPriceSwitch;
@property (weak, nonatomic) IBOutlet UIView *onRoadPriceVw;

//@property (nonatomic, strong) FinancierListDetailModel *financierFieldModel;
@property (strong, nonatomic) FinancierInsertQuoteModel *financierInsertQuoteModel;

- (IBAction)textFieldButtonClicked:(id)sender;

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData;

@end
