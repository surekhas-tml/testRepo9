//
//  DropDownViewController.h
//  e-Guru
//
//  Created by MI iMac04 on 28/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownViewControllerDelegate <NSObject>

@optional
- (void)didSelectValueFromDropDown:(NSString *)selectedValue forField:(id)dropDownForView;
- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;

@end

@interface DropDownViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingHeightConstraint;

@property (nonatomic, strong) id dropDownForView;
@property(nonatomic,assign) BOOL fromPotentialDropOff;
@property (nonatomic, weak) id<DropDownViewControllerDelegate> delegate;

- (instancetype)initWithWidth:(NSInteger)width;
- (void)showDropDownInController:(id)viewController withData:(NSMutableArray *)contentArray andModelData:(NSMutableArray *)modelDataArray forView:(UIView *)forView withDelegate:(id)delegate;
- (void)showDropDownInControllerForBeatPlan:(id)viewController withData:(NSMutableArray *)contentArray andModelData:(NSMutableArray *)modelDataArray forView:(UIView *)forView withDelegate:(id)delegate ;
@end
