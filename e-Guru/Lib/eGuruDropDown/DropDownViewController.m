//
//  DropDownViewController.m
//  e-Guru
//
//  Created by MI iMac04 on 28/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DropDownViewController.h"
#import "DropDownTableViewCell.h"
#import "NSString+NSStringCategory.h"

#define SINGLE_ROW_HEIGHT       43
#define DROP_DOWN_WIDTH         280
#define DROP_DOWN_MAX_HEIGHT    420
#define HEADING_HEIGHT          32

@interface DropDownViewController () {
    NSInteger dropDownWidth;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *modelDataArray;

@end

@implementation DropDownViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        dropDownWidth = DROP_DOWN_WIDTH;
    }
    return self;
}

- (instancetype)initWithWidth:(NSInteger)width {
    self = [super init];
    if (self) {
        dropDownWidth = width;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustDropDownSizeBasedOnContent:self.dataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - Private Methods

- (void)adjustDropDownSizeBasedOnContent:(NSMutableArray *)contentArray {
    
    CGSize contentSize;
    CGFloat headingHeight = 0;
    
    if (self.heading.text && [self.heading.text hasValue]) {
        headingHeight = HEADING_HEIGHT;
        self.headingHeightConstraint.constant = HEADING_HEIGHT;
    }
    else {
        self.headingHeightConstraint.constant = 0;
    }
    if(_fromPotentialDropOff &&[contentArray count] >= 12){
         contentSize = CGSizeMake(dropDownWidth, 530 + headingHeight);
    }
    else if (!_fromPotentialDropOff &&[contentArray count] >= 10) {
        contentSize = CGSizeMake(dropDownWidth, DROP_DOWN_MAX_HEIGHT + headingHeight);
    }
    else {
        contentSize = CGSizeMake(dropDownWidth, ([contentArray count] * SINGLE_ROW_HEIGHT) + headingHeight);
    }
    
    self.preferredContentSize = contentSize;
}

- (void)showDropDownInController:(id)viewController withData:(NSMutableArray *)contentArray andModelData:(NSMutableArray *)modelDataArray forView:(UIView *)forView withDelegate:(id)delegate {
    self.delegate = delegate;
    self.dropDownForView = forView;
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.dataArray = contentArray;
    self.modelDataArray = modelDataArray;
    UIPopoverPresentationController *popPresenter = [self popoverPresentationController];
    popPresenter.sourceView = forView;
    popPresenter.sourceRect = forView.bounds;
    [viewController presentViewController:self animated:true completion:nil];
}

- (void)showDropDownInControllerForBeatPlan:(id)viewController withData:(NSMutableArray *)contentArray andModelData:(NSMutableArray *)modelDataArray forView:(UIView *)forView withDelegate:(id)delegate {
    self.delegate = delegate;
    self.dropDownForView = forView;
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.dataArray = contentArray;
    self.modelDataArray = modelDataArray;
    UIPopoverPresentationController *popPresenter = [self popoverPresentationController];
    popPresenter.sourceView = forView;
    popPresenter.sourceRect = forView.bounds;
    //popPresenter.sourceRect = CGRectMake(forView.frame.origin.x + forView.frame.size.width/2, forView.frame.origin.y/2, forView.frame.size.width, forView.frame.size.height);
    [viewController presentViewController:self animated:true completion:nil];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DropDownCell";
    DropDownTableViewCell *cell = (DropDownTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.valueLabel setText:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectValueFromDropDown:forField:)]) {
        [self.delegate didSelectValueFromDropDown:[self.dataArray objectAtIndex:indexPath.row] forField:self.dropDownForView];
    }
    else if ([self.delegate respondsToSelector:@selector(didSelectValueFromDropDown:selectedObject:forField:)]) {
        id selectedModel = nil;
        if (self.modelDataArray) {
            selectedModel = [self.modelDataArray objectAtIndex:indexPath.row];
        }
        [self.delegate didSelectValueFromDropDown:[self.dataArray objectAtIndex:indexPath.row] selectedObject:selectedModel forField:self.dropDownForView];
    }
    
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
