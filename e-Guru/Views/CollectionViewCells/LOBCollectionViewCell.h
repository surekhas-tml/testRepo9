//
//  LOBCollectionViewCell.h
//  e-Guru
//
//  Created by MI iMac04 on 17/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOBCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lobImageView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalColumnCount;
@property (nonatomic, assign) NSInteger totalCellCount;

@end
