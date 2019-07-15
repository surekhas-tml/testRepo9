//
//  DSEModel.m
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "DSEModel.h"

@implementation DSEModel
@synthesize dseId,dseName,locationListForDSE,isActive;

- (instancetype)initWithDSEName:(NSString *)dseName dseId:(NSString*)dseCode locationList:(NSMutableArray*)dseLocationArray:(BOOL)isActive{
    self = [super init];
    if (!self) return nil;
    
    self.dseId = dseCode;
    self.dseName = dseName;
    self.locationListForDSE = dseLocationArray;
    self.isActive = isActive;
    return self;
}


@end
