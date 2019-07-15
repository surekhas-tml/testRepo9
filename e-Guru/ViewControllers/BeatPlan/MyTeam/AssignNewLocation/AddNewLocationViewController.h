//
//  AddNewLocationViewController.h
//  e-guru
//
//  Created by Apple on 21/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"
#import "DropDownTextField.h"
#import "AutoCompleteUITextField.h"
#import "EGState.h"
#import "DSEModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol addLOcationDelegate <NSObject>
-(void)updateLocationListCallBack :(MMGEOLocationModel*)loactionObject;
@end

@interface AddNewLocationViewController : UIViewController<UITextFieldDelegate,DropDownViewControllerDelegate,AutoCompleteUITextFieldDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<addLOcationDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)backButtonMethod:(id)sender;
- (IBAction)addNewLocationMethod:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLAbel;

@property (weak, nonatomic) IBOutlet DropDownTextField *stateTextField;

@property (weak, nonatomic) IBOutlet DropDownTextField *lobDropDownTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *microMarketTextField;
@property (weak, nonatomic) IBOutlet DropDownTextField *districtDropDownTextField;

//@property (weak, nonatomic) IBOutlet DropDownTextField *districtDropDownTextField;
@property (weak,nonatomic) IBOutlet DropDownTextField * city_TextField;

@property (strong,nonatomic)  EGState *state;

@property (weak,nonatomic) IBOutlet UIScrollView * pageScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,retain) DSEModel *dsedata;

-(void)getMMGEOList:(NSString*)state :(NSString*)district :(NSString*)city :(NSString*)lob;

@end

NS_ASSUME_NONNULL_END
