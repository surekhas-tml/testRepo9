//
//  ManageFianancierViewController.m
//  e-guru
//
//  Created by Admin on 21/08/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "ManageFianancierViewController.h"
#import "FinancierFieldViewController.h"
#import "FinancierListViewController.h"
#import "NSString+NSStringCategory.h"
#import "ManageFianancierViewController+searchFianancier.h"
#import "HelperManualView.h"
#import "HHSlideView.h"
#import "UtilityMethods.h"

@interface ManageFianancierViewController () <HHSlideViewDelegate>
{
    HelperManualView * helperView;
    
}
@property (strong,nonatomic)OpportunityOperationsHelper *optyOprations;

@end

@implementation ManageFianancierViewController
HHSlideView *slideViewForFinancier;
UILabel *lblTitle;

@synthesize optyOprations;
@synthesize financierOpportunity;

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    NSArray *array = @[@1, @2];
//    NSNumber *number = [array objectAtIndex:3];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
        _retailFinancierTeamOptySwitch.hidden = false;
    }else{
        _retailFinancierTeamOptySwitch.hidden = true;
    }
    
    isSearchManageOpty = NO;
    self.optyOprations = [[OpportunityOperationsHelper alloc]init];
    
    [self updateCollectionView];
    [self configureView];
    
    //use when api data is available
    [self.collectionView setPagedCollectionViewCallback:self];
    self.collectionView.delegate = self;
    [self.collectionView setCollectionViewDataSource:self];
    self.selectedSegmentIndex = 0;
    
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_Financier_Manage_Opportunity];
}

-(void)viewWillAppear:(BOOL)animated{
//    [self configureView];
    self.noresultfoundlbl.hidden=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    isSearchManageOpty = NO;
    [self searchView_Configuration];
    
    helperView = [[HelperManualView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    helperView.hidden = true;
    [self.view addSubview:helperView];
}

-(void)updateCollectionView{
    if (opportunityPagedArray.count > 0) {
        [opportunityPagedArray clearAllItems];
        [self.collectionView reloadData];
    }
}

- (void)configureView {
//    [self addGestureRecogniserToView];
    self.navigationController.title = FINANCER_OPTYDETAIL;
    [UtilityMethods navigationBarSetupForController:self];
    
    searchOptyFilter = [self searchFinancierOptyFilter];
    searchOptyFilter.sales_stage_name = [NSMutableArray arrayWithArray:SEARCH_FILTER_SALES_STAGE_C1];

    slideViewForFinancier = [[HHSlideView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 44)];
    slideViewForFinancier.slideFont = [UIFont systemFontOfSize:16];
    slideViewForFinancier.delegate = self;
    [self.view addSubview:slideViewForFinancier];

    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, slideViewForFinancier.frame.origin.y, 240, 44)];
    lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
    lblTitle.text=@"Non-Processed";

    lblTitle.textAlignment = NSTextAlignmentCenter;
    [lblTitle setFont:[UIFont systemFontOfSize:16]];
    
    [lblTitle setTextColor:[UIColor navBarColor]];
    [self.view addSubview:lblTitle];
    
}

//Fiter of date and others
- (EGSearchFinancierOptyFilterModel *)searchFinancierOptyFilter{
    
    EGSearchFinancierOptyFilterModel *searchFilter = [[EGSearchFinancierOptyFilterModel alloc] init];
    searchFilter.is_quote_submitted_to_financier = false;
    searchFilter.search_status = MYOPTY;
    searchFilter.financier_id = @"";
    searchFilter.financier_case_status = @"";
    searchFilter.quote_submitted_to_financier_from_dt = @"";
    searchFilter.quote_submitted_to_financier_to_dt = @"";
    searchFilter.last_name = @"";
    searchFilter.mobile_number = @"";
    searchFilter.opty_id = @"";
    searchFilter.offset = @"";
    searchFilter.limit = @"100";
    
    return searchFilter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    FinancierManageOptyCollectionViewCell *optyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"financierOptyCell" forIndexPath:indexPath];
        
    if (optyCell == nil) {
        optyCell = [[FinancierManageOptyCollectionViewCell alloc]init];
    }

    if ((indexPath.row + 2) % 3 == 0) {
        [optyCell.colorStripeView setBackgroundColor:[UIColor colorWithR:235 G:198 B:72 A:1]];
    }
    else {
        [optyCell.colorStripeView setBackgroundColor:[UIColor colorWithR:0 G:161 B:25 A:1]];
    }
    
    EGFinancierOpportunity *opportunity = [opportunityPagedArray objectAtIndex:indexPath.row];
    optyCell.name.text = [NSString stringWithFormat:@"%@ %@", opportunity.toFinancierContact.firstName? :@"", opportunity.toFinancierContact.lastName ? :@""];
    optyCell.optyID.text = [NSString stringWithFormat:@"%@", opportunity.toFinancierOpty.optyID];
    optyCell.productName.text = [NSString stringWithFormat:@"%@", opportunity.toFinancierOpty.ppl];
    optyCell.mobileNo.text = [NSString stringWithFormat:@"%@", opportunity.toFinancierContact.mobileno];
    optyCell.optyCreationDate.text = [NSString stringWithFormat:@"%@", opportunity.toFinancierOpty.optyCreatedDate];
    optyCell.salesStageValueLabel.text = opportunity.toFinancierOpty.sales_stage_name;
    
