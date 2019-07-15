//
//  HelperManualView.h
//  e-guru
//
//  Created by apple on 28/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    helperManualSectionType_FinancierView,
    helperManualSectionType_personalDetails,
    helperManualSectionType_ContactDetails,
    helperManualSectionType_AccountDetails,
    helperManualSectionType_vehOptyDetails,
    helperManualSectionType_RetailFinanceDetails,
    helperManualSectionType_CRM
} HelperManualSectionType;


@interface HelperManualView : UIView

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *reportTitle;
@property (weak, nonatomic) IBOutlet UIImageView *reportImage;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (assign, nonatomic) HelperManualSectionType selectedViewType;

- (IBAction)closeButtonClick:(id)sender;
-(void)setViewAccordingToSelectedHelperView;

@end
