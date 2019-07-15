//
//  HHSlideView+TabSelectionExtention.h
//  e-guru
//
//  Created by Juili on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "HHSlideView.h"

@interface HHSlideView (TabSelectionExtention)
- (void)buttonClicked:(UIButton *)button;
@property (strong, nonatomic) NSMutableArray *buttonsArray;     /**< 所有滑块上的按钮 */
@end
