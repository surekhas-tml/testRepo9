//
//  EGMSCollectionViewCalendarLayout.m
//  e-guru
//
//  Created by local admin on 12/23/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGMSCollectionViewCalendarLayout.h"

@implementation EGMSCollectionViewCalendarLayout


- (NSInteger)earliestHour
{
    return 0;
}
- (NSInteger)earliestHourForSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)latestHourForSection:(NSInteger)section
{
    NSInteger lastHr = [super latestHourForSection:section];
    if (lastHr < 8) {
        return 24;
    }
    return 24;
}
- (NSInteger)latestHour
{
    NSInteger lastHr = [super latestHour];
    if (lastHr < 8) {
        return 24;
    }
    return 24;
}
@end
