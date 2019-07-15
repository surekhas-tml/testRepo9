//
//  ReferalTypesDBHelper.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ReferalTypesDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_REFRAL_TYPE	 @"REFRAL_TYPE"

#define COL_REFRAL_TYPE  @"REFRAL_TYPE"

@implementation ReferalTypesDBHelper


- (NSArray *)fetchReferalTypes {
	NSMutableArray *arrReferalType = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@", COL_REFRAL_TYPE, TBL_REFRAL_TYPE];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strReferalType = [rs stringForColumn:COL_REFRAL_TYPE];
		[arrReferalType addObject:strReferalType];
	}
	[db close];
	
	return arrReferalType;
}
@end
