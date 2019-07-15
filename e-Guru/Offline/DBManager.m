//
//  DBManager.m
//
//
//  Created by Ganesh Patro on 03/02/16.
//  Copyright © 2016 cuelogic. All rights reserved.
//

#import "DBManager.h"

@interface DBManager() {
	
}
@property(strong,atomic) FMDatabase *db;
@end

@implementation DBManager
@synthesize db;

static DBManager *sharedInstance;

+ (id) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

#pragma mark - Public Methods
- (FMDatabase *)getMasterDataBase {
	return db;
}

#pragma mark -- Create DB
- (void)setUpDB:(NSString *)strDBName {
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",strDBName]];
    db = [FMDatabase databaseWithPath:dbPath];
}

#pragma mark - Get DataBase Path
- (NSString *)getDataBasePath {
    [db open];
    NSString *strPath = [db databasePath];
    [db close];
    return strPath;
}

@end
