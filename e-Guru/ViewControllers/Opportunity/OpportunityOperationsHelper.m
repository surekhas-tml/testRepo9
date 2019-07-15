//
//  OpportunityOperationsHelper.m
//  e-Guru
//
//  Created by local admin on 11/29/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "OpportunityOperationsHelper.h"
#import "CreateOpportunityViewController.h"
#import "PendingActivitiesListViewController.h"
#import "LostOpportunityViewController.h"
#import "EGDse.h"
#import "CreateNFAViewController.h"
#import "QuotationPreviewViewController.h"
#import "FinancierFieldViewController.h"
#import "FinancierListViewController.h"

#define C1Quote @"C1 (Quote Tendered)"

@interface OpportunityOperationsHelper()<PendingActivitiesListViewControllerDelegate>
{
    EGPagedArray * opportunityPagedArray;
}

@property LinkCampaignView *linkCampaignView;
@property (strong) AssignTO *assignToView;

@end
@implementation OpportunityOperationsHelper
@synthesize linkCampaignView,assignToView, financierOpportunity;


# pragma mark - Create New Activity
-(void)showCreateNewActivityViewOnOpportunity:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    PendingActivitiesListViewController *pendingActivity;
    pendingActivity.delegate=self;
    [senderVC performSegueWithIdentifier:[@"CreateActivity" stringByAppendingString:SEGUE] sender:nil];
}

#pragma marl - Assign

-(void)getDSElist:(EGOpportunity *)opportunity fromVC:(__weak UIViewController *)senderVC showLoader:(BOOL)showLoader{

    self.senderVC = senderVC;

    [MBProgressHUD showHUDAddedTo:self.senderVC.view animated:YES];
    
    [[EGRKWebserviceRepository sharedRepository]getDSElist:@{
                                                            @"dsm_id": @""                                                                     } andSucessAction:^(id contact) {
                                                                [MBProgressHUD hideHUDForView:self.senderVC.view animated:YES];
                                                                
                                                                         self.assignToView = [[AssignTO  alloc]initWithFrame:CGRectMake(0, 0, 500, 350)];
                                                                self.assignToView.currentAssignment.text =  opportunity.leadAssignedName;
                                                                         assignToView.layer.borderWidth = 0.5f;
                                                                         assignToView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                                                                         if ([[[contact allValues] firstObject] count] > 0) {
                                                                             NSArray * dseArray = [[contact allValues] firstObject];
                                                                             self.assignToView.delegate = self;
                                                                             self.assignToView.center = CGPointMake(self.senderVC.view.center.x, self.senderVC.view.center.y - 90);
                                                                             [self.senderVC.view addSubview:self.assignToView];
                                                                             assignToView.opportunity = opportunity;
                                                                             self.assignToView.pickerViewArray = dseArray;
                                                                             [self.assignToView.pickerView reloadAllComponents];
                                                                         }else{
                                                                             [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
                                                                             
                                                                         }
                                                                         
                                                                         
                                                                         
                                                                     } andFailuerAction:^(NSError *error) {
                                                                         
                                                                         [MBProgressHUD hideHUDForView:self.senderVC.view animated:YES];
                                                                         
                                                                         [ScreenshotCapture takeScreenshotOfView:senderVC.view];
                                                                         AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                                                         appdelegate.screenNameForReportIssue = @"Get DSE List";

                                                                         [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                                             
                                                                         } andReportIssueAction:^{
                                                                             
                                                                         }];
                                                                     } showLoader:showLoader];
    
    
}
-(void)cancelAssignmentOperation{
    [self.assignToView removeFromSuperview];
}

