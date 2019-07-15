//
//  FFMonthCell.h
//  FFCalendar
//
//  Created by Felipe Rocha on 14/02/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>

#import "FFEvent.h"
#import "EGExclusionViewModel.h"

@protocol FFMonthCellProtocol <NSObject>
@required
- (void)saveEditedEvent:(FFEvent *)eventNew ofCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex;
- (void)deleteEventOfCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex;
- (void)showAllEventOfCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex;

@end

@interface FFMonthCell : UICollectionViewCell

@property (nonatomic, strong) id<FFMonthCellProtocol> protocol;
@property (nonatomic, strong) NSMutableArray *arrayEvents;
@property (nonatomic, strong) NSDate *cellDate;
@property (strong, nonatomic) UILabel *labelDay;
@property (strong, nonatomic) UIImageView *imageViewCircle;
@property (strong, nonatomic)  EGExclusionViewModel * exclusionViewModel;
@property (strong, nonatomic) UIImageView *imageViewTick;

- (void)initLayout;
- (void)markAsWeekend;
- (void)markAsCurrentDay;

@end
