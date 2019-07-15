//
//  EGExclusionViewModel.m
//  e-guru
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGExclusionViewModel.h"
#import "EGExclusionModel.h"
//#import "EGExclusionTypeModel.h"
//#import "EGExclusionEventTypeModel.h"
//#import "EGExclusionLeaveTypeModel.h"
#import "EGRKWebserviceRepository.h"
#import "EGDse.h"
#import "EGExclusionListModel.h"
#import "NSDate+FFDaysCount.h"
#import "AppRepo.h"

@implementation EGExclusionViewModel
@synthesize arrayWithEvents,dictEvents,selectedDates;;
-(void)initialiseArrays{
    if (selectedDates == nil) {
        selectedDates = [NSMutableArray new];
    }
}
- (void)setArrayWithEvents:(NSMutableArray *)_arrayWithEvents {
    
    arrayWithEvents = _arrayWithEvents;
//    if (selectedDates == nil) {
        selectedDates = [NSMutableArray new];
//    }
//    if(dictEvents == nil){
        dictEvents = [NSMutableDictionary new];
//    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
    for (EGExclusionModel* event in _arrayWithEvents) {
        NSDate *date = [dateFormatter dateFromString:event.date];
        NSDateComponents *comp = [NSDate componentsOfDate:date];
        NSDate *newDate = [NSDate dateWithYear:comp.year month:comp.month day:comp.day];
        NSMutableArray *array = [dictEvents objectForKey:newDate];
        if (!array) {
            array = [NSMutableArray new];
            [dictEvents setObject:array forKey:newDate];
        }
        [array addObject:event];
    }
}

-(NSString*)getEventTitleForDate:(NSDate*)cellDate ForIndex : (NSInteger)index{
    id  event = [[dictEvents objectForKey:cellDate] objectAtIndex:index];
    NSString *title = @"";
    if ([event isKindOfClass:[EGExclusionModel class]]){
        EGExclusionModel *exclusionType = (EGExclusionModel*)event;
        if([[exclusionType.type lowercaseString] isEqualToString:@"exclusion"]){
            title = exclusionType.exclusionName;
        }else if (([[exclusionType.type lowercaseString] isEqualToString:@"event"]))
        {
            title = exclusionType.eventName;
            
        }else{
            title = [NSString stringWithFormat:@"%@ %@",exclusionType.dseId ,exclusionType.remark ];
        }
    }
    return title;
}
-(BOOL)ExcludeForDate:(NSDate*)cellDate
{
    NSMutableArray *array = [dictEvents objectForKey:cellDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"exclusion"];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        return true;
    }
    return false;
}

