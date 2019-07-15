//
//  NFACollectionViewContainerViewController.h
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "NFACollectionViewCell.h"
#import "DropDownViewController.h"
#import "UtilityMethods.h"
#import "EGPagedArray.h"
#import "EGPagedCollectionView.h"
#import "EGPagedTableView.h"
#import "EGPagedTableViewDataSource.h"
#import "nfaOperationsHelper.h"
#import "NFASearchView.h"
#import "NSDate+eGuruDate.h"
#import "EGNFA.h"
#import "NFAStatusMode.h"
@class SearchNFAViewController;
@interface NFACollectionViewContainerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,EGPagedCollectionViewDelegate,EGPagedCollectionViewDataSourceCallback,DropDownViewControllerDelegate,NFACollectionViewCellDelegate>{

}

-(EGSearchNFAFilter *)monthTillDateNFAQuery;
-(void)searchNFAWithQueryParameters:(NSDictionary *) queryParams;
@property (weak, nonatomic) IBOutlet EGPagedCollectionView *nfaCollectionView;
@property NFATabName TabMode;
@property (strong, nonatomic) SearchNFAViewController *searchNFAViewController;
@end
