//
//  ManageOpportunityViewController+SearchOpportunity.m
//  e-Guru
//
//  Created by Juili on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "ManageOpportunityViewController+SearchOpportunity.h"
#import "EGSearchOptyFilter.h"

@implementation ManageOpportunityViewController (SearchOpportunity)


- (void)searchOpportunityForFilter:(EGSearchOptyFilter *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size
{
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:[filter queryParamDict]];
    
    NSString * offsetStr = [NSString stringWithFormat:@"%lu",(unsigned long)offset];
    //TODO: remove hadrcode
    if (![[queryDict allKeys]containsObject:@"offset"]) {
        [queryDict addEntriesFromDictionary:@{@"offset":offsetStr}];
    }else{
        [queryDict setObject:offsetStr forKey:@"offset"];
    }

    NSString * sizeStr = [NSString stringWithFormat:@"%lu",(unsigned long)size];
    if (![[queryDict allKeys]containsObject:@"size"]) {
        [queryDict addEntriesFromDictionary:@{@"size":sizeStr}];
    }else{
        [queryDict setObject:sizeStr forKey:@"size"];
    }
    
    [self searchOpportunityWithQueryParameters:queryDict];
}

-(void)searchOpportunityWithQueryParameters:(NSDictionary *) queryParams{
    [self.collectionView resetNoResults];
    if (![searchOpportunityView isHidden]) {
        [searchOpportunityView closeSearchDrawer:nil];
    }
    [[EGRKWebserviceRepository sharedRepository]searchOpportunity:queryParams andSucessAction:^(EGPagination *oportunity) {
        NSString  *offset = [queryParams objectForKey:@"offset"];
        if ([offset integerValue] == 0) {
            [opportunityPagedArray clearAllItems];
        }
        [self opportunitySearchedSuccessfully:oportunity];
        
    } andFailuerAction:^(NSError *error) {
        [self opportunitySearchFailedWithErrorMessage:[UtilityMethods getErrorMessage:error]];
    }];
}

-(void)opportunitySearchFailedWithErrorMessage:(NSString *)errorMessage{
    [self.collectionView reportError];
    [self.collectionView reloadData];
//    [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:nil];
    
    [ScreenshotCapture takeScreenshotOfView:self.view];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"Manage Opportunity";

    [UtilityMethods alert_ShowMessagewithreportissue:errorMessage withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

}
-(void)opportunitySearchedSuccessfully:(EGPagination *)paginationObj{
    opportunityPagedArray = [EGPagedArray mergeWithCopy:opportunityPagedArray withPagination:paginationObj];
    if ([self.parentVC isEqualToString:MYPAGE] ){
        [self.filterInformation setText:[NSString stringWithFormat:@"Opportunity Count of last 7 days: %lu",(unsigned long)[opportunityPagedArray totalResults]]];
    }
    if ([opportunityPagedArray count] == 0) {
        [self.collectionView reportNoResults];
        [self.collectionView reloadData];
    }else{
        if(nil != opportunityPagedArray) {
            [self.collectionView refreshData:opportunityPagedArray];
            [self.collectionView reloadData];
        }
            
    }
}

-(void)searchOpportunityForQuery{
    if([searchOptyFilter isEqual:searchOpportunityView.searchFilter])
        return;
    searchOptyFilter = [[EGSearchOptyFilter alloc]initWithObject:searchOpportunityView.searchFilter];
    if (![self.parentVC isEqualToString:MYPAGE] ){
        [self.optywithsalessatgelbl setText:[NSString stringWithFormat:@"Opportunities with Sales Stage : %@",searchOptyFilter.sales_stage_name]];
    }
    [opportunityPagedArray clearAllItems];
    [self.collectionView reloadData];
    [self loadMore:self.collectionView.egPagedDataSource];
}

-(void)closedSearchDrawer{
    
}
-(void)fieldsCleared{
    
    
    EGSearchOptyFilter *defaultSearchFilter = [self lastWeekC0OptyQuery];
    
    if([searchOptyFilter isEqual:defaultSearchFilter])
        return;
    
    if (![self.parentVC isEqualToString:MYPAGE] ){
        [self.optywithsalessatgelbl setText:[NSString stringWithFormat:@"Opportunities with Sales Stage : %@",SEARCH_FILTER_SALES_STAGE_C0]];
    }
    
    [opportunityPagedArray clearAllItems];
    [self.collectionView reloadData];
    searchOptyFilter = defaultSearchFilter;
    [self loadMore:self.collectionView.egPagedDataSource];
}

// -------------------------------------------------------------------------
-(void)searchViewConfiguration{

    searchOpportunityView = [[SearchOpportunityView alloc]initWithFrame:CGRectMake(0, 0, 350, self.view.frame.size.height)];
    searchOpportunityView.delegate = self;
    [searchOpportunityView setHidden:YES];
    [searchOpportunityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:searchOpportunityView];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:searchOpportunityView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:searchOpportunityView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:searchOpportunityView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom                                                                   multiplier:1.0
                                                                     constant:0];
    
    [self.view addConstraints:@[trailingConstraint,topConstraint,bottomConstraint]];
}
@end
