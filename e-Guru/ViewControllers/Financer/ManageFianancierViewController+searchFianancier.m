//
//  ManageFianancierViewController+searchFianancier.m
//  e-guru
//
//  Created by apple on 24/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "ScreenshotCapture.h"
#import "ManageFianancierViewController+searchFianancier.h"
#import "EGSearchOptyFilter.h"
#import "EGSearchFinancierOptyFilterModel.h"

@implementation ManageFianancierViewController (searchFianancier)

- (void)searchOpportunityForFilter:(EGSearchFinancierOptyFilterModel *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size
{
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:[filter queryParamDict]];
    
    
    if (self.selectedSegmentIndex == 2) {
        [queryDict setObject:[NSMutableArray arrayWithArray:SEARCH_FILTER_SALES_STAGE_C1] forKey:@"sales_stage_name"];
    }
    
    queryDict = [self removeemptyFieldsFromRequest:queryDict];
    
//    NSString * offsetStr = [NSString stringWithFormat:@"%lu",(unsigned long)offset];
    //TODO: remove hadrcode
//    if (![[queryDict allKeys]containsObject:@"offset"]) {
//        [queryDict addEntriesFromDictionary:@{@"offset":offsetStr}];
//    }else{
//        [queryDict setObject:offsetStr forKey:@"offset"];
//    }
//    
//    NSString * sizeStr = [NSString stringWithFormat:@"%lu",(unsigned long)size];
//    if (![[queryDict allKeys]containsObject:@"size"]) {
//        [queryDict addEntriesFromDictionary:@{@"size":sizeStr}];
//    }else{
//        [queryDict setObject:sizeStr forKey:@"size"];
//    }
    
    [self searchFinancierOptyWithParam:queryDict];

}


-(NSMutableDictionary *)removeemptyFieldsFromRequest:(NSMutableDictionary *) queryParams {
    
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionaryWithDictionary:queryParams];
    
    for(NSString * keyName in [queryParams allKeys]) {
        if ([keyName isEqualToString:@"sales_stage_name"]) {
            if([[queryDict objectForKey:@"sales_stage_name"] count] == 0) {
                [queryDict removeObjectForKey:@"sales_stage_name"];
            }
        } else {
            if (![keyName isEqualToString:@"is_quote_submitted_to_financier"] && ! [keyName isEqualToString:@"search_status"] && [[queryDict objectForKey:keyName] isEqualToString:@""]) {
                [queryDict removeObjectForKey:keyName];
            }
        }
    }
    return queryDict;
}

#pragma mark :APICalls

-(void)searchFinancierOptyWithParam:(NSDictionary *) queryParams{
    [self.collectionView resetNoResults];
    if (![searchFinancierView isHidden]) {
        [searchFinancierView closeSearchDrawer:nil];
    }

    [[EGRKWebserviceRepository sharedRepository]searchFinancierOpty:queryParams andSucessAction:^(EGPagination* oportunity) {
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self opportunitySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [UtilityMethods hideProgressHUD];
        [self opportunitySearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)opportunitySearchFailedWithErrorMessage:(NSString *)errorMessage{
    [self.collectionView reportError];
    [self.collectionView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"Manage Opportunity";
    
    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];
    
}

-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
    [UtilityMethods hideProgressHUD];
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    
    if ([opportunityPagedArray count] == 0) {
        
        //no use of searmanageopty flag remove it later
        if (isSearchManageOpty) {
            
        } else {
            [self.collectionView reportNoResults];
            [self.collectionView reloadData];
        }
        
    }else{
        
        if(nil != opportunityPagedArray) {
            
            if (isSearchManageOpty) {
                self.manageOpportunityModel = [opportunityPagedArray objectAtIndex:0];
                [self navigateToFinancierListView];
                
            } else {
                [self.collectionView refreshData:opportunityPagedArray];
                [self.collectionView reloadData];
            }
        }
    }
}


#pragma mark - SearchFinancierViewDelegate methods

-(void)financierSearchOpportunityForQuery{
    if([searchOptyFilter isEqual:searchFinancierView.searchFilter])
        return;
    searchOptyFilter = [[EGSearchFinancierOptyFilterModel alloc] initWithObject:searchFinancierView.searchFilter];
    searchOptyFilter.isSerchApplied = true;
    [opportunityPagedArray clearAllItems];
    [self.collectionView reloadData];
    [self loadMore:self.collectionView.egPagedDataSource];
}

-(void)financierClosedSearchDrawer{
     
}
-(void)financierFieldsCleared{
    
    EGSearchFinancierOptyFilterModel * defaultSearchFilter = [self searchFinancierOptyFilter];
    defaultSearchFilter.isSerchApplied = false;
    if (self.selectedSegmentIndex == 0) {
        
        defaultSearchFilter.is_quote_submitted_to_financier = false;
        defaultSearchFilter.financier_case_status = @"";
        
    } else if (self.selectedSegmentIndex == 1) {
        
        defaultSearchFilter.is_quote_submitted_to_financier = true;
        defaultSearchFilter.financier_case_status = @"A";
        
    } else if (self.selectedSegmentIndex == 2) {
        
        defaultSearchFilter.is_quote_submitted_to_financier = true;
        defaultSearchFilter.financier_case_status = @"P";
        
        
    } else if (self.selectedSegmentIndex == 3) {
        
        defaultSearchFilter.is_quote_submitted_to_financier = true;
        defaultSearchFilter.financier_case_status = @"R";
        
    }
    
    if([searchOptyFilter isEqual:defaultSearchFilter])
        return;
    
    [opportunityPagedArray clearAllItems];
    [self.collectionView reloadData];
    searchOptyFilter = defaultSearchFilter;
    [self loadMore:self.collectionView.egPagedDataSource];
}

// -------------------------------------------------------------------------

-(void)searchView_Configuration{
    
    searchFinancierView = [[SearchFinancierView alloc] initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    searchFinancierView.delegate = self;
    [searchFinancierView setHidden:YES];
    [searchFinancierView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:searchFinancierView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:searchFinancierView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:searchFinancierView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:searchFinancierView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                         constant:0];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint]];
}

@end

