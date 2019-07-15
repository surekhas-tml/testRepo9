//
//  EGPagedArray.h
//  e-guru
//
//  Created by Rajkishan on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGPagination.h"

@interface EGPagedArray : NSObject
{
@private
    NSMutableArray * _embeddedArray;
    NSInteger _totalResults;
}

@property (nonatomic) NSInteger     totalResults;
@property (nonatomic, readonly) NSUInteger    currentSize;

- (id)init;
- (id)initWithCapacity:(NSUInteger)numItems;
- (id)initWithPagedArray:(EGPagedArray *)array;
-(id)initWithArray:(NSArray *)array;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:object;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:object;
- (void)insertObject:object atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)clearAllItems;

+ (EGPagedArray *)mergeWithCopy:(EGPagedArray *)anArray withArray:(EGPagedArray *)otherArray;
+ (EGPagedArray *)mergeWithCopy:(EGPagedArray *)anArray withPagination:(EGPagination *)pagination;
- (NSMutableArray *)getEmbededArray;
@end
