//
//  UsageCategoryDBHelper.h
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsageCategoryDBHelper : NSObject


- (NSArray *)fetchAllUsageCategoriesFromLob:(NSString *)strLOB;


@end
