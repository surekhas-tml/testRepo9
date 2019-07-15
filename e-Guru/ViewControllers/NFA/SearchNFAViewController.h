//
//  SearchNFAViewController.h
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilityMethods.h"
#import "HHSlideView.h"
#import "HHSlideView+TabSelectionExtention.h"
#import "NFAHHSlideView.h"
#import "NFACollectionViewContainerViewController.h"
#import "NFADetailViewController.h"
#import "Constant.h"
@interface SearchNFAViewController : UIViewController<UISplitViewControllerDelegate,SearchNFAViewDelegate, CreateNFAViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *addNFAButton;
@property (weak, nonatomic) IBOutlet UIButton *searchNFAButton;

- (IBAction)addNFA:(id)sender;
- (IBAction)searchNFA:(id)sender;

@property (nonatomic, strong) NFACollectionViewContainerViewController *nfaPendingViewController;
@property (nonatomic, strong) NFACollectionViewContainerViewController *nfaExpiredViewController;
@property (nonatomic, strong) NFACollectionViewContainerViewController *nfaRejectedViewController;
@property (nonatomic, strong) NFACollectionViewContainerViewController *nfaApprovedViewController;
@property (assign, nonatomic) InvokedFrom invokedFrom;

-(void)searchNFAWithQueryParameters:(NSDictionary *) queryParams;
@end
