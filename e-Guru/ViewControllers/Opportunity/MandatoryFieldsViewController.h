//
//  MandatoryFieldsViewController.h
//  e-Guru
//
//  Created by MI iMac04 on 24/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"
#import "EGOpportunity.h"
#import "EGActivity.h"
#import "PrimaryField.h"
#import "BlueUIButton.h"
#import "AppDelegate.h"
#import "AAAOpportunityMO+CoreDataClass.h"
#import "AAAActivityMO+CoreDataClass.h"
#import "AAADraftMO+CoreDataClass.h"
#import "AAAContactMO+CoreDataClass.h"
#import "UpdateActivityViewController.h"
#import "AAAVCNumberMO+CoreDataClass.h"
#import "AAAMMGeographyMO+CoreDataClass.h"
#import "AAAReferralCustomerMO+CoreDataClass.h"
#import "AAATGMMO+CoreDataClass.h"
#import "AAAFinancerMO+CoreDataClass.h"


@protocol MandatoryFieldsViewControllerDelegate <NSObject>

@required
- (void)mandatoryFieldsScreenSubmitButtonClicked;

@end

@interface MandatoryFieldsViewController : UIViewController <UITextFieldDelegate, DropDownViewControllerDelegate> {
    AppDelegate *appdelegate;
}

@property (weak, nonatomic) id<MandatoryFieldsViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *selectedLOBLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPPLLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPLLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedVCNumLabel;
@property (weak, nonatomic) IBOutlet BlueUIButton *saveAsDraftButton;
@property (nonatomic, strong) EGActivity *activity,*activityObj;
@property (nonatomic, strong) EGOpportunity *opportunity;
@property (nonatomic, strong) PrimaryField *primaryField;
@property (nonatomic, assign) InvokeForOperation entryPoint;
@property (nonatomic, assign) BOOL isFromReferralOptyCreatioin;
//@property (strong, nonatomic)   NSString *commentsString;


@end