//    optyCell.salesStageValueLabel.text = opportunity.toFinancierOpty.sales_stage_name;

    if (searchOptyFilter.is_quote_submitted_to_financier == 0) {
        optyCell.financierNameKeyLabel.hidden = true;
        optyCell.financierNameValueLabel.hidden = true;

    } else {
        optyCell.financierNameKeyLabel.hidden = false;
        optyCell.financierNameValueLabel.hidden = false;
        optyCell.financierNameValueLabel.text = opportunity.toFinancierSelectedFinancier.selectedFinancierName;
    }
    
    return optyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row >= [opportunityPagedArray count]) {
            return CGSizeMake(305, 192);
        }
        else{
            if ([[AppRepo sharedRepo] isDSMUser]) {
               return CGSizeMake(305, 192);
            }else{
                if (self.selectedSegmentIndex == 0) {
                    return CGSizeMake(305, 192);
                } else {
                    return CGSizeMake(305, 192);
                }
            }
        }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Financier" bundle:[NSBundle mainBundle]];

    financierOpportunity = [opportunityPagedArray objectAtIndex:indexPath.row];
    if (!financierOpportunity.isQuoteSubmittedToFinancier) {
        self.financierRequestVc = [storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
        self.financierRequestVc.financierOpportunity = self.financierOpportunity;
        self.financierRequestVc.entryPoint = NON_PROCESSED;
        [self.navigationController pushViewController:_financierRequestVc animated:YES];
   
    } else {
        if (!financierOpportunity.is_eligible_for_insert_quote) {
            FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
            vc.strFinancierOptyID = self.financierOpportunity.toFinancierOpty.optyID;
            vc.opportunity.optyID = self.financierOpportunity.toFinancierOpty.optyID;  // need to delete one of them first one mostly
            vc.search_status = searchOptyFilter.search_status; //new param for listVC to call opty/search
            [self.navigationController pushViewController:vc animated:YES] ;
        } else{
            if (financierOpportunity.isAnyCaseApproved) {
                FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                vc.strFinancierOptyID = self.financierOpportunity.toFinancierOpty.optyID;
                vc.opportunity.optyID = self.financierOpportunity.toFinancierOpty.optyID;  // need to delete one of them first one mostly
                
                vc.search_status = searchOptyFilter.search_status; //new param for listVC o call opty/search
                [self.navigationController pushViewController:vc animated:YES] ;
            } else {
//                if (financierOpportunity.is_first_case_rejected) {
//                    self.financierRequestVc=[storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                    self.financierRequestVc.financierOpportunity = self.financierOpportunity;
//                    [self.navigationController pushViewController:_financierRequestVc animated:YES];
//                } else{
                
                    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
                    vc.strFinancierOptyID = self.financierOpportunity.toFinancierOpty.optyID;
                    vc.opportunity.optyID = self.financierOpportunity.toFinancierOpty.optyID;  // need to delete one of them first one mostly
                    vc.search_status = searchOptyFilter.search_status; //new param for listVC o call opty/search
                    [self.navigationController pushViewController:vc animated:YES];
                
//                    if (financierOpportunity.isTimeBefore48Hours) {
//                      //if condition removed and code written before if condition above
//                        
//                    } else {
//                        self.financierRequestVc=[storyboard instantiateViewControllerWithIdentifier:@"FinancierRequestViewController"];
//                        self.financierRequestVc.financierOpportunity = self.financierOpportunity;
//                        [self.navigationController pushViewController:_financierRequestVc animated:YES];
//                    }
//                }
            }
        }
    }

}

