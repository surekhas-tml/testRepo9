//
//  DraftsViewController.m
//  e-Guru
//
//  Created by Apple on 29/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DraftsViewController.h"
#import "HHSlideView.h"
#import "ProspectViewController+CreateContact.h"
#import "ContactCollectionViewCell.h"
#import "AccountCollectionViewCell.h"
#import "FinancierCollectionViewCell.h"
#import "opportunityCollectionViewCell.h"
#import "ProspectViewController+CreateContact.h"
#import "FinancierRequestViewController+CreateFinancier.h"
#import "FinancierRequestViewController.h"

#import "FinancierInsertQuoteModel.h"

#import "EGDraftStatus.h"
#import "NSString+NSStringCategory.h"

@interface DraftsViewController () <HHSlideViewDelegate>{
    AppDelegate *appdelegate;
}
@property (strong) NSMutableArray *contactinfoarray;
@property (strong) NSMutableArray *accountinfoarray;
@property (strong) NSMutableArray *financierinfoarray;
@property (strong) NSMutableArray *opportunitytinfoarray;


@end

@implementation DraftsViewController
UILabel *lbl;

HHSlideView *slideView;
@synthesize contact_view,account_view,opportunity_view, financier_view,collectionView_contact,collectionView_account,collectionView_opportunity,collectionView_financier,contactinfoarray,accountinfoarray,opportunitytinfoarray, financierinfoarray,drafts_not_availble_view,notavailbledrafts;


#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _insertQuoteModel = [[FinancierInsertQuoteModel alloc] init];
    
    // Do not remove this AppDelegate Object instantiation
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.title = self.detailsObj;
//    [self fetchAllDrafts];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated{
	[self fetchAllDrafts];
    [self configureView];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOpportunityDraftValueChanged:) name:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountDraftValueChanged:) name:NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactDraftValueChanged:) name:NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFinancierDraftValueChanged:) name:NOTIFICATION_FINANCIER_DRAFT_VALUE_CHANGED object:nil]; //new
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DRAFT_VALUE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ACCOUNT_DRAFT_VALUE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONTACT_DRAFT_VALUE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_FINANCIER_DRAFT_VALUE_CHANGED object:nil];
}

-(void)fetchAllDrafts{
    NSError *error;
    
    NSPredicate *predicateUserId = [NSPredicate predicateWithFormat:@"userIDLink == %@", [[AppRepo sharedRepo] getLoggedInUser].userName];
    NSPredicate *predicateStatus = [NSPredicate predicateWithFormat:@"status!=%d",EGDraftStatusSyncSuccess];
    NSPredicate *predicateSearch = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateUserId, predicateStatus]];
    
    NSFetchRequest *requestDrafts = [AAADraftMO fetchRequest];
    [requestDrafts setPredicate:predicateSearch];
    
    NSFetchRequest *requestAccount = [AAADraftAccountMO fetchRequest];
    NSFetchRequest *requestContact = [AAADraftContactMO fetchRequest];
    NSFetchRequest *requestFinancier = [AAADraftFinancierMO fetchRequest];// new financier draft
    
    NSPredicate *predicateDraft = [NSPredicate predicateWithFormat:@"SELF.userIDLink == %@", [[AppRepo sharedRepo] getLoggedInUser].userName];
    [requestAccount setPredicate:predicateDraft];
    [requestContact setPredicate:predicateDraft];
    
    
    contactinfoarray = [NSMutableArray arrayWithArray:[appdelegate.managedObjectContext executeFetchRequest:requestContact error:&error]];
    opportunitytinfoarray = [NSMutableArray arrayWithArray:[appdelegate.managedObjectContext executeFetchRequest:requestDrafts error:&error]];
    accountinfoarray = [NSMutableArray arrayWithArray:[appdelegate.managedObjectContext executeFetchRequest:requestAccount error:&error]];
    financierinfoarray = [NSMutableArray arrayWithArray:[appdelegate.managedObjectContext executeFetchRequest:requestFinancier error:&error]];  //for financier
    
    if (error == nil) {
        [self.collectionView_contact reloadData];
        [self.collectionView_account reloadData];
        [self.collectionView_opportunity reloadData];
        [self.collectionView_financier reloadData];  //new
    }else{
        [UtilityMethods alert_ShowMessage:@"Can not read Drafts..." withTitle:APP_NAME andOKAction:nil];
    }
}

-(void)reloaAllCollectionView{
    [self fetchAllDrafts];
    [self.collectionView_opportunity reloadData];
    [self.collectionView_account reloadData];
    [self.collectionView_contact reloadData];
    [self.collectionView_financier reloadData]; //new
}

- (void)configureView {
    // Update the user interface for the detail item.
    contact_view.hidden=YES;
    account_view.hidden=YES;
    financier_view.hidden = YES;  //new
    opportunity_view.hidden=NO;
    
    slideView = [[HHSlideView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    slideView.slideFont = [UIFont systemFontOfSize:16];
    
    slideView.delegate = self;
    [self.view addSubview:slideView];
    
    [UtilityMethods navigationBarSetupForController:self];
    if([opportunitytinfoarray count]==0)
    {
        drafts_not_availble_view.hidden=NO;
        notavailbledrafts.text=@"No Opportunity record saved as draft";
    }
    else
    {
        drafts_not_availble_view.hidden=YES;
         notavailbledrafts.text=@"";
    }
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 310, 44)];
    lbl.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
    lbl.text=@"Opportunity";
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Opportunity];

    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl setFont:[UIFont systemFontOfSize:16]];
    
    [lbl setTextColor:[UIColor navBarColor]];
    [self.view addSubview:lbl];

}
#pragma mark - core Data

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Fetch the devices from persistent data store
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

