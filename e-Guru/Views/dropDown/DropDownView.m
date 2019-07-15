//
//  DropDownView.m
//  e-Guru
//
//  Created by Juili on 09/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "DropDownView.h"
@interface DropDownView()
    @property (strong,nonatomic) NSArray *dropdownList;
@end
@implementation DropDownView

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataList{
    self = [super initWithFrame:frame];
    if (self) {
        //initialisation
        [[NSBundle mainBundle] loadNibNamed:@"DropDownView" owner:self options:nil];
        self.dropdownList = [NSArray arrayWithArray:dataList];
        [self.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.scrollEnabled = YES;
        self.table.hidden = NO;
        [self.table reloadData];
        [self addSubview:self.view];
        
    }
    return self;
}
-(void)reloadDropdownWithNewArray:(NSArray *)array{
    self.dropdownList = [NSArray arrayWithArray:array];
    [self.table reloadData];
}
# pragma mark - table view Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [self.dropdownList objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dropdownList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    [self.delegate DropDownViewClickedWithTag:indexPath.row withView:self];
}
@end
