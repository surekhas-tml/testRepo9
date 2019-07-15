//
//  EGLoadingCollectionViewCell.h
//  e-guru
//
//  Created by local admin on 12/13/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGLoadingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
