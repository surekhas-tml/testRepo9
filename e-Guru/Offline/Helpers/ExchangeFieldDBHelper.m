//
//  ExchangeFieldDBHelper.m
//  e-guru
//
//  Created by Admin on 04/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "ExchangeFieldDBHelper.h"
#import "AppDelegate.h"

@implementation ExchangeFieldDBHelper

#define TBL_BRAND                  @"PL_PPL_FOR_EXCHANGE"
#define TBL_PL_PPL_FOR_EXCHANGE	   @"PL_PPL_FOR_EXCHANGE"
#define TBL_MILEAGE                @"MILEAGE"
#define TBL_AGE_OF_VEHICLE         @"AGE_OF_VEHICLE"

#define COL_BRAND_NAME  		   @"PPL_NAME"
#define COL_PL_NAME                @"PL_NAME"
#define COL_MILEAGE_NAME           @"NAME"
#define COL_AGE_NAME               @"NAME"

- (NSArray *)fetchBrand{
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_BRAND_NAME, TBL_BRAND];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString* modelObj = [rs stringForColumn:COL_BRAND_NAME];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchPLForExchange {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_PL_NAME, TBL_PL_PPL_FOR_EXCHANGE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString* modelObj = [rs stringForColumn:COL_PL_NAME];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchMileage {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_MILEAGE_NAME, TBL_MILEAGE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString* modelObj = [rs stringForColumn:COL_MILEAGE_NAME];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchAgeOfVehicle {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_AGE_NAME, TBL_AGE_OF_VEHICLE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString* modelObj = [rs stringForColumn:COL_AGE_NAME];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}





@end
