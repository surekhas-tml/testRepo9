#import "ExclusionViewController.h"
#import "FFCalendar.h"
#import "FFAddEventPopoverController.h"
#import "UIColor+eGuruColorScheme.h"
#import "EGDSELeaveView.h"
#import "EGExclusionViewModel.h"
//#import "EGExclusionTypeModel.h"
#import "FFMonthCell.h"
#import "NSDate+eGuruDate.h"

@interface ExclusionViewController () <FFButtonAddEventWithPopoverProtocol, FFYearCalendarViewProtocol, FFMonthCalendarViewProtocol, FFWeekCalendarViewProtocol, FFDayCalendarViewProtocol, EGDSELeaveViewProtocol>
@property (nonatomic) BOOL boolDidLoad;
@property (nonatomic) BOOL boolYearViewIsShowing;
@property (nonatomic, strong) UILabel *labelWithMonthAndYear;
@property (nonatomic, strong) NSArray *arrayButtons;
@property (nonatomic, strong) NSArray *arrayCalendars;
@property (nonatomic, strong) FFEditEventPopoverController *popoverControllerEditar;
@property (nonatomic, strong) FFYearCalendarView *viewCalendarYear;
@property (nonatomic, strong) FFMonthCalendarView *viewCalendarMonth;
@property (nonatomic, strong) FFWeekCalendarView *viewCalendarWeek;
@property (nonatomic, strong) FFDayCalendarView *viewCalendarDay;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic)  EGExclusionViewModel * exclusionViewModel;

@end

@implementation ExclusionViewController

#pragma mark - Synthesize

@synthesize boolDidLoad;
@synthesize boolYearViewIsShowing;
@synthesize protocol;
@synthesize labelWithMonthAndYear;
@synthesize arrayButtons;
@synthesize arrayCalendars;
@synthesize popoverControllerEditar;
@synthesize viewCalendarYear;
@synthesize viewCalendarMonth;
@synthesize viewCalendarWeek;
@synthesize viewCalendarDay;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _exclusionViewModel = [[EGExclusionViewModel alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:DATE_MANAGER_DATE_CHANGED object:nil];
    
    [self customNavigationBarLayout];
    
    [self addCalendars];
    
    [self.monthLabel setTextColor:[UIColor themePrimaryColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!boolDidLoad) {
        boolDidLoad = YES;
        
        [self buttonYearMonthWeekDayAction:[arrayButtons objectAtIndex:0]];
       
        button_AddLeave.frame = CGRectMake( [[UIScreen mainScreen]bounds].size.width/2 - 190, button_AddLeave.frame.origin.y, 120, 40);
        button_CancelLeave.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2 +90 , button_CancelLeave.frame.origin.y, 120, 40);
//        [self buttonTodayAction:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.x`
}

#pragma mark - FFDateManager Notification

- (void)dateChanged:(NSNotification *)notification {
    
    [self updateLabelWithMonthAndYear];
}

- (void)updateLabelWithMonthAndYear {
    NSDateComponents *comp = [NSDate componentsOfDate:[[FFDateManager sharedManager] currentDate]];
    NSString *string = boolYearViewIsShowing ? [NSString stringWithFormat:@"%li", (long)comp.year] : [NSString stringWithFormat:@"%@ %li", [arrayMonthName objectAtIndex:comp.month-1], (long)comp.year];
    [self.monthLabel setText:string];
    
    NSDate *newMonthDate = [NSDate dateWithYear:comp.year month:comp.month day:12];
    NSDate *lastDate=  [newMonthDate lastDayOfMonth];
    NSDateComponents *lastDatecomp = [NSDate componentsOfDate:lastDate];
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:2];
    [_exclusionViewModel  getExclusionDetailsForStartDate:[ NSString stringWithFormat:@"%li-%@-01",lastDatecomp.year,[numberFormatter stringFromNumber:[NSNumber numberWithInteger:lastDatecomp.month]]] andEndDate:[ NSString stringWithFormat:@"%li-%@-%li",lastDatecomp.year,[numberFormatter stringFromNumber:[NSNumber numberWithInteger:lastDatecomp.month]],lastDatecomp.day] SuccessAction:^{
//        [viewCalendarMonth setDictEvents:_exclusionViewModel.dictEvents];
        [viewCalendarMonth setExclusionViewModel:_exclusionViewModel];

    }];
}


#pragma mark - Custom NavigationBar

- (void)customNavigationBarLayout {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor lighterGrayCustom]];
    
    [self addRightBarButtonItems];
    [self addLeftBarButtonItems];
}

