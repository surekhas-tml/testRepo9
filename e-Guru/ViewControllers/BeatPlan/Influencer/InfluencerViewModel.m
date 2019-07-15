//
//  InfluencerViewModel.m
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "InfluencerViewModel.h"
#import "EGRKWebserviceRepository.h"
#import "AppRepo.h"
#import "EGDse.h"

@implementation InfluencerViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.arrayHeaderList = [NSMutableArray new];
    }
    return self;
}

#pragma mark - MMGeo Array
- (void)getInfluencerApiWithType:(NSString*)type withid:(NSString *)dsmID withLOB:(NSString *)lob withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    NSDictionary *requestDictionary = @{
        @"dsm_id": dsmID,//@"1-50E9AE",
        @"customer_type": type
    };

    [[EGRKWebserviceRepository sharedRepository] getMyInfluencerAPI:requestDictionary andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject) {

        EGInfluencerDataModel *influencerModel = [[EGInfluencerDataModel alloc]init];
        influencerModel.customerType = responseObject[@"customer_type"];
        NSMutableArray *arrayList = [NSMutableArray new];
        int value = 0;
        for (NSDictionary *dic in responseObject[@"data"]){
            NSMutableArray *arrayMMGeoList = [NSMutableArray new];
            EGInfluencerDSEModel *dseModel = [[EGInfluencerDSEModel alloc]init];
            dseModel.dseID = dic[@"dse_id"];
            dseModel.index = value;
            if (value == 0){
                dseModel.isSelectedDSE = YES;
            }else{
                dseModel.isSelectedDSE = NO;
            }
            int index = 0;
            for (NSDictionary *dict in dic[@"data"]){
                NSMutableArray *arrayFinancierList = [NSMutableArray new];
                NSMutableArray *arrayBodyBuilderList = [NSMutableArray new];
                NSMutableArray *arrayMechanicsList = [NSMutableArray new];

                EGMMGeoInfluencerModel *mmgeoModel = [[EGMMGeoInfluencerModel alloc]init];
                mmgeoModel.index = index;
                if (index == 0){
                    mmgeoModel.isSelectedMMGeo = YES;
                }else{
                    mmgeoModel.isSelectedMMGeo = NO;
                }
                if (dict[@"mm_geo"] != (id)[NSNull null]){
                    mmgeoModel.mmGeo = dict[@"mm_geo"];
                }
                if (dict[@"district"] != (id)[NSNull null]){
                    mmgeoModel.district = dict[@"district"];
                }
                if (dict[@"city"] != (id)[NSNull null]){
                    mmgeoModel.city = dict[@"city"];
                }
                if ([type isEqualToString:@"influencer"]){
                    for (NSDictionary *financierDict in dict[@"financier_executives"]){
                        [arrayFinancierList addObject:[self parseCustomerModel:financierDict]];
                    }
                    for (NSDictionary *bodyBuilderDict in dict[@"body_builders"]){
                        [arrayBodyBuilderList addObject:[self parseCustomerModel:bodyBuilderDict]];
                    }
                    for (NSDictionary *mechanicDict in dict[@"mechanics"]){
                        [arrayMechanicsList addObject:[self parseCustomerModel:mechanicDict]];
                    }
                    mmgeoModel.financier_executives = arrayFinancierList;
                    mmgeoModel.bodyBuilders = arrayBodyBuilderList;
                    mmgeoModel.mechanics = arrayMechanicsList;
                }else{
                    for (NSDictionary *financierDict in dict[@"key_customer"]){
                        [arrayFinancierList addObject:[self parseCustomerModel:financierDict]];
                    }
                    for (NSDictionary *bodyBuilderDict in dict[@"regular_visits"]){
                        [arrayBodyBuilderList addObject:[self parseCustomerModel:bodyBuilderDict]];
                    }
                    mmgeoModel.financier_executives = arrayFinancierList;
                    mmgeoModel.bodyBuilders = arrayBodyBuilderList;
                }
                [arrayMMGeoList addObject:mmgeoModel];
                index += 1;
            }
            dseModel.dseMMGeoArray = arrayMMGeoList;
            [arrayList addObject:dseModel];
            value += 1;
        }
        influencerModel.data = arrayList;
        self.egInfluencerDataModel = influencerModel;
        blck(@"Success");
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        errorBlck(error);
    }];
}
- (EGCustomerDetailModel*)parseCustomerModel:(NSDictionary*)dict{
    EGCustomerDetailModel *customerModel = [[EGCustomerDetailModel alloc]init];
    customerModel.name = dict[@"name"];
    customerModel.accountName = dict[@"account_name"];
    customerModel.contactNumber = dict[@"contact_number"];
    customerModel.lob = dict[@"lob"];
    customerModel.application = dict[@"application"];
    customerModel.status = dict[@"status"];
    customerModel.customer_id = dict[@"customer_id"];
    return customerModel;
}
- (NSString*)getTitleOfDSEAtIndex:(NSInteger)index {
    if (self.egInfluencerDataModel.data.count > 0){
        EGInfluencerDSEModel *model = [self.egInfluencerDataModel.data objectAtIndex:index];
        return model.dseID;
    }
    return @"";
}
- (NSMutableArray *)getAllDataDSEID{
    NSMutableArray *arrayDSE = [[NSMutableArray alloc] init];
    for ( EGInfluencerDSEModel *obj in self.egInfluencerDataModel.data){
        [arrayDSE addObject:obj.dseID];
    }
    return arrayDSE;
}

