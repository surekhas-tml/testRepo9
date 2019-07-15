//
//  NewNFARequestViewController.h
//  e-guru
//
//  Created by MI iMac04 on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFARequestTabsView.h"
#import "BlueUIButton.h"
#import "EGNFA.h"

@protocol NewNFARequestViewControllerDelegate <NSObject>

- (void)nfaUpdated:(EGNFA *)mNFAModel;

@end

@interface NewNFARequestViewController : UIViewController

@property (weak, nonatomic) IBOutlet NFARequestTabsView *dealerAndCustomerDetailsTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *dealDetailsTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *competitionDetailsTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *tmlProposedLandingPriceTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *dealerMarginAndRetentionTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *schemeDetailsTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *financierDetailsTab;
@property (weak, nonatomic) IBOutlet NFARequestTabsView *nfaRequestTab;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetButtonRightMargin;

@property (weak, nonatomic) IBOutlet BlueUIButton *resetButton;
@property (weak, nonatomic) IBOutlet BlueUIButton *previewButton;
@property (weak, nonatomic) IBOutlet BlueUIButton *submitButton;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (assign, nonatomic) NFAMode currentNFAMode;

@property (weak, nonatomic) id<NewNFARequestViewControllerDelegate> delegate;

@end
