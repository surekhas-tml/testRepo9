//
//  VehicleApplicationDBHelper.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "VehicleApplicationDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_VEHICLE_APPLICATION		 @"UPDATED_VAHICLE_APPLICATION"
#define TBL_BODY_TYPE                @"BODY_TYPE"

#define COL_VEHICLE_APPLICATION  	 @"VAHICLE_APPLICATION"
#define COL_LOB  			 		 @"LOB"
#define COL_BODY_TYPE  			 	 @"BODY_TYPE"

@implementation VehicleApplicationDBHelper


- (NSArray *)fetchAllVehicleApplication:(NSString *)strLOB {
	NSMutableArray *arrVehicleApplication = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" ", COL_VEHICLE_APPLICATION, TBL_VEHICLE_APPLICATION, COL_LOB, strLOB];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strVehicleApplication = [rs stringForColumn:COL_VEHICLE_APPLICATION];
		[arrVehicleApplication addObject:strVehicleApplication];
	}
	[db close];
	
	return arrVehicleApplication;
}

- (NSArray *)fetchDefaultBodyType:(NSString *)strVehicleApplication forLOB:(NSString *)strLOB {
	NSMutableArray *arrBodyTypes = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" AND \"%@\" = \"%@\" ", COL_BODY_TYPE, TBL_VEHICLE_APPLICATION, COL_VEHICLE_APPLICATION, strVehicleApplication, COL_LOB, strLOB];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strBodyType = [rs stringForColumn:COL_BODY_TYPE];
		[arrBodyTypes addObject:strBodyType];
	}
	[db close];
	
	return arrBodyTypes;
}

- (NSArray *)fetchAllBodyType:(NSString *)strVehicleApplication forLOB:(NSString *)strLOB {
    NSMutableArray *arrBodyTypes = [NSMutableArray new];
    NSString *strSelectStatement = [NSString
                                    stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\"", COL_BODY_TYPE, TBL_BODY_TYPE, COL_LOB, strVehicleApplication];
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString *strBodyType = [rs stringForColumn:COL_BODY_TYPE];
        [arrBodyTypes addObject:strBodyType];
    }
    [db close];
    
    return arrBodyTypes;
}

@end