#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
//    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodToDissmissSearchView:)];
//    tapRecognizer.delegate = self;
//    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (![searchFinancierView isHidden]) {
        if (![touch.view isDescendantOfView:searchFinancierView]) {
            return YES;
        }
    } else {
    if ([[touch.view superview]isKindOfClass:[FinancierManageOptyCollectionViewCell class]]) {
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
// not in use
#pragma mark - UISegement Control
- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    
    self.selectedSegmentIndex = sender.selectedSegmentIndex;

//    if (searchOptyFilter.sales_stage_name.count > 0) {
//        self.titleSalesStageLabel.text = [NSString stringWithFormat:@"Opportunities with Sales Stage : %@",[searchOptyFilter.sales_stage_name objectAtIndex:0]];
//    }

    if (sender.selectedSegmentIndex == 0) {
        [UtilityMethods showProgressHUD:YES];
        
        isQuoteSubmittedToFinancier = false;
        searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
        //searchOptyFilter.sales_stage_name = [NSMutableArray arrayWithArray:SEARCH_FILTER_SALES_STAGE_C1];
        searchOptyFilter.financier_case_status = @"";
        [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];

    } else if (sender.selectedSegmentIndex == 1) {
        
        [UtilityMethods showProgressHUD:YES];
        if (!searchOptyFilter.isSerchApplied) {
            [searchOptyFilter.sales_stage_name removeAllObjects];
        }
        isQuoteSubmittedToFinancier = true;
        searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
        searchOptyFilter.financier_case_status = @"A";
        [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];
    
    } else if (sender.selectedSegmentIndex == 2) {
        [UtilityMethods showProgressHUD:YES];
        if (!searchOptyFilter.isSerchApplied) {
            [searchOptyFilter.sales_stage_name removeAllObjects];
        }
        isQuoteSubmittedToFinancier = true;
        searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
        searchOptyFilter.financier_case_status = @"P";
        [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];

        
    } else if (sender.selectedSegmentIndex == 3) {
        [UtilityMethods showProgressHUD:YES];
        if (!searchOptyFilter.isSerchApplied) {
            [searchOptyFilter.sales_stage_name removeAllObjects];
        }
        isQuoteSubmittedToFinancier = true;
        searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
        searchOptyFilter.financier_case_status = @"R";
        [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
    }
}

 #pragma mark - HHSlideViewDelegate
 
-(NSInteger)numberOfSlideItemsInSlideView:(HHSlideView *)slideView {
    return 4;
}
 
-(NSArray *)namesOfSlideItemsInSlideView:(HHSlideView *)slideView {
//    return  @[F_NONPROCESSED,F_APPROVED, F_PENDING, F_REJECTED, F_ONHOLD, F_DATAISSUE, F_SYSTEMERROR];
    return  @[F_NONPROCESSED,F_APPROVED, F_PENDING, F_REJECTED];
}
 
-(void)slideView:(HHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
    
    if (searchOptyFilter.sales_stage_name.count > 0) {
        self.titleSalesStageLabel.text = [NSString stringWithFormat:@"Opportunities with Sales Stage : %@",[searchOptyFilter.sales_stage_name objectAtIndex:0]];
    }
    int Y= 0;
    int height = 44;
    int width  = 240;
    
    switch (index) {
        case 0:
        {
            [lblTitle removeFromSuperview];
            lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10,Y, width, height)];
            lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lblTitle.text=@"Non-Processed";
            lblTitle.textAlignment = NSTextAlignmentCenter;
            [lblTitle setFont:[UIFont systemFontOfSize:16]];
            [lblTitle setTextColor:[UIColor navBarColor]];
            [slideViewForFinancier addSubview:lblTitle];
            
            [UtilityMethods showProgressHUD:YES];
            
            isQuoteSubmittedToFinancier = false;
            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
            //searchOptyFilter.sales_stage_name = [NSMutableArray arrayWithArray:SEARCH_FILTER_SALES_STAGE_C1];
            searchOptyFilter.financier_case_status = @"";
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];
            
            break;
        }
            
        case 1:
        {
            [lblTitle removeFromSuperview];
            lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(250, Y, width, height)];
            lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lblTitle.text=@"Approved";
            lblTitle.textAlignment = NSTextAlignmentCenter;
            [lblTitle setFont:[UIFont systemFontOfSize:16]];
            [lblTitle setTextColor:[UIColor navBarColor]];
            [slideViewForFinancier addSubview:lblTitle];
            
            [UtilityMethods showProgressHUD:YES];
            if (!searchOptyFilter.isSerchApplied) {
                [searchOptyFilter.sales_stage_name removeAllObjects];
            }
            isQuoteSubmittedToFinancier = true;
            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
            searchOptyFilter.financier_case_status = @"A";
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];
            
            break;
        }
            
        case 2:
        {
            [lblTitle removeFromSuperview];
            lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(500, Y, width, height)];
            lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lblTitle.text=@"Pending";
            lblTitle.textAlignment = NSTextAlignmentCenter;
            [lblTitle setFont:[UIFont systemFontOfSize:16]];
            [lblTitle setTextColor:[UIColor navBarColor]];
            [slideViewForFinancier addSubview:lblTitle];
            
            [UtilityMethods showProgressHUD:YES];
            if (!searchOptyFilter.isSerchApplied) {
                [searchOptyFilter.sales_stage_name removeAllObjects];
            }
            isQuoteSubmittedToFinancier = true;
            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
            searchOptyFilter.financier_case_status = @"P";
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
            
            break;
            
        }
        case 3:
        {
            [lblTitle removeFromSuperview];
            lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(750, Y, width, height)];
            lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
            lblTitle.text=@"Rejected";
            lblTitle.textAlignment = NSTextAlignmentCenter;
            [lblTitle setFont:[UIFont systemFontOfSize:16]];
            [lblTitle setTextColor:[UIColor navBarColor]];
            [slideViewForFinancier addSubview:lblTitle];
            
            [UtilityMethods showProgressHUD:YES];
            if (!searchOptyFilter.isSerchApplied) {
                [searchOptyFilter.sales_stage_name removeAllObjects];
            }
            isQuoteSubmittedToFinancier = true;
            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
            searchOptyFilter.financier_case_status = @"R";
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
            
            break;
        }
