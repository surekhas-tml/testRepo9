//
//  LobDBHelper.m
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "VCNumberDBHelper.h"
#import "AppDelegate.h"
#import "EGLob.h"
#import "EGPpl.h"
#import "EGPl.h"

@implementation VCNumberDBHelper


#define TBL_VC_NUMBER		 @"VC_NUMBER"

#define COL_VC_NUMBER  		 @"VC_NUMBER"
#define COL_LOB  			 @"LOB"
#define COL_PPL  			 @"PPL"
#define COL_PL  			 @"PL"
#define COL_DESCRIPTION  	 @"description"
#define COL_PRODUCT_ID  	 @"PRODUCT_ID"

- (NSArray *)fetchAllLOB {
	NSMutableArray *arrLOBS = [NSMutableArray new];
	NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_LOB, TBL_VC_NUMBER];

	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGLob *lob = [EGLob new];
		lob.lobName = [rs stringForColumn:COL_LOB];
		[arrLOBS addObject:lob];
	}
	[db close];
	
	return arrLOBS;
}


- (NSArray *)fetchAllPPLFromLob:(NSString *)strLOB {
	NSMutableArray *arrPPL = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" ", COL_PPL, TBL_VC_NUMBER, COL_LOB, strLOB];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGPpl *ppl = [EGPpl new];
		ppl.pplName = [rs stringForColumn:COL_PPL];
		[arrPPL addObject:ppl];
	}
	[db close];

	return arrPPL;
}

- (NSArray *)fetchAllPLFromLob:(NSString *)strLOB withPPL:(NSString *)strPPL {
	NSMutableArray *arrPL = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT %@ from %@ WHERE \"%@\" = \"%@\" AND \"%@\" = \"%@\"", COL_PL, TBL_VC_NUMBER, COL_LOB, strLOB, COL_PPL, strPPL];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGPl *pl = [EGPl new];
		pl.plName = [rs stringForColumn:COL_PL];
		[arrPL addObject:pl];
	}
	[db close];
	return arrPL;
}

- (NSArray *)fetchAllVCNumberWithPL:(NSString *)strPL withPPL:(NSString *)ppl withLOB:(NSString *)lob {
	NSMutableArray *vcNumberArray = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT * from %@ WHERE \"%@\" = \"%@\" AND \"%@\" = \"%@\" AND \"%@\" = \"%@\"", TBL_VC_NUMBER, COL_PL, strPL, COL_PPL, ppl, COL_LOB, lob];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGVCNumber *vcNumber = [EGVCNumber new];
		vcNumber.lob = [rs stringForColumn:COL_LOB];
		vcNumber.ppl = [rs stringForColumn:COL_PPL];
		vcNumber.pl = [rs stringForColumn:COL_PL];
		vcNumber.vcNumber = [rs stringForColumn:COL_VC_NUMBER];
		vcNumber.productDescription = [rs stringForColumn:COL_DESCRIPTION];
		vcNumber.productID = [rs stringForColumn:COL_PRODUCT_ID];
		[vcNumberArray addObject:vcNumber];
	}
	[db close];
	return vcNumberArray;
}

//TODO - Search Query
- (NSArray *)fetchAllVCNumberWithSearchQuery:(NSString *)strSearchText {
	NSMutableArray *vcNumberArray = [NSMutableArray new];
	NSString *strSelectStatement = [NSString
									stringWithFormat:@"select DISTINCT * from %@ WHERE \"%@\" LIKE \"%%%@%%\"  OR  \"%@\" LIKE \"%%%@%%\" OR  \"%@\" LIKE \"%%%@%%\"", TBL_VC_NUMBER, COL_PL, strSearchText, COL_DESCRIPTION, strSearchText, COL_VC_NUMBER, strSearchText];
	
	FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
	[db open];
	FMResultSet *rs = [db executeQuery:strSelectStatement];
	while ([rs next]) {
		EGVCNumber *vcNumber = [EGVCNumber new];
		vcNumber.lob = [rs stringForColumn:COL_LOB];
		vcNumber.ppl = [rs stringForColumn:COL_PPL];
		vcNumber.pl = [rs stringForColumn:COL_PL];
		vcNumber.vcNumber = [rs stringForColumn:COL_VC_NUMBER];
		vcNumber.productDescription = [rs stringForColumn:COL_DESCRIPTION];
		vcNumber.productID = [rs stringForColumn:COL_PRODUCT_ID];
		[vcNumberArray addObject:vcNumber];
	}
	[db close];
	return vcNumberArray;
}

@end