- (void)addRightBarButtonItems {
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 30.;
    
    FFRedAndWhiteButton *buttonYear = [self calendarButtonWithTitle:@"year"];
    FFRedAndWhiteButton *buttonMonth = [self calendarButtonWithTitle:@"month"];
    FFRedAndWhiteButton *buttonWeek = [self calendarButtonWithTitle:@"week"];
    FFRedAndWhiteButton *buttonDay = [self calendarButtonWithTitle:@"day"];
    
    UIBarButtonItem *barButtonYear = [[UIBarButtonItem alloc] initWithCustomView:buttonYear];
    UIBarButtonItem *barButtonMonth = [[UIBarButtonItem alloc] initWithCustomView:buttonMonth];
    UIBarButtonItem *barButtonWeek = [[UIBarButtonItem alloc] initWithCustomView:buttonWeek];
    UIBarButtonItem *barButtonDay = [[UIBarButtonItem alloc] initWithCustomView:buttonDay];
    
    FFButtonAddEventWithPopover *buttonAdd = [[FFButtonAddEventWithPopover alloc] initWithFrame:CGRectMake(0., 0., 30., 44)];
    [buttonAdd setProtocol:self];
    UIBarButtonItem *barButtonAdd = [[UIBarButtonItem alloc] initWithCustomView:buttonAdd];
    
    arrayButtons = @[ buttonMonth, buttonWeek, buttonDay];
    [self.navigationItem setRightBarButtonItems:@[barButtonAdd, fixedItem, barButtonYear, barButtonMonth, barButtonWeek, barButtonDay]];
}

- (void)addLeftBarButtonItems {
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 30.;
    
    FFRedAndWhiteButton *buttonToday = [[FFRedAndWhiteButton alloc] initWithFrame:CGRectMake(0., 0., 80., 30)];
    [buttonToday addTarget:self action:@selector(buttonTodayAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonToday setTitle:@"today" forState:UIControlStateNormal];
    UIBarButtonItem *barButtonToday = [[UIBarButtonItem alloc] initWithCustomView:buttonToday];
    
    labelWithMonthAndYear = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 170., 30)];
    [labelWithMonthAndYear setTextColor:[UIColor redColor]];
    [labelWithMonthAndYear setFont:buttonToday.titleLabel.font];
    UIBarButtonItem *barButtonLabel = [[UIBarButtonItem alloc] initWithCustomView:labelWithMonthAndYear];
    
    [self.navigationItem setLeftBarButtonItems:@[barButtonLabel, fixedItem, barButtonToday]];
}