//         case 4:
//         {
//             [lblTitle removeFromSuperview];
//             lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(590, Y, width, height)];
//             lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
//             lblTitle.text=@"On Hold";
//             lblTitle.textAlignment = NSTextAlignmentCenter;
//             [lblTitle setFont:[UIFont systemFontOfSize:16]];
//             [lblTitle setTextColor:[UIColor navBarColor]];
//             [slideViewForFinancier addSubview:lblTitle];
//
//             [UtilityMethods showProgressHUD:YES];
//             if (!searchOptyFilter.isSerchApplied) {
//                 [searchOptyFilter.sales_stage_name removeAllObjects];
//             }
//             isQuoteSubmittedToFinancier = true;
//             searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
//             searchOptyFilter.financier_case_status = @"O";
//             [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
//
//             break;
//         }
//         case 5:
//         {
//             [lblTitle removeFromSuperview];
//             lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(730, Y, width, height)];
//             lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
//             lblTitle.text=@"Data Issues";
//             lblTitle.textAlignment = NSTextAlignmentCenter;
//             [lblTitle setFont:[UIFont systemFontOfSize:16]];
//             [lblTitle setTextColor:[UIColor navBarColor]];
//             [slideViewForFinancier addSubview:lblTitle];
//
//             [UtilityMethods showProgressHUD:YES];
//             if (!searchOptyFilter.isSerchApplied) {
//                 [searchOptyFilter.sales_stage_name removeAllObjects];
//             }
//             isQuoteSubmittedToFinancier = true;
//             searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
//             searchOptyFilter.financier_case_status = @"D";
//             [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
//
//             break;
//         }
//         case 6:
//         {
//             [lblTitle removeFromSuperview];
//             lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(870, Y, width, height)];
//             lblTitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:248/255.0 alpha:1.0];
//             lblTitle.text=@"System Error";
//             lblTitle.textAlignment = NSTextAlignmentCenter;
//             [lblTitle setFont:[UIFont systemFontOfSize:16]];
//             [lblTitle setTextColor:[UIColor navBarColor]];
//             [slideViewForFinancier addSubview:lblTitle];
//             
//             [UtilityMethods showProgressHUD:YES];
//             if (!searchOptyFilter.isSerchApplied) {
//                 [searchOptyFilter.sales_stage_name removeAllObjects];
//             }
//             isQuoteSubmittedToFinancier = true;
//             searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
//             searchOptyFilter.financier_case_status = @"S";
//             [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:15];
//             
//             break;
//         }
            
        default:
            break;
    }
}
 
