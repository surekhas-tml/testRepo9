//
//  NFAChoosePositionViewController.m
//  e-guru
//
//  Created by admin on 09/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAChoosePositionViewController.h"
#import "NSString+NSStringCategory.h"
#import "NFACreationValidationHelper.h"

#define DIALOG_WIDTH    384.0f

@interface NFAChoosePositionViewController () {
    NSMutableArray *mPositionArray;
    NFAUserPositionModel *mLastValidUserPosition;
    BOOL allowedToEnableNextButton;
}

@end


@implementation NFAChoosePositionViewController

#pragma mark - UI Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allowedToEnableNextButton = true;
    [self addGestureToDropDownFields];
    [self bindDataToFieldsFromNFAModel];
    
    if (self.currentNFAMode == NFAModeUpdate) {
        [self adjustUIForNFAUpdateMode];
    }else{
        [[GoogleAnalyticsHelper sharedHelper] track_ScreenName:GA_SN_ChooseDSMPosition_NFA];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustUIForNFAUpdateMode {
    [[self.choosePositionTextField superview] setUserInteractionEnabled:false];
    [self.nextButton setEnabled:true];
}

#pragma mark - Private Method

- (DropDownTextField *)choosePositionDropDownTextField {
    if (!_choosePositionTextField.field) {
        _choosePositionTextField.field = [[Field alloc] init];
    }
    return _choosePositionTextField;
}

- (void)addGestureToDropDownFields {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownFieldTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
        [[self.choosePositionTextField superview] addGestureRecognizer:tapGesture];
}

- (void)dropDownFieldTapped:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    for (id view in [gesture.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            DropDownTextField *textField = (DropDownTextField *)view;
            if (gesture.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(textField.frame, point)) {
                if (textField == self.choosePositionTextField) {
                    
                    [self getUserPosition:textField];
                }
            }
        }
    }
}

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    NSLog(@"%ld",(long)textField.tag);
    DropDownViewController *dropDown = [[DropDownViewController alloc] initWithWidth:DIALOG_WIDTH];
    [dropDown showDropDownInController:self withData:array andModelData:modelArray forView:textField withDelegate:self];
    
}

- (void)bindDataToFields:(NFANextAuthorityModel *)nextAuthorityModel {
    
    [self.nextAuthorityLabel setText:nextAuthorityModel.nextAuthority];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", nextAuthorityModel.nextAuthorityFirstName, nextAuthorityModel.nextAuthorityLastName]];
    [self.positionLabel setText:nextAuthorityModel.nextAuthorityPosition];
    [self.emailIDLabel setText:nextAuthorityModel.nextAuthorityEmaiID];
}

- (void)bindUserPositionDataToNFAModel:(NFAUserPositionModel *)userPositionModel {
    
    if (self.nfaModel) {
        
        // Region
        self.nfaModel.region = userPositionModel.dealerRegion;
        self.nfaModel.dealerState = userPositionModel.dealerState;
        NSLog(@"Dealer State:%@", self.nfaModel.dealerState);
        
        // LOB Name
        self.nfaModel.lobName = userPositionModel.lobName;
        
        // DSM Position
        self.nfaModel.userPosition = userPositionModel.positionName;
        
        // Dealer Name
        self.nfaModel.nfaDealerAndCustomerDetails.dealerCode = userPositionModel.dealerCode;
        
        // Dealer Code
        self.nfaModel.nfaDealerAndCustomerDetails.dealerName = userPositionModel.dealerName;
        
        // Create By
        self.nfaModel.createdBy = [[AppRepo sharedRepo] getLoggedInUser].userName;
    }
}

- (void)bindNextAuthorityDataToNFAModel:(NFANextAuthorityModel *)nextAuthorityModel {
    
    if (self.nfaModel) {
        
        // First Name
        self.nfaModel.tsmFirstName = nextAuthorityModel.nextAuthorityFirstName;
        
        // Last Name
        self.nfaModel.tsmLastName = nextAuthorityModel.nextAuthorityLastName;
        
        // Position
        self.nfaModel.tsmPosition = nextAuthorityModel.nextAuthorityPosition;
        
        // Email
        self.nfaModel.tsmEmail = nextAuthorityModel.nextAuthorityEmaiID;
    }
}

