//
//  EGCalenderViewControllerCollectionViewController.m
//  e-guru
//
//  Created by local admin on 12/20/16.
//  Copyright © 2016 TATA. All rights reserved.
//
#import "ScreenshotCapture.h"
#import "EGCalenderViewCollectionViewController.h"
#import "ActivityViewController.h"
NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";


@interface EGCalenderViewCollectionViewController ()<MSCollectionViewDelegateCalendarLayout>{
}

@property (nonatomic, strong) EGMSCollectionViewCalendarLayout *egcollectionViewCalendarLayout;

@property (nonatomic, readonly) CGFloat layoutSectionWidth;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonnull,nonatomic,strong) NSMutableArray *currentFilterSpan;
@property (nonnull,nonatomic,strong) NSMutableDictionary *eventDictionaryForWeek;

@end

@implementation EGCalenderViewCollectionViewController
@synthesize eventDictionaryForWeek,currentFilterSpan,requestDictionary;

static NSString * const reuseIdentifier = @"Cell";
- (id)init
{
    self.egcollectionViewCalendarLayout = [[EGMSCollectionViewCalendarLayout alloc] init];
    self.egcollectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.egcollectionViewCalendarLayout];
    self.viewMode = MSDayView;
    self.invokedFrom = MyPage;
    
    return self;
}

- (id)initWithViewMode:(NSString *)mode
{
    self.egcollectionViewCalendarLayout = [[EGMSCollectionViewCalendarLayout alloc] init];
    self.egcollectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.egcollectionViewCalendarLayout];
    self.viewMode = MSDayView;
    return self;
}
- (void)viewDidLoad {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    self.egcollectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    self.eventDictionaryForWeek = [NSMutableDictionary dictionary];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.egcollectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.egcollectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.egcollectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateActivityScreen)
                                                 name:@"UpdateActivityScreen"
                                               object:nil];

}
-(void)UpdateActivityScreen{
    [self refreshMode];
}
-(void)refreshMode{
    [self loadData];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    self.egcollectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    self.eventDictionaryForWeek = [NSMutableDictionary dictionary];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.egcollectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.egcollectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.egcollectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.egcollectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
}
- (void)loadData
{
    [self setCurrentFilterSpanFromQuery:[self requestDictionary]];
    [self searchActivityWithQueryParameters:[self requestDictionary]];
}
-(void)refreshCollectionView{
    [self.egcollectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionView reloadData];
    if ([self.collectionView numberOfSections] > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.egcollectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_CALENDER_SWITCH object:nil userInfo:nil];

        });

    }
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(NSMutableArray *)currentWeek{
    NSMutableArray * currentWeek = [NSMutableArray array];
    if ([self.viewMode isEqualToString:MSDayView] && self.invokedFrom == MyPage) {
        currentWeek = [NSMutableArray arrayWithArray:@[[NSDate date]]];
    }
    else{
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
    }
    return currentWeek;
    
}
-(NSMutableArray *)currentFilterSpan{
    if (currentFilterSpan) {
        return currentFilterSpan;
    }else{
    return [self currentWeek];
    }
}
-(void)setCurrentFilterSpanFromQuery:(NSDictionary *)queryParams{
    self.currentFilterSpan = [NSMutableArray array];
    NSMutableArray * timeSpan = [NSMutableArray array];
    NSDate *start_date = [NSDate getNSDateFromString:[queryParams objectForKey:@"start_date"] havingFormat:dateFormatyyyyMMddTHHmmssZ];
    NSDate *end_date = [NSDate getNSDateFromString:[queryParams objectForKey:@"end_date"] havingFormat:dateFormatyyyyMMddTHHmmssZ];
    [timeSpan addObject:start_date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth  | NSCalendarUnitYear | NSCalendarUnitTimeZone | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:start_date];
    [components setDay:([components day] + 1 )];
    NSDate *nextDay = [gregorian dateFromComponents:components];
    
        while ([end_date compare:nextDay] != NSOrderedAscending) {
            [timeSpan addObject:nextDay];
            [components setDay:([components day] + 1 )];// for beginning of the week.
            nextDay = [gregorian dateFromComponents:components];
    }

    currentFilterSpan = [NSMutableArray arrayWithArray:timeSpan];
}

-(NSMutableDictionary *)currentWeekQuery{
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    [request setObject:@"1000" forKey:@"size"];
    [request setObject:@"0" forKey:@"offset"];
    [request setObject:GTME_APP forKey:@"app_name"];
    [request setObject:@"Open" forKey:@"status"];
    [request setObject:[NSDate getDate:[[NSDate getEOD:[[self currentWeek] lastObject]] toGlobalTime] InFormat:dateFormatyyyyMMddTHHmmssZ] forKey:@"end_date"];
    [request setObject:[NSDate getDate:[[NSDate getSOD:[[self currentWeek] firstObject]] toGlobalTime]InFormat:dateFormatyyyyMMddTHHmmssZ] forKey:@"start_date"];
    
    [self setDSEDSMCorrespondingFlag:request];
    
    return request;
}

