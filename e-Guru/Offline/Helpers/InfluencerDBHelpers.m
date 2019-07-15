//
//  InfluencerDBHelpers.m
//  e-guru
//
//  Created by Ganesh Patro on 25/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "InfluencerDBHelpers.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_INFLUENCER	 @"INFLUENCER"

#define COL_INFLUENCER  @"INFLUENCER"

@implementation InfluencerDBHelpers

- (NSArray *)fetchInfluencerTypes {
	NSMutableArray *arrInfluencerType = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@", COL_INFLUENCER, TBL_INFLUENCER];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strInfluencerType = [rs stringForColumn:COL_INFLUENCER];
		[arrInfluencerType addObject:strInfluencerType];
	}
	[db close];
	
	return arrInfluencerType;
}
@end
