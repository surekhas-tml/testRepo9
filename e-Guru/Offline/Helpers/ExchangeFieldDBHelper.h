//
//  ExchangeFieldDBHelper.h
//  e-guru
//
//  Created by Admin on 04/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeFieldDBHelper : NSObject

-(NSArray *)fetchBrand;
-(NSArray *)fetchPLForExchange;
-(NSArray *)fetchMileage;
-(NSArray *)fetchAgeOfVehicle;


@end
