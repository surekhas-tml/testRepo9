//
//  PotentialDropOffViewController.m
//  e-guru
//
//  Created by Apple on 22/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "PotentialDropOffViewController.h"
#import "PotentialDropOffTableViewCell.h"
#import "EGRKWebserviceRepository.h"
#import "AppRepo.h"

@interface PotentialDropOffViewController ()
{
    UITapGestureRecognizer *tapRecognizer;
}
@end

@implementation PotentialDropOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Update Opportunity";
    [self.potentialDropTableView setAllowsSelection:FALSE];
    [UtilityMethods navigationBarSetupForController:self];
    
    [_potentialDropTableView registerNib:[UINib nibWithNibName:@"PotentialDropOffTableViewCell" bundle:nil] forCellReuseIdentifier:@"PDTableCell"];
    _potentialDropTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _potentialDropTableView.bounds.size.width, 0.01f)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(fieldTapped:)];
    [self.potentialDropDownSelectionView addGestureRecognizer:tapGesture];
//    [self addGestureRecogniserToView];

    [self getActivitiesForOpty];    // Do any additional setup after loading the view.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)fieldTapped:(UITapGestureRecognizer *)gesture {
    [self showPopOver:_potentialDropOffDropDownTextField];
}
/*
 @"Cust ineligible for finance",
 @"Delay in tender",
 @"Discount"
 @"Financing issue",
 @"Invalid entry",
 @"Mileage concern",
 @"Ongoing negotiations",
 @"Product acceptance",
 @"Requirement dropped",
 @"Requirement Postponed",
 @"Resale value",
 @"Service-related issues",
 @"Vehicle performance issue",
 @"Vehicle billed, in transit",
 @"Vehicle stck unavailable"
 */
- (void)showPopOver:(DropDownTextField *)textField {
    _potentialDropOffDropDownTextField.field = [[Field alloc]init];
    _potentialDropOffDropDownTextField.field.mValues = [[NSMutableArray alloc] initWithObjects:@"Cust ineligible for finance",
                                                        @"Delay in tender",
                                                        @"Discount",
                                                        @"Financing issue",
                                                        @"Invalid entry",
                                                        @"Mileage concern",
                                                        @"Ongoing negotiations",
                                                        @"Product acceptance",
                                                        @"Requirement dropped",
                                                        @"Requirement Postponed",
                                                        @"Resale value",
                                                        @"Service-related issues",
                                                        @"Vehicle performance issue",
                                                        @"Vehicle billed, in transit",
                                                        @"Vehicle stck unavailable", nil];

    _potentialDropOffDropDownTextField.field.mDataList = [[NSMutableArray alloc] initWithObjects:@"Cust ineligible for finance",
                                                          @"Delay in tender",
                                                          @"Discount",
                                                          @"Financing issue",
                                                          @"Invalid entry",
                                                          @"Mileage concern",
                                                          @"Ongoing negotiations",
                                                          @"Product acceptance",
                                                          @"Requirement dropped",
                                                          @"Requirement Postponed",
                                                          @"Resale value",
                                                          @"Service-related issues",
                                                          @"Vehicle performance issue",
                                                          @"Vehicle billed, in transit",
                                                          @"Vehicle stck unavailable", nil];
    
    [self.view endEditing:true];
    DropDownViewController *dropDown = [[DropDownViewController alloc] init];
    dropDown.fromPotentialDropOff = TRUE;
    [dropDown showDropDownInController:self withData:_potentialDropOffDropDownTextField.field.mValues andModelData:_potentialDropOffDropDownTextField.field.mDataList forView:textField withDelegate:self];
}
-(void)clearTextField{
    self.potentialDropOffDropDownTextField.text = nil;
    self.supportInterventionTextField.text = nil;
}
#pragma mark - DropDownViewControllerDelegate Method
- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    self.potentialDropOffDropDownTextField.text = selectedValue;
}
#pragma mark - uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activityList currentSize];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PotentialDropOffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDTableCell"];
    EGActivity *activity = [self.activityList objectAtIndex:indexPath.row];
    NSString *pd = @"";
    if ([activity.activitySubtype length ]>0){
        pd = activity.activitySubtype;
    }
    cell.potentialDropOffLabel.text = pd;
    cell.supportIterventionTextField.text = activity.activityDescription;
    cell.updateButton.tag = indexPath.row;
    cell.stakeholderTextField.text = activity.stakeholder;
    NSString *res = @"";
    if([activity.stakeholderResponse length]>0){
        res = activity.stakeholderResponse;
    }
    if ([activity.status isEqualToString:@"Done"]) {
        cell.updateButton.enabled = FALSE;
        cell.supportIterventionTextField.enabled = FALSE;
        [cell.updateButton setTitleColor:[UIColor themeDisabledColor] forState:UIControlStateNormal];
    }else{
        cell.updateButton.enabled = TRUE;
        cell.supportIterventionTextField.enabled = TRUE;
        [cell.updateButton setTitleColor:[UIColor themePrimaryColor] forState:UIControlStateNormal];
    }
    
    cell.stakeholderResponseTextField.text = res;
    
    [cell onupdatebtnclicked:^(NSInteger index) {
        EGActivity *updateactivity = [self.activityList objectAtIndex:indexPath.row];
        [self updateActivityForActivity:updateactivity forcell:cell];
    }];
    return cell;
}