- (void)setDSEDSMCorrespondingFlag:(NSMutableDictionary *)dictionary {
    
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.activity isEqualToString:@"My_Activity"]) {
            [dictionary setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
            
        }
        else
        {
            [dictionary setObject:[NSNumber numberWithInt:2] forKey:@"search_status"];
        }}else{
            [dictionary setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
        }
}


- (NSMutableDictionary *)requestDictionary {
    if (requestDictionary) {
        [self setDSEDSMCorrespondingFlag:requestDictionary];
        return requestDictionary;
    }else{
        requestDictionary = [self currentWeekQuery];
    }
    return requestDictionary;
}

-(void)filterAppliedWithQueryParams:(NSDictionary *)queryParams {
    NSMutableDictionary *changeQuery = [NSMutableDictionary dictionaryWithDictionary:queryParams];
    [changeQuery setObject:[queryParams objectForKey:@"start_date"] forKey:@"start_date"];
    [changeQuery setObject:[queryParams objectForKey:@"end_date"] forKey:@"end_date"];
    [changeQuery setObject:@"1000" forKey:@"size"];
    [changeQuery setObject:@"0" forKey:@"offset"];
    if ([[[AppRepo sharedRepo] getLoggedInUser].positionType isEqualToString:PostionforDSM]) {
        if ([self.activity isEqualToString:@"My_Activity"]) {
            [changeQuery setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
            
        }
        else
        {
            [changeQuery setObject:[NSNumber numberWithInt:2] forKey:@"search_status"];
        }}else{
            [changeQuery setObject:[NSNumber numberWithInt:1] forKey:@"search_status"];
        }
    

    isFilterSet = YES;
    self.requestDictionary = [NSMutableDictionary dictionaryWithDictionary:changeQuery];
    [self setCurrentFilterSpanFromQuery:changeQuery];
    [self searchActivityWithQueryParameters:changeQuery];
}

- (void)searchActivityWithQueryParameters:(NSDictionary *)queryParams {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self toggleDayViewButton:false];
    
    [[EGRKWebserviceRepository sharedRepository]searchActivity:queryParams andSucessAction:^(EGPagination *paginationObj) {
        
        [self loadResultInTableView:paginationObj];
        [self toggleDayViewButton:true];
    } andFailuerAction:^(NSError *error) {
        [self activitySearchFailedWithErrorMessage:error];
        [self toggleDayViewButton:true];
    }];
}

- (void)toggleDayViewButton:(BOOL)enable {
    if (self.activityViewController) {
        [self.activityViewController toggleDayViewButton:enable];
    }
    
    if (self.weekViewController) {
        [self.weekViewController toggleDayViewButton:enable];
    }
}

- (void)loadResultInTableView:(EGPagination *)paginationObj {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.events = paginationObj.items;
    self.eventDictionaryForWeek = [NSMutableDictionary dictionary];
    [self converArrayToLocalTimeArray:self.currentFilterSpan];
    for (NSDate *dateL in self.currentFilterSpan) {

        NSString *keyString = [NSDate getDate:dateL InFormat:dateFormatyyyyMMddhyp];
        
        NSString * stringEOD = [NSDate getDate:dateL InFormat:dateFormatEODyyyyMMddTHHmmssZ];
        NSDate *EODdate = [NSDate getNSDateFromString:stringEOD havingFormat:dateFormatyyyyMMddTHHmmssZ];
        
        NSString * stringSOD = [NSDate getDate:dateL InFormat:dateFormatSODyyyyMMddTHHmmssZ];
        NSDate *SODdate = [NSDate getNSDateFromString:stringSOD havingFormat:dateFormatyyyyMMddTHHmmssZ];
        
        NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:self.events];
        NSMutableArray* result = [NSMutableArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        formatter.dateFormat = dateFormatyyyyMMddTHHmmssZ;
        for (EGActivity *dict in filteredArray) {
            NSString *dateString = [(EGActivity *)dict planedDateSystemTime];
            NSDate *date = [formatter dateFromString:dateString];
            if (([date compare:SODdate] == NSOrderedDescending && [date compare:EODdate] == NSOrderedAscending)||([date compare:SODdate] == NSOrderedSame || [date compare:EODdate] == NSOrderedSame)) {
                [result addObject:dict];
            }
        }
        [self.eventDictionaryForWeek setObject:result forKey:keyString];
    }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshCollectionView];
        });
}

