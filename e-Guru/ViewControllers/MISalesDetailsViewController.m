//
//  MISalesDetailsViewController.m
//  e-guru
//
//  Created by Admin on 26/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "MISalesDetailsViewController.h"
#import "MISalesDetailsTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "UtilityMethods.h"
#import "AppRepo.h"
#import "SearchMISSalesDetailsView.h"
#import "EGMISDetails.h"
#import "NSString+NSStringCategory.h"

@interface MISalesDetailsViewController () <UITableViewDataSource, EGPagedTableViewDelegate,MISDetailsViewDelegate>{
    SearchMISSalesDetailsView *searchMISSalesDetailsView;
     UITextField *activeField;
    UITapGestureRecognizer *tapRecognizer;
}

@property (strong, nonatomic) EGPagedArray *MISSalesDetailsDataList;
@property (strong, nonatomic) EGPagedArray *MISSalesDetailsCompleteDataList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;
@property (strong, nonatomic) NSArray *filteredArray;

@end

@implementation MISalesDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.filteredArray=[[NSArray alloc]init];
        [self.MISalesDetailsTableView setPagedTableViewCallback:self];
        [self.MISalesDetailsTableView setTableviewDataSource:self];
    self.title = @"MIS Sales";
    [self addGestureRecogniserToView];
    [UtilityMethods navigationBarSetupForController:self];
    [self.dateFilterButton setTitle:self.fromToTillDateString forState:UIControlStateNormal];
    
    if (![[AppRepo sharedRepo] isDSMUser]) {
        [self.filterButton setHidden:YES];
    }else{
        [self searchViewConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        _requestDictionary = [[NSMutableDictionary alloc] init];
        [_requestDictionary setObject:self.dseUserID forKey:@"dse_name"];
        
    }
    return _requestDictionary;
}


#pragma mark - Configure UI -

//- (EGPagedArray *)MISSaleswiseDataList {
//    
//    if (!_MISSalesDetailsDataList) {
//        _MISSalesDetailsDataList = [[EGPagedArray alloc] init];
//    }
//    return _MISSalesDetailsDataList;
//}


#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodToDissmissSearchView:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (![searchMISSalesDetailsView isHidden]) {
        if (![touch.view isDescendantOfView:searchMISSalesDetailsView]) {
            return YES;
        }
    }else{
        if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
            return YES;
        }
        else if ([[touch.view superview]isKindOfClass:[MISalesDetailsTableViewCell class]]) {
            return NO;
        }
        else if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
        else if ([touch.view isDescendantOfView:self.view]) {
            return YES;
        }
    }
    return NO;
}

-(void)gestureHandlerMethodToDissmissSearchView:(id)sender{
    if (![searchMISSalesDetailsView isHidden]) {
        [searchMISSalesDetailsView closeButtonTapped:sender];
    }
    
    [activeField resignFirstResponder];
    if (activeField != nil) {
        activeField.text = @"";
    }
}


#pragma mark - Private Methods

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    self.MISSalesDetailsDataList = [EGPagedArray mergeWithCopy:self.MISSalesDetailsDataList withPagination:paginationObj];
    
    self.MISSalesDetailsCompleteDataList = [EGPagedArray mergeWithCopy:self.MISSalesDetailsCompleteDataList withPagination:paginationObj];
    
    if(self.MISSalesDetailsDataList) {
        [self.MISalesDetailsTableView refreshData:self.MISSalesDetailsDataList];
        [self.MISalesDetailsTableView reloadData];
    }
}

#pragma mark - EGPagedTableViewDelegate Method

- (void)loadMore:(EGPagedTableViewDataSource *)pagedTableViewDataSource {
    
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[pagedTableViewDataSource.data count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    [self getDSEMISdetailsData:self.requestDictionary];
    
}
#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.MISSalesDetailsDataList count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MISalesDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mISalesDetailsTableViewCell"];
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor tableViewAlternateCellColor]];
    }
    
    EGMISDetails *misDetails = [self.MISSalesDetailsDataList objectAtIndex:indexPath.row] ;
    cell.dseNameLabel.text=self.dseName;
    cell.customerNameLabel.text=misDetails.CustomerName;
    cell.customerCityLabel.text=misDetails.CustomerCity;
    cell.lobLabel.text=misDetails.LOB;
    cell.pplLabel.text=misDetails.PPL;
    cell.financerLabel.text=misDetails.FinancierName;
    cell.invoiceNoLabel.text=misDetails.InvoiceNumber;
    cell.invoiceStatusLabel.text=misDetails.InvoiceStatus;
    cell.invoiceDateLabel.text=misDetails.InvoiceDate;
    return cell;
}

