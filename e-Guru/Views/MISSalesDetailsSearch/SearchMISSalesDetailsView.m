//
//  SearchMISSalesDetailsView.m
//  e-guru
//
//  Created by Admin on 02/05/17.
//  Copyright © 2017 TATA. All rights reserved.
//
#import "EGRKWebserviceRepository.h"
#import "SearchMISSalesDetailsView.h"
#import "UtilityMethods.h"
#import "EGLob.h"
#import "EGDse.h"
#import "MISalesDetailsViewController.h"
@interface SearchMISSalesDetailsView(){
    UITapGestureRecognizer *tapRecognizer;
    UITextField *activeField;
    AppDelegate *appDelegate;
    NSMutableArray *LOBResponseArray;
    NSMutableArray *DSEResponseArray;
    EGLob *selectedlob;
    EGLob *selectedppl;
    EGDse *selectedDse;
    NSMutableArray *DSEfullname;

}

@end

@implementation SearchMISSalesDetailsView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        
        [[NSBundle mainBundle] loadNibNamed:@"SearchMISSalesDetailsView" owner:self options:nil];
        [self.view setFrame:frame];
        [self addSubview:self.view];
        [self addGestureRecogniserToView];
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.searchButton setEnabled:TRUE];
    [self.searchButton setBackgroundColor:[UIColor navBarColor]];
    self.searchButton.layer.cornerRadius = 5.0f;
    self.clearButton.layer.cornerRadius = 5.0f;
    
    self.layer.borderWidth = 1.0f;
    self.closeButton.layer.cornerRadius = 10.0f;
}

#pragma mark - gesture methods

-(void)addGestureRecogniserToView{
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] && ![touch.view isEqual:activeField]) {
        return YES;
    }
    else if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.view]) {
        return YES;
    }
    return NO;
}

-(void)gestureHandlerMethod:(id)sender{
    [activeField resignFirstResponder];
}

# pragma mark - Text field

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    
    if (textField == self.pplTextfield){
        if([self.lobTextfield.text isEqual:@""])
        {
            [textField resignFirstResponder];
            
            [UtilityMethods alert_ShowMessage:@"Please Select LOB" withTitle:APP_NAME andOKAction:nil];
        }else{
            [self APIpplForTextField:textField];
        }
    }else if (textField == self.lobTextfield){
//        selectedlob = nil;
        [self APILobForTextField:textField];
        self.pplTextfield.text=@"";
    }
    
    else if (textField == self.dseNameTextfield){
       // [self APIDSEForTextField:textField];
    }else if (textField == self.customerNameTextfield){
        
    }else if (textField == self.financerNameTextfield){
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (textField == self.lobTextfield || textField == self.pplTextfield ) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField{
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    if(textField == self.pplTextfield && textField == self.lobTextfield ){
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    return YES; // We do not want UITextField to insert line
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [activeField resignFirstResponder];
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Events Handling -

- (IBAction)searchButtonTapped:(id)sender {
    
    self.Customername=self.customerNameTextfield.text;
    self.financiername=self.financerNameTextfield.text;
    self.lob=self.lobTextfield.text;
    self.ppl=self.pplTextfield.text;
    self.dseName=self.dseNameTextfield.text;
    [self.delegate searchMISForQuery];
    [self closeDrawer];

}

- (IBAction)clearButtonTapped:(id)sender {
    self.customerNameTextfield.text=@"";
    self.lobTextfield.text=@"";
    self.pplTextfield.text=@"";
    self.financerNameTextfield.text=@"";
    self.dseNameTextfield.text=@"";
    [self.delegate MISfieldsCleared];
    [self closeDrawer];

}

- (IBAction)closeButtonTapped:(id)sender {
    
    [self closeDrawer];
}

-(void)closeDrawer
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromLeft;
    animation.duration = 0.2;
    [self.layer addAnimation:animation forKey:nil];
    [UIView transitionWithView:self
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self setHidden:!self.hidden];
                    }
                    completion:^(BOOL finished) {
                    }];

}
#pragma mark - API Calls -

-(void)APILobForTextField:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository] getListOfLOBsandSuccessAction:^(NSArray *responseArray)
     {
         if (responseArray && [responseArray count] > 0)
         {
             LOBResponseArray = [NSMutableArray arrayWithArray:responseArray];
         }
         [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[responseArray valueForKey:@"lobName"]] andModelData:LOBResponseArray];
     } andFailuerAction:^(NSError *error) {
     }];
}

-(void)APIpplForTextField:(UITextField *)textField{
    
    NSDictionary *requestDict = @{@"lob_name": selectedlob.lobName ? : @""};
    [[EGRKWebserviceRepository sharedRepository] getListOfPPL:requestDict andSuccessAction:^(NSArray *responseArray) {
        [self showPopOver:textField withDataArray:[NSMutableArray arrayWithArray:[responseArray valueForKey:@"pplName"]] andModelData:[NSMutableArray arrayWithArray:responseArray]];
    } andFailuerAction:^(NSError *error) {
    }];
}

-(void)APIDSEForTextField:(UITextField *)textField{
    [[EGRKWebserviceRepository sharedRepository] getListOfDSEs:^(NSArray *responseArray)
     {
         DSEfullname=[[NSMutableArray alloc]init];
         if (responseArray && [responseArray count] > 0)
             DSEResponseArray = [NSMutableArray arrayWithArray:responseArray];
         
         
         for (EGDse *dse in responseArray) {
             NSString *fullname = [[dse.FirstName stringByAppendingString:@"  "]stringByAppendingString:dse.LastName];
             [DSEfullname addObject:fullname];
         }
         
         if ([responseArray count]> 0) {
             [self showPopOver:textField
                 withDataArray:[NSMutableArray arrayWithArray:DSEfullname]
                  andModelData:[NSMutableArray arrayWithArray:DSEResponseArray]];
         }else{
             [UtilityMethods alert_ShowMessage:NoDataFoundError withTitle:APP_NAME andOKAction:nil];
         }
         
     } andFailuerAction:^(NSError *error) {
     }];
}

#pragma mark - DropDownViewControllerDelegate Method

- (void)showPopOver:(UITextField *)textField withDataArray:(NSMutableArray *)array andModelData:(NSMutableArray *)modelArray {
    [self.view endEditing:true];
    
    // Below check added to prevent blank dropdowns
    // from showing
    if (!array || [array count] < 1) {
        return;
    }
    
    DropDownViewController *dropDown;
  
    dropDown = [[DropDownViewController alloc] init];
    [dropDown showDropDownInController:[[appDelegate.navigationController viewControllers] lastObject] withData:array andModelData:modelArray forView:textField withDelegate:self];
}

- (void)didSelectValueFromDropDown:(NSString *)selectedValue selectedObject:(id)selectedObject forField:(id)dropDownForView;
{
    activeField.text = selectedValue;
    if([dropDownForView isEqual:self.lobTextfield]){
        selectedlob = selectedObject;
        self.lobTextfield.text = selectedValue;
    }else  if([dropDownForView isEqual:self.pplTextfield]){
        selectedppl = selectedObject;
        self.pplTextfield.text = selectedValue;
    }
    else if([dropDownForView isEqual:self.dseNameTextfield]){
        selectedDse = selectedObject;
    }
}


@end
