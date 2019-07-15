//
//  LinkCampaignView.h
//  e-Guru
//
//  Created by Juili on 01/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGCampaign.h"
@protocol LinkCampaignViewDelegate
-(void)cancelOperation;
-(void)linkCampaignOperationWithCampaign:(EGCampaign *)campaign;

@end
@interface LinkCampaignView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) EGCampaign *selectedCampaign;
@property (strong, nonatomic) EGOpportunity *opportunity;

@property (strong, nonatomic) NSArray *pickerArray;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) id<LinkCampaignViewDelegate>delegate;


- (IBAction)linkCampaign:(id)sender;
- (IBAction)cancelCampaignLinkage:(id)sender;

@end
