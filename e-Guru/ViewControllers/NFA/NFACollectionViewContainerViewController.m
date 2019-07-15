//
//  NFACollectionViewContainerViewController.m
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFACollectionViewContainerViewController.h"
#import "NFADetailViewController.h"
#import "SearchNFAViewController.h"
#import "PureLayout.h"

@interface NFACollectionViewContainerViewController (){
    EGNFA *selectedNFA;
    EGSearchNFAFilter *searchNFAFilter;

}
@property (strong,nonatomic) NFAOperationsHelper *nfaOprations;
@property (strong,nonatomic) EGPagedArray *NFAPagedArray;

@end
NSArray *actionList;
UITextField *activeField;

@implementation NFACollectionViewContainerViewController
@synthesize NFAPagedArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nfaOprations = [[NFAOperationsHelper alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchNFAForQuery:)
                                                 name:@"searchNFAForQuery"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeSearchDrawer:)
                                                 name:@"closeSearchDrawer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fieldsCleared:)
                                                 name:@"fieldsCleared"
                                               object:nil];
    [self.nfaCollectionView setPagedCollectionViewCallback:self];
    [self.nfaCollectionView setCollectionViewDataSource:self];
    [self configureView];
}
-(void)viewDidAppear:(BOOL)animated{
    switch (self.TabMode) {
        case TabpendingNFA:
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchPending_NFA];
            break;
        case TabApprovedNFA:
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchApproved_NFA];
            break;
        case TabExpiredNFA:
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchExpired_NFA];
            break;
        case TabRejectedNFA:
            [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_SearchRejected_NFA];
            break;
        default:
            break;
    }
}
-(void)configureView{
    searchNFAFilter = [self monthTillDateNFAQuery];
}
- (EGPagedArray *)NFAPagedArray {
    if (!NFAPagedArray) {
        NFAPagedArray = [[EGPagedArray alloc] init];
    }
    return NFAPagedArray;
}
-(EGSearchNFAFilter *)monthTillDateNFAQuery{
    
    NSDate *now = [[NSDate getEOD:[[NSDate date]toLocalTime]]toGlobalTime];
    NSDate *firstOfCurrentMonth = [[NSDate getSOD:[[NSDate getCurrentMonthFirstDateInFormat:dateFormatyyyyMMddTHHmmssZ]toLocalTime]]toGlobalTime];
    
    EGSearchNFAFilter *searchFilter = [[EGSearchNFAFilter alloc] init];
    searchFilter.nfa_from_date = [NSDate getDate:firstOfCurrentMonth InFormat:dateFormatyyyyMMddTHHmmssZ];
    searchFilter.nfa_to_date = [NSDate getDate:now InFormat:dateFormatyyyyMMddTHHmmssZ];
    switch (self.TabMode) {
        case TabpendingNFA:
            searchFilter.status = Pending;
            break;
        case TabApprovedNFA:
            searchFilter.status = Approved;
            break;
        case TabExpiredNFA:
            searchFilter.status = ExpiredOrCancelled;
            break;
        case TabRejectedNFA:
            searchFilter.status = Rejected;
            break;
        default:
            break;
    }
    return searchFilter;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[EGLoadingCollectionViewCell class]] ||
        [[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[EGErrorCollectionViewCell class]]) {
        return;
    }
    
    if (self.searchNFAViewController && [NFAPagedArray currentSize] > 0) {
        NFADetailViewController *nfaDetailViewController = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"NFADetail"];
        nfaDetailViewController.nfaModel = [NFAPagedArray objectAtIndex:indexPath.row];
        [[self.searchNFAViewController navigationController] pushViewController:nfaDetailViewController animated:true];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(300, 270);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NFACollectionViewCell alloc]init];
    }
    cell.tag = indexPath.row;
    cell.updateActionButton.tag = cell.tag;
    cell.delegate = self;
   
    EGNFA *tempNFA = [NFAPagedArray objectAtIndex:indexPath.row];
    cell.position.text = tempNFA.userPosition;
    cell.nfaNumber.text = tempNFA.nfaRequestNumber;
    cell.nfaStatus.text = tempNFA.status;
    cell.nfaAmount.text = tempNFA.nfaRequestModel.totalSupportSought;
    cell.accountName.text = tempNFA.nfaDealerAndCustomerDetails.accountName;
    cell.mobileNumber.text = tempNFA.nfaDealerAndCustomerDetails.customerNumber;
    cell.opportunityID.text = tempNFA.nfaDealerAndCustomerDetails.oppotunityID;
    [cell.quantity setTitle:tempNFA.nfaDealDetails.dealSize forState:UIControlStateNormal];
    cell.contactName.text = tempNFA.nfaDealerAndCustomerDetails.customerName;
    cell.updateActionButton.tag = indexPath.row;
    [cell.updateActionButton addTarget:self action:@selector(updateNFAForTag:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell
    actionList = [self.nfaOprations setActionsArrayForNFAWithStatus:tempNFA.status andOpportunitySaleStage:tempNFA.optySalesStage];
//    if(![actionList containsObject:UPDATE]){
//        [cell.updateActionButton setBackgroundColor:[UIColor darkGrayColor]];
//        [cell.updateActionButton setEnabled:NO];
//        [cell.updateActionButton setUserInteractionEnabled:NO];
//    }
 
    
    return cell;
}
-(void)updateNFAForTag:(UIButton *)sender{
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Update_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

    if([NFAPagedArray currentSize] > 0){
        CreateNFAViewController *createNFA = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNFA_View"];
        createNFA.nfaModel = [NFAPagedArray objectAtIndex:sender.tag];
        createNFA.entryPoint = NFAModeUpdate;
        createNFA.delegate = self.searchNFAViewController;
        [[self.searchNFAViewController navigationController] pushViewController:createNFA animated:true];

    }
}
-(void)loadMore:(EGPagedCollectionViewDataSource *)dataSource{
    NSLog(@"in load more %lu",(unsigned long)[dataSource.data count] );
    [self.nfaOprations searchNFAForFilter:searchNFAFilter withOffset:[dataSource.data count] withSize:10 fromVC:self];
}


#pragma - mark Notification Methods
-(void)searchNFAForQuery:(NSNotification *) notification{
    [NFAPagedArray clearAllItems];
    [self.nfaCollectionView reloadData];
    searchNFAFilter = [searchNFAFilter initWithObject:(EGSearchNFAFilter *) [[notification userInfo]objectForKey:@"filter"]];
    if ( searchNFAFilter.status == all) {
        searchNFAFilter.status = [self monthTillDateNFAQuery].status;
    }
    
    switch (self.TabMode) {
        case TabpendingNFA:
            if(searchNFAFilter.status != PendingForSPMApproval && searchNFAFilter.status != PendingForRSMApproval && searchNFAFilter.status != PendingForRMApproval && searchNFAFilter.status != PendingForLOBHeadApproval && searchNFAFilter.status != PendingForMarketingHeadApproval && searchNFAFilter.status != Pending && searchNFAFilter.status != SubmittedByDealer){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }

            break;
        case TabApprovedNFA:
            if(searchNFAFilter.status != ApproveBySPM && searchNFAFilter.status != ApproveByRSM && searchNFAFilter.status != ApproveByRM && searchNFAFilter.status != ApproveByLOBHead && searchNFAFilter.status != ApproveByMarketingHead && searchNFAFilter.status != Approved){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }
            break;
        case TabExpiredNFA:
            if(searchNFAFilter.status != CancelledByDSM && searchNFAFilter.status != CancelledByTSM && searchNFAFilter.status != CancelledAsOptyClosedLost && searchNFAFilter.status != CancelledByUser && searchNFAFilter.status != Expired && searchNFAFilter.status != Cancelled && searchNFAFilter.status != ExpiredOrCancelled){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }
            break;
        case TabRejectedNFA:
            if(searchNFAFilter.status != RejectedBySPM && searchNFAFilter.status != RejectedByRSM && searchNFAFilter.status != RejectedByRM && searchNFAFilter.status != RejectedByLOBHead && searchNFAFilter.status != RejectedByMarketingHead && searchNFAFilter.status != Rejected){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }
        default:
            break;
    }
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_SearchNFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

    [self loadMore:self.nfaCollectionView.egPagedDataSource];
}

-(void)fieldsCleared:(NSNotification *) notification{
    [NFAPagedArray clearAllItems];
    [self.nfaCollectionView reloadData];
    EGSearchNFAFilter *defaultSearchFilter = [self monthTillDateNFAQuery];
    if([searchNFAFilter isEqual:defaultSearchFilter])
        return;
    searchNFAFilter = defaultSearchFilter;
    [self loadMore:self.nfaCollectionView.egPagedDataSource];
}
-(void)closeSearchDrawer:(NSNotification *) notification{
    
}

#pragma Server Calls
-(void)searchNFAWithQueryParameters:(NSDictionary *) queryParams{
    [self.nfaCollectionView resetNoResults];
    BOOL hitServer = NO;
    switch (self.TabMode) {
        case TabpendingNFA:
            if (searchNFAFilter.status == PendingForSPMApproval || searchNFAFilter.status == PendingForRSMApproval || searchNFAFilter.status == PendingForRMApproval || searchNFAFilter.status == PendingForLOBHeadApproval || searchNFAFilter.status == PendingForMarketingHeadApproval || searchNFAFilter.status == Pending || searchNFAFilter.status == SubmittedByDealer) {
                hitServer = YES;
            }
            break;
        case TabApprovedNFA:
            if(searchNFAFilter.status == ApproveBySPM || searchNFAFilter.status == ApproveByRSM || searchNFAFilter.status == ApproveByRM || searchNFAFilter.status == ApproveByLOBHead || searchNFAFilter.status == ApproveByMarketingHead || searchNFAFilter.status == Approved){
                hitServer = YES;
            }
            break;
        case TabExpiredNFA:
            if(searchNFAFilter.status == CancelledByDSM || searchNFAFilter.status == CancelledByTSM || searchNFAFilter.status == CancelledByUser || searchNFAFilter.status == CancelledAsOptyClosedLost || searchNFAFilter.status == Cancelled || searchNFAFilter.status == Expired || searchNFAFilter.status == ExpiredOrCancelled){
                hitServer = YES;
            }
            break;
        case TabRejectedNFA:
            if(searchNFAFilter.status == RejectedBySPM || searchNFAFilter.status == RejectedByRSM || searchNFAFilter.status == RejectedByRM || searchNFAFilter.status == RejectedByLOBHead || searchNFAFilter.status == RejectedByMarketingHead || searchNFAFilter.status == Rejected){
                hitServer = YES;
            }
        default:
            break;
    }
     NSLog(@"Tab %u", self.TabMode);

    if (hitServer) {
        NSLog(@"%@ Tab %u",queryParams , self.TabMode);

        [[EGRKWebserviceRepository sharedRepository]searchNFA:queryParams andSucessAction:^(EGPagination *nfa) {
            NSString  *offset = [queryParams objectForKey:@"offset"];
            if ([offset integerValue] == 0) {
                [NFAPagedArray clearAllItems];
            }
            [self nfaSearchedSuccessfully:nfa];
            
        } andFailuerAction:^(NSError *error) {
            [self nfaSearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
        }];
    }else{
        [self clearCollectionView];
    }
}

-(void)nfaSearchFailedWithErrorMessage:(NSString *)errorMessage{
    [self.nfaCollectionView reportError];
    [self.nfaCollectionView reloadData];
    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
}
-(void)clearCollectionView{
        [self.NFAPagedArray clearAllItems];
        [self.nfaCollectionView reportNoResults];
        [self.nfaCollectionView reloadData];
}

-(void)nfaSearchedSuccessfully:(EGPagination *)paginationObj{

    if ([self.NFAPagedArray count] == 0) {
        [self.NFAPagedArray clearAllItems];
        [self.nfaCollectionView reloadData];
    }
    switch (self.TabMode) {
        case TabpendingNFA:
            if(searchNFAFilter.status != PendingForSPMApproval && searchNFAFilter.status != PendingForRSMApproval && searchNFAFilter.status != PendingForRMApproval && searchNFAFilter.status != PendingForLOBHeadApproval && searchNFAFilter.status != PendingForMarketingHeadApproval && searchNFAFilter.status != Pending && searchNFAFilter.status != SubmittedByDealer){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }else{
                self.NFAPagedArray = [EGPagedArray mergeWithCopy:self.NFAPagedArray withPagination:paginationObj];
            }
            break;
        case TabApprovedNFA:
            if(searchNFAFilter.status != ApproveBySPM && searchNFAFilter.status != ApproveByRSM && searchNFAFilter.status != ApproveByRM && searchNFAFilter.status != ApproveByLOBHead && searchNFAFilter.status != ApproveByMarketingHead && searchNFAFilter.status != Approved){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }else{
                self.NFAPagedArray = [EGPagedArray mergeWithCopy:self.NFAPagedArray withPagination:paginationObj];

            }
            break;
        case TabExpiredNFA:
            if(searchNFAFilter.status != CancelledByDSM && searchNFAFilter.status != CancelledByTSM && searchNFAFilter.status != CancelledByUser && searchNFAFilter.status != CancelledAsOptyClosedLost && searchNFAFilter.status != Expired && searchNFAFilter.status != Cancelled && searchNFAFilter.status != ExpiredOrCancelled){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }else{
                self.NFAPagedArray = [EGPagedArray mergeWithCopy:self.NFAPagedArray withPagination:paginationObj];

            }
            break;
        case TabRejectedNFA:
            if(searchNFAFilter.status != RejectedBySPM && searchNFAFilter.status != RejectedByRSM && searchNFAFilter.status != RejectedByRM && searchNFAFilter.status != RejectedByLOBHead && searchNFAFilter.status != RejectedByMarketingHead && searchNFAFilter.status != Rejected){
                [self.nfaCollectionView reportNoResults];
                [self.nfaCollectionView reloadData];
            }else{
                self.NFAPagedArray = [EGPagedArray mergeWithCopy:self.NFAPagedArray withPagination:paginationObj];
            }
        default:
            break;
    }
     if ([self.NFAPagedArray count] == 0) {
        [self.nfaCollectionView reportNoResults];
        [self.nfaCollectionView reloadData];
    }else{
        if(nil != self.NFAPagedArray) {
            [self.nfaCollectionView refreshData:self.NFAPagedArray];
            [self.nfaCollectionView reloadData];
        }
        
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
