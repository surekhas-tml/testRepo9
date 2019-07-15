//
//  InfluencerViewController.m
//  e-guru
//
//  Created by Apple on 14/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "InfluencerViewController.h"
#import "InfluencerCollectionViewCell.h"
#import "MMGeoInfluencerTableViewCell.h"
#import "InfluencerViewModel.h"
#import "CustomerDropDownViewController.h"

@interface InfluencerViewController ()<CustomerPopUpCloseDelegate>
{
    NSInteger selectedDSE;
    NSInteger selectedMMGeo;
    CustomerDropDownViewController *customerPopUpVC;
}
@property (nonatomic) SourceOfContact contact;
@property (strong, nonatomic) InfluencerViewModel *influencerViewModel;
@end

@implementation InfluencerViewController
@synthesize txtFieldDSEDropDown;

#pragma mark - VC Lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.manageInfluencerSwitch.onTintColor = [UIColor buttonBackgroundBlueColor];
    [self addGestureToDropDownFields];
    self.influencerViewModel = [[InfluencerViewModel alloc]init];
    [self refreshUI];
    customerPopUpVC = [[UIStoryboard storyboardWithName:@"BeatPlan" bundle:nil] instantiateViewControllerWithIdentifier:@"customerDropDownVCIdentifier"];
    customerPopUpVC.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Helper
- (void)refreshUI{
    self.contact = Financier;
    selectedDSE = 0;
    selectedMMGeo = 0;
    NSString *type = @"";
    switch (self.invokedFrom) {
        case Influencer:{
            type = @"influencer";
            [self.lblSlideToManage setText:@"Slide to Manage Influencer"];
        }
            break;
        case MyCustomer:{
            type = @"customer";
            [self.lblSlideToManage setText:@"Slide to Manage Customer"];
        }
            break;
        default:
            break;
    }
    [self.influencerViewModel getHeaderListWithType:type];
    
    NSString *lobName = [[AppRepo sharedRepo] getLoggedInUser].lobName;
    NSString *dsmID = [[AppRepo sharedRepo] getLoggedInUser].primaryEmployeeID;
    
    [self.influencerViewModel getInfluencerApiWithType:type withid:dsmID withLOB:lobName withCompletionBlock:^(id  _Nonnull response) {
        self.txtFieldDSEDropDown.text = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
        self.txtFieldDSEDropDown.field.mSelectedValue = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
        [self.soureOfContactTableView reloadData];
        [self.mmGeoTableView reloadData];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
    }];
}

- (DropDownTextField *)txtFieldDSEDropDown {
    if (!txtFieldDSEDropDown.field) {
        txtFieldDSEDropDown.field = [[Field alloc] init];
    }
    return txtFieldDSEDropDown;
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self.txtFieldDSEDropDown.superview addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    CGPoint point = [gesture locationInView:gesture.view];
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.txtFieldDSEDropDown) {
                    if ([self.influencerViewModel getAllDataDSEID].count == 0){
                        return;
                    }
                    DropDownViewController *dropDown;
                    dropDown = [[DropDownViewController alloc] init];
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:[self.influencerViewModel getAllDataDSEID] andModelData:nil forView:self.txtFieldDSEDropDown withDelegate:self];
                }
            }
        }
    }
}

- (NSString*)invokedFrom:(InvokedFrom)from withType:(SourceOfContact)contact{
    switch (self.invokedFrom)
    {
        case MyCustomer:
        {
            switch (self.contact)
            {
                case Financier:
                    return @"Key Customer";
                    break;
                case Bodybuilder:
                    return @"Regular Visits";
                    break;
                default:
                    return @"";
                    break;
            }
        }
            break;
        case Influencer:
        {
            switch (self.contact)
            {
                case Financier:
                    return @"Financier Executives";
                    break;
                case Bodybuilder:
                    return @"Body Builders";
                    break;
                case Mechanic:
                    return @"Mechanic";
                    break;
                default:
                    return @"";
                    break;
            }
        }
            break;
        default:
            return @"";
            break;
    }
}

