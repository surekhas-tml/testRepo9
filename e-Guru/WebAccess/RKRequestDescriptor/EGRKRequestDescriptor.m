//
//  EGRKRequestDescriptor.m
//  e-guru
//
//  Created by MI iMac04 on 19/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGRKRequestDescriptor.h"
#import "EGRKObjectMapping.h"

static EGRKRequestDescriptor *_sharedDescriptor;
@implementation EGRKRequestDescriptor

+(EGRKRequestDescriptor *)sharedDescriptor{
    @synchronized([EGRKRequestDescriptor class])
    {
        if (!_sharedDescriptor)
            _sharedDescriptor=[[self alloc] init];
        
        return _sharedDescriptor;
    }
    return nil;
}
+(id)alloc
{
    @synchronized([EGRKRequestDescriptor class])
    {
        NSAssert(_sharedDescriptor == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedDescriptor = [super alloc];
        return _sharedDescriptor;
    }
    
    return nil;
}

- (instancetype )init
{
    self = [super init];
    if (self) {
        [self setupAllRequestDescriptors];
    }
    return self;
}

- (void)setupAllRequestDescriptors {
    
    [EGRKRequestDescriptor setupRequestDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] opportunityMapping] objectClass:[EGOpportunity class] rootKeyPath:nil];
    
    //for financierInsertQuote model requestDescriptor
//    [EGRKRequestDescriptor setupRequestDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] financierInsertQuoteMapping] objectClass:[FinancierInsertQuoteModel class] rootKeyPath:nil];

    
//    [EGRKRequestDescriptor setupRequestDescriptorForMappingForPOSTMethod:[[EGRKObjectMapping sharedMapping] opportunityMapping] objectClass:[EGOpportunity class] rootKeyPath:nil];
}

+ (void)setupRequestDescriptorForMappingForPOSTMethod:(RKObjectMapping *)mapping objectClass:(Class)class rootKeyPath:(NSString *)path {
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[mapping inverseMapping]
                                                                                   objectClass:class
                                                                                   rootKeyPath:path
                                                                                        method:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
}

@end
