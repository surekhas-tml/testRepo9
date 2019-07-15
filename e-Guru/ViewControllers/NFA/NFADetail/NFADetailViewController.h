//
//  NFADetailViewController.h
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGNFA.h"
#import "CreateNFAViewController.h"

typedef enum {
    EntryPointDetail,
    EntryPointPreview
}NFADetailEntryPoint;

@interface NFADetailViewController : UIViewController <UISplitViewControllerDelegate, CreateNFAViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *actionContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopMargin;

@property (strong, nonatomic) EGNFA *nfaModel;
@property (assign, nonatomic) NFADetailEntryPoint entryPoint;

@end