- (void)refreshSourceOfContactTableViewData:(NSIndexPath*)indexPath{
    MMGeoInfluencerTableViewCell *cell = [self.soureOfContactTableView dequeueReusableCellWithIdentifier:@"InfluencerTableViewCellIdentifier"];
    switch (self.contact) {
        case Financier:
            [cell updateModelFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives atSelectedIndex:indexPath.row];
            break;
        case Bodybuilder:
            [cell updateModelFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders atSelectedIndex:indexPath.row];
            break;
        case Mechanic:
            [cell updateModelFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics atSelectedIndex:indexPath.row];
            break;
        default:
            break;
    }
    [self.soureOfContactTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mmGeoTableView) {
        if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
            return [self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray count];
        }else{
            return 0;
        }
    } else {
        switch (self.contact) {
            case Financier:{
                if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
                    if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
                        return self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives.count;
                    }
                    return 0;
                }else{
                    return 0;
                }
            }
                break;
            case Bodybuilder:{
                if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
                    if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
                        return self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders.count;
                    }
                    return 0;
                }else{
                    return 0;
                }
            }
                break;
            case Mechanic:{
                if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
                    if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
                        return self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics.count;
                    }
                    return 0;
                }else{
                    return 0;
                }
            }
                break;
            default:
                return 0;
                break;
        }
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mmGeoTableView){
        MMGeoInfluencerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMGeoInfluencerTableViewCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUpUIData:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray andIndex:indexPath.row];
        return cell;
    }else{
        MMGeoInfluencerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfluencerTableViewCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (self.contact) {
            case Financier:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives andIndex:indexPath.row];
                break;
            case Bodybuilder:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders andIndex:indexPath.row];
                break;
            case Mechanic:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics andIndex:indexPath.row];
                break;
            default:
                break;
        }
        
        [cell onBtnDeleteClicked:^(NSInteger index) {
            
            NSMutableDictionary *params = [NSMutableDictionary new];
           
            switch (self.contact) {
                case Financier:
                    params = [cell getCustomerIDFromArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives atSelectedIndex:indexPath.row];
                    break;
                case Bodybuilder:
                    params = [cell getCustomerIDFromArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders atSelectedIndex:indexPath.row];
                    break;
                case Mechanic:
                    params = [cell getCustomerIDFromArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics atSelectedIndex:indexPath.row];
                    break;
                default:
                    break;
            }
            [params setValue:[self invokedFrom:self.invokedFrom withType:self.contact] forKey:@"channel_type"];
            NSString *status = [params valueForKey:@"status"];
            if ([[status lowercaseString] isEqualToString:@"true"]){
                [params setValue:@"false" forKey:@"status"];
            }else {
                [params setValue:@"true" forKey:@"status"];
            }
            __weak InfluencerViewController *vc = self;
            [self.influencerViewModel addCustomerWithParams:params isUpdate:YES withCompletionBlock:^(id  _Nonnull response){
                NSDictionary *responseDic = (NSDictionary*)response;
                NSDictionary *dataDic = responseDic[@"data"];
                NSString *message = [dataDic[@"status"] isEqualToString:@"false"] ? @"Customer de-activated successfully" : @"Customer activated successfully";
                [UtilityMethods alert_ShowMessage:message withTitle:APP_NAME andOKAction:^{
                    [vc refreshSourceOfContactTableViewData:indexPath];
                }];
            } withFailureBlock:^(NSError * _Nonnull error){
                //[customerDropDown.view removeFromSuperview];
            }];

            /*
            switch (self.contact) {
                case Financier:{
                    NSMutableArray *tempArray = [self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives mutableCopy];
                    [tempArray removeObjectAtIndex:index];
                    self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives = tempArray;
                }
                    break;
                case Bodybuilder:{
                    NSMutableArray *tempArray = [self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders mutableCopy];
                    [tempArray removeObjectAtIndex:index];
                    self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders = tempArray;
                }
                    break;
                case Mechanic:{
                    NSMutableArray *tempArray = [self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics mutableCopy];
                    [tempArray removeObjectAtIndex:index];
                    self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics = tempArray;
                }
                    break;
                default:
                    break;
            }
            [self.soureOfContactTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            */
        }];
    
        if (self.manageInfluencerSwitch.isOn){
            [cell.btnDelete setHidden:NO];
        }else{
            [cell.btnDelete setHidden:YES];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mmGeoTableView){
        self.contact = Financier;
        selectedMMGeo = indexPath.row;
        [self.influencerViewModel setHeaderSelectedAtIndex:0];
        
        MMGeoInfluencerTableViewCell *cell = (MMGeoInfluencerTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        switch (self.contact) {
            case Financier:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives andIndex:0];
                break;
            case Bodybuilder:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders andIndex:0];
                break;
            case Mechanic:
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics andIndex:0];
                break;
            default:
                break;
        }
        [cell setMMGeoSelectedAtIndex:indexPath.row fromArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray];
        [self.mmGeoTableView reloadData];
        [self.soureOfContactTableView reloadData];
        [self.soureOfContactCollectionView reloadData];
    } else {
        if (self.manageInfluencerSwitch.isOn){
            MMGeoInfluencerTableViewCell *cell = (MMGeoInfluencerTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            customerPopUpVC.popUpTitle = @"Edit Potential Prospect";
            customerPopUpVC.selectedChannelType = [self invokedFrom:self.invokedFrom withType:self.contact];
            customerPopUpVC.selectedDSE = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
            switch (self.contact) {
                case Financier:{
                    if ([[cell getStatusFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives atSelectedIndex:indexPath.row] boolValue] == YES){
                        customerPopUpVC.selectedCustomerDict = [cell getDataOfCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives atSelectedIndex:indexPath.row withMMGeoArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray atMMGeoIndex:selectedMMGeo];
                        [self.view addSubview:customerPopUpVC.view];
                    }
                }
                    break;
                case Bodybuilder:{
                    if ([[cell getStatusFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders atSelectedIndex:indexPath.row] boolValue] == YES){
                        customerPopUpVC.selectedCustomerDict = [cell getDataOfCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders atSelectedIndex:indexPath.row withMMGeoArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray atMMGeoIndex:selectedMMGeo];
                        [self.view addSubview:customerPopUpVC.view];
                    }
                }
                    break;
                case Mechanic:{
                    if ([[cell getStatusFromCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics atSelectedIndex:indexPath.row] boolValue] == YES){
                        customerPopUpVC.selectedCustomerDict = [cell getDataOfCustomerArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics atSelectedIndex:indexPath.row withMMGeoArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray atMMGeoIndex:selectedMMGeo];
                        [self.view addSubview:customerPopUpVC.view];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.soureOfContactTableView){
        MMGeoInfluencerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellIdentifier"];
        cell.lblTitle.hidden = YES;
        cell.containerView.hidden = NO;
        cell.btnDelete.hidden = YES;
        
        cell.lblName.text = @"Name";
        cell.lblAccName.text = @"Account Name";
        cell.lblContactNo.text = @"Contact No.";
        cell.lblLOB.text = @"LOB";
        cell.lblApplication.text = @"Application";
        return cell.contentView;
    }else{
        MMGeoInfluencerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMGeoInfluencerTableViewCellIdentifierHeader"];
        cell.lblTitle.hidden = NO;
        cell.containerView.hidden = YES;
        cell.btnDelete.hidden = YES;
        cell.lblTitle.text = @"MM Geography";
        return cell.contentView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.soureOfContactTableView && self.manageInfluencerSwitch.isOn){
//        if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
//            if (self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
                UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
                UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnPlus setFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width - 230, 45)];
                [btnPlus setBackgroundColor:[UIColor colorWithR:34.0 G:115.0 B:181.0 A:1.0]];
                [btnPlus.titleLabel setFont:[UIFont systemFontOfSize:40]];
                [btnPlus setImage:[UIImage imageNamed:@"add_btn_icon"] forState:UIControlStateNormal];
                [btnPlus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnPlus setTag:section];
                [btnPlus addTarget:self action:@selector(btnPlusClicked:) forControlEvents:UIControlEventTouchUpInside];
                [footerView addSubview:btnPlus];
                return footerView;
//            }
//        }
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.soureOfContactTableView && self.manageInfluencerSwitch.isOn){
//        if(self.influencerViewModel.egInfluencerDataModel.data.count > 0){
//            if (self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
                return 50;
//            }
//        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   // if (tableView == self.soureOfContactTableView){
        return 40;
   // }
   // return 0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.influencerViewModel.arrayHeaderList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InfluencerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InfluencerCollectionViewCellIdentifier" forIndexPath:indexPath];

    if ([self.influencerViewModel getValueOfHeaderAtIndex:indexPath.item]){
        cell.lblTitle.backgroundColor = [UIColor colorWithR:34.0 G:115.0 B:181.0 A:1.0];
        cell.lblTitle.textColor = [UIColor colorWithR:223.0 G:229.0 B:234.0 A:1.0];
    }else{
        cell.lblTitle.backgroundColor = [UIColor colorWithR:223.0 G:229.0 B:234.0 A:1.0];
        cell.lblTitle.textColor = [UIColor colorWithR:34.0 G:115.0 B:181.0 A:1.0];
    }
    cell.lblTitle.text = [self.influencerViewModel getTitleOfHeaderAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.soureOfContactCollectionView.frame.size.width/self.influencerViewModel.arrayHeaderList.count - 10, 50);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.item){
        case Financier:
            self.contact = Financier;
            break;
        case Bodybuilder:
            self.contact = Bodybuilder;
            break;
        case Mechanic:
            self.contact = Mechanic;
            break;
        default:
            break;
    }
    [self.influencerViewModel setHeaderSelectedAtIndex:indexPath.item];
    //[self.influencerViewModel getSourceOfContactArrayListFromContact:self.contact atDSEIndex:selectedDSE andMMGeoIndex:selectedMMGeo];
    [self.soureOfContactTableView reloadData];
    [self.soureOfContactCollectionView reloadData];
}

#pragma mark - UISwitch Action
- (IBAction)manageInfluencerSwitchMethod:(id)sender{
    [self.soureOfContactTableView reloadData];
}

#pragma mark - UIButton Action
- (IBAction)btnPlusClicked:(UIButton*)sender{
    NSLog(@"Show add popup %ld",(long)sender.tag);
    customerPopUpVC.popUpTitle = @"Add Potential Prospect";
    customerPopUpVC.selectedChannelType = [self invokedFrom:self.invokedFrom withType:self.contact];
    customerPopUpVC.selectedDSE = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
    
    if (self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count > 0){
        customerPopUpVC.selectedCustomerDict = @{
                                                 @"mmgeo":self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mmGeo,
                                                 @"district":self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].district,
                                                 @"city":self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].city
                                                 };
    }else{
        customerPopUpVC.selectedCustomerDict = @{
                                                 @"mmgeo":@""
                                                 };
    }
    
    [self.view addSubview:customerPopUpVC.view];
}

