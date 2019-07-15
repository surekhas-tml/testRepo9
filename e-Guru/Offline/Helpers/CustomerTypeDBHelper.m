//
//  CustomerTypeDBHelper.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "CustomerTypeDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_CUSTOMER_TYPE	 @"CUSTOMER_TYPE"

#define COL_LOB  			 @"LOB"
#define COL_CUSTOMER_TYPE   @"CUSTOMER_TYPE"

@implementation CustomerTypeDBHelper

- (NSArray *)fetchCustomerTypesFromLob:(NSString *)strLOB {
	NSMutableArray *arrCustomerTypes = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" ", COL_CUSTOMER_TYPE, TBL_CUSTOMER_TYPE, COL_LOB, strLOB];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strCustomerType = [rs stringForColumn:COL_CUSTOMER_TYPE];
		[arrCustomerTypes addObject:strCustomerType];
	}
	[db close];
	
	return arrCustomerTypes;
}

@end
