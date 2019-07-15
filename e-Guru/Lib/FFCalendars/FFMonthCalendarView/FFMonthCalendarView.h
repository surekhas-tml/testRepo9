//
//  FFMonthCalendarView.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 3/18/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>
#import "FFEvent.h"
#import "FFMonthCollectionView.h"
#import "EGExclusionViewModel.h"

@protocol FFMonthCalendarViewProtocol <NSObject>
@required
- (void)setNewDictionary:(NSDictionary *)dict;
-(void)showPopOverWithIndex:(NSIndexPath*)indexPath;
- (void)addNewEvent:(FFEvent *)eventNew ;
-(void)showAllEventOfCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex;
@end

@interface FFMonthCalendarView : UIView
@property (nonatomic, strong) FFMonthCollectionView *collectionViewMonth;
@property (nonatomic, strong) NSMutableDictionary *dictEvents;
@property (nonatomic, strong) id<FFMonthCalendarViewProtocol> protocol;
@property (strong, nonatomic)  EGExclusionViewModel * exclusionViewModel;

- (void)invalidateLayout;

@end
