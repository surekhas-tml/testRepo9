//
//  CreateNFAViewController.h
//  e-guru
//
//  Created by MI iMac04 on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAStepView.h"
#import "NewNFARequestViewController.h"
#import "NFAChoosePositionViewController.h"
#import "NFAChooseNFATypeViewController.h"
#import "NFASearchOptyViewController.h"
#import "EGNFA.h"

@protocol CreateNFAViewControllerDelegate <NSObject>

- (void)nfaUpdated:(EGNFA *)mNFAModel;

@end

@interface CreateNFAViewController : UIViewController <NewNFARequestViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NFAStepView *choosePositionStep;
@property (weak, nonatomic) IBOutlet CircularView *choosePositionBullet;
@property (weak, nonatomic) IBOutlet UIView *choosePositionCompletionIndicator;
@property (weak, nonatomic) IBOutlet NFAStepView *chooseNFATypeStep;
@property (weak, nonatomic) IBOutlet CircularView *chooseNFATypeBullet;
@property (weak, nonatomic) IBOutlet UIView *chooseNFACompletionIndicator;
@property (weak, nonatomic) IBOutlet NFAStepView *searchOptyStep;
@property (weak, nonatomic) IBOutlet CircularView *searchOptyBullet;
@property (weak, nonatomic) IBOutlet UIView *searchOptyCompletionIndicator;
@property (weak, nonatomic) IBOutlet NFAStepView *nfaRequestStep;
@property (weak, nonatomic) IBOutlet CircularView *nfaRequestBullet;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NewNFARequestViewController * nfaRequestViewController;
@property (strong, nonatomic) NFAChoosePositionViewController * nfaChoosePositionViewController;
@property (strong, nonatomic) NFAChooseNFATypeViewController * nfaChooseNFATypeViewController;
@property (strong, nonatomic) NFASearchOptyViewController * nfaSearchOptyViewController;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (strong, nonatomic) EGOpportunity *opportunity;
@property (assign, nonatomic) NFAMode entryPoint;
@property (assign, nonatomic) BOOL invokedFromManageOpportunity;

@property (weak, nonatomic) id<CreateNFAViewControllerDelegate> delegate;

@end