#pragma mark - CustomerPopUpCloseDelegate Action
- (void)onBackButtonClicked{
}

- (void)onAddButtonClicked{
    [self refreshUI];
    [self.soureOfContactCollectionView reloadData];
}

#pragma mark - DropDownViewControllerDelegate Method
- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
   
}

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView{
    self.contact = Financier;
    selectedMMGeo = 0;//--Set to Initial
    [self.influencerViewModel setHeaderSelectedAtIndex:0];
    
    MMGeoInfluencerTableViewCell *cell = (MMGeoInfluencerTableViewCell*)[self.mmGeoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    switch (self.contact) {
        case Financier:{
            if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count >0){
                if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives.count >0){
                [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].financier_executives andIndex:0];
                }
            }
        }
            break;
        case Bodybuilder:{
            if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count >0){
                if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders.count >0){
                    [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].bodyBuilders andIndex:0];
                }
            }
        }
            break;
        case Mechanic:{
            if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count >0){
                if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics.count >0){
                    [cell setUpUIDataForSourceOfContact:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray[selectedMMGeo].mechanics andIndex:0];
                }
            }
        }
            break;
        default:
            break;
    }
    if(self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray.count >0){
        [cell setMMGeoSelectedAtIndex:0 fromArray:self.influencerViewModel.egInfluencerDataModel.data[selectedDSE].dseMMGeoArray];
    }

    NSArray *arr = [self.influencerViewModel getAllDataDSEID];
    selectedDSE = arr.count > 0 ? [arr indexOfObject:selectedValue] : 0 ;
    self.txtFieldDSEDropDown.text = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
    self.txtFieldDSEDropDown.field.mSelectedValue = [self.influencerViewModel getTitleOfDSEAtIndex:selectedDSE];
    [self.soureOfContactCollectionView reloadData];
    [self.soureOfContactTableView reloadData];
    [self.mmGeoTableView reloadData];
}

@end