- (FFRedAndWhiteButton *)calendarButtonWithTitle:(NSString *)title {
    
    FFRedAndWhiteButton *button = [[FFRedAndWhiteButton alloc] initWithFrame:CGRectMake(0., 0., 80., 30.)];
    [button addTarget:self action:@selector(buttonYearMonthWeekDayAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark - Add Calendars

- (void)addCalendars {
    
    CGRect frame = CGRectMake(0., 50., self.view.frame.size.width, self.view.frame.size.height- 80);
    
    viewCalendarYear = [[FFYearCalendarView alloc] initWithFrame:frame];
    [viewCalendarYear setProtocol:self];
    [self.view addSubview:viewCalendarYear];
    button_AddLeave = [UIButton buttonWithType:UIButtonTypeCustom];
    button_AddLeave.backgroundColor = [UIColor themePrimaryColor];
    [button_AddLeave setTitle:@"Mark as Leave" forState:UIControlStateNormal];
    button_AddLeave.layer.cornerRadius = 8.0;
    viewCalendarMonth = [[FFMonthCalendarView alloc] initWithFrame:frame];
    [viewCalendarMonth setProtocol:self];
    button_AddLeave.frame = CGRectMake(self.view.bounds.size.width/2 - 120, self.view.bounds.size.height - 180, 120, 40);
    [button_AddLeave addTarget:self action:@selector(showAddLeavePopUp:) forControlEvents:UIControlEventTouchUpInside];
//    [viewCalendarMonth setDictEvents:_exclusionViewModel.dictEvents];
    [self.view addSubview:viewCalendarMonth];
    [self.view addSubview:button_AddLeave];
    button_CancelLeave =[UIButton buttonWithType:UIButtonTypeCustom];
    button_CancelLeave.backgroundColor = [UIColor themePrimaryColor];
    [button_CancelLeave setTitle:@"Delete Leave" forState:UIControlStateNormal];
    button_CancelLeave.layer.cornerRadius = 8.0;
    button_CancelLeave.frame = CGRectMake(self.view.bounds.size.width/2 + 120, self.view.bounds.size.height - 180, 120, 40);
    [self.view addSubview:button_CancelLeave];
    [button_CancelLeave addTarget:self action:@selector(showCancelLeavePopUp:) forControlEvents:UIControlEventTouchUpInside];

    viewCalendarWeek = [[FFWeekCalendarView alloc] initWithFrame:frame];
    [viewCalendarWeek setProtocol:self];
    [viewCalendarWeek setDictEvents:_exclusionViewModel.dictEvents];
    [self.view addSubview:viewCalendarWeek];
    
    viewCalendarDay = [[FFDayCalendarView alloc] initWithFrame:frame];
    [viewCalendarDay setProtocol:self];
    [viewCalendarDay setDictEvents:_exclusionViewModel.dictEvents];
    [self.view addSubview:viewCalendarDay];
    
    arrayCalendars = @[ viewCalendarMonth, viewCalendarWeek, viewCalendarDay];
}

#pragma mark - Button Action

- (IBAction)buttonYearMonthWeekDayAction:(id)sender {
    
    long index = [arrayButtons indexOfObject:sender];
    
    [self.view bringSubviewToFront:[arrayCalendars objectAtIndex:index]];
      [self.view bringSubviewToFront:button_AddLeave];
     [self.view bringSubviewToFront:button_CancelLeave];
    for (UIButton *button in arrayButtons) {
        button.selected = (button == sender);
    }
    
    boolYearViewIsShowing = FALSE;
    [[FFDateManager sharedManager] setCurrentDate:[NSDate new]];
    [self updateLabelWithMonthAndYear];
}

- (IBAction)buttonTodayAction:(id)sender {
    
    [[FFDateManager sharedManager] setCurrentDate:[NSDate dateWithYear:[NSDate componentsOfCurrentDate].year
                                                                 month:[NSDate componentsOfCurrentDate].month
                                                                   day:[NSDate componentsOfCurrentDate].day]];
}

#pragma mark - Interface Rotation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [viewCalendarYear invalidateLayout];
    [viewCalendarMonth invalidateLayout];
    [viewCalendarWeek invalidateLayout];
    [viewCalendarDay invalidateLayout];
}

#pragma mark - FFButtonAddEventWithPopover Protocol

//- (void)addNewEvent:(FFEvent *)eventNew {
//
//    NSMutableArray *arrayNew = [dictEvents objectForKey:eventNew.dateDay];
//    if (!arrayNew) {
//        arrayNew = [NSMutableArray new];
//        [dictEvents setObject:arrayNew forKey:eventNew.dateDay];
//    }
//    [arrayNew addObject:eventNew];
//
//    [self setNewDictionary:dictEvents];
//}

#pragma mark - FFMonthCalendarView, FFWeekCalendarView and FFDayCalendarView Protocols

//- (void)setNewDictionary:(NSDictionary *)dict {
//
//    dictEvents = (NSMutableDictionary *)dict;
//
//    [viewCalendarMonth setDictEvents:dictEvents];
//    [viewCalendarWeek setDictEvents:dictEvents];
//    [viewCalendarDay setDictEvents:dictEvents];
//
//    [self arrayUpdatedWithAllEvents];
//}

-(void)showPopOverWithIndex:(NSIndexPath*)indexPath{
    FFMonthCell *cell = (FFMonthCell*)[viewCalendarMonth.collectionViewMonth cellForItemAtIndexPath:indexPath];
    NSDate *now = [NSDate date];
    if ([now compare:cell.cellDate] == NSOrderedDescending) {
        // muteOverDate in the past
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select future date" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ self presentViewController:alertController animated:YES completion:nil];
        return;
    }
//    else if([_exclusionViewModel ExcludeForDate:cell.cellDate]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This date is excluded from beat plan" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
//        [ self presentViewController:alertController animated:YES completion:nil];
//
//        return;
//    }
    if (cell.tag == 0) {
        cell.tag = 1;
        [_exclusionViewModel.selectedDates addObject:cell.cellDate];
        [cell.imageViewTick setImage:[UIImage imageNamed:@"check_mark"]];
    }else{
        [_exclusionViewModel.selectedDates removeObject:cell.cellDate];
        [cell.imageViewTick setImage:nil];
        cell.tag = 0;
    }

    //    [self buttonYearMonthWeekDayAction:[arrayButtons objectAtIndex:1]];
//    [self showAddLeavePopUp:indexPath forEventList:FALSE];
    //    [protocol showPopOverWithIndex:indexPath];
    
    //    FFAddEventPopoverController *popoverControllerAdd = [[FFAddEventPopoverController alloc] initPopover];
    ////    [popoverControllerAdd setProtocol:self];
    ////    [popoverControllerAdd presentPopoverFromRect:self.superview.frame inView: [super superview] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    //    [popoverControllerAdd presentPopoverFromRect:self.button_AddLeavePopup.frame
    //                                           inView: self.view
    //                         permittedArrowDirections:UIPopoverArrowDirectionAny
    //                                         animated:YES];
    
    //    [self presentViewController:popoverControllerAdd animated:YES completion:nil];
    //    [popoverControllerAdd presentPopoverFromRect:self inView:[super superview] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (void)showAllEventOfCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex{
    
    [self showAddLeavePopUp:[viewCalendarMonth.collectionViewMonth indexPathForCell:cell] forEventList:TRUE];
}
#pragma mark - FFYearCalendarView Protocol

- (void)showMonthCalendar {
    [self buttonYearMonthWeekDayAction:[arrayButtons objectAtIndex:1]];
}




#pragma mark - Sending Updated Array to ExclusionViewController Protocol

//- (void)arrayUpdatedWithAllEvents {
//
//    NSMutableArray *arrayNew = [NSMutableArray new];
//
//    NSArray *arrayKeys = dictEvents.allKeys;
//    for (NSDate *date in arrayKeys) {
//        NSArray *arrayOfDate = [dictEvents objectForKey:date];
//        for (FFEvent *event in arrayOfDate) {
//            [arrayNew addObject:event];
//        }
//    }
//
//    if (protocol != nil && [protocol respondsToSelector:@selector(arrayUpdatedWithAllEvents:)]) {
//        [protocol arrayUpdatedWithAllEvents:arrayNew];
//    }
//}
- (IBAction)showCancelLeavePopUp:(UIButton *)sender {
    if([_exclusionViewModel.selectedDates count] < 1 ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select date" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ self presentViewController:alertController animated:YES completion:nil];
        return;
    }else if( [self.exclusionViewModel getLeavesArrayForMultipleDates]  < 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No DSE leave found" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    EGDSELeaveView *nib = [[[UINib nibWithNibName:@"EGDSELeaveView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] objectAtIndex:0];
    nib.frame = self.view.bounds;
    CGRect rect = self.view.bounds;
    nib.protocolGDSELeaveView = self;
    nib.exclusionViewModel = self.exclusionViewModel;
    nib.selectedDate = [NSDate getDate:[_exclusionViewModel.selectedDates objectAtIndex:0] InFormat:dateFormatyyyyMMddhyp] ;
    nib.eventDate = [_exclusionViewModel.selectedDates objectAtIndex:0];
        nib.showDSELeaveView = false;
        [nib showEventList];
    rect.size.height = rect.size.height - HEADER_HEIGHT_MONTH - 76;
    [self.view addSubview:nib];
}
- (IBAction)showAddLeavePopUp:(UIButton *)sender {
    if([_exclusionViewModel.selectedDates count] < 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select date" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [ self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    EGDSELeaveView *nib = [[[UINib nibWithNibName:@"EGDSELeaveView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] objectAtIndex:0];
    nib.frame = self.view.bounds;
    CGRect rect = self.view.bounds;
    nib.protocolGDSELeaveView = self;
    nib.exclusionViewModel = self.exclusionViewModel;
    
//    nib.selectedDate = [NSDate getDate:[_exclusionViewModel.selectedDates objectAtIndex:0] InFormat:dateFormatyyyyMMddhyp] ;
//    nib.eventDate = [_exclusionViewModel.selectedDates objectAtIndex:0];

        nib.showDSELeaveView = TRUE;
        [nib showDSEView];
    rect.size.height = rect.size.height - HEADER_HEIGHT_MONTH - 76;
    [self.view addSubview:nib];
}

