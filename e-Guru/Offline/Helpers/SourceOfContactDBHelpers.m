//
//  SourceOfContactDBHelpers.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "SourceOfContactDBHelpers.h"
#import "FMDB.h"
#import "DBManager.h"


#define TBL_SOURCE_OF_CONTACT	 @"SOURCE_OF_CONTACT"

#define COL_SOURCE_OF_CONTACT    @"SOURCE_OF_CONTACT"

@implementation SourceOfContactDBHelpers

- (NSArray *)fetchSourceOfContactFromLob {
	NSMutableArray *arrSourceOfContact = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@", COL_SOURCE_OF_CONTACT, TBL_SOURCE_OF_CONTACT];
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		NSString *strSourceOfContact = [rs stringForColumn:COL_SOURCE_OF_CONTACT];
		[arrSourceOfContact addObject:strSourceOfContact];
	}
	[db close];
	
	return arrSourceOfContact;
}
@end
