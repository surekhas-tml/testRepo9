//
//  SearchContactView.h
//  e-Guru
//
//  Created by MI iMac01 on 18/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchContactTableViewCell.h"
#import "Constant.h"
#import "EGContact.h"

@protocol SearchContactViewDelegate <NSObject>
-(void)searchContactSelectedValue:(EGContact *)selectedContact withIndex:(NSInteger)rowIndex;
@end

@interface SearchContactView : UIView <UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray * array;
}
@property (weak,nonatomic)id<SearchContactViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong,nonatomic) NSArray * resultArray;
@property (weak, nonatomic) IBOutlet UITableView *contactSearchTableVIew;
@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)userArray;

@end