- (IBAction)createOrUpdateActivityClicked:(UIButton *)sender {
    [self.supportInterventionTextField resignFirstResponder];
    if (self.potentialDropOffDropDownTextField.text.length  == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select potential drop off reason" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [[EGRKWebserviceRepository sharedRepository] createGTMEActivity:@{
                                                                      @"opty_id":self.opportunity.optyID,
                                                                      @"activity_type":@"Potential Drop Off Reason",
                                                                      @"sub_type":self.potentialDropOffDropDownTextField.text,
                                                                      @"activity_status":@"Open",
                                                                      @"planned_start":@"",
                                                                      @"comments":self.supportInterventionTextField.text,
                                                                      @"emp_row_id":[[AppRepo sharedRepo] getLoggedInUser].employeeRowID,
                                                                      @"login_username":[[AppRepo sharedRepo] getLoggedInUser].userName
                                                                      } withLoadingView:TRUE andSucessAction:^(id activity) {
                                                                          NSLog(@"%@",[activity allValues]);
                                                                          [UtilityMethods showProgressHUD:true];
                                                                          [self performSelector:@selector(getActivitiesForOpty)  withObject:nil afterDelay:4];
                                                                          
                                                                          
                                                                      } andFailuerAction:^(NSError *error) {
                                                                          
                                                                      }];}

-(void)updateActivityForActivity:(EGActivity*)activity forcell:(PotentialDropOffTableViewCell*)cell{
    NSString *response = @"";  NSString * responsible = @"";
    if ([cell.stakeholderResponseTextField.text length]){
        response = cell.stakeholderResponseTextField.text;
    }
    if ([cell.stakeholderTextField.text length]){
        responsible = cell.stakeholderTextField.text;
    }else{
        responsible = activity.stakeholder;
    }
    [cell.stakeholderResponseTextField resignFirstResponder];
    [cell.stakeholderTextField resignFirstResponder];
    [cell.supportIterventionTextField resignFirstResponder];

    [[EGRKWebserviceRepository sharedRepository] updateGTMEActivity:@{
                                                                      @"opty_id":self.opportunity.optyID,
                                                                      @"activity_id":activity.activityID,
                                                                      @"activity_type":activity.activityType,
                                                                      @"sub_type":activity.activitySubtype,
                                                                      @"activity_status":activity.status,
                                                                      @"planned_start":@"",
                                                                      @"response" : response,
                                                                      @"comments":cell.supportIterventionTextField.text,
                                                                      @"emp_row_id":[[AppRepo sharedRepo] getLoggedInUser].employeeRowID,
                                                                      @"login_username": [[AppRepo sharedRepo] getLoggedInUser].userName
                                                                      } withLoadingView:TRUE andSucessAction:^(id activity) {
                                                                          NSLog(@"%@",[activity allValues]);
//                                                                          [UtilityMethods showProgressHUD:true];
//                                                                          [self performSelector:@selector(getActivitiesForOpty)  withObject:nil afterDelay:4];
                                                                            [UtilityMethods showToastWithMessage:@"Updated successfully"];
                                                                      } andFailuerAction:^(NSError *error) {
                                                                         
                                                                      }];
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    self.activityList = [EGPagedArray mergeWithCopy:self.activityList withPagination:paginationObj];
    if(self.activityList) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        NSArray *array = [self.activityList.getEmbededArray sortedArrayUsingComparator:^NSComparisonResult(EGActivity *obj1, EGActivity *obj2) {
            NSDate *d1 = [formatter dateFromString:obj1.endDate];
            NSDate *d2 = [formatter dateFromString:obj2.endDate];
                        return [d2 compare:d1]; // descending order
        }];
        self.activityList = [[EGPagedArray alloc]initWithArray:array];
        [self.potentialDropTableView refreshData:self.activityList];
    }
    [self.potentialDropTableView reloadData];
}
-(void)getActivitiesForOpty{
    [_activityList clearAllItems];
    [self.potentialDropTableView reloadData];
    [[EGRKWebserviceRepository sharedRepository]searchGTMEActivity:@{
                                                                 @"opty_id":self.opportunity.optyID,
                                                                 @"type":@"Potential Drop Off Reason", @"size": @"1000",
                                                                 @"offset":@"0"
                                                                 } andSucessAction:^(EGPagination *paginationObj) {
                                                                     if (paginationObj.items && [paginationObj.items count] > 0) {
                                                                         //            NSPredicate *pred =
                                                                         //            [NSPredicate predicateWithFormat:@"SELF.activityType contains[cd] %@",@"Potential Drop Off Reason"];
                                                                         //            [paginationObj.items filterUsingPredicate:pred];
                                                                         [self loadResultInTableView:paginationObj];
                                                                     }
                                                                     [UtilityMethods hideProgressHUD];
                                                                     
                                                                 } andFailuerAction:^(NSError *error) {
                                                                     [UtilityMethods hideProgressHUD];
                                                                     
                                                                 }];
    [self clearTextField];
}

-(void)addGestureRecogniserToView{
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)gestureHandlerMethod:(id)sender{
    [self.view endEditing:true];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end