-(void)assignToDSE:(EGDse *)dse{
    if (dse)
    {
        [[EGRKWebserviceRepository sharedRepository]assignOptyDSM:@{
                                                                   @"dse_id" : dse.leadid,
                                                                   @"dse_position" : dse.leadAssignedPositionName,
                                                                   @"dse_position_id" : dse.leadAssignedPositionID,
                                                                   @"dse_name" : dse.leadLogin,
                                                                  // @"opty_id" : @"1-7P9AW2Z"

                                                                   @"opty_id" : dse.toOpportunity.optyID
                                                                  } andSucessAction:^(NSDictionary *contact) {
                                                                       [self.assignToView removeFromSuperview];
                                                                      
                                                                      
                                                                      [UtilityMethods alert_ShowMessage:@"Opty Assigned Successfully"
                                                                                              withTitle:APP_NAME andOKAction:^{
                                                                                                  if (self.delegate && [self.delegate performSelector:@selector(optyAssignmentCompleted)]) {
                                                                                                      [self.delegate optyAssignmentCompleted];
                                                                                                  }
                                                                          
                                                                      }];
                                                                      if ([self.senderVC respondsToSelector:@selector(updateCollectionView)]){
                                                                          [self.senderVC performSelector:@selector(updateCollectionView)];
                                                                      }
                                                                      [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Assign_Opportunity_To_DSE_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_AssignToDSE_Successful];

                                                                   } andFailuerAction:^(NSError *error) {
                                                                       
                                                                       [ScreenshotCapture takeScreenshotOfView:self.assignToView];
                                                                       
                                                                       AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                                                       appdelegate.screenNameForReportIssue = @"Get DSE List";

                                                                       [self.assignToView removeFromSuperview];
                                                                       
//                                                                       [UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];
                                                                       [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                                           
                                                                       } andReportIssueAction:^{
                                                                           
                                                                       }];
                                                                       [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Assign_Opportunity_To_DSE_Assign_To_DSE_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_AssignToDSE_Failed];

                                                                       
                                                                   }];
    }
    
    NSLog(@"selected is from dsm");
    [assignToView removeFromSuperview];
}
# pragma mark - Link Campaign

//NSInteger val = _search_status;
//[queryParams setValue:[NSNumber numberWithInteger:val] forKey:@"search_status"];

-(void)showAvailbleCampaignListFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
//    NSInteger val = _search_status;
//    NSInteger val = _search_status;
    
    [[EGRKWebserviceRepository sharedRepository]getListOfCampaigns:@{
                                                                     @"plname": opportunity.toVCNumber.pl
    } andSucessAction:^(id contact) {
        
        self.linkCampaignView = [[LinkCampaignView alloc]initWithFrame:CGRectMake(0, 0, 500, 350)];
        linkCampaignView.layer.borderWidth = 0.5f;
        linkCampaignView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        if ([[[contact allValues] firstObject] count] > 0) {
            linkCampaignView.pickerArray = [[contact allValues] firstObject];
            linkCampaignView.delegate = self;
            linkCampaignView.center = CGPointMake(self.senderVC.view.center.x, self.senderVC.view.center.y - 90);
            [self.senderVC.view addSubview:self.linkCampaignView];
            linkCampaignView.opportunity = opportunity;
            [self.linkCampaignView.pickerView reloadAllComponents];
           
        }else{
            [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
        }
        
    } andFailuerAction:^(NSError *error) {
        
        [ScreenshotCapture takeScreenshotOfView:self.senderVC.view];
        AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appdelegate.screenNameForReportIssue = @"List Of Campaign";

        [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
            
        } andReportIssueAction:^{
            
        }];
    }];
}

-(void)cancelOperation{
    [self.linkCampaignView removeFromSuperview];
    NSLog(@"cancel");
}

-(void)linkCampaignOperationWithCampaign:(EGCampaign *)campaign{
    if (campaign)
    {
        [[EGRKWebserviceRepository sharedRepository]linkCampaign:@{
                                                                   @"contact_id" : campaign.toOpportunity.toContact.contactID,
                                                                   @"opty_id" : campaign.toOpportunity.optyID,
                                                                   @"campaign_id" : campaign.campaignID
                                                                   } andSucessAction:^(NSDictionary *contact) {
                                                                       [self.linkCampaignView removeFromSuperview];
                                                                       [UtilityMethods alert_ShowMessage:@"Campaign Linked Successfully" withTitle:APP_NAME andOKAction:nil];
                                                                       
                                                                       if ([self.senderVC respondsToSelector:@selector(updateCollectionView)]){
                                                                           [self.senderVC performSelector:@selector(updateCollectionView)];
                                                                       }
                                                                       [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Link_Campaign_Link_Campaign_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Link_Campaign_Successful];

                                                                       
                                                                   } andFailuerAction:^(NSError *error) {
                                                                       
                                                                       [ScreenshotCapture takeScreenshotOfView:self.linkCampaignView];
                                                                       AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                                                       appdelegate.screenNameForReportIssue = @"Link Compaign";

                                                                       [self.linkCampaignView removeFromSuperview];
                                                                       
                                                                       [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
                                                                           
                                                                       } andReportIssueAction:^{
                                                                           
                                                                       }];
                                                                       [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Link_Campaign_Link_Campaign_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:GA_EA_Link_Campaign_Failed];

                                                                   }];
    }
    
    [linkCampaignView removeFromSuperview];
    NSLog(@"selct");
    
    

}