-(NSArray *)childViewControllersInSlideView:(HHSlideView *)slideView {
 
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

- (IBAction)teamoptySwitchClicked:(UISegmentedControl *)sender {
        self.selectedSegmentIndex = sender.selectedSegmentIndex;

        if (sender.selectedSegmentIndex == 0) {
            [UtilityMethods showProgressHUD:YES];
//            isQuoteSubmittedToFinancier = false;
//            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
//            //searchOptyFilter.sales_stage_name = [NSMutableArray arrayWithArray:SEARCH_FILTER_SALES_STAGE_C1];
//            searchOptyFilter.financier_case_status = @"";
            searchOptyFilter.search_status = 1;
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];
    
        } else if (sender.selectedSegmentIndex == 1) {
            [UtilityMethods showProgressHUD:YES];
//            isQuoteSubmittedToFinancier = true;
//            searchOptyFilter.is_quote_submitted_to_financier = isQuoteSubmittedToFinancier;
//            searchOptyFilter.financier_case_status = @"A";
            searchOptyFilter.search_status = 2;
            [self searchOpportunityForFilter:searchOptyFilter withOffset:0 withSize:100];
        }
}

#pragma mark- callbacks of FinancierOptySearch

-(void)loadMore:(EGPagedCollectionViewDataSource *)dataSource{
    NSLog(@"in load more %lu",(unsigned long)[dataSource.data count] );
    if (self.selectedSegmentIndex == 1 || self.selectedSegmentIndex == 0) {
        [UtilityMethods showProgressHUD:YES];
        [self searchOpportunityForFilter:searchOptyFilter withOffset:[dataSource.data count] withSize:100];

    } else {
        [self searchOpportunityForFilter:searchOptyFilter withOffset:[dataSource.data count] withSize:15];
    }
    
    if (searchOptyFilter.sales_stage_name.count > 0) {
        self.titleSalesStageLabel.text = [NSString stringWithFormat:@"Opportunities with Sales Stage : %@",[searchOptyFilter.sales_stage_name objectAtIndex:0]];
    }
}

-(void)navigateToFinancierListView {
    
    FinancierListViewController *vc = [[UIStoryboard storyboardWithName:@"Financier" bundle:nil] instantiateViewControllerWithIdentifier:@"FinancierList_View"];
    vc.opportunity = self.manageOpportunityModel;
    [self.navigationController pushViewController:vc animated:YES] ;
}


- (IBAction)helperButtonClicked:(id)sender {
    
    helperView.selectedViewType = helperManualSectionType_FinancierView;
    [helperView setViewAccordingToSelectedHelperView];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    [helperView.layer addAnimation:animation forKey:nil];

    [UIView transitionWithView:helperView
                      duration:0.8
                       options:UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        [helperView setHidden:!helperView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@" manual shown!!!");
                    }];

}


- (IBAction)searchDrawerButtonClick:(id)sender {
    
    searchFinancierView.selectedSegmentIndex = self.selectedSegmentIndex;

    if (self.selectedSegmentIndex == 0) {
        searchFinancierView.searchDrawerView2.hidden = true;
        searchFinancierView.searchDrawerView3TopConstraint.constant = 10;
        searchFinancierView.financierLabel.hidden = true;
        searchFinancierView.financierTextField.hidden = true;
        searchFinancierView.salesStage.enabled = false;
        searchFinancierView.salesStage.text = [SEARCH_FILTER_SALES_STAGE_C1 objectAtIndex:0];
    } else {
        searchFinancierView.searchDrawerView2.hidden = false;
        searchFinancierView.searchDrawerView3TopConstraint.constant = searchFinancierView.searchDrawerView2.frame.size.height + 20;
        searchFinancierView.financierLabel.hidden = false;
        searchFinancierView.financierTextField.hidden = false;
        searchFinancierView.salesStage.enabled = true;
        searchFinancierView.salesStage.text = [SEARCH_FILTER_SALES_STAGE_C1 objectAtIndex:0];

    }
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromRight;
    animation.duration = 0.2;
    searchFinancierView.searchFilter = searchOptyFilter;
    [searchFinancierView.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:searchFinancierView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [searchFinancierView setHidden:!searchFinancierView.hidden];
                    }
                    completion:^(BOOL finished) {
                        NSLog(@"Search Open");

                    }];
}

@end

