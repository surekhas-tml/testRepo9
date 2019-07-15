//
//  CustomButtonForRemoveLocation.h
//  e-guru
//
//  Created by Apple on 19/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomButtonForRemoveLocation : UIButton
{    id userData;
}
@property (nonatomic,retain) NSMutableDictionary *selectedObjectDetailsDictionary;
@property (nonatomic, readwrite, retain) id userData;

@end

NS_ASSUME_NONNULL_END
