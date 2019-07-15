//
//  VehicleApplicationDBHelper.h
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleApplicationDBHelper : NSObject

- (NSArray *)fetchAllVehicleApplication:(NSString *)strLOB;
- (NSArray *)fetchAllBodyType:(NSString *)strVehicleApplication forLOB:(NSString *)strLOB;
- (NSArray *)fetchDefaultBodyType:(NSString *)strVehicleApplication forLOB:(NSString *)strLOB;
@end
