//
//  SearchResultViewController.m
//  e-Guru
//
//  Created by Ashish Barve on 12/4/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SearchResultViewController.h"
#import "EGReferralCustomer.h"
#import "EGTGM.h"
#import "EGBroker.h"
#import "NSString+NSStringCategory.h"
#import "ResultTwoLabelTableViewCell.h"

@interface SearchResultViewController () <UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *filteredArray;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapGestureOnView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)addTapGestureOnView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)showWithData:(NSArray *)dataArray fromViewController:(id)controller {
    self.dataArray = dataArray;
    self.filteredArray = dataArray;
    self.delegate = controller;
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController addChildViewController:self];
    self.view.frame = topRootViewController.view.frame;
    [topRootViewController.view addSubview:self.view];
    [self didMoveToParentViewController:topRootViewController];
    
   }

- (void)dismiss {
    [self.view removeFromSuperview];
}

-(void) reloadResultForInputString:(NSString *)inputString {
    
    if (self.dataArray && [self.dataArray count] > 0) {
        
        id dataObject = [self.dataArray objectAtIndex:0];
        NSPredicate *predicate;
        
        if ([inputString hasValue]) {
            
            if ([dataObject isKindOfClass:[EGBroker class]]) {
                predicate = [NSPredicate predicateWithFormat:@"SELF.accountName CONTAINS[c] %@", inputString];
            }
            else if ([dataObject isKindOfClass:[EGTGM class]]) {
                
            }
            else if ([dataObject isKindOfClass:[EGReferralCustomer class]]) {
                
                NSPredicate *predicateFirstName;
                NSPredicate *predicateLastName;
                
                NSArray *nameComponents = [inputString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([nameComponents count] > 1 && [[nameComponents lastObject] hasValue]) {
                    
                    predicateFirstName = [NSPredicate predicateWithFormat:@"SELF.firstName BEGINSWITH[cd] %@", [nameComponents firstObject]];
                    predicateLastName = [NSPredicate predicateWithFormat:@"SELF.lastName BEGINSWITH[cd] %@", [nameComponents lastObject]];
                    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateFirstName, predicateLastName]];
                    
                } else {
                    
                    NSString *trimmedString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    predicateFirstName = [NSPredicate predicateWithFormat:@"SELF.firstName BEGINSWITH[cd] %@", trimmedString];
                    predicateLastName = [NSPredicate predicateWithFormat:@"SELF.lastName BEGINSWITH[cd] %@", trimmedString];
                    predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateFirstName, predicateLastName]];
                }
            }
            
            self.filteredArray = [self.dataArray filteredArrayUsingPredicate:predicate];
        }
        else {
            self.filteredArray = self.dataArray;
        }
        
        [self.searchResultTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"TableCell";
    
    ResultTwoLabelTableViewCell *cell = (ResultTwoLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResultTwoLabelTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    id arrayObject = [self.filteredArray objectAtIndex:indexPath.row];
    if ([arrayObject isKindOfClass:[EGReferralCustomer class]]) {
        EGReferralCustomer *referralCustomer = (EGReferralCustomer *)arrayObject;
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@", [referralCustomer.firstName hasValue] ? referralCustomer.firstName : @"-", [referralCustomer.lastName hasValue] ? referralCustomer.lastName : @"-"]];
        [cell.numberLabel setText:[referralCustomer.cellPhoneNumber hasValue] ? referralCustomer.cellPhoneNumber : @"-"];

    }
    else if ([arrayObject isKindOfClass:[EGBroker class]]) {
        EGBroker *broker = (EGBroker *)arrayObject;
        [cell.nameLabel setText:[broker.accountName hasValue] ? broker.accountName : @"-"];
        [cell.numberLabel setText:[broker.mainPhoneNumber hasValue] ? broker.mainPhoneNumber : @"-"];

    }
    else if ([arrayObject isKindOfClass:[EGTGM class]]) {
        EGTGM *tgm = (EGTGM *)arrayObject;
        [cell.nameLabel setText:[tgm.accountName hasValue] ? tgm.accountName : @"-"];
        [cell.numberLabel setText:[tgm.mainPhoneNumber hasValue] ? tgm.mainPhoneNumber : @"-"];

    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectResultFromSearchResultController:)]) {
        [self.delegate didSelectResultFromSearchResultController:[self.filteredArray objectAtIndex:indexPath.row]];
        [self dismiss];
    }
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.searchResultTableView]) {
        return false;
    }
    return true;
}

#pragma mark - UISearchBarDelegate Methods

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *currentString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self reloadResultForInputString:currentString];
    return true;
}

@end