#pragma mark - HHSlideViewDelegate

- (NSInteger)numberOfSlideItemsInSlideView:(HHSlideView *)slideView {
    
    return 4;
}

- (NSArray *)namesOfSlideItemsInSlideView:(HHSlideView *)slideView {
    return  @[ E_OPPORTUNITY,E_CONTACT, E_ACCOUNT,E_FINANCER];
}

- (void)slideView:(HHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
   
    switch (index) {
            
        case 0:
        {
            if([opportunitytinfoarray count]==0)
            {
                drafts_not_availble_view.hidden=NO;
                notavailbledrafts.text=@"No Opportunity record saved as draft";
            }
            else {
                drafts_not_availble_view.hidden=YES;
                contact_view.hidden=YES;
                account_view.hidden=YES;
                financier_view.hidden = YES;
                notavailbledrafts.text=@"";
                opportunity_view.hidden=NO;
                [self.collectionView_opportunity reloadData];
            }
            [lbl removeFromSuperview];
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 250, 42)];
            lbl.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lbl.text=@"Opportunity";
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl setFont:[UIFont systemFontOfSize:16]];
            
            [lbl setTextColor:[UIColor navBarColor]];
            [slideView addSubview:lbl];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Opportunity];
        }
            break;

        case 1:
        {
            if([contactinfoarray count]==0)
            {
                drafts_not_availble_view.hidden = NO;
                notavailbledrafts.text=@"No Contact record saved as draft";
            }
            else {
                drafts_not_availble_view.hidden = YES;
                opportunity_view.hidden = YES;
                contact_view.hidden = NO;
                account_view.hidden = YES;
                financier_view.hidden = YES;
                 notavailbledrafts.text=@"";
                [self.collectionView_contact reloadData];
            }
            [lbl removeFromSuperview];
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(280, 8, 250, 42)];
            lbl.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lbl.text=@"Contact";
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl setFont:[UIFont systemFontOfSize:16]];
            [lbl setTextColor:[UIColor navBarColor]];
            [slideView addSubview:lbl];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Contact];

        }
            break;
        case 2:
        {
            if([accountinfoarray count]==0)
            {
                drafts_not_availble_view.hidden=NO;
                notavailbledrafts.text=@"No Account record saved as draft";
            }
            else {
                drafts_not_availble_view.hidden=YES;
                opportunity_view.hidden=YES;
                contact_view.hidden=YES;
                financier_view.hidden = YES;
                account_view.hidden=NO;
                notavailbledrafts.text=@"";
                [self.collectionView_account reloadData];
                
            }
            [lbl removeFromSuperview];
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(500, 8, 250, 42)];
            lbl.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lbl.text=@"Account";
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl setFont:[UIFont systemFontOfSize:16]];
            [lbl setTextColor:[UIColor navBarColor]];
            [slideView addSubview:lbl];
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Account];
            break;
            
        }
        case 3:
        {
            if([financierinfoarray count]==0)
            {
                drafts_not_availble_view.hidden = NO;
                notavailbledrafts.text=@"No Financier record saved as draft";
            } else {
                drafts_not_availble_view.hidden = YES;
                opportunity_view.hidden = YES;
                account_view.hidden = YES;
                contact_view.hidden = YES;
                financier_view.hidden = NO;
                notavailbledrafts.text=@"";
                [self.collectionView_financier reloadData];
            }
            
            [lbl removeFromSuperview];
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(750, 8, 250, 42)];
            lbl.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lbl.text=@"Retail Financier";
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl setFont:[UIFont systemFontOfSize:16]];
            [lbl setTextColor:[UIColor navBarColor]];
            [slideView addSubview:lbl];
//            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Drafts_Contact];
        }
            
            break;
               default:
            break;
    }
}

- (NSArray *)childViewControllersInSlideView:(HHSlideView *)slideView {
    
    UIViewController *subVC_1 = [[UIViewController alloc] init];
    UIViewController *subVC_2 = [[UIViewController alloc] init];
    UIViewController *subVC_3 = [[UIViewController alloc] init];
    UIViewController *subVC_4 = [[UIViewController alloc] init];
    
    NSArray *childViewControllersArray = @[subVC_1, subVC_2, subVC_3, subVC_4];
    return childViewControllersArray;
}

- (UIColor *)colorOfSlideView:(HHSlideView *)slideView {
    return [UIColor tableHeaderColor];
}

- (UIColor *)colorOfSliderInSlideView:(HHSlideView *)slideView {
    return [UIColor clearColor];
}

