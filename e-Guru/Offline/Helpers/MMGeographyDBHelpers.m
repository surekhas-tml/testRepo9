//
//  MMGeographyDBHelpers.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "MMGeographyDBHelpers.h"
#import "FMDB.h"
#import "DBManager.h"


#define TBL_MMGEOGRAPHY		 @"MMGeography"

#define COL_LOB  			 @"LOB"
#define COL_MMGeography  	 @"MMGeography"


@implementation MMGeographyDBHelpers

- (NSArray *)fetchAllMMGeoGraphyFromLob:(NSString *)strLOB {
	NSMutableArray *arrMMGeoGraphy = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" ", COL_MMGeography, TBL_MMGEOGRAPHY, COL_LOB, strLOB];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strMMGeo = [rs stringForColumn:COL_MMGeography];
		[arrMMGeoGraphy addObject:strMMGeo];
	}
	[db close];
	
	return arrMMGeoGraphy;
}


@end
