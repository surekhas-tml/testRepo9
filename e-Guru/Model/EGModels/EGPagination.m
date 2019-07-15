//
//  EGPagination.m
//  e-Guru
//
//  Created by Rajkishan on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPagination.h"

@implementation EGPagination
{
    
}
@synthesize totalResultsString,totalResults,items;

-(NSUInteger)totalResults{
    return [self.totalResultsString integerValue];
}

+ (RKObjectMapping *)initMapping:(RKObjectMapping *)itemsMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EGPagination class]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"result" toKeyPath:@"items"]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"total_results" toKeyPath:@"totalResultsString"]];
    return mapping;
}

@end
