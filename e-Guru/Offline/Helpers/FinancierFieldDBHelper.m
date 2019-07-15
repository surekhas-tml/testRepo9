//
//  FinancierFieldDBHelper.m
//  e-guru
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierFieldDBHelper.h"
#import "AppDelegate.h"
#import "FinancierInsertQuoteModel.h"

@implementation FinancierFieldDBHelper

#define TBL_TITLE                 @"TITLE"
#define TBL_GENDER                @"GENDER"
#define TBL_MARITAL_STATUS		  @"MARITAL_STATUS"
#define TBL_ADDRESS_TYPE          @"ADDRESS_TYPE"
#define TBL_RELIGION              @"RELIGION"
#define TBL_ACCOUNT_TYPE		  @"ACCOUNT_TYPE"
#define TBL_VEHICLE_COLOR         @"VEHICLE_COLOR"
#define TBL_EMMISSION_NORMS       @"EMMISSION_NORMS"
#define TBL_CUSTOMER_CATEGORY	  @"CUSTOMER_CATEGORY"
#define TBL_CUSTOMER_SUBCATAGORY  @"CUSTOMER_SUBCATAGORY"
#define TBL_ID_TYPE               @"ID_TYPE"


#define COL_title                 @"title"
#define COL_gender                @"gender"
#define COL_marital_status  	  @"marital_status"
#define COL_address_type  		  @"address_type"
#define COL_religion              @"religion"
#define COL_account_type          @"account_type"
#define COL_vehicle_color  		  @"vehicle_color"
#define COL_emmision_norms  	  @"emmision_norms"
#define COL_customer_category  	  @"customer_category"
#define COL_customer_subcatagory  @"customer_subcatagory"
#define COL_idtype                @"ID_TYPE"


- (NSArray *)fetchTitle {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_title, TBL_TITLE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.title = [rs stringForColumn:COL_title];
        
        NSString* modelObj = [rs stringForColumn:COL_title];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchGender {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_gender, TBL_GENDER];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.gender = [rs stringForColumn:COL_gender];
        NSString* modelObj = [rs stringForColumn:COL_gender];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchMarritalStatus {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_marital_status, TBL_MARITAL_STATUS];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.partydetails_maritalstatus = [rs stringForColumn:COL_marital_status];
        NSString* modelObj = [rs stringForColumn:COL_marital_status];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchAddressType {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_address_type, TBL_ADDRESS_TYPE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.address_type = [rs stringForColumn:COL_address_type];
        NSString* modelObj = [rs stringForColumn:COL_address_type];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchReligion {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_religion, TBL_RELIGION];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.religion = [rs stringForColumn:COL_religion];
        NSString* modelObj = [rs stringForColumn:COL_religion];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchAccountType {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_account_type, TBL_ACCOUNT_TYPE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.account_type = [rs stringForColumn:COL_account_type];
        NSString* modelObj = [rs stringForColumn:COL_account_type];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchVehicleColor {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_vehicle_color, TBL_VEHICLE_COLOR];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.vehicle_color = [rs stringForColumn:COL_vehicle_color];
        NSString* modelObj = [rs stringForColumn:COL_vehicle_color];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}
- (NSArray *)fetchEmmisionNorms {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_emmision_norms, TBL_EMMISSION_NORMS];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.emission_norms = [rs stringForColumn:COL_emmision_norms];
        NSString* modelObj = [rs stringForColumn:COL_emmision_norms];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchCustomerCategory {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_customer_category, TBL_CUSTOMER_CATEGORY];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.customer_category = [rs stringForColumn:COL_customer_category];
        NSString* modelObj = [rs stringForColumn:COL_customer_category];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchCustomerSubCategory {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_customer_subcatagory, TBL_CUSTOMER_SUBCATAGORY];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *modelObj = [FinancierInsertQuoteModel new];
//        modelObj.customer_category_subcategory = [rs stringForColumn:COL_customer_subcatagory];
        NSString* modelObj = [rs stringForColumn:COL_customer_subcatagory];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

- (NSArray *)fetchIDType {
    NSMutableArray *arr = [NSMutableArray new];
    NSString *strSelectStatement = [NSString stringWithFormat:@"select DISTINCT %@ from %@", COL_idtype, TBL_ID_TYPE];
    
    FMDatabase *db = [[DBManager sharedInstance] getMasterDataBase];
    [db open];
    FMResultSet *rs = [db executeQuery:strSelectStatement];
    while ([rs next]) {
//        FinancierInsertQuoteModel *model = [FinancierInsertQuoteModel new];
//        model.id_type = [rs stringForColumn:COL_idtype];
        NSString* modelObj = [rs stringForColumn:COL_idtype];
        [arr addObject:modelObj];
    }
    [db close];
    
    return arr;
}

@end
