//
//  Field.h
//  e-Guru
//
//  Created by MI iMac04 on 23/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum fieldType
{
    Text,
    AutoCompleteText,
    SingleSelectList,
    SingleLongSelectList,
    Search,
    Number
    
} FieldType;

@interface Field : NSObject

@property (nonatomic, assign) FieldType mFieldType;

@property (nonatomic, strong) NSString *mTitle;
@property (nonatomic, strong) NSString *mDisplayTitle;
@property (nonatomic, strong) NSString *mDefaultValue;
@property (nonatomic, strong) NSString *mSelectedValue;
@property (nonatomic, strong) NSString *mValidationRegex;
@property (nonatomic, strong) NSString *mErrorMessage;

@property (nonatomic, strong) NSMutableArray *mDataList;
@property (nonatomic, strong) NSMutableArray *mValues;
@property (nonatomic, strong) NSMutableArray *mPredecessors;
@property (nonatomic, strong) NSMutableArray *mSuccessors;

@property (nonatomic, assign) BOOL mIsEnabled;
@property (nonatomic, assign) BOOL mIsMandatory;

@property (nonatomic, assign) NSInteger mOrder;
@property (nonatomic, assign) NSInteger mMaxDisplayCharWidth;

- (instancetype)initWithTitle:(NSString *)title;

- (void)addSuccessor:(Field *)successor;
- (void)removeSuccessor:(Field *)successor;
- (void)addPredecessor:(Field *)predecessor;
- (void)removePredecessor:(Field *)predecessor;
- (void)addValue:(NSString *)value;

@end
