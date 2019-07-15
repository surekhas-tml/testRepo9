//
//  TollFreeViewController.m
//  e-guru
//
//  Created by Devendra on 24/01/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "TollFreeViewController.h"
#import "Constant.h"
#import "UtilityMethods.h"
#import "ServiceTollFreeTableViewCell.h"

@interface TollFreeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView_ServiceTollFree;
@property (nonatomic,retain) NSArray *tollFreeNumbersArray;

@end

@implementation TollFreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setTitle:SERVICE_TOLL_FREE];
    [UtilityMethods navigationBarSetupForController:self];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_ServiceTollFree];
    
    self.tollFreeNumbersArray = [[NSArray alloc]initWithObjects:@{@"Name":@"Sampoorna Seva",@"Number":@"1800 209 79 79"},@{@"Name":@"Kavach",@"Number":@"1800 209 00 60"},@{@"Name":@"Priority Desk",@"Number":@"1800 258 25 89"}, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceTollFreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceTollFreeTableViewCellIdentifier"];
    NSDictionary *dataDictionary = self.tollFreeNumbersArray[indexPath.row];
    cell.label_Name.text = [dataDictionary objectForKey:@"Name"];
    cell.label_MobileNumber.text = [dataDictionary objectForKey:@"Number"];
    // Configure the cell...
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
