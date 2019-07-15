//
//  FFMonthCollectionView.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/15/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>
#import "FFEvent.h"
#import "EGExclusionViewModel.h"

@protocol FFMonthCollectionViewProtocol <NSObject>
@required
- (void)setNewDictionary:(NSDictionary *)dict;
-(void)showPopOverWithIndex:(NSIndexPath*)indexPath;
- (void)addNewEvent:( id)eventNew ;
-(void)showAllEventOfCell:(UICollectionViewCell *)cell atIndex:(NSInteger)intIndex;

@end

@interface FFMonthCollectionView : UICollectionView
- (void)changeYearDirectionIsUp:(BOOL)isUp;
@property (nonatomic, strong) id<FFMonthCollectionViewProtocol>protocol;
@property (nonatomic, strong) NSMutableDictionary *dictEvents;
@property (strong, nonatomic)  EGExclusionViewModel * exclusionViewModel;

@end
