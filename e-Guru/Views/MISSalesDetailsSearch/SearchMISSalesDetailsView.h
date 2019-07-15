//
//  SearchMISSalesDetailsView.h
//  e-guru
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewController.h"


@protocol MISDetailsViewDelegate
-(void)searchMISForQuery;
-(void)closedMISSearchDrawer;
-(void)MISfieldsCleared;
@end

@interface SearchMISSalesDetailsView : UIView<UIGestureRecognizerDelegate,DropDownViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id<MISDetailsViewDelegate> delegate;
@property (strong, nonatomic) NSString *lob;
@property (strong, nonatomic) NSString *Customername;
@property (strong, nonatomic) NSString *financiername;
@property (strong, nonatomic) NSString *ppl;
@property (strong, nonatomic) NSString *dseName;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UITextField *dseNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *customerNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *lobTextfield;
@property (strong, nonatomic) IBOutlet UITextField *pplTextfield;
@property (strong, nonatomic) IBOutlet UITextField *financerNameTextfield;
- (IBAction)searchButtonTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
-(void)closeDrawer;
@end
