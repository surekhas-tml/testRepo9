//
//  EGExclusionViewModel.h
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EGExclusionViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *arrayWithEvents;
@property (nonatomic, strong) NSMutableDictionary *dictEvents;
@property (nonatomic, strong) NSMutableArray *selectedDates;
-(NSInteger)getEventCountForDate:(NSDate*)cellDate;
-(void)getExclusionDetailsForStartDate:(NSString*)startDate andEndDate:(NSString*)endDate SuccessAction:(void (^)(void))successBlock;
-(void)getDSEListSuccessAction:(void (^)(NSMutableArray *responseArray,NSMutableArray *dseObjArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock;
-(void)applyLeaveWithForDSEID: (NSString*)DSEID andRemark : (NSString*)remark ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock;
-(NSString*)getEventTitleForDate:(NSDate*)cellDate ForIndex : (NSInteger)index;
-(void)cancelLeaveWithForDSEID: (NSString*)LeaveID  ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock;
-(NSInteger)getLeavesArrayForMultipleDates;
-(NSString*)getLeaveIDForDate:(NSDate*)cellDate ForIndex : (NSInteger)index;
-(NSString*)getLeaveTitleForDate:(NSDate*)cellDate ForIndex : (NSInteger)index;
-(NSInteger)getLeavesArrayForDate:(NSDate*)cellDate;
-(void)applyLeaveWithForDSERequestDict:(NSDictionary*)requestDict SuccessAction:(void (^)(bool status, NSString *message))successBlock;

-(NSString*)getLeaveTitleForIndex : (NSInteger)index;

-(NSString*)getLeaveIDForIndex : (NSInteger)index;

-(void)cancelLeaveForDSEArray: (NSMutableArray*)LeaveIDArray  ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock;

-(NSMutableArray*)getLeavesIDsForSelectedDates;
-(NSString*)getLeaveDateForIndex : (NSInteger)index;
-(BOOL)leaveExistForLeaveID:(NSString*)dseId ForDate:(NSDate*)cellDate;
-(BOOL)ExcludeForDate:(NSDate*)cellDate;

@end

