//
//  RetailFinancierDetails.h
//  e-guru
//
//  Created by Shashi on 29/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierSectionView.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "UtilityMethods+UtilityMethodsValidations.h"

@interface RetailFinancierDetails : FinancierSectionView<UITextFieldDelegate>
{
        NSMutableArray* customerCategoryArray;
        NSMutableArray* customerSubCategoryArray;
}
@property (weak, nonatomic) IBOutlet DropDownTextField *customerCategoryDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *customerSubCategoryDropDown;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *repaymentModeTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *indicativeLoanTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *loanRepaymentTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *loanTenorTextField;
@property (weak, nonatomic) IBOutlet GreyBorderUITextField *ltvTextField;

@property (strong, nonatomic) FinancierInsertQuoteModel *financierInsertQuoteModel;

- (IBAction)textFieldButtonClicked:(id)sender;

- (void)bindDataToFieldsFromModel:(FinancierInsertQuoteModel *)fieldModelData;
@end
