//
//  MyTeamViewController.m
//  e-guru
//
//  Created by Apple on 13/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "MyTeamViewController.h"
#import "DSENameTableViewCell.h"
#import "MMGEOCollectionViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "DSEModel.h"
#import "MMGEOLocationModel.h"
#import "MyTeamViewModel.h"
#import "DSEGeoLocationListViewController.h"
#import "AppRepo.h"
#import "Constant.h"
#import "UtilityMethods.h"



@interface MyTeamViewController ()<ManageDSELocationOfMyTeamDelegate,newLocationAddTODSEDelegate>
{
    BOOL isManageLocationSwitchActivated;
    NSMutableArray *dseNameArray;
    NSMutableArray *dsewiseMMGEOLocationArray;
    MyTeamViewModel *teamViewModelObject;
    
    
    UIStoryboard *board;
    DSEGeoLocationListViewController *locationListView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *locationCollectionView;
@end

@implementation MyTeamViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fetchDSEButton.backgroundColor = [UIColor buttonBackgroundBlueColor];
    self.manageMMGEOSwitch.onTintColor = [UIColor buttonBackgroundBlueColor];
    isManageLocationSwitchActivated = NO;
    self.manageMMGEOSwitch.on = NO;

    board = [UIStoryboard storyboardWithName:@"BeatPlan" bundle:nil];
    locationListView = [board instantiateViewControllerWithIdentifier:@"DSEGeoLocationListVC"];
    locationListView.delegate = self;
    
    self.fetchDSEButton.layer.cornerRadius = 3.0f;
    self.fetchDSEButton.layer.masksToBounds = true;
}

//Delegate Method
-(void)updateMyTeamDetailsCallBack{
    [self getMyTeamDetails];
}

//getMyTeamDetails Method
-(void)getMyTeamDetails{
    NSString *dsmIdStr = [[AppRepo sharedRepo] getLoggedInUser].employeeRowID;
    NSString *lobStr = [[AppRepo sharedRepo] getLoggedInUser].lobName;
    
    NSDictionary *requestDictionary = @{
                                        @"dsm_id": dsmIdStr,
                                        @"lob": lobStr
                                        };
    
//    [UtilityMethods showProgressHUD:true];

    [teamViewModelObject getMyTeamApiWithType:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSLog(@"array Size: %lu",(unsigned long)teamViewModelObject.dsewiseMMGEOLocationArray.count);
        [self.dseTableView reloadData];
//        [UtilityMethods hideProgressHUD];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
//        [UtilityMethods hideProgressHUD];
    }];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    teamViewModelObject = [[MyTeamViewModel alloc]init];
    NSString *data = [teamViewModelObject getData];
    NSLog(@"MVVM : VC DATA : %@",data);
    
    //
    [self getMyTeamDetails];
}

#pragma mark - TableView Delegates - numberOfSectionsInTableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - TableView Delegates - numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return teamViewModelObject.dsewiseMMGEOLocationArray.count;
}