- (void)resetPositionHierarchyFields {
    [self.nextAuthorityLabel setText:@""];
    [self.nameLabel setText:@""];
    [self.positionLabel setText:@""];
    [self.emailIDLabel setText:@""];
    
    self.nfaModel.tsmFirstName = @"";
    self.nfaModel.tsmLastName = @"";
    self.nfaModel.tsmPosition = @"";
    self.nfaModel.tsmEmail = @"";
}

- (void)bindDataToFieldsFromNFAModel {
    
    if (self.nfaModel) {
        
        [self.nextAuthorityLabel setText:self.nfaModel.nextAuthority];
        [self.choosePositionTextField setText:self.nfaModel.userPosition];
        [self.positionLabel setText:self.nfaModel.tsmPosition];
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.nfaModel.tsmFirstName, self.nfaModel.tsmLastName]];
        [self.emailIDLabel setText:self.nfaModel.tsmEmail];
        
        if (self.currentNFAMode == NFAModeUpdate || *(self->_invokedFromManageOpportunity)) {
            [self getUserPosition:nil];
        }
    }
}

- (NFAUserPositionModel *)findUserPositionDetailsFromListOfPosition:(NSMutableArray *)positionArray {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"positionName == %@", self.nfaModel.userPosition];
    
    NSArray *filteredArray = [positionArray filteredArrayUsingPredicate:predicate];
    
    if (filteredArray && [filteredArray count] > 0) {
        
        return [filteredArray objectAtIndex:0];
    }
    return nil;
}

- (void)setUserPositionBasedOnOpportunityLOB:(NSMutableArray *)positionArray {
    
    NSString *opportunityLOB = self.nfaModel.nfaDealDetails.lob;
    
    if (![opportunityLOB hasValue]) {
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lobName == %@", opportunityLOB];
    NSArray *filteredArray = [positionArray filteredArrayUsingPredicate:predicate];
    
    if (filteredArray && [filteredArray count] > 0) {
        NFAUserPositionModel *userPositionModel = [filteredArray objectAtIndex:0];
        
        mLastValidUserPosition = userPositionModel;
        [self.choosePositionTextField setText:userPositionModel.positionName];
        
        [self bindUserPositionDataToNFAModel:userPositionModel];
        [self getNextAuthority:userPositionModel];
    }
    else {
        
        NSString *errorMessage = [NSString stringWithFormat:@"Could not find a position for the LOB - %@. Hence cannot create NFA for the selected Opty - %@. Request you to select the correct opportunity.", self.nfaModel.nfaDealDetails.lob, self.nfaModel.nfaDealerAndCustomerDetails.oppotunityID];
        
        [UtilityMethods alert_ShowMessage:errorMessage withTitle:APP_NAME andOKAction:^{
            
        }];
    }
}

- (void)bindToField:(DropDownTextField *)textField  selectedUserPositionModel:(NFAUserPositionModel *)userPositionModel {
    
    textField.text = userPositionModel.positionName;
    textField.field.mSelectedValue = userPositionModel.positionName;
    [self bindUserPositionDataToNFAModel:userPositionModel];
    
    // Resetting previous values
    self.nfaNextAuthorityModel = nil;
    [self resetPositionHierarchyFields];
    
    // Dealy added to show loading during API call
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_FOR_API * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getNextAuthority:userPositionModel];
    });
}

