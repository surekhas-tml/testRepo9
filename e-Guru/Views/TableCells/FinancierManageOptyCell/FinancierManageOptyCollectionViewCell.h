//
//  FinancierManageOptyCollectionViewCell.h
//  e-guru
//
//  Created by Shashi on 28/09/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinancierManageOpptyCollectionViewCellDelegate <NSObject>
@optional
-(void)deleteCellIndex:(long)index;
@end

@interface FinancierManageOptyCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *optyID;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNo;
@property (weak, nonatomic) IBOutlet UILabel *optyCreationDate;

@property (weak ,nonatomic) id<FinancierManageOpptyCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *salesStage;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dseNameViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *colorStripeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manageOptyViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manageOptySubViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseLableTopSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DSELabelTopSpacingConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OptyIdTopSpacingConstraints;
@property (weak, nonatomic) IBOutlet UILabel *salesStageKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesStageValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *financierNameKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *financierNameValueLabel;

@end
