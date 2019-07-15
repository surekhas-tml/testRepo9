//
//  PersonalDetails.h
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FinancierSectionView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface PersonalDetails : FinancierSectionView <UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray* titleArray;
    NSMutableArray* genderArray;
    NSMutableArray* maritalArray;
    NSMutableArray* addresArray;
    NSMutableArray* religionArray;
    NSMutableArray* idTypeArray;
    NSMutableArray* relationTypeArray;
    
}
@property (weak, nonatomic) IBOutlet DropDownTextField *titleDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *genderDD;
@property (weak, nonatomic) IBOutlet DropDownTextField *maritalDD;
@property (weak, nonatomic) IBOutlet DropDownTextField *addressDD;
@property (weak, nonatomic) IBOutlet DropDownTextField *religionDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *relationTypeDropDownField;
@property (weak, nonatomic) IBOutlet DropDownTextField *idTypeDD;

@property (strong, nonatomic) IBOutlet UITextField *fatherNameTF;
@property (weak, nonatomic)  IBOutlet UITextField *idDescTF;

@property (weak, nonatomic)  IBOutlet UITextField *dobTextField;
@property (weak, nonatomic)  IBOutlet UITextField *issueTextField;
@property (weak, nonatomic)  IBOutlet UITextField *expiryTextField;
@property (weak, nonatomic) IBOutlet UITextField *fin_OccupationTF;
@property (weak, nonatomic) IBOutlet UITextField *occupationTF;
@property (weak, nonatomic) IBOutlet UITextField *partyAnualTF;

@property (nonatomic, strong) UIDatePicker *tappedView;
@property (nonatomic, strong) UIToolbar    *toolbar;

@property (nonatomic, strong) FinancierInsertQuoteModel *financierInsertQuoteModel;
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;

- (IBAction)textFieldButtonClicked:(id)sender;

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData;  //not in use

@end