- (void)notifyUserPositionChanged {
    
    // Send message to CreateOpportunityViewController to reset the screens
    // as position has been changed
    if ([self.delegate respondsToSelector:@selector(userPositionChanged)]) {
        [self.delegate userPositionChanged];
    }
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView {
    if (dropDownForView && [dropDownForView isKindOfClass:[DropDownTextField class]]) {
        DropDownTextField *textField = (DropDownTextField *)dropDownForView;

        if (*(self->_invokedFromManageOpportunity) &&
            ![((NFAUserPositionModel *)selectedObject).lobName isEqualToString:self.nfaModel.nfaDealDetails.lob]) {
            
            [self bindToField:textField selectedUserPositionModel:selectedObject];
            
            // Show error with confirmation
            NSString *confirmationMessage = [NSString stringWithFormat:@"Selected position cannot be used to create NFA for Opty ID %@. Do you want to create NFA for different Opty with the selected position?", self.nfaModel.nfaDealerAndCustomerDetails.oppotunityID];
            
            [UtilityMethods alert_showMessage:confirmationMessage withTitle:APP_NAME andOKAction:^{
                // User clicked YES
                *(self->_invokedFromManageOpportunity) = false;
                [self notifyUserPositionChanged];
                allowedToEnableNextButton = true;
                [self.nextButton setEnabled:true];
            } andNoAction:^{
                // User clicked NO
                allowedToEnableNextButton = false;
                [self.nextButton setEnabled:false];
            }];
        }
        else {
            if (mLastValidUserPosition) {
                [self notifyUserPositionChanged];
            }
            mLastValidUserPosition = selectedObject;
            allowedToEnableNextButton = true;
            [self bindToField:textField selectedUserPositionModel:selectedObject];
        }
    }
}

#pragma mark - IBActions

- (IBAction)nextButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(choosePositionViewControllerNextButtonCliked)]) {
        if ([NFACreationValidationHelper checkPositionValidityAndShowErroMessage:self.nfaModel]) {
            [self.delegate choosePositionViewControllerNextButtonCliked];
        }
    }
}

#pragma mark - API Calls

- (void)getUserPosition:(DropDownTextField *)textField {
    
    if (mPositionArray) {
        NSMutableArray *positionNameArray = [mPositionArray valueForKeyPath:@"positionName"];
        [self showPopOver:textField withDataArray:positionNameArray andModelData:mPositionArray];
    }
    else {
        
        NSDictionary *requestDict = @{@"user_login" : [[AppRepo sharedRepo] getLoggedInUser].userName};
        [[EGRKWebserviceRepository sharedRepository] getUserPosition:requestDict andSuccessAction:^(NSArray * positionArray) {
            
            mPositionArray = [positionArray mutableCopy];
            NSMutableArray *positionNameArray = [mPositionArray valueForKeyPath:@"positionName"];
            if (self.currentNFAMode == NFAModeUpdate) {
                NFAUserPositionModel *userPositionModel = [self findUserPositionDetailsFromListOfPosition:mPositionArray];
                if (userPositionModel) {
                    [self bindUserPositionDataToNFAModel:userPositionModel];
                    [self getNextAuthority:userPositionModel];
                }
                else {
                    self.nfaModel.userPosition = nil;
                    [NFACreationValidationHelper checkPositionValidityAndShowErroMessage:self.nfaModel];
                }
            }
            else if (*(self->_invokedFromManageOpportunity)) {
                [self setUserPositionBasedOnOpportunityLOB:mPositionArray];
            }
            else {
                [self showPopOver:textField withDataArray:positionNameArray andModelData:mPositionArray];
            }
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Choose_Position_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_ChoosePosition_NFA_Successful];
  
        } andFailuerAction:^(NSError *error) {
            [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Choose_Position_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_ChoosePosition_NFA_Failed];
 
        }];
    }
}

- (void)getNextAuthority:(NFAUserPositionModel *) userPositionModel {
    
    NSDictionary *requestDict = @{@"position_id" : userPositionModel.positionID};
    [[EGRKWebserviceRepository sharedRepository] getNextAuthority:requestDict andSuccessAction:^(NFANextAuthorityModel *nextAuthorityModel) {
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Choose_Position_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_GetNextAuthority_NFA_Successful];

        self.nfaNextAuthorityModel = nextAuthorityModel;
        if (allowedToEnableNextButton) {
            [self.nextButton setEnabled:true];
        }
        [self bindNextAuthorityDataToNFAModel:self.nfaNextAuthorityModel];
        [self bindDataToFields:self.nfaNextAuthorityModel];
        [NFACreationValidationHelper checkPositionValidityAndShowErroMessage:self.nfaModel];
        
    } andFailuerAction:^(NSError *error) {
        [NFACreationValidationHelper checkPositionValidityAndShowErroMessage:self.nfaModel];
        [[GoogleAnalyticsHelper sharedHelper] track_EventAction:GA_EA_Choose_Position_NFA_Button_Click withEventCategory:GA_CL_NFA withEventResponseDetails:GA_EA_GetNextAuthority_NFA_Failed];

    }];
}

@end
