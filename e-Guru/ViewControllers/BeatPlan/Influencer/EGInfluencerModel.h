//
//  EGInfluencerModel.h
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGInfluencerModel : NSObject
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) BOOL isSelectedSourceOfContact;
@end

NS_ASSUME_NONNULL_END
