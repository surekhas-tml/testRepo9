//
//  OpportunityDetailsViewController.h
//  e-Guru
//
//  Created by Juili on 04/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"
#import "EGOpportunity.h"
#import "OpportunityOperationsHelper.h"
#import "LostOpportunityViewController.h"
#import "NewActivityViewController.h"
#import "PendingActivitiesListViewController.h"
#import "Constant.h"
#import "DropDownTextField.h"

@interface OpportunityDetailsViewController : UIViewController<UISplitViewControllerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dsenamevalue;
@property (weak, nonatomic) IBOutlet UILabel *dsenamelbl;
@property (weak, nonatomic) IBOutlet UILabel *opportunityName;
@property (weak, nonatomic) IBOutlet UILabel *opportunityID;
@property (weak, nonatomic) IBOutlet UILabel *salesStage;
@property (weak, nonatomic) IBOutlet UILabel *salesStageDate;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *financerName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *contactNAme;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *contactAddress;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountContactNumeber;
@property (weak, nonatomic) IBOutlet DropDownTextField *opportunityActionSelector;
@property (weak, nonatomic) IBOutlet UIView *contatainerView;

@property (assign, nonatomic) DSMDSEACTIVITY isdsmdseactivity1;
@property (weak, nonatomic) IBOutlet UILabel *activityType;
@property (weak, nonatomic) IBOutlet UILabel *activityDate;
@property (weak, nonatomic) IBOutlet UILabel *activityComments;

@property (weak, nonatomic) IBOutlet UILabel *doneActivityType;
@property (weak, nonatomic) IBOutlet UILabel *doneActivityDate;
@property (weak, nonatomic) IBOutlet UILabel *doneActivityComments;

@property (weak, nonatomic) IBOutlet UILabel *salesStageLabel; //for showing salesStage

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *plLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@property (weak, nonatomic) IBOutlet UIView *doneActivityLoaderView;
@property (weak, nonatomic) IBOutlet UIView *pendingActivityLoaderView;

@property (strong, nonatomic) NSString *showOpty;

@property EGOpportunity * opportunity;
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;

@end
