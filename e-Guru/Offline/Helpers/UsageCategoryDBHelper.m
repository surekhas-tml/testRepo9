//
//  UsageCategoryDBHelper.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UsageCategoryDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"


#define TBL_USAGE_CATEGORY	 @"USAGE_CATEGORY"

#define COL_LOB  			 @"LOB"
#define COL_USAGE_CATEGORY   @"USAGE_CATEGORY"


@implementation UsageCategoryDBHelper



- (NSArray *)fetchAllUsageCategoriesFromLob:(NSString *)strLOB {
	NSMutableArray *arrUsageCategories = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" ", COL_USAGE_CATEGORY, TBL_USAGE_CATEGORY, COL_LOB, strLOB];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strUsageCategory = [rs stringForColumn:COL_USAGE_CATEGORY];
		[arrUsageCategories addObject:strUsageCategory];
	}
	[db close];
	
	return arrUsageCategories;
}

@end
