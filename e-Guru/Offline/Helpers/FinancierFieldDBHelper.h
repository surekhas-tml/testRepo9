//
//  FinancierFieldDBHelper.h
//  e-guru
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancierFieldDBHelper : NSObject

-(NSArray *)fetchTitle;
-(NSArray *)fetchGender;
-(NSArray *)fetchMarritalStatus;
-(NSArray *)fetchAddressType;
-(NSArray *)fetchReligion;
-(NSArray *)fetchAccountType;
-(NSArray *)fetchVehicleColor;
-(NSArray *)fetchEmmisionNorms;
-(NSArray *)fetchCustomerCategory;
-(NSArray *)fetchCustomerSubCategory;
-(NSArray *)fetchIDType;

@end
