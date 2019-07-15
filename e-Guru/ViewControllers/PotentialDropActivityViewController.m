//
//  PotentialDropActivityViewController.m
//  e-guru
//
//  Created by Apple on 03/05/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "PotentialDropActivityViewController.h"
#import "UtilityMethods.h"
#import "ContentCollectionViewCell.h"
#import "AppRepo.h"
#import "OpportunityDetailsViewController.h"

@interface PotentialDropActivityViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewObj;

@end

@implementation PotentialDropActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Potential Drop Off";
    [_collectionViewObj registerNib:[UINib nibWithNibName:@"ContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ContentCellIdentifier"];
    _collectionViewObj.dataSource = self;
    
    [self getActivitiesForOpty];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UtilityMethods navigationBarSetupForController:self];
}
#pragma mark - API Call
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
        [_collectionViewObj reloadData];
    }
}
-(NSMutableDictionary *)currentWeekQuery{
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    [request setObject:@"1000" forKey:@"size"];
    [request setObject:@"0" forKey:@"offset"];
    [request setObject:GTME_APP forKey:@"app_name"];
    [request setObject:@"Open" forKey:@"status"];
    [request setObject:[NSDate getDate:[[NSDate getEOD:[[self currentWeek] lastObject]] toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ] forKey:@"end_date"];
    [request setObject:[NSDate getDate:[[NSDate getSOD:[[self currentWeek] firstObject]] toGlobalTime]InFormat:dateFormatyyyyMMddTHHmmssZ] forKey:@"start_date"];
    return request;
}

-(NSMutableArray *)currentWeek{
    NSMutableArray * currentWeek = [NSMutableArray array];
  
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth  | NSCalendarUnitYear | NSCalendarUnitTimeZone | NSCalendarUnitHour fromDate:today];
        
        NSInteger dayofweek = [components weekday];
        [components setDay:([components day] - (dayofweek - 1))];
        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
        
        [currentWeek addObject:beginningOfWeek];
        for (int i = 0; i <= 5; i++) {
            [components setDay:([components day] + 1)];
            NSDate *nextDay = [gregorian dateFromComponents:components];
            [currentWeek addObject:nextDay];
        }
    return currentWeek;
    
}
- (NSMutableDictionary *)requestDictionary {
    if (!_requestDictionary) {
        NSNumber *num = [NSNumber numberWithInt:1] ;

        if ([[AppRepo sharedRepo] isDSMUser])
        {
            num = [NSNumber numberWithInt:2];
        }
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setMonth:-2];
        NSDate *lastMonth = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];

        NSString *lastMonthDate = [NSDate getDate:lastMonth InFormat:dateFormatyyyyMMddTHHmmssZ];
        NSString *today = [NSDate getDate:[NSDate date]InFormat:dateFormatyyyyMMddTHHmmssZ];
        _requestDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Potential Drop Off Reason",@"type",@"0",@"offset",@"1000",@"size",num,@"search_status",@"Open",@"status",GTME_APP,@"app_name",today,@"end_date",lastMonthDate, @"start_date", nil];
          }
    return _requestDictionary;
}

- (void)loadMore{
    NSString *offsetString = [NSString stringWithFormat:@"%ld", (long)[_activityList count]];
    [self.requestDictionary setObject:offsetString forKey:@"offset"];
    [self getActivitiesForOpty];

}
-(void)getActivitiesForOpty{
    NSString  *offset = [self.requestDictionary objectForKey:@"offset"];
    if ([offset integerValue] == 0) {
        [self.activityList clearAllItems];
        [self.collectionViewObj reloadData];
    }
    [[EGRKWebserviceRepository sharedRepository]searchActivity:self.requestDictionary andSucessAction:^(EGPagination *paginationObj) {
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
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 11;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return self.activityList.count + 1;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _activityList.count - 1) {  //numberofitem count
        [self loadMore];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContentCellIdentifier" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell setBackgroundColor:[UIColor tableTitleBarColor]];
        [cell.contentLabel setTextColor:[UIColor themePrimaryColor]];
        switch (indexPath.row) {
            case 0:
                cell.contentLabel.text = @" Activity ID ";
                break;
            case 1:
                cell.contentLabel.text = @"Opty ID ";
                break;
            case 2:
                cell.contentLabel.text = @" C0 Date ";

                break;
            case 3:
                cell.contentLabel.text = @" Stage ";
                break;
            case 4:
                
                cell.contentLabel.text = @"First Name";

                break;
            case 5:
                cell.contentLabel.text = @"Last Name";

                break;
            case 6:
                cell.contentLabel.text = @"Contact Number";

                break;
            case 7:
                cell.contentLabel.text = @"Potential Drop Off Reason";

                break;
            case 8:
                cell.contentLabel.text = @"Support Required";

                break;
            case 9:
                cell.contentLabel.text = @"Stakeholder";

                break;
            case 10:
                cell.contentLabel.text = @"Stakeholder Response";
                
                break;
            default:
                break;
        }
        
    } else {
        EGActivity *activity = [self.activityList objectAtIndex:indexPath.section - 1];
        if ( fmod(indexPath.section,2) == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor tableViewAlternateCellColor];
        }
        [cell.contentLabel setTextColor:[UIColor blackColor]];
        
        switch (indexPath.row) {
            case 0:
                cell.contentLabel.text  =activity.activityID;
                break;
            case 1:
                cell.contentLabel.text = activity.toOpportunity.optyID;
                break;
            case 2:
                cell.contentLabel.text = activity.endDate;
                break;
            case 3:
                cell.contentLabel.text = activity.toOpportunity.salesStageName;
                break;
            case 4:
                cell.contentLabel.text = activity.toOpportunity.toContact.firstName;

                break;
            case 5:
                cell.contentLabel.text = [activity.toOpportunity.toContact.lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
                break;
            case 6:
                cell.contentLabel.text = activity.toOpportunity.toContact.contactNumber;
                break;
            
                break;
            case 7:
                cell.contentLabel.text = activity.activitySubtype;
                break;
            case 8:
                cell.contentLabel.text = activity.activityDescription;
                break;
            case 9:
                cell.contentLabel.text = activity.stakeholder;
                break;
            case 10:
                cell.contentLabel.text = activity.stakeholderResponse;
                break;
            default:
                break;
        }}
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section != 0 && indexPath.row == 1) {
//        EGActivity *activity = [self.activityList objectAtIndex:indexPath.section - 1];
//        OpportunityDetailsViewController * optyViewController = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"opportunityDetails"];
//        optyViewController.opportunity = activity.toOpportunity;
//        [self.navigationController pushViewController:optyViewController animated:YES];
//    }
//    if (indexPath.section != 0 && indexPath.row == 0) {
//        EGActivity *activity = [self.activityList objectAtIndex:indexPath.section - 1];
//    }
//    if (indexPath.section != 0) {
//        EGActivity *activity = [self.activityList objectAtIndex:indexPath.section - 1];
//        OpportunityDetailsViewController * optyViewController = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"opportunityDetails"];
//        optyViewController.opportunity = activity.toOpportunity;
//        optyViewController.showOpty = @"My_Opportunity";
//        [self.navigationController pushViewController:optyViewController animated:YES];
//    }
}
@end
