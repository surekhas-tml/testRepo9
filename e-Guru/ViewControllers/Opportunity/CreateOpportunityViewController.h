//
//  CreateOpportunityViewController.h
//  e-Guru
//
//  Created by Ashish Barve on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "CircularView.h"
#import "ProductSelectionViewController.h"
#import "MandatoryFieldsViewController.h"
#import "OptionalFieldsViewController.h"
#import "FinancierFieldViewController.h"          //new changes
#import "EGAccount.h"
#import "EGContact.h"
#import "EGOpportunity.h"
#import "AAAOpportunityMO+CoreDataClass.h"
#import "AAADraftMO+CoreDataClass.h"
#import "AAAContactMO+CoreDataClass.h"
#import "AAAAccountMO+CoreDataClass.h"

@interface CreateOpportunityViewController : UIViewController <UISplitViewControllerDelegate, ProductSelectionViewControllerDelegate, MandatoryFieldsViewControllerDelegate>{
    AppDelegate *appdelegate;
}

@property (weak, nonatomic) IBOutlet CircularView   *productSelectionTabNumber;
@property (weak, nonatomic) IBOutlet UIButton       *productSelectionTabButton;
@property (weak, nonatomic) IBOutlet CircularView   *mandatoryFieldsTabNumber;
@property (weak, nonatomic) IBOutlet UIButton       *mandatoryFieldsTabButton;
@property (weak, nonatomic) IBOutlet CircularView   *optionalFieldsTabNumber;
@property (weak, nonatomic) IBOutlet UIButton       *optionalFieldsTabButton;

@property (weak, nonatomic) IBOutlet CircularView   *financeFieldTabNumber;
@property (weak, nonatomic) IBOutlet UIButton       *financeFieldTabButton;

@property (weak, nonatomic) IBOutlet UIView         *containerView;

@property (strong, atomic)      EGAccount           *accountObject;
@property (strong, atomic)      EGContact           *contactObject;
@property (nonatomic, strong)   EGOpportunity       *opportunity;
@property (assign, nonatomic)   InvokeForOperation entryPoint;
@property (strong, atomic)      AAADraftMO *opportunityDraft;
//@property (strong, nonatomic)   NSString *commentsString;
@property (nonatomic, strong) EGActivity *activityObj;//--Carry the GTME Activity Data

@property (nonatomic, assign) BOOL isFromReferralOptyCreatioin;

@end
