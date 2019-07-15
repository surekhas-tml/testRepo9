//
//  FinancierBranchDetailsModel.h
//  e-guru
//
//  Created by Shashi on 09/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancierBranchDetailsModel : NSObject

@property (nullable, nonatomic, copy) NSString *financier_id;
@property (nullable, nonatomic, copy) NSString *financier_name;
@property (nullable, nonatomic, copy) NSString *branch_id;

-(_Nonnull instancetype)initWithObject:(NSString * _Nullable)object;

@end
