//
//  NFAChooseNFATypeViewController.h
//  e-guru
//
//  Created by admin on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTextField.h"
#import "DraftsViewController.h"
#import "EGNFA.h"
#import "NFATypeDetailsModel.h"
#import "NFAUIHelper.h"

@protocol NFAChooseNFATypeViewControllerDelegate <NSObject>

- (void)chooseNFATypeViewControllerNextButtonCliked;

@end

@interface NFAChooseNFATypeViewController : UIViewController{
    
}

@property (weak ,nonatomic) IBOutlet UILabel *nfaRequestDateLabel;
@property (weak ,nonatomic) IBOutlet UILabel *spendCategoryLabel;
@property (weak ,nonatomic) IBOutlet UILabel *categorySubTypeLabel;
@property (weak ,nonatomic) IBOutlet UILabel *spendLabel;
@property (weak ,nonatomic) IBOutlet UIView *searchResultView;
@property (weak ,nonatomic) IBOutlet DropDownTextField *chooseNFATypeTextField;
@property (weak ,nonatomic) IBOutlet UIButton *nextButton;

@property (weak ,nonatomic) id<NFAChooseNFATypeViewControllerDelegate> delegate;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (nonatomic) NFATypeDetailsModel *nfaTypeDetails;
@property (assign, nonatomic) NFAMode currentNFAMode;

@end
