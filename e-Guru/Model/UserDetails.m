//
//  UserDetails.m
//  e-Guru
//
//  Created by Juili on 26/10/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "UserDetails.h"
#import "Constant.h"
@implementation UserDetails
static UserDetails*  _sharedobject=nil;
@synthesize position;
+(UserDetails *)sharedobject{
    @synchronized([UserDetails class])
    {
        if (!_sharedobject)
            _sharedobject=[[self alloc] init];
        
        return _sharedobject;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([UserDetails class])
    {
        NSAssert(_sharedobject == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedobject = [super alloc];
        return _sharedobject;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
//        self.position = PostionforDSE;
//        self.name = @"Mahesh";
//        self.contact = @"9869540114";
//        self.org =@"DADA MOTORS";

    }
    
    return self;
}
@end
