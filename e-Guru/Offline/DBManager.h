//
//  DBManager.h
//  SnapHelp
//
//  Created by Ganesh Patro on 03/02/16.
//  Copyright © 2016 cuelogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "EGOfflineMasterSyncHelper.h"
@interface DBManager : NSObject

+ (id) sharedInstance;

#pragma mark - Public Methods
- (FMDatabase *)getMasterDataBase;

#pragma mark -- Create DB
- (void)setUpDB:(NSString *)strDBName;

#pragma mark - Get DataBase Path
- (NSString *)getDataBasePath;

@end
