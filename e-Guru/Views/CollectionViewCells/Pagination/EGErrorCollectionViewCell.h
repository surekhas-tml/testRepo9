//
//  EGErrorCollectionViewCell.h
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGErrorCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@end
