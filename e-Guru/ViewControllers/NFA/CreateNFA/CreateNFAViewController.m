//
//  CreateNFAViewController.m
//  e-guru
//
//  Created by MI iMac04 on 08/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "CreateNFAViewController.h"
#import "UtilityMethods.h"

@interface CreateNFAViewController () <NFAChoosePositionViewControllerDelegate, NFAChooseNFATypeViewControllerDelegate, NFASearchOptyViewControllerDelegate>

@end

@implementation CreateNFAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.entryPoint != NFAModeUpdate) {
        self.nfaModel = [[EGNFA alloc] init];
    }

    // Create NFA from Manage Opportunity
    if (self.invokedFromManageOpportunity && self.opportunity) {
        self.nfaModel.nfaDealDetails.lob = self.opportunity.toVCNumber.lob;
        self.nfaModel.nfaDealerAndCustomerDetails.oppotunityID = self.opportunity.optyID;
    }
    if (self.entryPoint == NFAModeUpdate) {
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:@""];

    }
    else {
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:@""];
    }
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.entryPoint == NFAModeUpdate) {
        self.title = @"Update NFA";
    }
    else {
        self.title = @"Create NFA";
    }
    
    [UtilityMethods navigationBarSetupForController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Initialization

- (void)initUI {
    [self bindClickToSteps];
    [self loadFirstChoosePositionScreen];
    
//    if (self.entryPoint == NFAModeUpdate) {
//        [self gotoChooseNFATypeStep:nil];
//        [self gotoSearchOptyStep:nil];
//    }
}

#pragma mark - UIActions

- (void)gotoChoosePositionStep:(UIButton *)sender {
    
    // Set Colors to indicate step
    [self.choosePositionStep setCurrentStep:true];
    [self.choosePositionBullet setBackgroundColor:[UIColor themePrimaryColor]];
    
    // Load ViewController
    if (![self.nfaChoosePositionViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        self.nfaChoosePositionViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAChoosePositionViewController"];
        self.nfaChoosePositionViewController.delegate = self;
        self.nfaChoosePositionViewController.nfaModel = self.nfaModel;
        self.nfaChoosePositionViewController.opportunity = self.opportunity;
        self.nfaChoosePositionViewController.currentNFAMode = self.entryPoint;
        self.nfaChoosePositionViewController.invokedFromManageOpportunity = &(self->_invokedFromManageOpportunity);
        [self addChildViewController:self.nfaChoosePositionViewController];
        [self.containerView addSubview:self.nfaChoosePositionViewController.view];
        [self.nfaChoosePositionViewController.view setFrame:self.containerView.bounds];
        [self.nfaChoosePositionViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.nfaChoosePositionViewController.view];
    }
}

- (void)gotoChooseNFATypeStep:(UIButton *)sender {
    
    // If screen is not current step and it is still loaded
    // then remove the screen from parent view controller and reload it
    if (!self.chooseNFATypeStep.isCurrentStep && [self.nfaChooseNFATypeViewController parentViewController]) {
        [self.nfaChooseNFATypeViewController willMoveToParentViewController:nil];
        [self.nfaChooseNFATypeViewController.view removeFromSuperview];
        [self.nfaChooseNFATypeViewController removeFromParentViewController];
    }
    
    // Set Colors to indicate step
    [self.chooseNFATypeStep setCurrentStep:true];
    [self.chooseNFATypeBullet setBackgroundColor:[UIColor themePrimaryColor]];
    [self.choosePositionCompletionIndicator setBackgroundColor:[UIColor themePrimaryColor]];
    
    // Load ViewController
    if (![self.nfaChooseNFATypeViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        self.nfaChooseNFATypeViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAChooseNFATypeViewController"];
        self.nfaChooseNFATypeViewController.delegate = self;
        self.nfaChooseNFATypeViewController.nfaModel = self.nfaModel;
        self.nfaChooseNFATypeViewController.currentNFAMode = self.entryPoint;
        [self addChildViewController:self.nfaChooseNFATypeViewController];
        [self.containerView addSubview:self.nfaChooseNFATypeViewController.view];
        [self.nfaChooseNFATypeViewController.view setFrame:self.containerView.bounds];
        [self.nfaChooseNFATypeViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.nfaChooseNFATypeViewController.view];
    }
}

- (void)gotoSearchOptyStep:(UIButton *)sender {
    
    // If screen is not current step and it is still loaded
    // then remove the screen from parent view controller and reload it
    if (!self.searchOptyStep.isCurrentStep && [self.nfaSearchOptyViewController parentViewController]) {
        [self.nfaSearchOptyViewController willMoveToParentViewController:nil];
        [self.nfaSearchOptyViewController.view removeFromSuperview];
        [self.nfaSearchOptyViewController removeFromParentViewController];
    }
    
    // Set Colors to indicate step
    [self.searchOptyStep setCurrentStep:true];
    [self.searchOptyBullet setBackgroundColor:[UIColor themePrimaryColor]];
    [self.chooseNFACompletionIndicator setBackgroundColor:[UIColor themePrimaryColor]];
    
    // Load ViewController
    if (![self.nfaSearchOptyViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        self.nfaSearchOptyViewController = [storyboard instantiateViewControllerWithIdentifier:@"NFASearchOptyViewController"];
        self.nfaSearchOptyViewController.delegate = self;
        self.nfaSearchOptyViewController.nfaModel = self.nfaModel;
        self.nfaSearchOptyViewController.opportunity = self.opportunity;
        self.nfaSearchOptyViewController.currentNFAMode = self.entryPoint;
        self.nfaSearchOptyViewController.invokedFromManageOpportunity = &(self->_invokedFromManageOpportunity);
        [self addChildViewController:self.nfaSearchOptyViewController];
        [self.containerView addSubview:self.nfaSearchOptyViewController.view];
        [self.nfaSearchOptyViewController.view setFrame:self.containerView.bounds];
        [self.nfaSearchOptyViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.nfaSearchOptyViewController.view];
    }
}

- (void)gotoNewNFARequestStep:(UIButton *)sender {
    
    // If screen is not current step and it is still loaded
    // then remove the screen from parent view controller and reload it
    if (!self.nfaRequestStep.isCurrentStep && [self.nfaRequestViewController parentViewController]) {
        [self.nfaRequestViewController willMoveToParentViewController:nil];
        [self.nfaRequestViewController.view removeFromSuperview];
        [self.nfaRequestViewController removeFromParentViewController];
    }
    
    // Set Colors to indicate step
    [self.nfaRequestStep setCurrentStep:true];
    [self.nfaRequestBullet setBackgroundColor:[UIColor themePrimaryColor]];
    [self.searchOptyCompletionIndicator setBackgroundColor:[UIColor themePrimaryColor]];
    
    // Load ViewController
    if (![self.nfaRequestViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        self.nfaRequestViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewNFARequestViewController"];
        self.nfaRequestViewController.nfaModel = self.nfaModel;
        self.nfaRequestViewController.currentNFAMode = self.entryPoint;
        self.nfaRequestViewController.delegate = self;
        [self addChildViewController:self.nfaRequestViewController];
        [self.containerView addSubview:self.nfaRequestViewController.view];
        [self.nfaRequestViewController.view setFrame:self.containerView.bounds];
        [self.nfaRequestViewController didMoveToParentViewController:self];
    }
    else {
        [self.containerView bringSubviewToFront:self.nfaRequestViewController.view];
    }
}

#pragma mark - Private Method

- (void)loadFirstChoosePositionScreen {
    [self gotoChoosePositionStep:nil];
}

- (void)bindClickToSteps {
    
    [self.choosePositionStep.button addTarget:self
                                       action:@selector(gotoChoosePositionStep:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    [self.chooseNFATypeStep.button addTarget:self
                                      action:@selector(gotoChooseNFATypeStep:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.searchOptyStep.button addTarget:self
                                   action:@selector(gotoSearchOptyStep:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.nfaRequestStep.button addTarget:self
                                   action:@selector(gotoNewNFARequestStep:)
                         forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadNFARequestStep {
    
    // Set Colors to indicate step
    [self.nfaRequestStep setCurrentStep:true];
    [self.nfaRequestBullet setBackgroundColor:[UIColor themePrimaryColor]];
    [self.searchOptyCompletionIndicator setBackgroundColor:[UIColor themePrimaryColor]];
    
    if ([self.nfaRequestViewController parentViewController]) {
        [self.nfaRequestViewController willMoveToParentViewController:nil];
        [self.nfaRequestViewController.view removeFromSuperview];
        [self.nfaRequestViewController removeFromParentViewController];
    }
    
    // Load ViewController
    if (![self.nfaRequestViewController parentViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NFA" bundle:[NSBundle mainBundle]];
        self.nfaRequestViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewNFARequestViewController"];
        self.nfaRequestViewController.nfaModel = self.nfaModel;
        self.nfaRequestViewController.currentNFAMode = self.entryPoint;
        self.nfaRequestViewController.delegate = self;
        [self addChildViewController:self.nfaRequestViewController];
        [self.containerView addSubview:self.nfaRequestViewController.view];
        [self.nfaRequestViewController.view setFrame:self.containerView.bounds];
        [self.nfaRequestViewController didMoveToParentViewController:self];
    }
}

- (void)resetScreenAsPositionChanged {
    
    [self.chooseNFATypeStep setCurrentStep:false];
    [self.chooseNFATypeBullet setBackgroundColor:[UIColor themeDisabledColor]];
    [self.choosePositionCompletionIndicator setBackgroundColor:[UIColor themeDisabledColor]];
    
    [self.searchOptyStep setCurrentStep:false];
    [self.searchOptyBullet setBackgroundColor:[UIColor themeDisabledColor]];
    [self.chooseNFACompletionIndicator setBackgroundColor:[UIColor themeDisabledColor]];
    
    [self.nfaRequestStep setCurrentStep:false];
    [self.nfaRequestBullet setBackgroundColor:[UIColor themeDisabledColor]];
    [self.searchOptyCompletionIndicator setBackgroundColor:[UIColor themeDisabledColor]];
}

#pragma mark - NFAChoosePositionViewControllerDelegate Methods

- (void)choosePositionViewControllerNextButtonCliked {
    [self gotoChooseNFATypeStep:nil];
}

- (void)userPositionChanged {
    [self resetScreenAsPositionChanged];
}

#pragma mark - NFAChooseNFATypeViewControllerDelegate Methods

- (void)chooseNFATypeViewControllerNextButtonCliked {
    [self gotoSearchOptyStep:nil];
}

#pragma mark - NFASearchOptyViewControllerDelegate

- (void)opportunitySelected {
    [self loadNFARequestStep];
}

#pragma mark - NFARequestViewControllerDelegate Methods

- (void)nfaUpdated:(EGNFA *)mNFAModel {
    
    if ([self.delegate respondsToSelector:@selector(nfaUpdated:)]) {
        [self.delegate nfaUpdated:mNFAModel];
    }
}

@end
