//
//  HelperManualView.m
//  e-guru
//
//  Created by apple on 28/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "HelperManualView.h"

@implementation HelperManualView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        
        [[NSBundle mainBundle] loadNibNamed:@"HelperManualView" owner:self options:nil];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        //[self addGestureRecogniserToView];
        //appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

-(void)setViewAccordingToSelectedHelperView {
    
    switch (self.selectedViewType) {
       
        case helperManualSectionType_FinancierView:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_status"];
            self.reportTitle.text = @"Retail Financier Opportunity";
        }
            break;
        case helperManualSectionType_personalDetails:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_personal"];
            self.reportTitle.text = @"Personal Details";
        }
            break;
        case helperManualSectionType_ContactDetails:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_contact"];
            self.reportTitle.text = @"Contact Details";
        }
            break;
        case helperManualSectionType_AccountDetails:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_account"];
            self.reportTitle.text = @"Account Details";
        }
            break;
        case helperManualSectionType_vehOptyDetails:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_vehicle_opty"];
            self.reportTitle.text = @"Vehicle/Opty Details";
        }
            break;
        case helperManualSectionType_RetailFinanceDetails:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_loan"];
            self.reportTitle.text = @"Retail Financier Details";
        }
            break;
        case helperManualSectionType_CRM:
        {
            self.reportImage.image = [UIImage imageNamed:@"h_crm"];
            self.reportTitle.text = @"Update Retail Financier";
        }
            break;
        
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)closeButtonClick:(id)sender {
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromLeft;
    animation.duration = 0.2;
    [self.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:self
                      duration:0.8
                       options:UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        [self setHidden:!self.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@" manual hidden!!!");
                    }];
}
@end
