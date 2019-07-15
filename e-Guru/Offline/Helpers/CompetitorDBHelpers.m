//
//  CompetitorDBHelpers.m
//  e-guru
//
//  Created by Ganesh Patro on 25/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "CompetitorDBHelpers.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_COMPETITOR_MAKE_LOST  @"COMPETITOR_MAKE_LOST"

#define COL_COMPETITOR_MAKE_LOST  @"COMPETITOR_MAKE_LOST"

@implementation CompetitorDBHelpers

- (NSArray *)fetchAllCompetitors {
	NSMutableArray *arrInfluencerType = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@", COL_COMPETITOR_MAKE_LOST, TBL_COMPETITOR_MAKE_LOST];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strInfluencerType = [rs stringForColumn:COL_COMPETITOR_MAKE_LOST];
		[arrInfluencerType addObject:strInfluencerType];
	}
	
	[db close];
	return arrInfluencerType;
}

@end
