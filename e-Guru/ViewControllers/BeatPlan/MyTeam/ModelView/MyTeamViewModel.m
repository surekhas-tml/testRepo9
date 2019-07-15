//
//  MyTeamViewModel.m
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "MyTeamViewModel.h"
#import "DSEModel.h"
#import "MMGEOLocationModel.h"
#import "WebServiceConstants.h"
#import "EGRKWebserviceRepository.h"


@implementation MyTeamViewModel


- (instancetype)init:(DSEModel *)dseCurrentObject 
{
    self.dseCurrentObject =dseCurrentObject;
    return self.dseCurrentObject;
}

-(NSString*)getData{
    NSLog(@"Data:%@",self.dseCurrentObject.dseName);
    return self.dseCurrentObject.dseName;
}
//API call for get details , fetch new dse , remove object
//set data to ui components by method implemented here

-(NSString*)getDSEName:(NSInteger)tag{
    
    DSEModel *dseObject = [_dsewiseMMGEOLocationArray objectAtIndex:tag];
    return dseObject.dseName;
}

-(NSMutableArray*)getLocationList:(NSInteger)tag
{
    DSEModel *dseObject = [_dsewiseMMGEOLocationArray objectAtIndex:tag];
    return dseObject.locationListForDSE;
}

-(NSString*)getMicroMarketName:(NSMutableArray*)locationListArray :(NSInteger)tag{
    MMGEOLocationModel *locationObject = [locationListArray objectAtIndex:tag];
    return locationObject.microMarketName;
}

//-(NSString*)getMicroMarketName:(NSInteger)locationObjectTag :(NSInteger)tag{
//    DSEModel *dseObject = [_dsewiseMMGEOLocationArray objectAtIndex:locationObjectTag];
//    MMGEOLocationModel *locationObject = [dseObject.locationListForDSE objectAtIndex:tag];
//    return locationObject.microMarketName;
//}

-(BOOL)isDSEAcivated:(NSInteger)tag{
    DSEModel *dseObject = [self.dsewiseMMGEOLocationArray objectAtIndex:tag];
    if (dseObject.isActive) {
        return true;
    }
    else
    {
        return false;
    }
}

- (void)getMyTeamApiWithType:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck
{
    //MYTEAMEXTENTION
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:MYTEAMEXTENTION :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSArray *dseArray = [responseObject objectForKey:@"data"];
        NSLog(@"dseArr :%@",dseArray);
        
        if (dseArray.count != 0){
            self.dsewiseMMGEOLocationArray  = [[NSMutableArray alloc]init];
            for (int i=0; i< dseArray.count; i++) {
                NSDictionary *dseDetail = [dseArray objectAtIndex:i];
                DSEModel *dseObject = [[DSEModel alloc]init];
                if([dseDetail objectForKey:@"dse_id"] != nil || [[dseDetail objectForKey:@"dse_id"] length] != 0){
                    dseObject.dseName = [dseDetail objectForKey:@"dse_id"];
                }
                if([dseDetail objectForKey:@"dse_emp_id"] != nil || [[dseDetail objectForKey:@"dse_emp_id"] length] != 0){
                    dseObject.dseId = [dseDetail objectForKey:@"dse_emp_id"];
                }
                if([dseDetail objectForKey:@"is_active"])
                {
                    dseObject.isActive = [[dseDetail objectForKey:@"is_active"] boolValue] ;
                }
                NSArray *dseLocationArray = [dseDetail objectForKey:@"locations"];
                if(dseLocationArray.count != 0 ){
                    NSMutableArray *locationArray = [[NSMutableArray alloc]init];
                    for (int i=0 ;i<dseLocationArray.count ;i++ ){
                        NSDictionary *locationDict = [dseLocationArray objectAtIndex:i];
                        MMGEOLocationModel *locationObject = [[MMGEOLocationModel alloc]init];
                        if([locationDict objectForKey:@"mm_geo"] != nil || [[locationDict objectForKey:@"mm_geo"] length] != 0){
                            locationObject.microMarketName = [locationDict objectForKey:@"mm_geo"];
                        }
                        if([locationDict objectForKey:@"state"] != nil || [[locationDict objectForKey:@"state"] length] != 0){
                            locationObject.stateName = [locationDict objectForKey:@"state"];
                        }
                        if([locationDict objectForKey:@"city"] != nil || [[locationDict objectForKey:@"city"] length] != 0){
                            locationObject.cityName = [locationDict objectForKey:@"city"];
                        }
                        if([locationDict objectForKey:@"district"] != nil || [[locationDict objectForKey:@"district"] length] != 0){
                            locationObject.districtName = [locationDict objectForKey:@"district"];
                        }
                        if([locationDict objectForKey:@"lob"]!= nil || [[locationDict objectForKey:@"lob"] length] != 0){
                            locationObject.lobName = [locationDict objectForKey:@"lob"];
                        }
                        
                        locationObject.talukaName = @"";//[locationDict objectForKey:@"mm_geo"];
                        [locationArray addObject:locationObject];
                    }
                    dseObject.locationListForDSE = locationArray;
                }
                [self.dsewiseMMGEOLocationArray addObject:dseObject];
                NSLog(@"Array Size:%lu",(unsigned long)self.dsewiseMMGEOLocationArray.count);
            }
        }
        blck(@"Success");
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
//        [UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);
    }];
}

#pragma mark - getMMGEOList

//getMMGEOList
- (void)getMMGEOList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETMMGEOLIST :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSArray *mmgeoList = (NSArray*)responseObject ;
        NSLog(@"mmgeoList MVVM  : %@",mmgeoList);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
       // [UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);

    }];
}

#pragma mark - getDISTRICTList

- (void)getDistrictList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETDISTRICTLIST :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
//        NSArray *districtList = (NSArray*)responseObject ;
        NSLog(@"DISTRICT List MVVM  : %@",responseObject);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        // [UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);
        
    }];
}

#pragma mark - getCITYList

- (void)getCityList:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETCITYLIST :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSArray *cityList = (NSArray*)responseObject ;
        NSLog(@"City List MVVM  : %@",cityList);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        // [UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);
        
    }];
}

#pragma mark - getStateCode

// StateCode
- (void)getStateCode:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
 
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETSTATECODEBYSTATENAME :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSDictionary *stateDict = responseObject ;
        NSLog(@"stateDict123 :%@",stateDict);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        errorBlck(error);
    }];
}


#pragma mark - assignlocationToDSE

// assignlocationToDSE
- (void)assignLocationToDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:ASSIGNLOCATIONTODSE :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSString *successMsg = (NSString*)responseObject ;
        NSLog(@"successMsg123 : %@",successMsg);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
       // [UtilityMethods showToastWithMessage:@"Location already assigned to DSE"];
        errorBlck(error);
    }];
}

#pragma mark - removeDSE

- (void)removeDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:REMOVEDSE :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSDictionary *mmgeoDict = (NSDictionary*)responseObject ;
        NSLog(@"%@", mmgeoDict[@"msg"]);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
       // [UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);
    }];
}

#pragma mark - removeDSE

- (void)removeMMGEOLocationDSE:(NSDictionary*)paramDict withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:REMOVEMMGEOLOCATIONOFDSE :paramDict andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        NSDictionary *mmgeoDict = (NSDictionary*)responseObject ;
        NSLog(@"%@", mmgeoDict[@"msg"]);
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        //[UtilityMethods showToastWithMessage:@"No records found"];
        errorBlck(error);
    }];
}


@end