- (IBAction)showAddLeavePopUp:(NSIndexPath*)sender forEventList:(BOOL)showEventList {
//    return;
    EGDSELeaveView *nib = [[[UINib nibWithNibName:@"EGDSELeaveView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] objectAtIndex:0];
    nib.frame = self.view.bounds;
    CGRect rect = self.view.bounds;
//    nib.showDSELeaveView = TRUE;
    nib.protocolGDSELeaveView = self;
    nib.exclusionViewModel = self.exclusionViewModel;
   FFMonthCell *cell = (FFMonthCell*)[viewCalendarMonth.collectionViewMonth cellForItemAtIndexPath:sender];
   nib.selectedDate = [NSDate getDate:cell.cellDate InFormat:dateFormatyyyyMMddhyp] ;
    nib.eventDate = cell.cellDate;
    if (showEventList){
        nib.showDSELeaveView = false;
        [nib showEventList];
    }else{
            nib.showDSELeaveView = TRUE;
            [nib showDSEView];
        }
    rect.size.height = rect.size.height - HEADER_HEIGHT_MONTH - 76;
    [self.view addSubview:nib];
}
- (IBAction)showNextMonth:(id)sender {
    [viewCalendarMonth.collectionViewMonth changeYearDirectionIsUp:true];
}
- (IBAction)showPreviousMonth:(id)sender {
    [viewCalendarMonth.collectionViewMonth changeYearDirectionIsUp:false];
}

#pragma mark - EGDSELeaveProtocol
-(void)reloadDataForDate{
    [self updateLabelWithMonthAndYear];
}
@end
