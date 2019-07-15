//
//  MasterViewController.m
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "PotentialDropActivityViewController.h"
#import "ProspectViewController.h"
#import "FinancierFieldViewController.h"
#import "DraftsViewController.h"
#import "AppRepo.h"
#import "SearchNFAViewController.h"
#import "CreateNFAViewController.h"
#import "ActivityViewController.h"
#import "TollFreeViewController.h"

@interface MasterViewController (){
    AppDelegate *appdelegate;
    NSString * prospect_Mode;
    UITableViewCell * syncCell;
    BOOL isInvokedFromNotification;
}

@property (strong, nonatomic) NSMutableDictionary *menuImagesDictionary;

@end

@implementation MasterViewController
@dynamic tableView;
- (BOOL)syncButtonState{
    return [EGOfflineMasterSyncHelper dispatch_queue_is_empty];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; //AppDelegate instance
    [self localNavBarSetup];
    self.menueArray = [[NSMutableArray alloc] init];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.tableView setBackgroundColor:[UIColor menuColor]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    self.tableView.scrollEnabled = NO;
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SyncON:)
                                                 name:@"SyncON"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SyncOFF:)
                                                 name:@"SyncOFF"
                                               object:nil];
}
- (void) SyncON:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self setSyncButtonUI];
        [self.tableView reloadData];
    });
}
- (void) SyncOFF:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self setSyncButtonUI];
        [self.tableView reloadData];
        
    });
}
-(void)localNavBarSetup{
    
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [logo setImage:[UIImage imageNamed:@"eguru"]];
    UIBarButtonItem *logoButton = [[UIBarButtonItem alloc]initWithCustomView:logo];
    
    self.navigationItem.leftBarButtonItems = @[logoButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        self.menueArray = [NSMutableArray arrayWithArray:DSMMENU];
    }else {
        self.menueArray = [NSMutableArray arrayWithArray:DSEMENU];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableDictionary *)menuImagesDictionary {
    if (!_menuImagesDictionary) {
        _menuImagesDictionary = [[NSMutableDictionary alloc] init];
        [_menuImagesDictionary setObject:@"Drafts" forKey:DRAFT];
        [_menuImagesDictionary setObject:@"Manage Opportunity" forKey:MANAGEOPTY];
        [_menuImagesDictionary setObject:@"Activity" forKey:ACTIVITY];
          [_menuImagesDictionary setObject:@"Activity" forKey:PDActivity];
        [_menuImagesDictionary setObject:@"Create Opportunity" forKey:CREATEOPTY];
        [_menuImagesDictionary setObject:@"Targets" forKey:TARGETS];
        [_menuImagesDictionary setObject:@"Logout" forKey:LOGOUT];
        [_menuImagesDictionary setObject:@"Create New Prospect" forKey:CREATEPROSPECT];
        [_menuImagesDictionary setObject:@"Dashboard" forKey:DASHBOARD];
        
        [_menuImagesDictionary setObject:@"NFAMenuIcon" forKey:NFA];
        [_menuImagesDictionary setObject:@"newNFA" forKey:CREATENFA];
        [_menuImagesDictionary setObject:@"SearchNFA" forKey:SEARCHNFA];
        
        [_menuImagesDictionary setObject:@"Home" forKey:HOME];
        [_menuImagesDictionary setObject:@"My Page" forKey:MYPAGE];
        [_menuImagesDictionary setObject:@"Account" forKey:ACCOUNT];
        [_menuImagesDictionary setObject:@"Contact" forKey:CONTACT];
        [_menuImagesDictionary setObject:@"searchResult" forKey:SEARCHRESULT];
        [_menuImagesDictionary setObject:@"reset_icon" forKey:SYNC];
        [_menuImagesDictionary setObject:@"bell_icon" forKey:NOTIFICATIONS];
        [_menuImagesDictionary setObject:@"Retail Financier" forKey:RETAIL_FINANCIER];
        [_menuImagesDictionary setObject:@"Report" forKey:REPORT];
        [_menuImagesDictionary setObject:@"tollfree" forKey:SERVICE_TOLL_FREE];
        [_menuImagesDictionary setObject:@"beatPlan" forKey:BEATPLAN];
    }
    return _menuImagesDictionary;
}

- (void)openActivityScreenWithTeamsActivityForNotification:(BOOL) forNotification {
    isInvokedFromNotification = forNotification;
    [self performSegueWithIdentifier:[ACTIVITY stringByAppendingString:SEGUE] sender:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.splitViewController.delegate = controller;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
    
    if ([segue.identifier isEqualToString: [DRAFT stringByAppendingString:SEGUE]]) {
        DraftsViewController __weak *draftVC = (DraftsViewController *)[[segue destinationViewController] topViewController];
        draftVC.detailsObj = DRAFT;
        
    }
    else if ([segue.identifier isEqualToString: [NFANew stringByAppendingString:SEGUE]]) {
    }
    else if ([segue.identifier isEqualToString: [NFASearch stringByAppendingString:SEGUE]]) {
        //NFA Dashboard
        SearchNFAViewController __weak *sNFAVC = (SearchNFAViewController *)[[segue destinationViewController] topViewController];
        sNFAVC.invokedFrom = None;
    }
    else if ([segue.identifier isEqualToString:[CREATEPROSPECT stringByAppendingString:SEGUE]]) {
        ProspectViewController __weak *prospectVC = (ProspectViewController *)[[segue destinationViewController] topViewController];
        prospectVC.detailsObj = prospect_Mode;
        
    }
    
    else if([segue.identifier isEqualToString:[CREATEOPTY stringByAppendingString:SEGUE]]){
        
        CreateOpportunityViewController __weak *createOpty = (CreateOpportunityViewController *)[[segue destinationViewController] topViewController];
        
        // If user is logged out when coming from product app
        // the appdelegate object is found nil hence the below check
        if (!appdelegate) {
            appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        }
        
        if (sender && [sender isKindOfClass:[EGOpportunity class]]) {
            EGOpportunity *opty = [[EGOpportunity alloc] init];
            opty.toContact  = [[EGContact alloc] init];
            opty.toAccount = [[EGAccount alloc] init];
            opty.toVCNumber = [[EGVCNumber alloc] init];
            opty.toLOBInfo  = [[EGLOBInfo alloc] init];
            opty = (EGOpportunity *)sender;
            
            createOpty.opportunity = opty;
            if (appdelegate.isInvokedFromProductApp) {
                createOpty.entryPoint = InvokeFromProductApp;
                appdelegate.isInvokedFromProductApp = false;
            }
            else if (![opty.toAccount.accountID isEqual:[NSNull null]] || ![opty.toContact.contactID isEqual:[NSNull null]]) {
                createOpty.entryPoint = InvokeForCreateOpportunity;
            }
            
            
            createOpty.accountObject = nil;
            createOpty.contactObject = nil;
        }
    }
    else if ([segue.identifier isEqualToString:[ACTIVITY stringByAppendingString:SEGUE]]) {
        if (isInvokedFromNotification) {
            ActivityViewController __weak *activityViewController = (ActivityViewController *)[[segue destinationViewController] topViewController];
            [activityViewController setShouldShowTeamsActivity:true];
            
            isInvokedFromNotification = false;
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menueArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *menuItem = [self.menueArray objectAtIndex:indexPath.row];
    [self configureCell:cell withText:menuItem];
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell withText:(NSString *)menuItem {
    if ([menuItem isEqualToString:SYNC]){
        if(![syncCell.textLabel.text isEqualToString:SYNC]){
            [self setCellColor:[UIColor menuColor] ForCell:cell];
        }
        syncCell = cell;
        [self setSyncButtonUI];
    }
    else{
        [self setCellColor:[UIColor menuColor] ForCell:cell];
    }
    cell.textLabel.text = menuItem;
    cell.imageView.image = [UIImage imageNamed:[self.menuImagesDictionary objectForKey:menuItem]];
}
- (void)setSyncButtonUI {
    
    if(![self syncButtonState]) {
        [self setCellColor:[UIColor lightGrayColor] ForCell:syncCell];
    }else{
        [self setCellColor:[UIColor menuColor] ForCell:syncCell];
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    if (![syncCell isEqual:tempCell]) {
        [self setCellColor:[UIColor navBarColor] ForCell:[tableView cellForRowAtIndexPath:indexPath]];  //highlight colour
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    if (![syncCell isEqual:tempCell]) {
        [self setCellColor:[UIColor menuColor] ForCell:[tableView cellForRowAtIndexPath:indexPath]]; //normal color
    }
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    // Menu Clicked, Close Product App Linking
    appdelegate.productAppOpty = nil;
    appdelegate.userName = nil;
    
    [[tableView cellForRowAtIndexPath:indexPath]setBackgroundColor:[UIColor navBarColor]];
    if ([[self.menueArray objectAtIndex:indexPath.row]isEqual:[self.menueArray lastObject]]) {
        [appdelegate.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];
        [self performSelector:@selector(showLogoutConfirmation) withObject:nil afterDelay:0.5];
    }
    else if([[tableView cellForRowAtIndexPath:indexPath] isEqual:syncCell]){
        if ([self syncButtonState] && [[AppRepo sharedRepo] isUserLoggedIn]) {
            [EGOfflineMasterSyncHelper forceSyncOfflineMaster];
        }
    }
    else if([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:CREATEPROSPECT]){
        [self collapseExpandButtonTap:indexPath];
    }
    
    else if([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM] && [[self.menueArray objectAtIndex:indexPath.row] isEqualToString:NFA]){
        [self collapseExpandNFAButtonTap:indexPath];
    }
    else{
        [appdelegate.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];
        NSString * segueToTrigger;
        if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:CONTACT]) {
            prospect_Mode = PROSPECT_CONTACT;
            segueToTrigger = [CREATEPROSPECT stringByAppendingString:SEGUE];
            
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:ACCOUNT]){
            prospect_Mode = PROSPECT_ACCOUNT;
            segueToTrigger = [CREATEPROSPECT stringByAppendingString:SEGUE];
            
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:CREATENFA]){
            segueToTrigger = [NFANew stringByAppendingString:SEGUE];
            
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:SEARCHNFA]){
            segueToTrigger = [NFASearch stringByAppendingString:SEGUE];
            
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:MANAGEOPTY]){
            segueToTrigger = [MANAGEOPTY stringByAppendingString:SEGUE];
            
        }else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:PDActivity]) {
            segueToTrigger = [PDActivity stringByAppendingString:SEGUE];
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:RETAIL_FINANCIER]){
            segueToTrigger = [FINANCER stringByAppendingString:SEGUE];
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:SERVICE_TOLL_FREE]){
            segueToTrigger = [TOLL_FREE stringByAppendingString:SEGUE];
        }
        else if ([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:BEATPLAN]){
            segueToTrigger = [BEAT_PLAN stringByAppendingString:SEGUE];
        }
        
        else{
            segueToTrigger = [[self.menueArray objectAtIndex:indexPath.row]stringByAppendingString:SEGUE];
        }
        
        [self performSegueWithIdentifier:segueToTrigger sender:self];
    }
}


