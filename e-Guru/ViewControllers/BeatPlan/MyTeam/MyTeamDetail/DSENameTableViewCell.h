//
//  DSENameTableViewCell.h
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGEOLocationModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ManageDSELocationOfMyTeamDelegate <NSObject>
-(void)removeDSELocation:(NSInteger)tag :(NSInteger)locationTag;
@end

@interface DSENameTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<ManageDSELocationOfMyTeamDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *dseNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *locationCollectionView;
@property (nonatomic,retain) NSMutableArray *locationNameArray;
@property BOOL isManageLocationSwitchActivated;
@property NSInteger selectedDSERowId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationCollectionTailingSpaceOutlet;
@property (weak, nonatomic) IBOutlet UIButton *addNewLocationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraintOfBtn;


@end

@interface MyButton : UIButton
@end

NS_ASSUME_NONNULL_END

