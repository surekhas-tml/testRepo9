//
//  ChooseLOBViewController.m
//  e-Guru
//
//  Created by MI iMac04 on 17/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ChooseLOBViewController.h"
#import "LOBCollectionViewCell.h"

#define GRID_SPACING        0.0
#define GRID_COLUMN_COUNT   5
#define LOB_COUNT           13

@interface ChooseLOBViewController ()

@end

@implementation ChooseLOBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return LOB_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LOBCollectionViewCell *cell = (LOBCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"lobCell" forIndexPath:indexPath];
    cell.currentIndex = indexPath.row;
    cell.totalColumnCount = GRID_COLUMN_COUNT;
    cell.totalCellCount = LOB_COUNT;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthAvailable = self.lobCollectionView.frame.size.width - ( (GRID_COLUMN_COUNT + 1) * GRID_SPACING );
    CGFloat widthPerItem = widthAvailable / GRID_COLUMN_COUNT;
    return CGSizeMake(widthPerItem, widthPerItem);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(GRID_SPACING, GRID_SPACING, GRID_SPACING, GRID_SPACING);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GRID_SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GRID_SPACING;
}

@end
