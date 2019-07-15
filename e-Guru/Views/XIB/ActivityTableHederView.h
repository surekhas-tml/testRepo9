//
//  ActivityTableHederView.h
//  e-Guru
//
//  Created by Juili on 05/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+eGuruColorScheme.h"

@interface ActivityTableHederView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *col1;
@property (weak, nonatomic) IBOutlet UIButton *col2;
@property (weak, nonatomic) IBOutlet UIButton *col3;
@property (weak, nonatomic) IBOutlet UIButton *col4;
@property (weak, nonatomic) IBOutlet UIButton *col5;
@property (weak, nonatomic) IBOutlet UIButton *col6;
- (IBAction)activityFilterButtonClicked:(id)sender;
-(instancetype)initWithFrame:(CGRect)frame withActivity:(NSString *)activity;
@end