# pragma mark - Pending Activities

-(void)showPendingActivitiesListFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    PendingActivitiesListViewController *p1;
    p1.opportunity=[EGOpportunity new];
    p1.opportunity=opportunity;
    [senderVC performSegueWithIdentifier:[@"PendingActivity" stringByAppendingString:SEGUE] sender:nil];
}

# pragma mark - Create New NFA Request

-(void)openCreateNFARequestFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    CreateNFAViewController *createNFA = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNFA_View"];
    createNFA.opportunity = opportunity;
    createNFA.entryPoint = NFAModeCreate;
    createNFA.invokedFromManageOpportunity = true;
    [senderVC.navigationController pushViewController:createNFA animated:YES];
}

# pragma mark - Update Opportunity;

-(void)openUpdateOpportunityViewFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    CreateOpportunityViewController *createOpty = [[UIStoryboard storyboardWithName:@"CreateOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"Create Opportunity_View"];
    createOpty.opportunity = opportunity;
    createOpty.entryPoint = InvokeForUpdateOpportunity;
    [senderVC.navigationController pushViewController:createOpty animated:YES];
}

# pragma mark - Lost Opportunity

-(void)markOpportunityAsLostFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    [senderVC performSegueWithIdentifier:[@"LostOpportunity" stringByAppendingString:SEGUE] sender:nil];
}

# pragma mark - Create Quote

-(void)createQuoteForOpportunityFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC{
    self.senderVC = senderVC;
    
    [UtilityMethods alert_showMessage:@"Are You sure you want to create Quote for this opportunity ?" withTitle:APP_NAME andOKAction:^{
        [[EGRKWebserviceRepository sharedRepository]createC1:
         @{@"contact_id": (opportunity.toContact.contactID !=nil) ? opportunity.toContact.contactID : @"",
           @"opty_id": (opportunity.optyID != nil) ? opportunity.optyID : @"",
           @"ppl": (opportunity.toVCNumber.ppl != nil) ? opportunity.toVCNumber.ppl : @"",
           @"pl": (opportunity.toVCNumber.pl !=nil) ? opportunity.toVCNumber.pl : @"",
           @"vc_number": (opportunity.toVCNumber.vcNumber != nil) ? opportunity.toVCNumber.vcNumber : @"",
           @"search_status":[NSNumber numberWithInt:1],
           @"product_quantity":opportunity.quantity
           }
                                             andSucessAction:^(NSDictionary *contact) {
                                                 opportunity.salesStageName = C1Quote;
                                                 [self quoteCreatedSuccessfully];
                                             } andFailuerAction:^(NSError *error) {
                                                 
                                                 [ScreenshotCapture takeScreenshotOfView:self.senderVC.view];
                                                 AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                                 appdelegate.screenNameForReportIssue = @"Create Quote";

                                                 [self quoteCreationFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
                                             }];
    } andNoAction:nil];
}




-(void)quoteCreatedSuccessfully{
    if ([self.senderVC respondsToSelector:@selector(updateCollectionView)]){
        [self.senderVC performSelector:@selector(updateCollectionView)];
    }else{
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UpdateScreen"
         object:self];
    }
    
    [UtilityMethods alert_ShowMessage:@"Quote Created successfully." withTitle:APP_NAME andOKAction:^(void){
        
            [self.senderVC.navigationController popViewControllerAnimated:YES];
        
        
    }];
}
    

-(void)quoteCreationFailedWithErrorMessage:(NSString *)errorMessage{
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}


#pragma mark - Email Quotation

- (void)openQuotationPreviewFor:(EGQuotation *)quotationObj opportunity:(EGOpportunity *)opportunityObj fromVC:(UIViewController *__weak)senderVC {
    self.senderVC = senderVC;
    [senderVC performSegueWithIdentifier:[@"QuotationPreview" stringByAppendingString:SEGUE] sender:nil];
}

#pragma mark - Financer
-(void)openFinancerViewFor:(EGOpportunity *)opportunity fromVC:(UIViewController *__weak)senderVC
{
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_ManageOpportunity_Financier_Button_Click withEventCategory:GA_CL_Opportunity withEventResponseDetails:nil];    
}

