//
//  FinanciersDBHelpers.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "FinanciersDBHelpers.h"
#import "FMDB.h"
#import "DBManager.h"
#import "EGFinancier.h"

#define TBL_FINANCIER	 @"FINANCIER"

#define COL_FINANCIER    @"FINANCIER_NAME"
#define COL_FINANCIER_ID @"COL_FINANCIER_ID"
#define COL_BU_NAME      @"COL_BU_NAME"
#define COL_FIN_CAT      @"COL_FIN_CAT"


@implementation FinanciersDBHelpers

- (NSArray *)fetchAllFinanciers {
	NSMutableArray *arrFinanciers = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT * from %@", TBL_FINANCIER];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGFinancier *egFinancier = [EGFinancier new];
		egFinancier.financierName = [rs stringForColumn:COL_FINANCIER];
		egFinancier.financierID = [rs stringForColumn:COL_FINANCIER_ID];
		[arrFinanciers addObject:egFinancier];
	}
	[db close];
	
	return arrFinanciers;
}
@end