#pragma mark - UITableViewDelegate - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"DSETableCell";
    
    DSENameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[DSENameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.dseNameLabel.text = [teamViewModelObject getDSEName:indexPath.row];
    cell.locationNameArray = [teamViewModelObject getLocationList:indexPath.row];
    
    cell.selectedDSERowId = indexPath.row;
    cell.addNewLocationButton.tag = indexPath.row;
    [cell.addNewLocationButton addTarget:self action:@selector(showLocationList:) forControlEvents:UIControlEventTouchUpInside];

    if (isManageLocationSwitchActivated == YES) {
        cell.isManageLocationSwitchActivated = YES;
        cell.locationCollectionTailingSpaceOutlet.constant = 65;
        cell.addNewLocationButton.hidden = false;
        [cell.locationCollectionView reloadData];
    }
    else
    {
        cell.isManageLocationSwitchActivated = NO;
        cell.locationCollectionTailingSpaceOutlet.constant = 8;
        cell.addNewLocationButton.hidden = true;
        [cell.locationCollectionView reloadData];
    }
    
    if ( fmod(indexPath.row,2) != 0) {
        cell.backgroundColor = [UIColor tableDarkRowColor];
    }else{
        cell.backgroundColor = [UIColor tableLightRowColor];
    }
    
    cell.addNewLocationButton.layer.borderWidth = 1.0;
    cell.addNewLocationButton.layer.borderColor = [[UIColor nonmandatoryFieldRedBorderColor] CGColor];
    
    //RemoveDSE
    // this is where you set your color view
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:203/255.0
                    green:97/255.0
                     blue:133/255.0
                    alpha:0.2];
    cell.selectedBackgroundView =  customColorView;

   // cell.dseNameLabel.userInteractionEnabled = true;
  //  cell.dseNameLabel.tag =indexPath.row;
   // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDSERecord:)];
   // [cell.dseNameLabel addGestureRecognizer:tapGesture];
    
    //delegate for removal of loaction
    cell.delegate = self;

    NSString *statusStr;
    
    statusStr = [teamViewModelObject isDSEAcivated:indexPath.row] ? @"true":@"false";
    NSLog(@"statusStr %@",statusStr);

    //
    cell.dseNameLabel.layer.shadowColor = [UIColor lightTextColor].CGColor;
    cell.dseNameLabel.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    cell.dseNameLabel.layer.shadowRadius = 2.0f;
    cell.dseNameLabel.layer.shadowOpacity = 0.3f;
    cell.dseNameLabel.layer.masksToBounds = NO;
    cell.dseNameLabel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.dseNameLabel.layer.borderWidth = 1.0;
    cell.dseNameLabel.layer.cornerRadius = 5;
    
    if (![teamViewModelObject isDSEAcivated:indexPath.row]) {
        cell.dseNameLabel.layer.borderColor = [UIColor colorWithRed:203/255.0
                                                              green:97/255.0
                                                               blue:133/255.0
                                                              alpha:0.8].CGColor;
    }
    else{
        cell.dseNameLabel.layer.borderColor = [[UIColor nonmandatoryFieldRedBorderColor] CGColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{return 50;}

#pragma mark - fetchDSEMethod

- (IBAction)fetchDSEMethod:(id)sender {

    NSString *dsmIdStr = [[AppRepo sharedRepo] getLoggedInUser].employeeRowID;
    NSString *lobStr = [[AppRepo sharedRepo] getLoggedInUser].lobName;
    
//    NSDictionary *requestDictionary = @{
//                                        @"dsm_id": dsmIdStr,
//                                        @"lob": lobStr,
//                                        @"fetch_dse":@"True"
//                                        };
    NSDictionary *requestDictionary = @{
                                        @"dsm_id": dsmIdStr,

                                        };

    [UtilityMethods showProgressHUD:true];
    [teamViewModelObject getMyTeamApiWithType:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
        NSLog(@"fetch array Size: %lu",(unsigned long)teamViewModelObject.dsewiseMMGEOLocationArray.count);
        [self.dseTableView reloadData];
        [UtilityMethods hideProgressHUD];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
        [UtilityMethods hideProgressHUD];
    }];
}

#pragma mark - show location list of DSE

-(void)showLocationList:(UIButton*)sender{
    DSEModel *dseObject = [teamViewModelObject.dsewiseMMGEOLocationArray objectAtIndex:sender.tag];
    NSLog(@"Location List counnt: %lu",(unsigned long)[dseObject.locationListForDSE count]);
    locationListView.dseLocationListArray = dseObject.locationListForDSE;
    locationListView.dseObject = dseObject;
    [self.view addSubview:locationListView.view];
}

#pragma mark - manageLocationMethod
- (IBAction)manageLocationMethod:(id)sender {
    if (self.manageMMGEOSwitch.isOn) {
         isManageLocationSwitchActivated = YES;
        self.dseTableView.allowsSelection = YES;
    }
    else{
         isManageLocationSwitchActivated = NO;
         self.dseTableView.allowsSelection = NO;
    }
    [self.dseTableView reloadData];
}

#pragma mark - removeDSELocation Delegate

//Custom Delegate
-(void)removeDSELocation:(NSInteger)tag:(NSInteger)locationTag{
    
    DSEModel *dse = [teamViewModelObject.dsewiseMMGEOLocationArray objectAtIndex:tag];
    MMGEOLocationModel *location = [dse.locationListForDSE objectAtIndex:locationTag];
    NSString *msgString = [NSString stringWithFormat:@"Are You Sure Want to Remove %@ ?",location.microMarketName];
    if (dse.locationListForDSE.count !=0 ){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:APP_NAME
                                     message:msgString
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"No", @"No action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        UIAlertAction* yesButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //remove DSE
                                       [self callToRemoveMMGEO:dse :location];
                                   }];
        [yesButton setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"Confirmed Protocol");
}


#pragma mark - callToRemoveMMGEO

