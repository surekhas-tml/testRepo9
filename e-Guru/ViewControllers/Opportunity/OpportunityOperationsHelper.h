//
//  OpportunityOperationsHelper.h
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilityMethods.h"
#import "EGOpportunity.h"
#import "AppDelegate.h"
#import "LinkCampaignView.h"
#import "AssignTO.h"
#import "EGRKWebserviceRepository.h"
#import "UserDetails.h"
#import "EGVCNumber.h"
#import "AppRepo.h"
#import "ManageOpportunityViewController.h"
#import "LostOpportunityViewController.h"


@protocol OpportunityOperationsHelperDelegate <NSObject>

@optional
- (void)optyAssignmentCompleted;

@end

@interface OpportunityOperationsHelper : NSObject<LinkCampaignViewDelegate,AssignTODelegate>

@property (weak,nonatomic) UIViewController* senderVC;
@property (weak, nonatomic) id<OpportunityOperationsHelperDelegate> delegate;

-(NSArray *)setActionsArrayForOpportunity:(EGOpportunity *)opportunity withTab:(NSString *)showOpty;
-(void)showCreateNewActivityViewOnOpportunity:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)showAvailbleCampaignListFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)getDSElist:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC showLoader:(BOOL)showLoader;
-(void)showPendingActivitiesListFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)openUpdateOpportunityViewFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)markOpportunityAsLostFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)createQuoteForOpportunityFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
-(void)openCreateNFARequestFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC;
- (void)openQuotationPreviewFor:(EGQuotation *)quotationObj opportunity:(EGOpportunity *)opportunityObj fromVC:(UIViewController *__weak)senderVC;

-(void)openFinancerViewFor:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC;
//@property (strong , nonatomic) EGOpportunity *opportunity;
@property (nonatomic, strong) EGFinancierOpportunity *financierOpportunity;


@property (nonatomic, strong) NSString *userCheck;



@end
