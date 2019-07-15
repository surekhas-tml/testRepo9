//
//  MMGEOCollectionViewCell.h
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButtonForRemoveLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMGEOCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
//@property (weak, nonatomic) IBOutlet UIButton *removeLocationButton;
//var imageArray = [String] ()
@property (weak, nonatomic) IBOutlet CustomButtonForRemoveLocation *removeLocationButton;
@property (nonatomic,retain) NSMutableArray *locationNameArray;



@end

NS_ASSUME_NONNULL_END
