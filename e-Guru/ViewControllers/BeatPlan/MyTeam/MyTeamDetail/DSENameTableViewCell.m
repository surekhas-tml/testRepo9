//
//  DSENameTableViewCell.m
//  e-guru
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "DSENameTableViewCell.h"
#import "MMGEOCollectionViewCell.h"
#import "CustomButtonForRemoveLocation.h"
#import "UIColor+eGuruColorScheme.h"
#import "MyTeamViewModel.h"


@implementation DSENameTableViewCell

{
    MyTeamViewModel *teamViewModelObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.locationCollectionView.delegate = self;
    self.locationCollectionView.dataSource = self;
        
    teamViewModelObject = [[MyTeamViewModel alloc]init];
}

#pragma mark - CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.locationNameArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MMGEOCell";
    MMGEOCollectionViewCell * cell = [self.locationCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // return the cell
    
    //selectedDSERowId
    cell.locationNameLabel.text = [teamViewModelObject getMicroMarketName:self.locationNameArray :indexPath.row];
    
//    MMGEOLocationModel *locationObject = [ self.locationNameArray objectAtIndex:indexPath.row];
//    cell.locationNameLabel.text = locationObject.microMarketName;
    
//    NSString *locationName = [NSString stringWithFormat:@" %@",[ self.locationNameArray objectAtIndex:indexPath.row]];
//    cell.locationNameLabel.text = locationName;
    
    
    if (_isManageLocationSwitchActivated == YES)
    {
        cell.removeLocationButton.hidden = false;
    }
    else{
        cell.removeLocationButton.hidden = true;
    }
    
    NSString *selectedObjectIdInStringFormat = [NSString stringWithFormat:@"%ld%ld",(long)_selectedDSERowId, (long)indexPath.row];
    cell.removeLocationButton.tag = indexPath.row;
        NSLog(@"Selected Object id :%@",selectedObjectIdInStringFormat);
     [cell.removeLocationButton addTarget:self action:@selector(removeLocationMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeLocationButton setUserData:selectedObjectIdInStringFormat];

    if (self.locationNameArray.count == 0) {
//        self.leadingContarintConstraint.constant = 238;
    }
    else
    {
//       self.horizontalDistanceContarintOutletOfAddButton.constant = 1120;
    
    }
    
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor nonmandatoryFieldRedBorderColor] CGColor];
    
    //app
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    cell.layer.shadowRadius = 1.5f;
    cell.layer.shadowOpacity = 0.3f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    return cell;
}

#pragma mark - removeLocationMethod

- (void) removeLocationMethod:(CustomButtonForRemoveLocation *) sender {
    NSLog(@"Tag : %ld", (long)sender.tag);
     id userData = sender.userData;
    NSLog(@"USerData : %@",[userData description]);
    //use delegate to come fro table cell to My team vc and then call vm method to remove location api
    [self.delegate removeDSELocation:self.selectedDSERowId :sender.tag];
}

#pragma mark - collectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *name = [teamViewModelObject getMicroMarketName:self.locationNameArray :indexPath.row];
//    return [name sizeWithAttributes:NULL];
//    return  CGSizeMake(self.locationCollectionView.frame.size.width/2-20, self.locationCollectionView.frame.size.height);
    
    MMGEOCollectionViewCell *cell =  (MMGEOCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    CGFloat  sizeFromString   = [self getTextHeightFromString:name ViewWidth:cell.frame.size.width WithPading:10 FontName:@"Roboto-Regular" AndFontSize:14];
    
    return CGSizeMake(sizeFromString+60, self.locationCollectionView.frame.size.height);

}

#pragma mark - getTextHeightFromString

- (CGFloat)getTextHeightFromString:(NSString *)text ViewWidth:(CGFloat)width WithPading:(CGFloat)pading FontName:(NSString *)fontName AndFontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:fontName size:fontSize]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    NSLog(@"rect.size.height: %f", rect.size.height);
    return rect.size.width + pading;
}

#pragma mark - setSelected

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
