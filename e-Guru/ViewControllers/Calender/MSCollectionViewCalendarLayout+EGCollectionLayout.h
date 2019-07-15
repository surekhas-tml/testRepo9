//
//  MSCollectionViewCalendarLayout+EGCollectionLayout.h
//  e-guru
//
//  Created by local admin on 12/24/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <MSCollectionViewCalendarLayout/MSCollectionViewCalendarLayout.h>

@interface MSCollectionViewCalendarLayout (EGCollectionLayout)
- (NSInteger)earliestHour;
- (NSInteger)latestHour;
- (NSInteger)latestHourForSection:(NSInteger)section;
- (NSInteger)earliestHourForSection:(NSInteger)section;
@end
