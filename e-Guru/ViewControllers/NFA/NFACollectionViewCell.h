//
//  NFACollectionViewCell.h
//  e-guru
//
//  Created by Juili on 27/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NFACollectionViewCellDelegate
//-(void)updateNFAForTag:(UIButton *)sender;
@end
@interface NFACollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIButton *quantity;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *nfaNumber;
@property (weak, nonatomic) IBOutlet UILabel *nfaAmount;
@property (weak, nonatomic) IBOutlet UILabel *nfaStatus;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *opportunityID;
@property (weak, nonatomic) IBOutlet UIButton *updateActionButton;
- (IBAction)updateNFAAction:(id)sender;
@property (weak, nonatomic) id<NFACollectionViewCellDelegate> delegate;


@end
