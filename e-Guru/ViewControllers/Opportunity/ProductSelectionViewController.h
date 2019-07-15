//
//  CreateOpportunityViewController.h
//  e-Guru
//
//  Created by Juili on 27/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "SearchTextFieldBackgroundView.h"
#import "DropDownTextField.h"
#import "DropDownViewController.h"
#import "EGOpportunity.h"
#import "SearchTextField.h"
#import "EGPagedTableView.h"

@protocol ProductSelectionViewControllerDelegate <NSObject>

@required
- (void)productSelectionScreenNextButtonClicked;
- (void)opportunityModelChanged:(EGOpportunity *)newOpportuityModel;

@end

@interface ProductSelectionViewController : UIViewController {
    AppDelegate *appdelegate;
}

@property (weak, nonatomic) id<ProductSelectionViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *searchResultView;

@property (weak, nonatomic) IBOutlet EGPagedTableView *searchResultTableView;

@property (weak, nonatomic) IBOutlet SearchTextFieldBackgroundView *productSearchView;
@property (weak, nonatomic) IBOutlet SearchTextFieldBackgroundView *lobPPLPLSelectionView;

@property (weak, nonatomic) IBOutlet UIButton *productSelectionRadioButton;
@property (weak, nonatomic) IBOutlet UIButton *lobSelectionRadioButton;

@property (weak, nonatomic) IBOutlet DropDownTextField *lobDropDownTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *pplDropDownTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *plDropDownTextField;

@property (weak, nonatomic) IBOutlet SearchTextField *vcSearchTextField;

@property (nonatomic, strong) EGOpportunity *opportunity;
@property (nonatomic, assign) InvokeForOperation entryPoint;

@end
