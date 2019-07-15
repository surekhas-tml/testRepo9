//
//  EGMMGeoInfluencerModel.m
//  e-guru
//
//  Created by Apple on 04/03/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "EGMMGeoInfluencerModel.h"

@implementation EGMMGeoInfluencerModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.mmGeo = @"";
        self.district = @"";
        self.city = @"";
    }
    return self;
}
@end
