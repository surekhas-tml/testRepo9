//
//  PotentialDropActivityViewController.h
//  e-guru
//
//  Created by Apple on 03/05/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGPagedTableView.h"
#import "EGPagedArray.h"
NS_ASSUME_NONNULL_BEGIN

@interface PotentialDropActivityViewController : UIViewController< UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) EGPagedArray *activityList;
@property (strong, nonatomic) NSMutableDictionary *requestDictionary;

@end

NS_ASSUME_NONNULL_END
