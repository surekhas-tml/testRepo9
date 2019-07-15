//
//  EGPagedArray.m
//  e-guru
//
//  Created by Rajkishan on 08/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGPagedArray.h"

@implementation EGPagedArray

@synthesize totalResults = _totalResults;

#pragma mark initialize methods
- (id)init
{
    self = [super init];
    if (self)
    {
        _embeddedArray = [[NSMutableArray alloc] init];
        _totalResults = -1;
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        _embeddedArray = [[NSMutableArray alloc] initWithCapacity:numItems];
        _totalResults = -1;
    }
    return self;
}

- (id)initWithPagedArray:(EGPagedArray *)array
{
    self = [super init];
    if (self)
    {
        _embeddedArray = [[NSMutableArray alloc] initWithArray:array->_embeddedArray];
        _totalResults = array->_totalResults;
    }
    return self;
}

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        _embeddedArray = [[NSMutableArray alloc] initWithArray:array];
        _totalResults = array.count;
    }
    return self;
}

- (id)initWithPagination:(EGPagination *)pagination
{
    self = [super init];
    if (self)
    {
        _embeddedArray = [[NSMutableArray alloc] initWithArray:pagination.items];
        _totalResults = pagination.totalResults;
    }
    return self;
}

#pragma mark dtor
- (void)dealloc {
    _embeddedArray = nil;
}

#pragma static util methods
+ (EGPagedArray *)mergeWithCopy:(EGPagedArray *)anArray withArray:(EGPagedArray *)otherArray {
    if (anArray == nil && otherArray == nil) {
        return nil;
    }
    
    if (anArray == nil) {
        return [[EGPagedArray alloc] initWithPagedArray:otherArray];
    }
    
    if (otherArray == nil) {
        return [[EGPagedArray alloc] initWithPagedArray:anArray];
    }

    EGPagedArray *newArray = [[EGPagedArray alloc] initWithPagedArray:anArray];
    newArray.totalResults = MAX(anArray->_totalResults, otherArray->_totalResults);
    
    for (id item in otherArray->_embeddedArray) {
        [newArray->_embeddedArray addObject:item];
    }
    return newArray;
}

+ (EGPagedArray *)mergeWithCopy:(EGPagedArray *)anArray withPagination:(EGPagination *)pagination
{
    if(nil == pagination) {
        return anArray;
    }
    
    EGPagedArray *anotherArray = [[EGPagedArray alloc] initWithPagination:pagination];
    
    return [EGPagedArray mergeWithCopy:anArray withArray:anotherArray];
}

#pragma public methods and properties
- (NSUInteger)count {
    return [_embeddedArray count];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_embeddedArray objectAtIndex:index];
}

- (void)addObject:(id)object {
    [_embeddedArray addObject:object];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:object {
    [_embeddedArray replaceObjectAtIndex:index withObject:object];
}

- (void)removeLastObject {
    [_embeddedArray removeLastObject];
}

- (void)insertObject:object atIndex:(NSUInteger)index {
    [_embeddedArray insertObject:object atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_embeddedArray removeObjectAtIndex:index];
}

- (void)setArray:(NSArray *)otherArray {
    _embeddedArray = [[NSMutableArray alloc] initWithArray:otherArray];
}

- (void)clearAllItems {
    [_embeddedArray removeAllObjects];
    
    _totalResults = -1;
}

- (NSInteger)totalResults {
    return _totalResults;
}

- (NSUInteger)currentSize {
    return [_embeddedArray count];
}

- (NSMutableArray *)getEmbededArray {
    return _embeddedArray;
}

@end
