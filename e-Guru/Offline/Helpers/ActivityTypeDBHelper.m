//
//  ActivityTypeDBHelper.m
//  e-guru
//
//  Created by Admin on 26/03/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "ActivityTypeDBHelper.h"
#import "FMDB.h"
#import "DBManager.h"

#define TBL_ACTIVITY_TYPE  @"ACTIVITY_TYPE"

#define COL_ACTIVITY_TYPE  @"ACTIVITY_TYPE"

@implementation ActivityTypeDBHelper


- (NSArray *)fetchAllActivityTypes {
    
    NSMutableArray *arrInfluencerType = [NSMutableArray new];
    NSString *strSelectStatement = [NSString
                                    stringWithFormat:@"select DISTINCT %@ from %@", COL_ACTIVITY_TYPE, TBL_ACTIVITY_TYPE];
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
        NSString *strInfluencerType = [rs stringForColumn:COL_ACTIVITY_TYPE];
        [arrInfluencerType addObject:strInfluencerType];
    }
    
    [db close];
    return arrInfluencerType;
}

@end