#pragma mark - CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView_account)
    {
        return self.accountinfoarray.count;
    }
    else if(collectionView == self.collectionView_contact)
    {
        return self.contactinfoarray.count;
    }
    else if (collectionView == self.collectionView_financier)   //new
    {
        return self.financierinfoarray.count;
    }
    else
    {
        return opportunitytinfoarray.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
     if (collectionView == self.collectionView_account)
     {
         AccountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellAccount" forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[AccountCollectionViewCell alloc]init];
         }
         cell.tag = indexPath.row;
         cell.deleteAccount.tag = indexPath.row;
         [cell.deleteAccount addTarget:self action:@selector(delete_Action_Account:) forControlEvents:UIControlEventTouchUpInside];
         AAADraftAccountMO *accountDraft = [self.accountinfoarray objectAtIndex:indexPath.row];
         cell.siteName.text = [accountDraft valueForKeyPath:@"toAccount.site"];
         cell.mainPhoneNumberData.text = [accountDraft valueForKeyPath:@"toAccount.contactNumber"];
         cell.accoutnNameData.text = [accountDraft valueForKeyPath:@"toAccount.accountName"];
         cell.pan_no_data.text=[[accountDraft valueForKeyPath:@"toAccount.accountPAN"]length] == 0 ? @"Not Available" : [accountDraft valueForKeyPath:@"toAccount.accountPAN"];
    
         NSSet *contactsSet = [accountDraft valueForKeyPath:@"toAccount.toContact"];
         
         AAAContactMO *contact = [[contactsSet allObjects] firstObject];
         
         cell.fnamedata.text=[[contact valueForKey:@"firstName"] length] == 0 ? @"Not Available" : [contact valueForKeyPath:@"firstName"];
         cell.lnamedata.text=[[contact valueForKey:@"lastName"]length] == 0 ? @"Not Available" : [contact valueForKeyPath:@"lastName"];

         cell.mobilenumberdata.text=[[contact valueForKey:@"contactNumber"]length] == 0 ? @"Not Available" : [contact valueForKeyPath:@"contactNumber"];

         cell.emaildata.text=[[contact valueForKey:@"emailID"]length] == 0 ? @"Not Available" : [contact valueForKeyPath:@"emailID"];
         
         EGDraftStatus egDraftStatus = (EGDraftStatus)accountDraft.status;
         cell.statusLabel.text = [self getOptyStatusStringFrom:egDraftStatus];

         return cell;
     }

     else if (collectionView == self.collectionView_contact)
     {
         ContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellContact" forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[ContactCollectionViewCell alloc]init];
         }
         cell.tag = indexPath.row;
         cell.deleteButton.tag = indexPath.row;
         [cell.deleteButton addTarget:self action:@selector(delete_Action_contact:) forControlEvents:UIControlEventTouchUpInside];
         
         AAADraftContactMO *contactDraft = [self.contactinfoarray objectAtIndex:indexPath.row];
         cell.firstNameData.text = [[contactDraft valueForKeyPath:@"toContact.firstName"] length] == 0 ? @"Not Available" : [contactDraft valueForKeyPath:@"toContact.firstName"];
         
         cell.lastNameData.text = [[contactDraft valueForKeyPath:@"toContact.lastName"] length] == 0 ? @"Not Available" : [contactDraft valueForKeyPath:@"toContact.lastName"];
         
         cell.emailData.text = [[contactDraft valueForKeyPath:@"toContact.emailID"] length] == 0 ? @"Not Available" : [contactDraft valueForKeyPath:@"toContact.emailID"];
         
         cell.contactNumberdraftContact.text = [[contactDraft valueForKeyPath:@"toContact.contactNumber"]length] == 0 ? @"Not Available" : [contactDraft valueForKeyPath:@"toContact.contactNumber"];
        
         cell.panNoData.text = [[contactDraft valueForKeyPath:@"toContact.panNumber"]length] == 0 ? @"Not Available" : [contactDraft valueForKeyPath:@"toContact.panNumber"];
         
         EGDraftStatus egDraftStatus = (EGDraftStatus)contactDraft.status;
         cell.statusLabel.text = [self getOptyStatusStringFrom:egDraftStatus];
         
         return cell;
     }
    //financier Collection view
     else if (collectionView == self.collectionView_financier)
     {
         FinancierCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellFinancier" forIndexPath:indexPath];
         if (cell == nil) {
             cell = [[FinancierCollectionViewCell alloc]init];
         }
         cell.tag = indexPath.row;
         cell.deleteButton.tag = indexPath.row;
         [cell.deleteButton addTarget:self action:@selector(delete_Action_Financier:) forControlEvents:UIControlEventTouchUpInside];//
        
         AAADraftFinancierMO *financierDraft = [self.financierinfoarray objectAtIndex:indexPath.row];
         
         cell.firstName.text = [[financierDraft valueForKeyPath:@"toInsertQuote.first_name"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.first_name"];
         cell.lastName.text = [[financierDraft valueForKeyPath:@"toInsertQuote.last_name"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.last_name"];
         cell.financieName.text = [[financierDraft valueForKeyPath:@"toInsertQuote.financier_name"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.financier_name"];
         cell.optyID.text = [[financierDraft valueForKeyPath:@"toInsertQuote.opty_id"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.opty_id"];
         cell.mobileNo.text = [[financierDraft valueForKeyPath:@"toInsertQuote.mobile_no"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.mobile_no"];
         cell.productName.text = [[financierDraft valueForKeyPath:@"toInsertQuote.pl"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.pl"];
         cell.salesStage.text = [[financierDraft valueForKeyPath:@"toInsertQuote.sales_stage_name"] length] == 0 ? @"-" : [financierDraft valueForKeyPath:@"toInsertQuote.sales_stage_name"]; // need to change
//         cell.statusLabel.text = [[financierDraft valueForKeyPath:@"toInsertQuote.first_name"] length] == 0 ? @"Not Available" : [financierDraft valueForKeyPath:@"toInsertQuote.first_name"];
         
         EGDraftStatus egDraftStatus = (EGDraftStatus)financierDraft.status;
         cell.statusLabel.text = [self getOptyStatusStringFrom:egDraftStatus];
         
         return cell;
         
     }
      else {
        opportunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellOpportunity" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[opportunityCollectionViewCell alloc]init];
        }
        cell.tag = indexPath.row;
        cell.deleteOptyDraft.tag = indexPath.row;
        [cell.deleteOptyDraft addTarget:self action:@selector(delete_Action_Opportunity:) forControlEvents:UIControlEventTouchUpInside];
        AAADraftMO *optyDraft = [opportunitytinfoarray objectAtIndex:indexPath.row];
        
        cell.optyEmail.text = [[optyDraft valueForKeyPath:@"toOpportunity.toContact.emailID"]length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toContact.emailID"] ;
        
        cell.opportunitymobilenodata.text = [[optyDraft valueForKeyPath:@"toOpportunity.toContact.contactNumber"]length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toContact.contactNumber"] ;
        
        cell.optyPL.text = [[optyDraft valueForKeyPath:@"toOpportunity.toVC.lob"] length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toVC.pl"] ;

         cell.optyPPL.text = [[optyDraft valueForKeyPath:@"toOpportunity.toVC.ppl"]length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toVC.ppl"] ;
       
        cell.optyLOB.text = [[optyDraft valueForKeyPath:@"toOpportunity.toVC.lob"] length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toVC.lob"] ;
        
        cell.optyApplication.text = [[optyDraft valueForKeyPath:@"toOpportunity.toLobInfo.vehicleApplication"] length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toLobInfo.vehicleApplication"] ;
		
        NSString *fname = [[optyDraft valueForKeyPath:@"toOpportunity.toContact.firstName"] length] == 0 ? @"Not Available" : [optyDraft valueForKeyPath:@"toOpportunity.toContact.firstName"] ;
        NSString *lname = [[optyDraft valueForKeyPath:@"toOpportunity.toContact.lastName"]length] == 0 ? @"" : [optyDraft valueForKeyPath:@"toOpportunity.toContact.lastName"] ;
        fname = [fname stringByAppendingString:@" "];
        cell.accountname.text = [fname stringByAppendingString:lname];
		
		//Opty Draft Status
		EGDraftStatus egDraftStatus = (EGDraftStatus)optyDraft.status;
		cell.optyStatus.text = [self getOptyStatusStringFrom:egDraftStatus];
	
		//TODO - Based on condition ... check the visibility
//		if (egDraftStatus == EGDraftStatusSyncing) {
//			[cell.activityIndicator setHidden:NO];
//		} else {
			[cell.activityIndicator stopAnimating];
			[cell.activityIndicator setHidden:YES];
//		}
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView_contact) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateNewProspect" bundle: nil];
        ProspectViewController *tempCreateContactVC = (ProspectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create New Prospect_View"];
        tempCreateContactVC.detailsObj = PROSPECT_CONTACT;
        tempCreateContactVC.entryPoint = DRAFT;
        tempCreateContactVC.draftContact = [self.contactinfoarray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:tempCreateContactVC animated:YES];
        
    }else if (collectionView == self.collectionView_account){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateNewProspect" bundle: nil];
        ProspectViewController *tempCreateAccountVC = (ProspectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create New Prospect_View"];
        tempCreateAccountVC.detailsObj = PROSPECT_ACCOUNT;
        tempCreateAccountVC.entryPoint = DRAFT;
        tempCreateAccountVC.draftAccount = [self.accountinfoarray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:tempCreateAccountVC animated:YES];
        
    }
    //new
    else if (collectionView == self.collectionView_financier){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle: nil];
        FinancierRequestViewController *financierVC = (FinancierRequestViewController *) [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//        financierVC.detailsObj = RETAIL_FINANCIER;
        financierVC.entryPoint = DRAFT;
        AAADraftFinancierMO *financierDraft = [self.financierinfoarray objectAtIndex:indexPath.row];//have tocheck why use this
        financierVC.draftFinancier = [self.financierinfoarray objectAtIndex:indexPath.row]; //for sending draft's data to next
        financierVC.insertQuoteModel = [self bindInsertQuoteData:financierDraft];
        [self.navigationController pushViewController:financierVC animated:YES];
    }
    else if (collectionView == self.collectionView_opportunity){
		AAADraftMO *optyDraft = [opportunitytinfoarray objectAtIndex:indexPath.row];
		//Opty Draft Status
		EGDraftStatus egDraftStatus = (EGDraftStatus)optyDraft.status;
		if (egDraftStatus == EGDraftStatusQueuedToSync || egDraftStatus == EGDraftStatusSyncing || egDraftStatus == EGDraftStatusDefault) {
			//DO NOTHING
		} else {
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateOpportunity" bundle: nil];
			
			CreateOpportunityViewController *tempCreateOptyVC = (CreateOpportunityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Create Opportunity_View"];
			tempCreateOptyVC.entryPoint = InvokeForDraftEdit;
			tempCreateOptyVC.opportunityDraft = optyDraft;
			[self.navigationController pushViewController:tempCreateOptyVC animated:YES];
		}
    }
}

-(FinancierInsertQuoteModel *)bindInsertQuoteData:(AAADraftFinancierMO *)financierDraft {
    
    FinancierInsertQuoteModel *insertQuoteModel = [FinancierInsertQuoteModel new];
    insertQuoteModel.financierTMFBDMDetailsArray = [financierDraft valueForKeyPath:@"toInsertQuote.financierTMFBDMDetailsArray"];
    insertQuoteModel.financier_name = [financierDraft valueForKeyPath:@"toInsertQuote.financier_name"];
    insertQuoteModel.financier_id = [financierDraft valueForKeyPath:@"toInsertQuote.financier_id"];
    insertQuoteModel.branch_name = [financierDraft valueForKeyPath:@"toInsertQuote.branch_name"];
    insertQuoteModel.branch_id = [financierDraft valueForKeyPath:@"toInsertQuote.branch_id"];
    insertQuoteModel.bdm_name = [financierDraft valueForKeyPath:@"toInsertQuote.bdm_name"]; 
    insertQuoteModel.bdm_id = [financierDraft valueForKeyPath:@"toInsertQuote.bdm_id"]; //new
    insertQuoteModel.bdm_mobile_no = [financierDraft valueForKeyPath:@"toInsertQuote.bdm_mobile_no"]; //new
    
    insertQuoteModel.relation_type = [financierDraft valueForKeyPath:@"toInsertQuote.relation_type"];
    insertQuoteModel.organization = [financierDraft valueForKeyPath:@"toInsertQuote.organization"] ;
    insertQuoteModel.title = [financierDraft valueForKeyPath:@"toInsertQuote.title"] ;
    insertQuoteModel.father_mother_spouse_name =[financierDraft valueForKeyPath:@"toInsertQuote.father_mother_spouse_name"];
    insertQuoteModel.gender = [financierDraft valueForKeyPath:@"toInsertQuote.gender"];
    insertQuoteModel.first_name = [financierDraft valueForKeyPath:@"toInsertQuote.first_name"] ;
    insertQuoteModel.last_name = [financierDraft valueForKeyPath:@"toInsertQuote.last_name"] ;
    insertQuoteModel.mobile_no = [financierDraft valueForKeyPath:@"toInsertQuote.mobile_no"] ;
    insertQuoteModel.religion = [financierDraft valueForKeyPath:@"toInsertQuote.religion"];
    insertQuoteModel.address_type = [financierDraft valueForKeyPath:@"toInsertQuote.address_type"];
    insertQuoteModel.address1 = [financierDraft valueForKeyPath:@"toInsertQuote.address1"];
    insertQuoteModel.address2 = [financierDraft valueForKeyPath:@"toInsertQuote.address2"];
    insertQuoteModel.area =[financierDraft valueForKeyPath:@"toInsertQuote.area"];
    insertQuoteModel.city_town_village = [financierDraft valueForKeyPath:@"toInsertQuote.city_town_village"];
    insertQuoteModel.state = [financierDraft valueForKeyPath:@"toInsertQuote.state"];
    insertQuoteModel.district = [financierDraft valueForKeyPath:@"toInsertQuote.district"];
    insertQuoteModel.pincode = [financierDraft valueForKeyPath:@"toInsertQuote.pincode"];
    insertQuoteModel.date_of_birth = [financierDraft valueForKeyPath:@"toInsertQuote.date_of_birth"];
    insertQuoteModel.customer_category = [financierDraft valueForKeyPath:@"toInsertQuote.customer_category"];
    insertQuoteModel.customer_category_subcategory = [financierDraft valueForKeyPath:@"toInsertQuote.customer_category_subcategory"];
    insertQuoteModel.partydetails_maritalstatus = [financierDraft valueForKeyPath:@"toInsertQuote.partydetails_maritalstatus"];
    insertQuoteModel.intended_application = [financierDraft valueForKeyPath:@"toInsertQuote.intended_application"];
    insertQuoteModel.cust_loan_type = [financierDraft valueForKeyPath:@"toInsertQuote.cust_loan_type"];  //new for individual
    insertQuoteModel.account_type = [financierDraft valueForKeyPath:@"toInsertQuote.account_type"];
    insertQuoteModel.account_name = [financierDraft valueForKeyPath:@"toInsertQuote.account_name"];
    insertQuoteModel.account_site = [financierDraft valueForKeyPath:@"toInsertQuote.account_site"];
    insertQuoteModel.account_number = [financierDraft valueForKeyPath:@"toInsertQuote.account_number"];
    insertQuoteModel.account_pan_no_company = [financierDraft valueForKeyPath:@"toInsertQuote.account_pan_no_company"];
    insertQuoteModel.account_address1 = [financierDraft valueForKeyPath:@"toInsertQuote.account_address1"];
    insertQuoteModel.account_address2 = [financierDraft valueForKeyPath:@"toInsertQuote.account_address2"];
    insertQuoteModel.account_city_town_village = [financierDraft valueForKeyPath:@"toInsertQuote.account_city_town_village"];
    insertQuoteModel.account_state =[financierDraft valueForKeyPath:@"toInsertQuote.account_state"];
    insertQuoteModel.account_district = [financierDraft valueForKeyPath:@"toInsertQuote.account_district"];
    insertQuoteModel.account_pincode = [financierDraft valueForKeyPath:@"toInsertQuote.account_pincode"];
    insertQuoteModel.opty_id = [financierDraft valueForKeyPath:@"toInsertQuote.opty_id"];
    insertQuoteModel.opty_created_date = [financierDraft valueForKeyPath:@"toInsertQuote.opty_created_date"];
    insertQuoteModel.ex_showroom_price = [financierDraft valueForKeyPath:@"toInsertQuote.ex_showroom_price"];
    insertQuoteModel.on_road_price_total_amt = [financierDraft valueForKeyPath:@"toInsertQuote.on_road_price_total_amt"];  //new 
    insertQuoteModel.pan_no_company = [financierDraft valueForKeyPath:@"toInsertQuote.pan_no_company"];
    insertQuoteModel.pan_no_indiviual =[financierDraft valueForKeyPath:@"toInsertQuote.pan_no_indiviual"];
    insertQuoteModel.id_type = [financierDraft valueForKeyPath:@"toInsertQuote.id_type"];
    insertQuoteModel.id_description = [financierDraft valueForKeyPath:@"toInsertQuote.id_description"];
    insertQuoteModel.id_issue_date = [financierDraft valueForKeyPath:@"toInsertQuote.id_issue_date"];
    insertQuoteModel.id_expiry_date = [financierDraft valueForKeyPath:@"toInsertQuote.id_expiry_date"];
    insertQuoteModel.lob = [financierDraft valueForKeyPath:@"toInsertQuote.lob"];
    insertQuoteModel.ppl = [financierDraft valueForKeyPath:@"toInsertQuote.ppl"];
    insertQuoteModel.pl = [financierDraft valueForKeyPath:@"toInsertQuote.pl"];
    insertQuoteModel.usage = [financierDraft valueForKeyPath:@"toInsertQuote.usage"];
    insertQuoteModel.vehicle_class = [financierDraft valueForKeyPath:@"toInsertQuote.vehicle_class"];
    insertQuoteModel.vehicle_color = [financierDraft valueForKeyPath:@"toInsertQuote.vehicle_color"];
    insertQuoteModel.emission_norms = [financierDraft valueForKeyPath:@"toInsertQuote.emission_norms"];
    insertQuoteModel.loandetails_repayable_in_months = [financierDraft valueForKeyPath:@"toInsertQuote.loandetails_repayable_in_months"];
    insertQuoteModel.repayment_mode = [financierDraft valueForKeyPath:@"toInsertQuote.repayment_mode"];
    insertQuoteModel.taluka = [financierDraft valueForKeyPath:@"toInsertQuote.taluka"];
    insertQuoteModel.vc_number = [financierDraft valueForKeyPath:@"toInsertQuote.vc_number"];
    insertQuoteModel.product_id = [financierDraft valueForKeyPath:@"toInsertQuote.product_id"];
    insertQuoteModel.event_id = [financierDraft valueForKeyPath:@"toInsertQuote.event_id"];
    insertQuoteModel.event_name = [financierDraft valueForKeyPath:@"toInsertQuote.event_name"];
    insertQuoteModel.bu_id = [financierDraft valueForKeyPath:@"toInsertQuote.bu_id"];
    insertQuoteModel.channel_type = [financierDraft valueForKeyPath:@"toInsertQuote.channel_type"];
    insertQuoteModel.ref_type = [financierDraft valueForKeyPath:@"toInsertQuote.ref_type"];
    insertQuoteModel.mmgeo = [financierDraft valueForKeyPath:@"toInsertQuote.mmgeo"];
    insertQuoteModel.camp_id = [financierDraft valueForKeyPath:@"toInsertQuote.camp_id"];
    insertQuoteModel.camp_name = [financierDraft valueForKeyPath:@"toInsertQuote.camp_name"];
    insertQuoteModel.body_type = [financierDraft valueForKeyPath:@"toInsertQuote.body_type"];
    insertQuoteModel.loan_tenor = [financierDraft valueForKeyPath:@"toInsertQuote.loan_tenor"];
    insertQuoteModel.division_id = [financierDraft valueForKeyPath:@"toInsertQuote.division_id"];
    insertQuoteModel.organization_code = [financierDraft valueForKeyPath:@"toInsertQuote.organization_code"];
    insertQuoteModel.quantity = [financierDraft valueForKeyPath:@"toInsertQuote.quantity"];
    insertQuoteModel.fin_occupation_in_years = [financierDraft valueForKeyPath:@"toInsertQuote.fin_occupation_in_years"];
    insertQuoteModel.fin_occupation = [financierDraft valueForKeyPath:@"toInsertQuote.fin_occupation"];
    insertQuoteModel.partydetails_annualincome =[financierDraft valueForKeyPath:@"toInsertQuote.partydetails_annualincome"];
    insertQuoteModel.indicative_loan_amt = [financierDraft valueForKeyPath:@"toInsertQuote.indicative_loan_amt"];
    insertQuoteModel.ltv = [financierDraft valueForKeyPath:@"toInsertQuote.ltv"];
    insertQuoteModel.account_tahsil_taluka = [financierDraft valueForKeyPath:@"toInsertQuote.account_tahsil_taluka"];
    insertQuoteModel.type_of_property = [financierDraft valueForKeyPath:@"toInsertQuote.type_of_property"];
    insertQuoteModel.customer_type = [financierDraft valueForKeyPath:@"toInsertQuote.customer_type"];
    insertQuoteModel.sales_stage_name = [financierDraft valueForKeyPath:@"toInsertQuote.sales_stage_name"];  //new
    insertQuoteModel.coapplicant_first_name = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_first_name"];
    insertQuoteModel.coapplicant_last_name = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_last_name"];
    insertQuoteModel.coapplicant_date_of_birth = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_date_of_birth"];
    insertQuoteModel.coapplicant_mobile_no = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_mobile_no"];
    insertQuoteModel.coapplicant_address1 = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_address1"];
    insertQuoteModel.coapplicant_address2 = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_address2"];
    insertQuoteModel.coapplicant_city_town_village = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_city_town_village"];
    insertQuoteModel.coapplicant_pan_no_indiviual = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_pan_no_indiviual"];
    insertQuoteModel.coapplicant_pincode = [financierDraft valueForKeyPath:@"toInsertQuote.coapplicant_pincode"];
    insertQuoteModel.toggleMode = [financierDraft valueForKeyPath:@"toInsertQuote.toggleMode"];                   
    
    return insertQuoteModel;
}


#pragma mark - delete Drafts

-(void)delete_Action_Opportunity:(UIButton*)sender
{
    AAADraftMO *optyDraft = [opportunitytinfoarray objectAtIndex:sender.tag];
    
    //Opty Draft Status
    EGDraftStatus egDraftStatus = (EGDraftStatus)optyDraft.status;
    if (egDraftStatus == EGDraftStatusSyncFailed || egDraftStatus == EGDraftStatusSavedAsDraft) {
        
        [UtilityMethods alert_showMessage:@"Do you really want to delete this draft ?" withTitle:APP_NAME andOKAction:^{
            // Delete object from database
            [appdelegate.managedObjectContext deleteObject:[opportunitytinfoarray objectAtIndex:sender.tag]];
            
            NSError *error = nil;
            if (![appdelegate.managedObjectContext save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }else{
                // Remove object from table view
                [opportunitytinfoarray removeObjectAtIndex:sender.tag];
            }
            [self reloaAllCollectionView];
            [self.drafts_not_availble_view setHidden:!([opportunitytinfoarray count] == 0)];
        } andNoAction:nil];
    }
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Drafts_Delete_Button_Click withEventCategory:GA_CL_Drafts withEventResponseDetails:nil];

}

-(void)delete_Action_Account:(UIButton*)sender
{
    [UtilityMethods alert_showMessage:@"Do you really want to delete this draft ?" withTitle:APP_NAME andOKAction:^{
        
        // Delete object from database
        [appdelegate.managedObjectContext deleteObject:[self.accountinfoarray objectAtIndex:sender.tag]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [self.accountinfoarray removeObjectAtIndex:sender.tag];
        }
        
        [self reloaAllCollectionView];
        [self.drafts_not_availble_view setHidden:!([self.accountinfoarray count] == 0)];

    } andNoAction:nil];
    
}

-(void)delete_Action_contact:(UIButton*)sender
{
    [UtilityMethods alert_showMessage:@"Do you really want to delete this draft ?" withTitle:APP_NAME andOKAction:^{
        [appdelegate.managedObjectContext deleteObject:[self.contactinfoarray objectAtIndex:sender.tag]];
		
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [self.contactinfoarray removeObjectAtIndex:sender.tag];
        }
        [self reloaAllCollectionView];
        [self.drafts_not_availble_view setHidden:!([self.contactinfoarray count] == 0)];
    } andNoAction:nil];
}

-(void)delete_Action_Financier:(UIButton*)sender
{
    [UtilityMethods alert_showMessage:@"Do you really want to delete this draft ?" withTitle:APP_NAME andOKAction:^{
         [appdelegate.managedObjectContext deleteObject:[self.financierinfoarray objectAtIndex:sender.tag]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [self.financierinfoarray removeObjectAtIndex:sender.tag];
        }
        [self reloaAllCollectionView];
        [self.drafts_not_availble_view setHidden:!([self.financierinfoarray count] == 0)];
    } andNoAction:nil];
    
}


- (NSString *)getOptyStatusStringFrom:(EGDraftStatus)egDraftStatus {
	NSString *strDraftStatus;
	switch (egDraftStatus) {
  		case EGDraftStatusSyncing:
			strDraftStatus = @"Syncing";
			break;
			
		case EGDraftStatusSyncFailed:
			strDraftStatus = @"Failed";
			break;
			
		case EGDraftStatusSavedAsDraft:
			strDraftStatus = @"Saved as draft";
			break;
			
		case EGDraftStatusQueuedToSync:
			strDraftStatus = @"Queued";
			break;
		
  		default:
			strDraftStatus = @"NA";
			break;
	}
	return strDraftStatus;
}

#pragma mark - NSNotification callbacks
- (void)onOpportunityDraftValueChanged:(NSNotification *)notification {
	NSDictionary *dictUserInfo = [notification userInfo];
	NSString *strOptyID = [dictUserInfo objectForKey:@"opty_id"];
	EGDraftStatus currentDraftStatus = (EGDraftStatus)[[dictUserInfo objectForKey:@"status"] intValue];
	
	//Update UI
	if (currentDraftStatus == EGDraftStatusSyncSuccess) {
        [self deleteDraftWithDraftID:strOptyID];
		//[self fetchAllDrafts];
	} else if ([strOptyID hasValue]) {
		int indexRowToUpdate = -1;
		for (AAADraftMO *draft in opportunitytinfoarray) {
			if ([draft.draftID isEqualToString:strOptyID]) {
				indexRowToUpdate = (int)[opportunitytinfoarray indexOfObject:draft];
                break;
			}
		}
		
		if (indexRowToUpdate >= 0) {
			AAADraftMO *draft = [opportunitytinfoarray objectAtIndex:indexRowToUpdate];
			draft.status = currentDraftStatus;
			[opportunitytinfoarray replaceObjectAtIndex:indexRowToUpdate withObject:draft];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView_opportunity reloadData];
            });
        }
	}
}

- (void)deleteDraftWithDraftID:(NSString *)draftId{
    NSLog(@"Draft ID:- %@",draftId);
    int indexRowToUpdate = -1;
    for (AAADraftMO *draft in opportunitytinfoarray) {
        if ([draft.draftID isEqualToString:draftId]) {
            indexRowToUpdate = (int)[opportunitytinfoarray indexOfObject:draft];
            break;
        }
    }
    
    if (indexRowToUpdate >= 0) {
        [appdelegate.managedObjectContext deleteObject:[self.opportunitytinfoarray objectAtIndex:indexRowToUpdate]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [opportunitytinfoarray removeObjectAtIndex:indexRowToUpdate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView_opportunity reloadData];
        });
    }
}

- (void)onAccountDraftValueChanged:(NSNotification *)notification {
    NSDictionary *dictUserInfo = [notification userInfo];
    NSString *strAccountID = [dictUserInfo objectForKey:@"account_id"];
    EGDraftStatus currentDraftStatus = (EGDraftStatus)[[dictUserInfo objectForKey:@"status"] intValue];
    
    //Update UI
    if (currentDraftStatus == EGDraftStatusSyncSuccess) {
        [self deleteAccountDraftWithDraftID:strAccountID];
        //[self fetchAllDrafts];
    } else if ([strAccountID hasValue]) {
        int indexRowToUpdate = -1;
        for (AAADraftAccountMO *accountDraft in accountinfoarray) {
            if ([accountDraft.draftIDAccount isEqualToString:strAccountID]) {
                indexRowToUpdate = (int)[accountinfoarray indexOfObject:accountDraft];
                break;
            }
        }
        
        if (indexRowToUpdate >= 0) {
            AAADraftAccountMO *accountDraft = [accountinfoarray objectAtIndex:indexRowToUpdate];
            accountDraft.status = currentDraftStatus;
            [accountinfoarray replaceObjectAtIndex:indexRowToUpdate withObject:accountDraft];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView_account reloadData];
            });
        }
    }
}

- (void)deleteAccountDraftWithDraftID:(NSString *)draftId{
    NSLog(@"Account Draft ID:- %@",draftId);
    int indexRowToUpdate = -1;
    for (AAADraftAccountMO *accountDraft in accountinfoarray) {
        if ([accountDraft.draftIDAccount isEqualToString:draftId]) {
            indexRowToUpdate = (int)[accountinfoarray indexOfObject:accountDraft];
            break;
        }
    }
    
    if (indexRowToUpdate >= 0) {
        [appdelegate.managedObjectContext deleteObject:[self.accountinfoarray objectAtIndex:indexRowToUpdate]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [accountinfoarray removeObjectAtIndex:indexRowToUpdate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView_account reloadData];
        });
    }
}

- (void)onContactDraftValueChanged:(NSNotification *)notification {
    NSDictionary *dictUserInfo = [notification userInfo];
    NSString *strContactID = [dictUserInfo objectForKey:@"contact_id"];
    EGDraftStatus currentDraftStatus = (EGDraftStatus)[[dictUserInfo objectForKey:@"status"] intValue];
    
    //Update UI
    if (currentDraftStatus == EGDraftStatusSyncSuccess) {
        [self deleteContactDraftWithDraftID:strContactID];
        //[self fetchAllDrafts];
    } else if ([strContactID hasValue]) {
        int indexRowToUpdate = -1;
        for (AAADraftContactMO *contactDraft in contactinfoarray) {
            if ([contactDraft.draftIDContact isEqualToString:strContactID]) {
                indexRowToUpdate = (int)[contactinfoarray indexOfObject:contactDraft];
                break;
            }
        }
        
        if (indexRowToUpdate >= 0) {
            AAADraftContactMO *contactDraft = [contactinfoarray objectAtIndex:indexRowToUpdate];
            contactDraft.status = currentDraftStatus;
            [contactinfoarray replaceObjectAtIndex:indexRowToUpdate withObject:contactDraft];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView_contact reloadData];
            });
        }
    }
}

- (void)onFinancierDraftValueChanged:(NSNotification *)notification {
    NSDictionary *dictUserInfo = [notification userInfo];
    NSString *strFinancierID = [dictUserInfo objectForKey:@"contact_id"];
    EGDraftStatus currentDraftStatus = (EGDraftStatus)[[dictUserInfo objectForKey:@"status"] intValue];
    
    //Update UI
    if (currentDraftStatus == EGDraftStatusSyncSuccess) {
        [self deleteFinancierDraftWithDraftID:strFinancierID];

    } else if ([strFinancierID hasValue]) {
        int indexRowToUpdate = -1;
        for (AAADraftFinancierMO *financierDraft in financierinfoarray) {
            if ([financierDraft.draftID isEqualToString:strFinancierID]) {
                indexRowToUpdate = (int)[financierinfoarray indexOfObject:financierDraft];
                break;
            }
        }
        
        if (indexRowToUpdate >= 0) {
            AAADraftFinancierMO *financierDraft = [financierinfoarray objectAtIndex:indexRowToUpdate];
            financierDraft.status = currentDraftStatus;
            [contactinfoarray replaceObjectAtIndex:indexRowToUpdate withObject:financierDraft];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView_financier reloadData];
            });
        }
    }
}

- (void)deleteFinancierDraftWithDraftID:(NSString *)draftId{
    NSLog(@"Contact Draft ID:- %@",draftId);
    int indexRowToUpdate = -1;
    for (AAADraftFinancierMO *financierDraft in financierinfoarray) {
        if ([financierDraft.draftID isEqualToString:draftId]) {
            indexRowToUpdate = (int)[financierinfoarray indexOfObject:financierDraft];
            break;
        }
    }
    
    if (indexRowToUpdate >= 0) {
        [appdelegate.managedObjectContext deleteObject:[self.contactinfoarray objectAtIndex:indexRowToUpdate]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [financierinfoarray removeObjectAtIndex:indexRowToUpdate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView_financier reloadData];
        });
    }
}


- (void)deleteContactDraftWithDraftID:(NSString *)draftId{
    NSLog(@"Contact Draft ID:- %@",draftId);
    int indexRowToUpdate = -1;
    for (AAADraftContactMO *contactDraft in contactinfoarray) {
        if ([contactDraft.draftIDContact isEqualToString:draftId]) {
            indexRowToUpdate = (int)[contactinfoarray indexOfObject:contactDraft];
            break;
        }
    }
    
    if (indexRowToUpdate >= 0) {
        [appdelegate.managedObjectContext deleteObject:[self.contactinfoarray objectAtIndex:indexRowToUpdate]];
        
        NSError *error = nil;
        if (![appdelegate.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            // Remove object from table view
            [contactinfoarray removeObjectAtIndex:indexRowToUpdate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView_contact reloadData];
        });
    }
}

@end