- (IBAction)filterButtonTapped:(id)sender {
    [self viewAnimate];
}

-(void) viewAnimate{
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    [searchMISSalesDetailsView.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:searchMISSalesDetailsView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [searchMISSalesDetailsView setHidden:!searchMISSalesDetailsView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@"Search Open");
                    }];
}

-(void)searchViewConfiguration{
    
    searchMISSalesDetailsView = [[SearchMISSalesDetailsView alloc]initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    searchMISSalesDetailsView.delegate = (id)self;
    [searchMISSalesDetailsView setHidden:YES];
    [searchMISSalesDetailsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:searchMISSalesDetailsView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:searchMISSalesDetailsView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:searchMISSalesDetailsView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:searchMISSalesDetailsView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                         constant:0];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:searchMISSalesDetailsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:350];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint, widthConstraint]];
}

- (void)getDSEMISdetailsData:(NSDictionary *)requestDictionary {
    
    [[EGRKWebserviceRepository sharedRepository] getDSEMisDetailswisePipeline:requestDictionary andSuccessAction:^(EGPagination *paginationObj) {
        [UtilityMethods hideProgressHUD];
        [self loadResultInTableView:paginationObj];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Search withEventCategory:GA_CL_Dashboard withEventResponseDetails:GA_EA_Dashboard_MisSales_Search_Successful];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self.MISalesDetailsTableView reportErrorWithMessage:[UtilityMethods errorMessageForErrorCode:error.code]];
        [self.MISalesDetailsTableView reloadData];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Dashboard_MisSales_Details withEventCategory:GA_CL_Dashboard withEventResponseDetails:GA_EA_Dashboard_MisSales_Search_Failed];
        
    }];
}

-(void)searchMISForQuery{
    [self.view endEditing:true];
    
       if(![searchMISSalesDetailsView.dseName hasValue] || [self.dseName rangeOfString:searchMISSalesDetailsView.dseName options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSPredicate *customerName = [NSPredicate predicateWithFormat:@"SELF.CustomerName contains[cd] %@",searchMISSalesDetailsView.Customername];
        NSPredicate *financierName = [NSPredicate predicateWithFormat:@"SELF.FinancierName contains[cd] %@",searchMISSalesDetailsView.financiername];
        NSPredicate *lob = [NSPredicate predicateWithFormat:@"SELF.LOB contains[cd] %@",searchMISSalesDetailsView.lob];
        NSPredicate *ppl = [NSPredicate predicateWithFormat:@"SELF.PPL contains[cd] %@",searchMISSalesDetailsView.ppl];
        
        NSMutableArray *predicateArray = [[NSMutableArray alloc] init];
        
        if ([searchMISSalesDetailsView.lob hasValue]) {
            [predicateArray addObject:lob];
        }
        
        if ([searchMISSalesDetailsView.ppl hasValue]) {
            [predicateArray addObject:ppl];
        }
        
        if ([searchMISSalesDetailsView.Customername hasValue]) {
            [predicateArray addObject:customerName];
        }
        
        
        if ([searchMISSalesDetailsView.financiername hasValue]) {
            [predicateArray addObject:financierName];
        }
        
        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:predicateArray]];
        self.filteredArray = [self.MISSalesDetailsCompleteDataList.getEmbededArray filteredArrayUsingPredicate:andPredicate];
        self.MISSalesDetailsDataList=[[EGPagedArray alloc]initWithArray:self.filteredArray];
    }
    else{
        self.MISSalesDetailsDataList = [[EGPagedArray alloc] initWithArray:[[NSArray alloc] init]];
    }

    [self.MISalesDetailsTableView refreshData:self.MISSalesDetailsDataList];
    [self.MISalesDetailsTableView reloadData];
    NSLog(@"HERE %@",self.filteredArray);
}

-(void)MISfieldsCleared{
     [self.view endEditing:true];
    self.MISSalesDetailsDataList=[[EGPagedArray alloc]initWithPagedArray:self.MISSalesDetailsCompleteDataList];
    [self.MISalesDetailsTableView refreshData:self.MISSalesDetailsDataList];
    [self.MISalesDetailsTableView reloadData];
}

@end
