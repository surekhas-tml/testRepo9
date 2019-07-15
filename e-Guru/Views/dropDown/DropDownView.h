//
//  DropDownView.h
//  e-Guru
//
//  Created by Juili on 09/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropDownViewDelegate <NSObject>
-(void)DropDownViewClickedWithTag:(long)tag withView:(id)view;
@end@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak,nonatomic)id<DropDownViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *table;
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataList;
-(void)reloadDropdownWithNewArray:(NSArray *)array;
@end
