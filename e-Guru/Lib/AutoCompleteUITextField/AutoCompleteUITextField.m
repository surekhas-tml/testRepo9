//
//  AutoCompleteUITextField.m
//  e-Guru
//
//  Created by MI iMac01 on 16/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "AutoCompleteUITextField.h"
#import "UtilityMethods.h"

#define PADDING_X 8.0
#define PADDING_Y 0.0

@implementation AutoCompleteUITextField


- (instancetype)init {
    self = [super init];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (void)customizeAppearance {
    
    [self setLayerAndBorderProperties];
    [self setFontToTextField];
    self.resultTableView = [[UITableView alloc] init];
}

- (void)setLayerAndBorderProperties {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:201/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 0;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;

}

- (void)setFontToTextField {
//    [self setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
}

    //used for mmgeography ad financier  at additional Details
-(void)loadTableViewForTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray {
    [self loadTableViewForTextFiled:frame onView:view withArray:dropdownArray atTop:false];
}

-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray {
    [self loadTableViewForTalukaTextFiled:frame onView:view withArray:dropdownArray atTop:false isFromBeatPlan:false];
}

-(void)loadTableViewForTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop {
    isTalukaActive = NO;

    self.dropdownArray = [dropdownArray copy];
    self.resultArray = [dropdownArray copy];
    if (showAtTop) {
        self.resultTableView.frame = CGRectMake(frame.origin.x,frame.origin.y - 150 ,frame.size.width, 150);
    } else {
        self.resultTableView.frame = CGRectMake(frame.origin.x,frame.origin.y + frame.size.height ,frame.size.width, 150);
    }
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.resultTableView.layer.borderWidth = 1.0;
    [self.resultTableView reloadData];
    [view addSubview:self.resultTableView];
}

//<<<<<<< HEAD
-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop isFromBeatPlan:(BOOL)isFromBeatPlan {
    
    CGFloat height;
//=======
//
////For taluka from contect Details/Account Details updated
//-(void)loadTableViewForTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop {
//>>>>>>> V3.2.5_B31
    isTalukaActive = YES;

    self.dropdownArray = [dropdownArray copy];
    self.resultArray = [dropdownArray copy];
    
    if (isFromBeatPlan) { height = 165;}  else{ height = 175;}

    if (showAtTop) {
//<<<<<<< HEAD
//        self.resultTableView.frame = CGRectMake(frame.origin.x-1,frame.origin.y+55 ,frame.size.width, height);//175
//========
        self.resultTableView.frame = CGRectMake(frame.origin.x-1,frame.origin.y + 70 ,frame.size.width, 175);

    } else {
        self.resultTableView.frame = CGRectMake(frame.origin.x,frame.origin.y + frame.size.height ,frame.size.width, height);//175
    }
    
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.resultTableView.layer.borderWidth = 1.0;
    [self.resultTableView reloadData];
    [view addSubview:self.resultTableView];
}

//Financier taluka textfields
-(void)loadTableViewForFinancierTalukaTextFiled:(CGRect)frame onView:(UIView*)view withArray:(NSArray *)dropdownArray atTop:(BOOL) showAtTop {
    isTalukaActive = YES;
    
    self.dropdownArray = [dropdownArray copy];
    self.resultArray = [dropdownArray copy];
    if (showAtTop) {
        self.resultTableView.frame = CGRectMake(frame.origin.x-1,frame.origin.y -150,frame.size.width, 150);
    } else {
        self.resultTableView.frame = CGRectMake(frame.origin.x,frame.origin.y + frame.size.height ,frame.size.width, 175);
    }
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.resultTableView.layer.borderWidth = 1.0;
    [self.resultTableView reloadData];
    [view addSubview:self.resultTableView];
}

-(void)reloadDropdownList_ForTalukaString:(NSString *)string{
    
    if (![string isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",string];
        self.resultArray = [self.dropdownArray filteredArrayUsingPredicate:predicate];
    }
    else{
        self.resultArray = self.dropdownArray;
    }
    
    NSLog(@"data %lu", (unsigned long)self.resultArray.count);
    if (self.resultArray.count ==0) {
        
        [self hideDropDownFromView];
        [UtilityMethods showToastWithMessage:@"No result found"];
    }
    else{
        [self showDropDownFromView];
      [self.resultTableView reloadData];
    }
  
    [self.resultTableView reloadData];

}

-(void)reloadDropdownList_ForString:(NSString *)string{

    if (![string isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",string];
        self.resultArray = [self.dropdownArray filteredArrayUsingPredicate:predicate];
    }
    else{
        self.resultArray = self.dropdownArray;
    }

     [self showDropDownFromView];
    [self.resultTableView reloadData];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}
    
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, PADDING_X, PADDING_Y);
}

-(void)removeDropDownFromView{
    [self.resultTableView removeFromSuperview];
}

-(void)hideDropDownFromView{
    self.resultTableView.hidden = YES;
}

-(void)showDropDownFromView{
    self.resultTableView.hidden = NO;
}
# pragma mark - table view Delegates
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [self.resultArray objectAtIndex:indexPath.row];
    if (isTalukaActive == YES)
  {
       cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0f];
       cell.textLabel.textColor=  [[UIColor blackColor] colorWithAlphaComponent:1.0f];

  }
    else{
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];

    }
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.resultArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.text = [self.resultArray objectAtIndex:indexPath.row];
	self.field.mSelectedValue = [self.resultArray objectAtIndex:indexPath.row];;
   // [self.resultTableView removeFromSuperview];
    [self hideDropDownFromView];
    [self.autocompleteTableRowSelectedDelegate selectedActionSender:self];
}

@end
