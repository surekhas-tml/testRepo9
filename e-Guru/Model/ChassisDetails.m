//
//  ChassisDetails.m
//  e-guru
//
//  Created by Admin on 06/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "ChassisDetails.h"

@implementation ChassisDetails

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.tml_src_assset_id  = @"";
        self.CHASSIS_NUM_s      = @"";
        self.PPL_s              = @"";
        self.PPL_ID_s           = @"";
        self.VC_ID_s            = @"";
        self.CHA_STAT_s         = @"";
        self.PL_s               = @"";
        self.tml_ref_pl_id      = @"";

    }
    return self;
}


@end
