//
//  ManageOpportunityCollectionViewCell.h
//  e-Guru
//
//  Created by Juili on 02/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ManageOpportunityCollectionViewCellDelegate <NSObject>
@optional
-(void)deleteCellAtIndex:(long)index;
@end
@interface ManageOpportunityCollectionViewCell : UICollectionViewCell

@property (weak ,nonatomic) id<ManageOpportunityCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *quantityView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *optyCreationDate;
@property (weak, nonatomic) IBOutlet UILabel *salesStage;
@property (weak, nonatomic) IBOutlet UILabel *selectnextactionlbl;
@property (weak, nonatomic) IBOutlet UITextField *nextActivityDropdown;
@property (weak, nonatomic) IBOutlet UILabel *lastPendingActivity;
@property (weak, nonatomic) IBOutlet UILabel *dseName;
@property (weak, nonatomic) IBOutlet UILabel *dseNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *nfaStatus;
@property (weak, nonatomic) IBOutlet UILabel *nfaStatusTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dseNameViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *dseNameView;
@property (weak, nonatomic) IBOutlet UIView *colorStripeView;
@property (weak, nonatomic) IBOutlet UILabel *optyId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manageOptyViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manageOptySubViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseLableTopSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DSELabelTopSpacingConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OptyIdTopSpacingConstraints;

@end
