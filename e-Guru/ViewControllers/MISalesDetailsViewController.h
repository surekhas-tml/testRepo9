//
//  MISalesDetailsViewController.h
//  e-guru
//
//  Created by Admin on 26/04/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"
#import "SearchMISSalesDetailsView.h"

@interface MISalesDetailsViewController : UIViewController<MISDetailsViewDelegate>

@property (strong, nonatomic) IBOutlet EGPagedTableView *MISalesDetailsTableView;
@property (strong, nonatomic) IBOutlet UIButton *dateFilterButton;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) NSString *fromToTillDateString;
@property (strong, nonatomic) NSString *dseUserID;
@property (strong, nonatomic) NSString *dseName;

- (IBAction)filterButtonTapped:(id)sender;
-(void)getDSEMISdetailsData:(NSDictionary *)requestDictionary;
@end
