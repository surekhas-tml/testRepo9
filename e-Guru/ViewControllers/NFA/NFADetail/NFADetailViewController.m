//
//  NFADetailViewController.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFADetailViewController.h"
#import "UtilityMethods.h"
#import "PureLayout.h"
#import "NFAUIHelper.h"

#define SECTION_LEFT_RIGHT_MARGIN 10.0
#define SECTION_TOP_MARGIN 10.0

@interface NFADetailViewController () {
    UIView *containerView;
}

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation NFADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_NFA_Details];

    if (self.entryPoint == EntryPointPreview) {
        self.containerTopMargin.constant = 0;
        _updateButton.hidden = YES;
        
    }
    else {
        self.containerTopMargin.constant = 46;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UtilityMethods navigationBarSetupForController:self];
    
    AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if(appdelegate.shouldRefreshNFASummaryView){
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)updateViewConstraints {
    
    if (!self.didSetupConstraints) {
        [self renderNFASections];
        self.didSetupConstraints = true;
    }
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)updateButtonTapped:(id)sender {
    [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Update_NFADetails_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:nil];

    CreateNFAViewController *createNFA = [[UIStoryboard storyboardWithName:@"NFA" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNFA_View"];
    createNFA.entryPoint = NFAModeUpdate;
    createNFA.nfaModel = self.nfaModel;
    createNFA.delegate = self;
    [self.navigationController pushViewController:createNFA animated:YES];
}


#pragma mark - Private Methods

- (void)renderNFASections {
    
    NSMutableArray *sectionsArray = [NFAUIHelper getNFASectionsWithData:self.nfaModel forNFARequestType:NFATypeAdditonalSupport forMode:NFAModeDisplay];
    if (!sectionsArray || [sectionsArray count] == 0) {
        return;
    }
    
    containerView = [[UIView alloc] initForAutoLayout];
    [self.containerScrollView addSubview:containerView];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [containerView autoSetDimension:ALDimensionWidth toSize:self.view.frame.size.width];
    
    [self.containerScrollView addSubview:[sectionsArray firstObject]];
    [[sectionsArray firstObject] autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, SECTION_LEFT_RIGHT_MARGIN, 0, SECTION_LEFT_RIGHT_MARGIN) excludingEdge:ALEdgeBottom];
    UIView *previousView = nil;
    for (UIView *view in sectionsArray) {
        if (previousView) {
            [self.containerScrollView addSubview:view];
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:SECTION_TOP_MARGIN];
            [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SECTION_LEFT_RIGHT_MARGIN];
            [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SECTION_LEFT_RIGHT_MARGIN];
        }
        previousView = view;
    }
    [[sectionsArray lastObject] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:SECTION_TOP_MARGIN];
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController*)svc shouldHideViewController:(UIViewController*)vc inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

#pragma mark - CreateNFAViewControllerDelegate Methods

- (void)nfaUpdated:(EGNFA *)mNFAModel {
    self.nfaModel = mNFAModel;
    if ([containerView isDescendantOfView:self.containerScrollView]) {
        [containerView removeFromSuperview];
        containerView = nil;
    }
    [self renderNFASections];
}

@end