-(void)activitySearchFailedWithErrorMessage:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [UtilityMethods alert_ShowMessage:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:nil];

    [ScreenshotCapture takeScreenshotOfView:self.view];
    AppDelegate *appDelegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
    appDelegate.screenNameForReportIssue = @"My Calendar";

    
    [UtilityMethods alert_ShowMessagewithreportissue:[UtilityMethods getErrorMessage:error] withTitle:APP_NAME andOKAction:^{
        
    } andReportIssueAction:^{
        
    }];

}

//-----------------
-(void)viewDidAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)layoutSectionWidth
{

    if ([self.viewMode isEqualToString:MSDayView] && self.invokedFrom == MyPage){
        return 240;
    }
    else if ([self.viewMode isEqualToString:MSDayView]) {
        return self.view.frame.size.width - 70;
    }
    else if ([self.viewMode isEqualToString:MSWeekView]){
        if ([self.currentFilterSpan count] == 1 ) {
            return self.view.frame.size.width - 70;
        }else if ([self.currentFilterSpan count] >= 7 ) {
            return (self.view.frame.size.width / 7.5f);
        }else{
            return ((self.view.frame.size.width - 50 ) / [self.currentFilterSpan count]);
        }
    }else{
        return 200;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.eventDictionaryForWeek allKeys] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *key = [NSDate formatDate:[(NSDate *)[self.currentFilterSpan objectAtIndex:section] description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp];
    return [[self.eventDictionaryForWeek objectForKey:key] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    if ([self.activity isEqualToString:@"My_Activity"]) {
        
        cell.dSENameNumber.hidden = YES;
    }else{
        cell.dSENameNumber.hidden = NO;
    }
    
    NSString *key = [NSDate formatDate:[(NSDate *)[self.currentFilterSpan objectAtIndex:(indexPath.section )] description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp];
    cell.event = [[self.eventDictionaryForWeek objectForKey:key]objectAtIndex:indexPath.row];
    [cell updateColors];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.egcollectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.egcollectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.egcollectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(EGMSCollectionViewCalendarLayout *)egcollectionViewCalendarLayout dayForSection:(NSInteger)section
{
    return [self.currentFilterSpan objectAtIndex:(section)];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(EGMSCollectionViewCalendarLayout *)egcollectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSDate formatDate:[(NSDate *)[self.currentFilterSpan objectAtIndex:(indexPath.section )] description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp];
    EGActivity *event = [[self.eventDictionaryForWeek objectForKey:key]objectAtIndex:indexPath.row];
    return [NSDate getNSDateFromString:[event planedDateSystemTime] havingFormat:dateFormatyyyyMMddTHHmmssZ];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(EGMSCollectionViewCalendarLayout *)egcollectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSDate formatDate:[(NSDate *)[self.currentFilterSpan objectAtIndex:(indexPath.section)] description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp];
    EGActivity *event = [[self.eventDictionaryForWeek objectForKey:key]objectAtIndex:indexPath.row];
    return [[NSDate getNSDateFromString:[event planedDateSystemTime] havingFormat:dateFormatyyyyMMddTHHmmssZ]dateByAddingTimeInterval:(60 * 60 * 1.2)];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(EGMSCollectionViewCalendarLayout *)egcollectionViewCalendarLayout
{
    return [NSDate date];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateActivityViewController *activityDetails = [[UIStoryboard storyboardWithName:@"ManageOpportunity" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateActivity_View"];
    NSString *key = [NSDate formatDate:[(NSDate *)[self.currentFilterSpan objectAtIndex:(indexPath.section)] description] FromFormat:dateFormatNSDateDate toFormat:dateFormatyyyyMMddhyp];
    activityDetails.activity = [[self.eventDictionaryForWeek objectForKey:key]objectAtIndex:indexPath.row];
    activityDetails.entryPoint = ACTIVITY;
    if ([self.activity isEqualToString:@"My_Activity"]) {
        activityDetails.checkuser=@"My_Activity";
    }
    else{
        activityDetails.checkuser=@"Team_Activity";
    }
    
    if (self.invokedFrom == Dashboard && self.dashboardViewController) {
        [self.dashboardViewController.navigationController pushViewController:activityDetails animated:true];
    }
    else {
        [self.navigationController pushViewController:activityDetails animated:YES];
    }
}
-(void)resetFilter{
    isFilterSet = !isFilterSet;
    self.requestDictionary = [self currentWeekQuery];
    [self refreshMode];
}

-(void)converArrayToLocalTimeArray:(NSArray *)array{
    NSMutableArray * arr = [NSMutableArray array];
    NSDate * addedDate;
    for (NSDate *aDate in self.currentFilterSpan) {
        if (![[NSDate getDate:addedDate InFormat:dateFormatyyyyMMddhyp] isEqualToString:[NSDate getDate:aDate InFormat:dateFormatyyyyMMddhyp]]) {
            addedDate = [aDate toLocalTime];
            [arr addObject:addedDate];
        }
    }
    self.currentFilterSpan = arr;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
