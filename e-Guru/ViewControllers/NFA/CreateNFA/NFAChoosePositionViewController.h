//
//  NFAChoosePositionViewController.h
//  e-guru
//
//  Created by admin on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTextField.h"
#import "DraftsViewController.h"
#import "EGNFA.h"
#import "NFANextAuthorityModel.h"
#import "NFAUIHelper.h"

@protocol NFAChoosePositionViewControllerDelegate <NSObject>

- (void)choosePositionViewControllerNextButtonCliked;
- (void)userPositionChanged;

@end

@interface NFAChoosePositionViewController : UIViewController{
    
}

@property (weak ,nonatomic) IBOutlet UILabel *nextAuthorityLabel;
@property (weak ,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak ,nonatomic) IBOutlet UILabel *positionLabel;
@property (weak ,nonatomic) IBOutlet UILabel *emailIDLabel;
@property (weak ,nonatomic) IBOutlet UIView *searchResultView;
@property (weak ,nonatomic) IBOutlet DropDownTextField *choosePositionTextField;
@property (weak ,nonatomic) IBOutlet UIButton *nextButton;

@property (weak ,nonatomic) id<NFAChoosePositionViewControllerDelegate> delegate;

@property (strong, nonatomic) EGOpportunity *opportunity;
@property (strong, nonatomic) EGNFA *nfaModel;
@property (nonatomic) NFANextAuthorityModel *nfaNextAuthorityModel;
@property (assign, nonatomic) NFAMode currentNFAMode;
@property (assign, nonatomic) BOOL *invokedFromManageOpportunity;

@end
