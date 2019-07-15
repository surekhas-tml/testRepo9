//
//  AutoCompleteUITextField.h
//  e-Guru
//
//  Created by MI iMac01 on 16/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Field.h"

@protocol AutoCompleteUITextFieldDelegate
@optional
-(void)selectedActionSender:(id)sender;

@end
@interface AutoCompleteUITextField : UITextField<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL isTalukaActive;
}


@property (nonatomic, strong) Field *field;
@property (strong,nonatomic) UITableView * resultTableView;
@property (strong,nonatomic)NSArray * dropdownArray;
@property (strong,nonatomic)NSArray *resultArray;
@property (weak,nonatomic)id<AutoCompleteUITextFieldDelegate>autocompleteTableRowSelectedDelegate;
-(void)loadTableViewForTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray;
-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray;
-(void)loadTableViewForTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop;
-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop isFromBeatPlan:(BOOL)isFromBeatPlan;
-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop;
-(void)loadTableViewForFinancierTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop;

-(void)reloadDropdownList_ForString:(NSString *)string;
-(void)reloadDropdownList_ForTalukaString:(NSString *)string;

-(void)removeDropDownFromView;
-(void)hideDropDownFromView;
-(void)showDropDownFromView;
@end
