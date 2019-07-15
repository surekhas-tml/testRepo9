//
//  EGExclusionListModel.h
//  e-guru
//
//  Created by Apple on 27/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGExclusionListModel : NSObject
@property(nonatomic,copy)  NSString * startDate;
@property(nonatomic,copy)  NSString * endDate;
@property(nonatomic,copy)  NSMutableArray * exclusions;
@end

NS_ASSUME_NONNULL_END
