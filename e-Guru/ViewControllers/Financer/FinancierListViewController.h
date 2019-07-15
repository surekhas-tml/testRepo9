//
//  FinancierListViewController.h
//  e-guru
//
//  Created by Admin on 22/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedArray.h"
#import "EGOpportunity.h"

@interface FinancierListViewController : UIViewController
{
    EGPagedArray * opportunityPagedArray;
    BOOL radioButtonSelected;
    NSString *financierName;
    NSString *financierID;
    
}

@property (nonatomic, strong) NSString               *strFinancierOptyID;
//@property (nonatomic, strong) NSInteger              search_status;
@property (assign, nonatomic) DSMDSEOPTY             search_status;
@property (nonatomic, strong) EGOpportunity          *opportunity;

@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentStockLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitToCRMButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *helperButton;
- (IBAction)helperButtonClicked:(id)sender;

@end
