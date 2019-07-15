//
//  DSEGeoLocationListViewController.m
//  e-guru
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "DSEGeoLocationListViewController.h"
#import "LocationDetailsTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "AddNewLocationViewController.h"
#import "MMGEOLocationModel.h"



@interface DSEGeoLocationListViewController ()<addLOcationDelegate>
{
    UIStoryboard *board;
    AddNewLocationViewController *assignLocationiew;
    NSMutableArray *mmgeoList ;
}
@end

@implementation DSEGeoLocationListViewController

#pragma mark - viewWillAppear

-(void)viewWillAppear:(BOOL)animated{
//    mmgeoList = [[NSMutableArray alloc]init];
//    mmgeoList = [self.dseLocationListArray mutableCopy];
    [self.locationTableView reloadData];
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addLocationButton.backgroundColor = [UIColor buttonBackgroundBlueColor];
    self.saveButton.backgroundColor = [UIColor buttonBackgroundBlueColor];
    self.backButton.backgroundColor = [UIColor buttonBackgroundBlueColor];

    board = [UIStoryboard storyboardWithName:@"BeatPlan" bundle:nil];
    assignLocationiew = [board instantiateViewControllerWithIdentifier:@"AddNewLocationVC"];
    NSLog(@"DSE Obj Data :%@",_dseObject.dseId);
    assignLocationiew.delegate = self;
    
    self.backButton.layer.cornerRadius = 3.0f;
    self.backButton.layer.masksToBounds = true;
    self.addLocationButton.layer.cornerRadius = 3.0f;
    self.addLocationButton.layer.masksToBounds = true;
}

#pragma mark - TableViewDelegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dseLocationListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocationDetailsTableViewCell *cellDetail;
    NSString *tableIdentifier = @"LocationDetailCell";
 
    cellDetail = [self.locationTableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cellDetail == nil) {
        cellDetail = [[LocationDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    MMGEOLocationModel *locationObject = [self.dseLocationListArray objectAtIndex:indexPath.row];
    
    cellDetail.stateNameLabel.text = locationObject.stateName;
    cellDetail.districtNameLabel.text = locationObject.districtName;//@"Pune";
    cellDetail.microMarketNameLAbel.text = locationObject.microMarketName;//@"Wakad";
    cellDetail.lobNameLabel.text = locationObject.lobName;//@"HCV 1";
//    cellDetail.talukaNameLabel.text = locationObject.talukaName;//
    cellDetail.cityNameLabel.text = locationObject.cityName;//
    
    if ( fmod(indexPath.row,2) != 0) {
        cellDetail.backgroundColor = [UIColor tableDarkRowColor];
    }else{
        cellDetail.backgroundColor = [UIColor tableLightRowColor];
    }
    
    //    cell.dseNameLabel.text = [teamViewModelObject getDSEName:indexPath.row];
    //    cell.locationNameArray = [teamViewModelObject getLocationList:indexPath.row];
    return  cellDetail;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell * cell ;
    NSString *tableIdentifier  = @"HeaderCell";
    cell = [self.locationTableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    [cell setBackgroundColor:[UIColor tableTitleBarColor]];
    
    return cell;
}

- (CGFloat)getTextHeightFromString:(NSString *)text ViewWidth:(CGFloat)width WithPading:(CGFloat)pading FontName:(NSString *)fontName AndFontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:fontName size:fontSize]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    NSLog(@"rect.size.height: %f", rect.size.height);
    return rect.size.width + pading;
}

- (IBAction)backButtonMethod:(id)sender {
    [_delegate updateMyTeamDetailsCallBack];
    [self.view removeFromSuperview];
}
- (IBAction)addLocationMethod:(id)sender {
    [self.view addSubview:assignLocationiew.view];
    assignLocationiew.dsedata = self.dseObject;
}
- (IBAction)saveButtonMethod:(id)sender {
}

-(void)updateLocationListCallBack :(MMGEOLocationModel*)loactionObject{
    if (self.dseLocationListArray == nil) {
        self.dseLocationListArray = [[NSMutableArray alloc]init];
    }
    [self.dseLocationListArray addObject:loactionObject];
    [self.locationTableView reloadData];
}
@end
