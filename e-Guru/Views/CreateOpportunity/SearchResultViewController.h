//
//  SearchResultViewController.h
//  e-Guru
//
//  Created by Ashish Barve on 12/4/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"

@protocol SearchResultViewControllerDelegate <NSObject>

- (void)didSelectResultFromSearchResultController:(id)selectedObject;

@end

@interface SearchResultViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) id <SearchResultViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

- (void)showWithData:(NSArray *)dataArray fromViewController:(id)controller;

@end