-(BOOL)leaveExistForLeaveID:(NSString*)dseId ForDate:(NSDate*)cellDate{
    NSMutableArray *array = [dictEvents objectForKey:cellDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dseId == %@", dseId];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        return true;
    }
    return false;
}
-(NSString*)getLeaveTitleForIndex : (NSInteger)index{
    NSString *title = @"";
    NSMutableArray *leaves = [NSMutableArray new];
    for (NSDate *date in self.selectedDates) {
        [leaves addObjectsFromArray:[dictEvents objectForKey:date]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [leaves filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        id  event = [filteredArray objectAtIndex:index];
        if ([event isKindOfClass:[EGExclusionModel class]]){
            EGExclusionModel *exclusionType = (EGExclusionModel*)event;
            if (([[exclusionType.type lowercaseString] isEqualToString:@"leave"]))
            {
                title = [NSString stringWithFormat:@"%@ %@",exclusionType.dseId ,exclusionType.remark ];
            }
        }
    }
    return title;
}


-(NSString*)getLeaveDateForIndex : (NSInteger)index{
    NSString *title = @"";
    NSMutableArray *leaves = [NSMutableArray new];
    for (NSDate *date in self.selectedDates) {
        [leaves addObjectsFromArray:[dictEvents objectForKey:date]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [leaves filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        id  event = [filteredArray objectAtIndex:index];
        if ([event isKindOfClass:[EGExclusionModel class]]){
            EGExclusionModel *exclusionType = (EGExclusionModel*)event;
            if (([[exclusionType.type lowercaseString] isEqualToString:@"leave"]))
            {
                title = [NSString stringWithFormat:@"%@",exclusionType.date];
            }
        }
    }
    return title;
}

-(NSString*)getLeaveIDForIndex : (NSInteger)index{
    NSString *title = @"";
    NSMutableArray *leaves = [NSMutableArray new];
    for (NSDate *date in self.selectedDates) {
        [leaves addObjectsFromArray:[dictEvents objectForKey:date]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [leaves filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        id  event = [filteredArray objectAtIndex:index];
        if ([event isKindOfClass:[EGExclusionModel class]]){
            EGExclusionModel *exclusionType = (EGExclusionModel*)event;
            if (([[exclusionType.type lowercaseString] isEqualToString:@"leave"]))
            {
                title = [NSString stringWithFormat:@"%@",exclusionType.leaveID ];
            }
        }
    }
    return title;
}
-(NSString*)getLeaveTitleForDate:(NSDate*)cellDate ForIndex : (NSInteger)index{
    NSString *title = @"";
//    if ([event isKindOfClass:[EGExclusionModel class]]){
//        EGExclusionModel *exclusionType = (EGExclusionModel*)event;
//        if([[exclusionType.type lowercaseString] isEqualToString:@"exclusion"]){
//            title = exclusionType.exclusionName;
//        }else if (([[exclusionType.type lowercaseString] isEqualToString:@"event"]))
//        {
//            title = exclusionType.eventName;
//
//        }else{
//            title = [NSString stringWithFormat:@"%@ %@",exclusionType.dseId ,exclusionType.remark ];
//        }
//    }
    NSArray *exclusionsArray = [dictEvents objectForKey:cellDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [exclusionsArray filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        id  event = [filteredArray objectAtIndex:index];
        if ([event isKindOfClass:[EGExclusionModel class]]){
            EGExclusionModel *exclusionType = (EGExclusionModel*)event;
            if (([[exclusionType.type lowercaseString] isEqualToString:@"leave"]))
            {
                title = [NSString stringWithFormat:@"%@ %@",exclusionType.dseId ,exclusionType.remark ];
            }
        }
    }
    return title;
}

-(NSNumber*)getLeaveIDForDate:(NSDate*)cellDate ForIndex : (NSInteger)index{
    NSNumber *title = 0;
    NSArray *exclusionsArray = [dictEvents objectForKey:cellDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [exclusionsArray filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        id  event = [filteredArray objectAtIndex:index];
        if ([event isKindOfClass:[EGExclusionModel class]]){
            EGExclusionModel *exclusionType = (EGExclusionModel*)event;
            if (([[exclusionType.type lowercaseString] isEqualToString:@"leave"]))
            {
                title = exclusionType.leaveID;
            }
        }
    }
   
    return title;
}

-(NSInteger)getEventCountForDate:(NSDate*)cellDate{
    return [[dictEvents objectForKey:cellDate] count];
}

-(NSInteger)getLeavesArrayForDate:(NSDate*)cellDate{
    NSArray *exclusionsArray = [dictEvents objectForKey:cellDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [exclusionsArray filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        return  [filteredArray count];
    }
    return 0;
}


-(NSMutableArray*)getLeavesIDsForSelectedDates{
    NSMutableArray *leaveIds = [[NSMutableArray alloc]init];
    for (NSDate *date in self.selectedDates) {
        NSArray *exclusionsArray = [dictEvents objectForKey:date];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
        NSArray *filteredArray = [exclusionsArray filteredArrayUsingPredicate:predicate];
        for (EGExclusionModel *model in filteredArray) {
            [leaveIds addObject:[NSString stringWithFormat:@"%@",model.leaveID ]];
        }
            }
    return leaveIds;
}
-(NSInteger)getLeavesArrayForMultipleDates{
    NSMutableArray *leaves = [NSMutableArray new];
    for (NSDate *date in self.selectedDates) {
        [leaves addObjectsFromArray:[dictEvents objectForKey:date]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"leave"];
    NSArray *filteredArray = [leaves filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        return  [filteredArray count];
    }
    return 0;
}
-(void)getExclusionArrayForDate:(NSDate*)date{
    
}

-(void)getExclusionDetailsForStartDate:(NSString*)startDate andEndDate:(NSString*)endDate SuccessAction:(void (^)(void))successBlock
{
    [[EGRKWebserviceRepository sharedRepository]getExclusionlist:  [self exclusionListRequestDictionaryForStartDate:startDate andEndDate:endDate] andSucessAction:^(EGExclusionListModel * exclusionList) {
        [self setArrayWithEvents:exclusionList.exclusions];
        successBlock();
    } andFailuerAction:^(NSError *error) {
        [self initialiseArrays];

    } showLoader:false];
}

-(NSDictionary*)exclusionListRequestDictionaryForStartDate:(NSString*)startDate andEndDate:(NSString*)endDate
{
    NSMutableDictionary *request = [NSMutableDictionary new];
//    if ([[AppRepo sharedRepo] getLoggedInUser].dsmName != nil){
//        [request setObject:[[AppRepo sharedRepo] getLoggedInUser].dsmName forKey:@"dsm_name"];
//    }else{
//        [request setObject:@"" forKey:@"dsm_name"];
//    }
    if ([[AppRepo sharedRepo] getLoggedInUser].employeeRowID != nil){
        [request setObject:[[AppRepo sharedRepo] getLoggedInUser].employeeRowID forKey:@"dsm_id"];
    }else{
        [request setObject:@"" forKey:@"dsm_id"];
    }
    if ([[AppRepo sharedRepo] getLoggedInUser].lobName != nil){
        [request setObject:[[AppRepo sharedRepo] getLoggedInUser].lobName forKey:@"lob"];
    }else{
        [request setObject:@"" forKey:@"lob"];
    }
    if ([[AppRepo sharedRepo] getLoggedInUser].organisationName != nil){
        [request setObject:[[AppRepo sharedRepo] getLoggedInUser].organisationName forKey:@"organization_name"];
    }else{
        [request setObject:@"" forKey:@"organization_name"];
    }
    if ([[AppRepo sharedRepo] getLoggedInUser].dealerCode != nil){
        [request setObject:[[AppRepo sharedRepo] getLoggedInUser].dealerCode forKey:@"dealer_code"];
    }else{
        [request setObject:@"" forKey:@"dealer_code"];
    }
    [request setObject:startDate forKey:@"start_date"];
    [request setObject:endDate forKey:@"end_date"];
    return [[NSDictionary alloc]initWithDictionary:request];
}

-(void)getDSEListSuccessAction:(void (^)(NSMutableArray *responseArray,NSMutableArray *dseObjArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock{
    [[EGRKWebserviceRepository sharedRepository]getDSElist:@{
                                                             @"dsm_id": [[AppRepo sharedRepo] getLoggedInUser].employeeRowID
                                                             } andSucessAction:^(id contact) {
                                                                 if ([[[contact allValues] firstObject] count] > 0) {
                                                                     NSMutableArray * dseArray = [[contact allValues] firstObject];
                                                                     NSMutableArray *dseArr = [[NSMutableArray alloc]init];
                                                                 for (EGDse *dse in dseArray) {
                                                                     [dseArr addObject:[NSString stringWithFormat:@"%@ %@",dse.FirstName, dse.LastName]];
                                                                 }
                                                                     successBlock(dseArr,dseArray);}
                                                        } andFailuerAction:^(NSError *error) {failuerBlock(error);} showLoader:YES];
}

-(void)cancelLeaveWithForDSEID: (NSString*)LeaveID  ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock
{
    [[EGRKWebserviceRepository sharedRepository] cancelLeave:@{
                                                              @"id": LeaveID
                                                              } andSucessAction:^(id responseDict) {
        NSString *msg = @"";
        if (responseDict != nil && responseDict [@"msg"] != nil){
            msg = responseDict [@"msg"];
        }
        successBlock (TRUE,msg) ;
        
    } andFailuerAction:^(NSError *error)
     {  successBlock (FALSE,@"Please try later") ;
         
     }];
    
}

-(void)cancelLeaveForDSEArray: (NSMutableArray*)LeaveIDArray  ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock
{
    [[EGRKWebserviceRepository sharedRepository] cancelLeave:@{
                                                               @"id": LeaveIDArray
                                                               } andSucessAction:^(id responseDict) {
                                                                   NSString *msg = @"";
                                                                   if (responseDict != nil && responseDict [@"msg"] != nil){
                                                                       msg = responseDict [@"msg"];
                                                                   }
                                                                   successBlock (TRUE,msg) ;
                                                                   
                                                               } andFailuerAction:^(NSError *error)
     {  successBlock (FALSE,@"Please try later") ;
         
     }];
    
}
-(void)applyLeaveWithForDSERequestDict:(NSDictionary*)requestDict SuccessAction:(void (^)(bool status, NSString *message))successBlock
{
    [[EGRKWebserviceRepository sharedRepository] applyLeave:requestDict andSucessAction:^(id responseDict) {
        NSString *msg = @"";
        if (responseDict != nil && responseDict [@"msg"] != nil){
            msg = responseDict [@"msg"];
        }
        successBlock (TRUE,msg) ;
        
    } andFailuerAction:^(NSError *error)
     {  successBlock (FALSE,@"Please try later") ;
         
     }];
    
}
-(void)applyLeaveWithForDSEID: (NSString*)DSEID andRemark : (NSString*)remark ForDate:(NSString*)date SuccessAction:(void (^)(bool status, NSString *message))successBlock
{
    NSMutableDictionary *  requestDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                               @"dse_id" : DSEID,
                                                                        @"date" : date,                @"remark" : remark                          }];
    if ([[AppRepo sharedRepo] getLoggedInUser].lobName != nil){
        [requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].lobName forKey:@"lob"];
    }else{
        [requestDictionary setObject:@"" forKey:@"lob"];
    }
    if ([[AppRepo sharedRepo] getLoggedInUser].employeeRowID != nil){
        [requestDictionary setObject:[[AppRepo sharedRepo] getLoggedInUser].employeeRowID forKey:@"dsm_id"];
    }else{
        [requestDictionary setObject:@"" forKey:@"dsm_id"];
    }
    
    [[EGRKWebserviceRepository sharedRepository] applyLeave:requestDictionary andSucessAction:^(id responseDict) {
        NSString *msg = @"";
        if (responseDict != nil && responseDict [@"msg"] != nil){
            msg = responseDict [@"msg"];
        }
        successBlock (TRUE,msg) ;
        
    } andFailuerAction:^(NSError *error)
    {  successBlock (FALSE,@"Please try later") ;
        
    }];
    
}
@end