//-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
//    
//    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination *oportunity){
//        NSString  *offset = [queryParams objectForKey:@"offset"];
//        if ([offset integerValue] == 0) {
//            [opportunityPagedArray clearAllItems];
//        }
//        [self opportunitySearchedSuccessfully:oportunity];
//        
//    } andFailuerAction:^(NSError *error) {
//        [self opportunitySearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
//    }];
//}
//
//-(void)opportunitySearchFailedWithErrorMessage:(NSString *)errorMessage{
//    
//    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
//    appDelegate.screenNameForReportIssue = @"OPtional page financier button clicked";
//    
//    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
//        
//    } andReportIssueAction:^{
//        
//    }];
//    
//}

//-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
//    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
//    
//    if ([opportunityPagedArray count] == 0) {
//        NSLog(@"opportunityPagedArray count is :%@", opportunityPagedArray);
//    }else{
//        if(nil != opportunityPagedArray) {
//            self.financierOpportunity = [opportunityPagedArray objectAtIndex:0];
//            if (financierOpportunity.isQuoteSubmittedToFinancier) {
//                FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
//                vc.opportunity = self.opportunity;
//                [self.navigationController pushViewController:vc animated:YES] ;
//            } else {
//                FinancierFieldViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"Financer_View"];
//                vc.financierOpportunity = self.financierOpportunity;
//                [self.navigationController pushViewController:vc animated:YES] ;
//            }
//        }
//    }
//}


# pragma mark - Actions Allowed For Opportunity

-(NSArray *)setActionsArrayForOpportunity:(EGOpportunity *)opportunity withTab:(NSString *)showOpty{
    NSString * optyStage = opportunity.salesStageName;

    if ([[AppRepo sharedRepo] isDSMUser]) {
        
        if ([showOpty isEqualToString:@"My_Opportunity"]) {
            
            if ([optyStage containsString:LOST]) {
                return OPPTYACTIONFORLOST;
            }else if ([optyStage containsString:C0]) {
                return MYOPPTYACTIONSDSEC0;
            }else if ([optyStage containsString:C1A]){
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return MYOPPTYACTIONSDSEC1A;
                }
                else {
                    return MYOPPTYACTIONSDSEC1A_NO_NFA;
                }
            }else if ([optyStage containsString:C1]) {
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return MYOPPTYACTIONSDSEC1;
                }
                else {
                    return MYOPPTYACTIONSDSEC1_NO_NFA;
                }
            }else if ([optyStage containsString:C2]) {
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return MYOPPTYACTIONSDSEC2;
                }
                else {
                    return MYOPPTYACTIONSDSEC2_NO_NFA;
                }
            }
                
        }else{
            if ([optyStage containsString:LOST]) {
                return OPPTYACTIONFORLOST;
            }else if ([optyStage containsString:C0]) {
                return OPPTYACTIONSDSMC0;
            }else if ([optyStage containsString:C1A]) {
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return OPPTYACTIONSDSMC1A;
                }
                else {
                    return OPPTYACTIONSDSMC1A_NO_NFA;
                }
            }else if ([optyStage containsString:C1]) {
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return OPPTYACTIONSDSMC1;
                }
                else {
                    return OPPTYACTIONSDSMC1_NO_NFA;
                }
            }else if ([optyStage containsString:C2]) {
                if ([UtilityMethods canNFABeCreatedForOpportunity:opportunity]) {
                    return OPPTYACTIONSDSMC2;
                }
                else {
                    return OPPTYACTIONSDSMC2_NO_NFA;
                }
            }
        }
    }
    else {
        if ([optyStage containsString:LOST]) {
            return OPPTYACTIONFORLOST;
        }else if ([optyStage containsString:C0]) {
            return OPPTYACTIONSDSEC0;//MYOPPTYACTIONSDSEC0;
        }else if ([optyStage containsString:C1A]){
           //For preview option in C1A by shashi
            if (opportunity.is_quote_submitted_to_crm) {
                return OPPTYACTIONSDSEPREVIEWC1A;//MYOPPTYACTIONSDSEC1A;
            } else{
                return OPPTYACTIONSDSEC1A;
            }
            
        }else if ([optyStage containsString:C1]) {
            return OPPTYACTIONSDSEC1;//MYOPPTYACTIONSDSEC1;
        }else if ([optyStage containsString:C2]) {
            return OPPTYACTIONSDSEC2;//MYOPPTYACTIONSDSEC2;
        }
    }
    return [NSArray array];
}


@end