- (void) collapseExpandButtonTap:(NSIndexPath *) indexPath
{
    if ([self.menueArray containsObject:CONTACT])
    {
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];    }
    else
    {
        [self.menueArray insertObject:CONTACT atIndex:(indexPath.row + 1)];
        [self.menueArray insertObject:ACCOUNT atIndex:(indexPath.row + 2)];
    }
    [self.tableView reloadData];
    
}

- (void) collapseExpandNFAButtonTap:(NSIndexPath *) indexPath
{
    if ([self.menueArray containsObject:CREATENFA])
    {
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];    }
    else
    {
        [self.menueArray insertObject:CREATENFA atIndex:(indexPath.row + 1)];
        [self.menueArray insertObject:SEARCHNFA atIndex:(indexPath.row + 2)];
    }
    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath]setBackgroundColor:[UIColor menuColor]];
    //    if([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSE] && [[self.menueArray objectAtIndex:indexPath.row] isEqualToString:CREATEPROSPECT]){
    if([[self.menueArray objectAtIndex:indexPath.row] isEqualToString:CREATEPROSPECT]){
        
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [tableView reloadData];
    }
    else if([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM] && [[self.menueArray objectAtIndex:indexPath.row] isEqualToString:NFA]){
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [self.menueArray removeObjectAtIndex:(indexPath.row + 1)];
        [tableView reloadData];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)showLogoutConfirmation{
    UIAlertController *alertMessage = [UIAlertController
                                       alertControllerWithTitle:[[AppRepo sharedRepo] getLoggedInUser].positionType
                                       message:@"Are you sure you want to logout?"
                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *YesAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action)
                                {
                                    [self logout];
                                }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"No action")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertMessage addAction:YesAction];
    [alertMessage addAction:noAction];
    [self presentViewController:alertMessage animated:YES completion:nil];
}

-(void)logout {
    //[[AppRepo sharedRepo] logoutUser];
    [self callLogOutAPI];
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Logout withEventCategory:GA_CL_Authentication withEventResponseDetails:nil];
}

#pragma mark - API Calls

- (void)callLogOutAPI {
    [EGOfflineMasterSyncHelper disableQueueIntake];
    [self setSyncButtonUI];
    [[EGRKWebserviceRepository sharedRepository] performLogoutWithSuccessAction:^(id response) {
        [[AppRepo sharedRepo] logoutUser];
        [EGOfflineMasterSyncHelper enableQueueIntake];
    } andFailureAction:^(NSError *error) {
        [[AppRepo sharedRepo] logoutUser];
        [EGOfflineMasterSyncHelper enableQueueIntake];
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
