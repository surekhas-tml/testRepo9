//
//  EGPagination.h
//  e-Guru
//
//  Created by Rajkishan on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface EGPagination : NSObject

@property(retain, nonatomic)    NSMutableArray *items;
@property(nonatomic,copy)  NSString *totalResultsString;

@property(nonatomic)  NSUInteger totalResults;

//TODO - start and end values are not handled right now. May be needed later

+ (RKObjectMapping *)initMapping:(RKObjectMapping *)itemsMapping;

@end