-(void)callToRemoveMMGEO:(DSEModel*)dse :(MMGEOLocationModel*)mmgeoLocation{
    if (dse.locationListForDSE.count !=0 ) {
        NSDictionary *requestDictionary = @{
                                            @"dse_id": dse.dseName,
                                            @"mm_geo_location": mmgeoLocation.microMarketName
                                            };
        [teamViewModelObject removeMMGEOLocationDSE:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
            NSDictionary *mmgeoDict = (NSDictionary*)response ;
            NSLog(@"Response:%@",[mmgeoDict objectForKey:@"msg"]);
            [UtilityMethods showToastWithMessage:[mmgeoDict objectForKey:@"msg"]];
            
            [self getMyTeamDetails];
        } withFailureBlock:^(NSError * _Nonnull error) {
            //Show Error
        }];
    }
}


// DSE Remove
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [teamViewModelObject.dsewiseMMGEOLocationArray removeObjectAtIndex:indexPath.row];
    [self.dseTableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewCellEditingStyleDelete;
}*/

#pragma mark - removeDSERecord

//DSE Remove
-(void)removeDSERecord:(UILongPressGestureRecognizer*)recognizer
{
    UILabel *dseLabel = (UILabel*)recognizer.view ;

    if (recognizer.state == UIPressPhaseBegan) {dseLabel.backgroundColor = [UIColor redColor];}
    if (recognizer.state == UIPressPhaseEnded) {
        dseLabel.backgroundColor = [UIColor redColor];
//        [teamViewModelObject.dsewiseMMGEOLocationArray removeObjectAtIndex:dseLabel.tag];
//        [self.dseTableView reloadData];
//
        //TODO : Integrate RemoveDSE API
        NSDictionary *requestDictionary = @{
                                            @"dse_id": @"",
                                            };
        
        [teamViewModelObject removeDSE:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
            [teamViewModelObject.dsewiseMMGEOLocationArray removeObjectAtIndex:dseLabel.tag];
            [self.dseTableView reloadData];
        } withFailureBlock:^(NSError * _Nonnull error) {
            //Show Error
        }];
    }
}

#pragma mark - didSelectRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dseName = [teamViewModelObject getDSEName:indexPath.row];
    NSString * msg = [NSString stringWithFormat:@"Are You Sure Want to Remove %@?",dseName];
    NSString * msgString = [NSString stringWithFormat:@"%@ is Active DSE, so can't remove it",dseName];
    
    if (isManageLocationSwitchActivated && ![teamViewModelObject isDSEAcivated:indexPath.row]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:APP_NAME
                                     message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"No", @"No action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //no
                                        [self.dseTableView deselectRowAtIndexPath:indexPath animated:false];
                                    }];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                     
                                       //remove DSE
                                       //                                        [teamViewModelObject.dsewiseMMGEOLocationArray removeObjectAtIndex:indexPath.row];
                                       //                                        [self.dseTableView reloadData];
                                       //API Call
                                       [self removeDSE:indexPath.row];
                                       
                                   }];
        [yesButton setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (isManageLocationSwitchActivated && [teamViewModelObject isDSEAcivated:indexPath.row])
    {
        [UtilityMethods alert_ShowMessage:msgString withTitle:APP_NAME andOKAction:^{
            [self.dseTableView deselectRowAtIndexPath:indexPath animated:false];
        }];
    }
}

#pragma mark - didDeselectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
     DSENameTableViewCell *cell = (DSENameTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    UIView *customColorView = [[UIView alloc] init];
//    customColorView.backgroundColor = [UIColor clearColor];
//    cell.selectedBackgroundView =  customColorView;
//    [self.dseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

//Remove DSE Call
// ** Snehal Change In REquest Removal Of DSE
-(void)removeDSE:(NSInteger)index{
    //TODO : Integrate RemoveDSE API
    DSEModel *dse = [teamViewModelObject.dsewiseMMGEOLocationArray objectAtIndex:index];
    NSString *statusStr;
    
    statusStr = dse.isActive ? @"true":@"false";
    
    NSDictionary *requestDictionary = @{
                                        @"dse_id": dse.dseName,
                                        @"status": statusStr
                                        };
    
    [teamViewModelObject removeDSE:requestDictionary withCompletionBlock:^(id  _Nonnull response) {
         [self getMyTeamDetails];
    } withFailureBlock:^(NSError * _Nonnull error) {
        //Show Error
    }];
}


#pragma mark - heightForHeaderInSection

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

#pragma mark - viewForHeaderInSection

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell * cell ;
    NSString *tableIdentifier  = @"HeaderCell";
    cell = [self.dseTableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    return cell;
}
@end