#pragma mark - DSE List API
- (void)getDSEListFromMMGeo:(NSString*)mmGeo withSuccessAction:(successBlock)successBlock andFailuerAction:(errorBlock)failuerBlock{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:MMGEO_DSE_LIST :@{
                                                                                     @"mm_geo": mmGeo
                                                                                     } andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
                                                                                         successBlock(responseObject);
                                                                                     } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
                                                                                         NSLog(@"%@",error.localizedDescription);
                                                                                         failuerBlock(error);
                                                                                     }];
}

#pragma mark - MMGEO List API
- (void)getMMGEOListWithParams:(NSDictionary*)params withSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETMMGEOLIST :params andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        errorBlck(error);
    }];
}

#pragma mark - District List API
- (void)getDistrictListFromState:(NSString*)state withSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETDISTRICTLIST :@{
                                                                                     @"state": state
                                                                                     } andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
                                                                                         blck(responseObject);
                                                                                     } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
                                                                                         NSLog(@"%@",error.localizedDescription);
                                                                                         errorBlck(error);
                                                                                     }];
}

#pragma mark - City List API
- (void)getCityListFromParams:(NSDictionary*)params SuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:GETCITYLIST : params
    andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        errorBlck(error);
    }];
}

#pragma mark - LOB List API
- (void)getLOBListSuccessBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{
    
    [[EGRKWebserviceRepository sharedRepository] getMyTeamDetailsAPI:LOB_LIST :nil andSucessAction:^(AFRKHTTPRequestOperation *operation, id responseObject){
            blck(responseObject);
        } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            errorBlck(error);
    }];
}

#pragma mark - ADD Customer API
- (void)addCustomerWithParams:(NSDictionary*)params isUpdate:(BOOL)isUpdate withCompletionBlock:(successBlock)blck withFailureBlock:(errorBlock)errorBlck{

    [[EGRKWebserviceRepository sharedRepository] addCustomerAPI:params isUpdate:isUpdate  andSucessAction:^(AFRKHTTPRequestOperation *op, id responseObject) {
        blck(responseObject);
    } andFailuerAction:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        errorBlck(error);
    }];
}

#pragma mark - Header Array
- (void)getHeaderListWithType:(NSString*)type{
    [self.arrayHeaderList removeAllObjects];
    EGInfluencerModel *modelFinancier = [[EGInfluencerModel alloc]init];
    modelFinancier.index = 0;
    modelFinancier.isSelectedSourceOfContact = YES;
    [self.arrayHeaderList addObject:modelFinancier];
    
    EGInfluencerModel *modelBodybuilder = [[EGInfluencerModel alloc]init];
    modelBodybuilder.index = 1;
    modelBodybuilder.isSelectedSourceOfContact = NO;
    [self.arrayHeaderList addObject:modelBodybuilder];
    
    if([type isEqualToString:@"influencer"]){
        modelFinancier.title = @"Financier";
        modelBodybuilder.title = @"Bodybuilder";
        
        EGInfluencerModel *modelMechanic = [[EGInfluencerModel alloc]init];
        modelMechanic.index = 2;
        modelMechanic.title = @"Mechanic";
        modelMechanic.isSelectedSourceOfContact = NO;
        [self.arrayHeaderList addObject:modelMechanic];
    }else{
        modelFinancier.title = @"Key Customer";
        modelBodybuilder.title = @"Regular Visits";
    }
}
- (NSString*)getTitleOfHeaderAtIndex:(NSInteger)index{
    if (self.arrayHeaderList.count > 0){
        EGInfluencerModel *model = [self.arrayHeaderList objectAtIndex:index];
        return model.title;
    }
    return @"";
}
- (void)setHeaderSelectedAtIndex:(NSInteger)index{
    for (EGInfluencerModel *model in self.arrayHeaderList) {
        if (model.index == index) {
            model.isSelectedSourceOfContact = YES;
        } else {
            model.isSelectedSourceOfContact = NO;
        }
    }
}
- (BOOL)getValueOfHeaderAtIndex:(NSInteger)index {
    if (self.arrayHeaderList.count > 0){
        EGInfluencerModel *model = [self.arrayHeaderList objectAtIndex:index];
        return model.isSelectedSourceOfContact;
    }
    return NO;
}

@end
